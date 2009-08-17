From: akpm@linux-foundation.org
Subject: + kcore-use-usual-list-for-kclist.patch added to -mm tree
Date: Mon, 17 Aug 2009 14:25:51 -0700
Message-ID: <200908172125.n7HLPqnR029009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753249AbZHQV1G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Aug 2009 17:27:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, benh@kernel.crashing.org, ralf@linux-mips.org, xiyou.wangcong@gmail.com


The patch titled
     kcore: use usual list for kclist
has been added to the -mm tree.  Its filename is
     kcore-use-usual-list-for-kclist.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kcore: use usual list for kclist
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This patchset is for /proc/kcore.  With this,

 - many per-arch hooks are removed.

 - /proc/kcore will know really valid physical memory area.

 - /proc/kcore will be aware of memory hotplug.

 - /proc/kcore will be architecture independent i.e.
   if an arch supports CONFIG_MMU, it can use /proc/kcore.
   (if the arch uses usual memory layout.)



This patch:

/proc/kcore uses its own list handling codes. It's better to use
generic list codes.

No changes in logic. just clean up.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c         |   12 ++++++------
 include/linux/proc_fs.h |    2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/proc/kcore.c~kcore-use-usual-list-for-kclist fs/proc/kcore.c
--- a/fs/proc/kcore.c~kcore-use-usual-list-for-kclist
+++ a/fs/proc/kcore.c
@@ -20,6 +20,7 @@
 #include <linux/init.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
+#include <linux/list.h>
 
 #define CORE_STR "CORE"
 
@@ -57,7 +58,7 @@ struct memelfnote
 	void *data;
 };
 
-static struct kcore_list *kclist;
+static LIST_HEAD(kclist_head);
 static DEFINE_RWLOCK(kclist_lock);
 
 void
@@ -67,8 +68,7 @@ kclist_add(struct kcore_list *new, void 
 	new->size = size;
 
 	write_lock(&kclist_lock);
-	new->next = kclist;
-	kclist = new;
+	list_add_tail(&new->list, &kclist_head);
 	write_unlock(&kclist_lock);
 }
 
@@ -80,7 +80,7 @@ static size_t get_kcore_size(int *nphdr,
 	*nphdr = 1; /* PT_NOTE */
 	size = 0;
 
-	for (m=kclist; m; m=m->next) {
+	list_for_each_entry(m, &kclist_head, list) {
 		try = kc_vaddr_to_offset((size_t)m->addr + m->size);
 		if (try > size)
 			size = try;
@@ -192,7 +192,7 @@ static void elf_kcore_store_hdr(char *bu
 	nhdr->p_align	= 0;
 
 	/* setup ELF PT_LOAD program header for every area */
-	for (m=kclist; m; m=m->next) {
+	list_for_each_entry(m, &kclist_head, list) {
 		phdr = (struct elf_phdr *) bufp;
 		bufp += sizeof(struct elf_phdr);
 		offset += sizeof(struct elf_phdr);
@@ -317,7 +317,7 @@ read_kcore(struct file *file, char __use
 		struct kcore_list *m;
 
 		read_lock(&kclist_lock);
-		for (m=kclist; m; m=m->next) {
+		list_for_each_entry(m, &kclist_head, list) {
 			if (start >= m->addr && start < (m->addr+m->size))
 				break;
 		}
diff -puN include/linux/proc_fs.h~kcore-use-usual-list-for-kclist include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~kcore-use-usual-list-for-kclist
+++ a/include/linux/proc_fs.h
@@ -79,7 +79,7 @@ struct proc_dir_entry {
 };
 
 struct kcore_list {
-	struct kcore_list *next;
+	struct list_head list;
 	unsigned long addr;
 	size_t size;
 };
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

mm-revert-oom-move-oom_adj-value.patch
mm-clean-up-page_remove_rmap.patch
vmscan-throttle-direct-reclaim-when-too-many-pages-are-isolated-already.patch
mm-remove-__addsub_zone_page_state.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
ksm-add-mmu_notifier-set_pte_at_notify.patch
ksm-first-tidy-up-madvise_vma.patch
ksm-define-madv_mergeable-and-madv_unmergeable.patch
ksm-the-mm-interface-to-ksm.patch
ksm-no-debug-in-page_dup_rmap.patch
ksm-identify-pageksm-pages.patch
ksm-kernel-samepage-merging.patch
ksm-prevent-mremap-move-poisoning.patch
ksm-change-copyright-message.patch
ksm-change-ksm-nice-level-to-be-5.patch
vmalloc-unmap-vmalloc-area-after-hiding-it.patch
kcore-fix-vread-vwrite-to-be-aware-of-holes.patch
kcore-fix-vread-vwrite-to-be-aware-of-holes-update.patch
kcore-proc-kcore-should-use-vread.patch
mm-add_to_swap_cache-must-not-sleep.patch
mm-add_to_swap_cache-does-not-return-eexist.patch
kcore-fix-proc-kcores-statst_size.patch
kcore-use-usual-list-for-kclist.patch
kcore-add-kclist-type.patch
kcore-register-vmalloc-area-in-generic-way.patch
kcore-register-text-area-in-generic-way.patch
walk-system-ram-range.patch
kcore-use-registerd-physmem-information.patch
cgroups-support-named-cgroups-hierarchies.patch
cgroups-move-the-cgroup-debug-subsys-into-cgroupc-to-access-internal-state.patch
cgroups-add-a-back-pointer-from-struct-cg_cgroup_link-to-struct-cgroup.patch
cgroups-allow-cgroup-hierarchies-to-be-created-with-no-bound-subsystems.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch
memcg-add-comments-explaining-memory-barriers.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
memory-controller-soft-limit-documentation-v9.patch
memory-controller-soft-limit-interface-v9.patch
memory-controller-soft-limit-organize-cgroups-v9.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
memory-controller-soft-limit-refactor-reclaim-flags-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memcg-improve-resource-counter-scalability.patch
memcg-improve-resource-counter-scalability-v5.patch

