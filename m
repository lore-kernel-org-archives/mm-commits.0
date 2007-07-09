From: akpm@linux-foundation.org
Subject: - rd-mark-ramdisk-buffer-heads-dirty-in-ramdisk_set_page_dirty.patch removed from -mm tree
Date: Mon, 09 Jul 2007 14:48:34 -0700
Message-ID: <200707092148.l69LmYA3014120@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40468 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755063AbXGIVsl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 17:48:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     rd: mark ramdisk buffer heads dirty in ramdisk_set_page_dirty
has been removed from the -mm tree.  Its filename was
     rd-mark-ramdisk-buffer-heads-dirty-in-ramdisk_set_page_dirty.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: rd: mark ramdisk buffer heads dirty in ramdisk_set_page_dirty
From: Eric W. Biederman <ebiederm@xmission.com>

The problem: When we are trying to free buffers try_to_free_buffers will look
at ramdisk pages with clean buffer heads and remove the dirty bit from the
page.  Resulting in ramdisk pages with data that get removed from the page
cache.  Ouch!

When we mark a ramdisk page dirty we call set_page_dirty which then calls
ramdisk_set_page_dirty.  Currently we don't mark the buffer heads dirty
leaving us susceptible to the problem above.

So to fix the mismatch between buffer head state and page state this patch
modifies ramdisk_set_page_dirty to set the dirty bit on all of the buffers a
page may posses.

I set the uptodate bit on the buffer head so that later we can use
simple_commit_write, and because it is trivially safe.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/rd.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN drivers/block/rd.c~rd-mark-ramdisk-buffer-heads-dirty-in-ramdisk_set_page_dirty drivers/block/rd.c
--- a/drivers/block/rd.c~rd-mark-ramdisk-buffer-heads-dirty-in-ramdisk_set_page_dirty
+++ a/drivers/block/rd.c
@@ -184,6 +184,21 @@ static int ramdisk_writepages(struct add
  */
 static int ramdisk_set_page_dirty(struct page *page)
 {
+	struct address_space * const mapping = page_mapping(page);
+
+	spin_lock(&mapping->private_lock);
+	if (page_has_buffers(page)) {
+		struct buffer_head *head = page_buffers(page);
+		struct buffer_head *bh = head;
+
+		do {
+			set_buffer_uptodate(bh);
+			set_buffer_dirty(bh);
+			bh = bh->b_this_page;
+		} while (bh != head);
+	}
+	spin_unlock(&mapping->private_lock);
+
 	if (!TestSetPageDirty(page))
 		return 1;
 	return 0;
_

Patches currently in -mm which might be from ebiederm@xmission.com are

dvb_en_50221-convert-to-kthread-api.patch
git-kbuild.patch
fix-i-oat-for-kexec.patch
fix-x86_64-mm-add-common-orderly_poweroff.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
i386-trim-memory-not-covered-by-wb-mtrrs.patch
x86-64-disable-the-gart-in-shutdown.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
x86_64-add-ioapic-nmi-support.patch
xen-suppress-abs-symbol-warnings-for-unused-reloc-pointers.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
buffer-kill-old-incorrect-comment.patch
remove-config_uts_ns-and-config_ipc_ns.patch
user-namespace-add-the-framework.patch
user-namespace-add-unshare.patch
mm-fix-create_new_namespaces-return-value.patch
add-a-kmem_cache-for-nsproxy-objects.patch
update-procfs-guide-doc-of-read_func.patch
namespace-ensure-clone_flags-are-always-stored-in-an-unsigned-long.patch
add-documentation-sysctl-ctl_unnumberedtxt.patch
sysctlc-add-text-telling-people-to-use-ctl_unnumbered.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
containersv10-basic-container-framework.patch
containersv10-basic-container-framework-fix.patch
containersv10-example-cpu-accounting-subsystem.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface.patch
containersv10-add-procfs-interface-fix.patch
containersv10-make-cpusets-a-client-of-containers.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch
containersv10-simple-debug-info-subsystem.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
containersv10-support-for-automatic-userspace-release-agents.patch
containers-implement-subsys-post_clone.patch
containers-implement-namespace-tracking-subsystem-v3.patch
