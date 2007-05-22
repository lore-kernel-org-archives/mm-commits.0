From: akpm@linux-foundation.org
Subject: + preserve-the-dirty-bit-in-init_page_buffers.patch added to -mm tree
Date: Tue, 22 May 2007 09:47:02 -0700
Message-ID: <200705221647.l4MGl3hR005723@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49414 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758422AbXEVQsS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 12:48:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com


The patch titled
     Preserve the dirty bit in init_page_buffers
has been added to the -mm tree.  Its filename is
     preserve-the-dirty-bit-in-init_page_buffers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Preserve the dirty bit in init_page_buffers
From: Eric W. Biederman <ebiederm@xmission.com

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
 1 files changed, 3 insertions(+)

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

freezer-close-potential-race-between-refrigerator-and-thaw_tasks.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
freezer-fix-kthread_create-vs-freezer-theoretical-race.patch
freezer-fix-pf_nofreeze-vs-freezeable-race.patch
freezer-move-frozen_process-to-kernel-power-processc.patch
dvb_en_50221-convert-to-kthread-api.patch
fix-i-oat-for-kexec.patch
pci-disable-msi-by-default-on-systems-with-serverworks-ht1000-chips.patch
x86_64-build-and-use-gdt-on-copied-compressed-kernel.patch
i386-efi-fix-proc-iomem-type-for-kexec-tools.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
preserve-the-dirty-bit-in-init_page_buffers.patch
rd-mark-ramdisk-buffer-heads-dirty-in-ramdisk_set_page_dirty.patch
rd-simplify-by-using-the-same-helper-functions-in-libfs.patch
