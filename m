From: akpm@linux-foundation.org
Subject: [merged] mm-sparse-remove-index_init_lock.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:18:50 -0700
Message-ID: <20120801201851.45130200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:44762 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895Ab2HAUSx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:18:53 -0400
Received: by weyr1 with SMTP id r1so344221wey.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:18:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shangw@linux.vnet.ibm.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sparse: remove index_init_lock
has been removed from the -mm tree.  Its filename was
     mm-sparse-remove-index_init_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
