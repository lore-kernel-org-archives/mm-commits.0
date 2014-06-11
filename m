From: akpm@linux-foundation.org
Subject: +
 vmalloc-use-rcu-list-iterator-to-reduce-vmap_area_lock-contention.patch
 added to -mm tree
Date: Wed, 11 Jun 2014 14:56:55 -0700
Message-ID: <5398d0a7.m/rCgHrOJ73KlPL5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51654 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbaFKV44 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jun 2014 17:56:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei.yes@gmail.com, ryao@gentoo.org, peter@hurleysoftware.com, hannes@cmpxchg.org, edumazet@google.com, andi@firstfloor.org, iamjoonsoo.kim@lge.com

Subject: + vmalloc-use-rcu-list-iterator-to-reduce-vmap_area_lock-contention.patch added to -mm tree
To: iamjoonsoo.kim@lge.com,andi@firstfloor.org,edumazet@google.com,hannes@cmpxchg.org,peter@hurleysoftware.com,ryao@gentoo.org,zhangyanfei.yes@gmail.com
From: akpm@linux-foundation.org
Date: Wed, 11 Jun 2014 14:56:55 -0700


The patch titled
     Subject: vmalloc: use rcu list iterator to reduce vmap_area_lock contention
has been added to the -mm tree.  Its filename is
     vmalloc-use-rcu-list-iterator-to-reduce-vmap_area_lock-contention.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmalloc-use-rcu-list-iterator-to-reduce-vmap_area_lock-contention.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmalloc-use-rcu-list-iterator-to-reduce-vmap_area_lock-contention.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: vmalloc: use rcu list iterator to reduce vmap_area_lock contention

Richard Yao reported a month ago that his system have a trouble with
vmap_area_lock contention during performance analysis by /proc/meminfo. 
Andrew asked why his analysis checks /proc/meminfo stressfully, but he
didn't answer it.

https://lkml.org/lkml/2014/4/10/416

Although I'm not sure that this is right usage or not, there is a solution
reducing vmap_area_lock contention with no side-effect.  That is just to
use rcu list iterator in get_vmalloc_info().

rcu can be used in this function because all RCU protocol is already
respected by writers, since Nick Piggin commit db64fe02258f1507e13fe5
("mm: rewrite vmap layer") back in linux-2.6.28

Specifically :
   insertions use list_add_rcu(),
   deletions use list_del_rcu() and kfree_rcu().

Note the rb tree is not used from rcu reader (it would not be safe),
only the vmap_area_list has full RCU protection.

Note that __purge_vmap_area_lazy() already uses this rcu protection.

        rcu_read_lock();
        list_for_each_entry_rcu(va, &vmap_area_list, list) {
                if (va->flags & VM_LAZY_FREE) {
                        if (va->va_start < *start)
                                *start = va->va_start;
                        if (va->va_end > *end)
                                *end = va->va_end;
                        nr += (va->va_end - va->va_start) >> PAGE_SHIFT;
                        list_add_tail(&va->purge_list, &valist);
                        va->flags |= VM_LAZY_FREEING;
                        va->flags &= ~VM_LAZY_FREE;
                }
        }
        rcu_read_unlock();


Peter:

: While rcu list traversal over the vmap_area_list is safe, this may
: arrive at different results than the spinlocked version. The rcu list
: traversal version will not be a 'snapshot' of a single, valid instant
: of the entire vmap_area_list, but rather a potential amalgam of
: different list states.

Joonsoo:

: Yes, you are right, but I don't think that we should be strict here. 
: Meminfo is already not a 'snapshot' at specific time.  While we try to get
: certain stats, the other stats can change.  And, although we may arrive at
: different results than the spinlocked version, the difference would not be
: large and would not make serious side-effect.

[edumazet@google.com: add more commit description]
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reported-by: Richard Yao <ryao@gentoo.org>
Acked-by: Eric Dumazet <edumazet@google.com>
Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Zhang Yanfei <zhangyanfei.yes@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/vmalloc.c~vmalloc-use-rcu-list-iterator-to-reduce-vmap_area_lock-contention mm/vmalloc.c
--- a/mm/vmalloc.c~vmalloc-use-rcu-list-iterator-to-reduce-vmap_area_lock-contention
+++ a/mm/vmalloc.c
@@ -2690,14 +2690,14 @@ void get_vmalloc_info(struct vmalloc_inf
 
 	prev_end = VMALLOC_START;
 
-	spin_lock(&vmap_area_lock);
+	rcu_read_lock();
 
 	if (list_empty(&vmap_area_list)) {
 		vmi->largest_chunk = VMALLOC_TOTAL;
 		goto out;
 	}
 
-	list_for_each_entry(va, &vmap_area_list, list) {
+	list_for_each_entry_rcu(va, &vmap_area_list, list) {
 		unsigned long addr = va->va_start;
 
 		/*
@@ -2724,7 +2724,7 @@ void get_vmalloc_info(struct vmalloc_inf
 		vmi->largest_chunk = VMALLOC_END - prev_end;
 
 out:
-	spin_unlock(&vmap_area_lock);
+	rcu_read_unlock();
 }
 #endif
 
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
mm-slabc-add-__init-to-init_lock_keys.patch
vmalloc-use-rcu-list-iterator-to-reduce-vmap_area_lock-contention.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
page-owners-correct-page-order-when-to-free-page.patch

