From: akpm@linux-foundation.org
Subject: + mm-sparse-remove-index_init_lock.patch added to -mm tree
Date: Mon, 23 Jul 2012 15:26:46 -0700
Message-ID: <20120723222647.A5F9C5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:64581 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785Ab2GWW0t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jul 2012 18:26:49 -0400
Received: by mail-fa0-f74.google.com with SMTP id 25so345309fat.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Jul 2012 15:26:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shangw@linux.vnet.ibm.com, mhocko@suse.cz


The patch titled
     Subject: mm/sparse: remove index_init_lock
has been added to the -mm tree.  Its filename is
     mm-sparse-remove-index_init_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: mm/sparse: remove index_init_lock

sparse_index_init() uses the index_init_lock spinlock to protect root
mem_section assignment.  The lock is not necessary anymore because the
function is called only during boot (during paging init which is executed
only from a single CPU) and from the hotplug code (by add_memory() via
arch_add_memory()) which uses mem_hotplug_mutex.

The lock was introduced by 28ae55c9 ("sparsemem extreme: hotplug
preparation") and sparse_index_init() was used only during boot at that
time.

Later when the hotplug code (and add_memory()) was introduced there was no
synchronization so it was possible to online more sections from the same
root probably (though I am not 100% sure about that).  The first
synchronization has been added by 6ad696d2 ("mm: allow memory hotplug and
hibernation in the same kernel") which was later replaced by the
mem_hotplug_mutex - 20d6c96b ("mem-hotplug: introduce
{un}lock_memory_hotplug()").

Let's remove the lock as it is not needed and it makes the code more
confusing.

[mhocko@suse.cz: changelog]
Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff -puN mm/sparse.c~mm-sparse-remove-index_init_lock mm/sparse.c
--- a/mm/sparse.c~mm-sparse-remove-index_init_lock
+++ a/mm/sparse.c
@@ -77,7 +77,6 @@ static struct mem_section noinline __ini
 
 static int __meminit sparse_index_init(unsigned long section_nr, int nid)
 {
-	static DEFINE_SPINLOCK(index_init_lock);
 	unsigned long root = SECTION_NR_TO_ROOT(section_nr);
 	struct mem_section *section;
 	int ret = 0;
@@ -88,20 +87,9 @@ static int __meminit sparse_index_init(u
 	section = sparse_index_alloc(nid);
 	if (!section)
 		return -ENOMEM;
-	/*
-	 * This lock keeps two different sections from
-	 * reallocating for the same index
-	 */
-	spin_lock(&index_init_lock);
-
-	if (mem_section[root]) {
-		ret = -EEXIST;
-		goto out;
-	}
 
 	mem_section[root] = section;
-out:
-	spin_unlock(&index_init_lock);
+
 	return ret;
 }
 #else /* !SPARSEMEM_EXTREME */
_
Subject: Subject: mm/sparse: remove index_init_lock

Patches currently in -mm which might be from shangw@linux.vnet.ibm.com are

linux-next.patch
mm-slab-remove-duplicate-check.patch
mm-buddy-cleanup-on-should_fail_alloc_page.patch
mm-compaction-cleanup-on-compaction_deferred.patch
memcg-add-mem_cgroup_from_css-helper.patch
memcg-add-mem_cgroup_from_css-helper-fix.patch
memcg-add-mem_cgroup_from_css-helper-fix-2.patch
mm-sparse-optimize-sparse_index_alloc.patch
mm-sparse-more-check-on-mem_section-number.patch
mm-sparse-remove-index_init_lock.patch

