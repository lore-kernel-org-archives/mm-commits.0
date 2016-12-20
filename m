From: akpm@linux-foundation.org
Subject: + mm-vmallocc-use-rb_entry_safe.patch added to -mm tree
Date: Tue, 20 Dec 2016 14:08:06 -0800
Message-ID: <5859abc6.9rB2ug5SMnrTSbIl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34696 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754445AbcLTWHj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 20 Dec 2016 17:07:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@gmail.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: use rb_entry_safe
has been added to the -mm tree.  Its filename is
     mm-vmallocc-use-rb_entry_safe.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmallocc-use-rb_entry_safe.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmallocc-use-rb_entry_safe.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geliang Tang <geliangtang@gmail.com>
Subject: mm/vmalloc.c: use rb_entry_safe

Use rb_entry_safe() instead of open-coding it.

Link: http://lkml.kernel.org/r/81bb9820e5b9e4a1c596b3e76f88abf8c4a76cb0.1482221947.git.geliangtang@gmail.com
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmalloc.c~mm-vmallocc-use-rb_entry_safe mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmallocc-use-rb_entry_safe
+++ a/mm/vmalloc.c
@@ -2309,7 +2309,7 @@ EXPORT_SYMBOL_GPL(free_vm_area);
 #ifdef CONFIG_SMP
 static struct vmap_area *node_to_va(struct rb_node *n)
 {
-	return n ? rb_entry(n, struct vmap_area, rb_node) : NULL;
+	return rb_entry_safe(n, struct vmap_area, rb_node);
 }
 
 /**
_

Patches currently in -mm which might be from geliangtang@gmail.com are

mm-vmallocc-use-rb_entry_safe.patch
timerqueue-use-rb_entry_safe.patch

