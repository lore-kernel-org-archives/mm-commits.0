From: akpm@linux-foundation.org
Subject: + rd-mark-ramdisk-buffer-heads-dirty-in-ramdisk_set_page_dirty.patch added to -mm tree
Date: Tue, 22 May 2007 09:47:07 -0700
Message-ID: <200705221647.l4MGl7uA005728@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48163 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757812AbXEVQsS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 12:48:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com


The patch titled
     rd: Mark ramdisk buffer heads dirty in ramdisk_set_page_dirty
has been added to the -mm tree.  Its filename is
     rd-mark-ramdisk-buffer-heads-dirty-in-ramdisk_set_page_dirty.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rd: Mark ramdisk buffer heads dirty in ramdisk_set_page_dirty
From: Eric W. Biederman <ebiederm@xmission.com

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
 1 files changed, 15 insertions(+)

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
