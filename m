From: akpm@linux-foundation.org
Subject: - preserve-the-dirty-bit-in-init_page_buffers.patch removed from -mm tree
Date: Mon, 09 Jul 2007 14:48:32 -0700
Message-ID: <200707092148.l69LmWtx014115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43170 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754334AbXGIVsj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 17:48:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     Preserve the dirty bit in init_page_buffers
has been removed from the -mm tree.  Its filename was
     preserve-the-dirty-bit-in-init_page_buffers.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: Preserve the dirty bit in init_page_buffers
From: Eric W. Biederman <ebiederm@xmission.com>

The problem: When we are trying to free buffers try_to_free_buffers will look
at ramdisk pages with clean buffer heads and remove the dirty bit from the
page.  Resulting in ramdisk pages with data that get removed from the page
cache.  Ouch!

Buffer heads appear on ramdisk pages when a filesystem calls getblk, which
through a series of function calls eventually calls init_page_buffers.

So to fix the mismatch between buffer head state and page state this patch
modifies init_page_buffers to transfer the dirty bit from the page to the
buffer heads like we currently do for the uptodate bit.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/buffer.c~preserve-the-dirty-bit-in-init_page_buffers fs/buffer.c
--- a/fs/buffer.c~preserve-the-dirty-bit-in-init_page_buffers
+++ a/fs/buffer.c
@@ -972,6 +972,7 @@ init_page_buffers(struct page *page, str
 	struct buffer_head *head = page_buffers(page);
 	struct buffer_head *bh = head;
 	int uptodate = PageUptodate(page);
+	int dirty = PageDirty(page);
 
 	do {
 		if (!buffer_mapped(bh)) {
@@ -980,6 +981,8 @@ init_page_buffers(struct page *page, str
 			bh->b_blocknr = block;
 			if (uptodate)
 				set_buffer_uptodate(bh);
+			if (dirty)
+				set_buffer_dirty(bh);
 			set_buffer_mapped(bh);
 		}
 		block++;
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
