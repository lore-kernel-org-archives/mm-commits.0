From: akpm@linux-foundation.org
Subject: - isdn-guard-against-a-potential-null-pointer-dereference-in-old_capi_manufacturer.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:40:02 -0700
Message-ID: <200710162040.l9GKe2VD015646@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48042 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936001AbXJPVHs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:07:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     isdn: guard against a potential NULL pointer dereference in old_capi_manufacturer()
has been removed from the -mm tree.  Its filename was
     isdn-guard-against-a-potential-null-pointer-dereference-in-old_capi_manufacturer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: isdn: guard against a potential NULL pointer dereference in old_capi_manufacturer()
From: Jesper Juhl <jesper.juhl@gmail.com>

In drivers/isdn/capi/kcapi.c::old_capi_manufacturer(), if the call to
get_capi_ctr_by_nr(ldef.contr); in line 823 returns NULL, then we'll be
dereferencing a NULL pointer in the very next line.

(Found by Coverity checker as bug #402)

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Acked-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/capi/kcapi.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/isdn/capi/kcapi.c~isdn-guard-against-a-potential-null-pointer-dereference-in-old_capi_manufacturer drivers/isdn/capi/kcapi.c
--- a/drivers/isdn/capi/kcapi.c~isdn-guard-against-a-potential-null-pointer-dereference-in-old_capi_manufacturer
+++ a/drivers/isdn/capi/kcapi.c
@@ -821,6 +821,8 @@ static int old_capi_manufacturer(unsigne
 				return -EFAULT;
 		}
 		card = get_capi_ctr_by_nr(ldef.contr);
+		if (!card)
+			return -EINVAL;
 		card = capi_ctr_get(card);
 		if (!card)
 			return -ESRCH;
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
git-alsa.patch
git-cifs.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
git-xfs.patch
clean-up-duplicate-includes-in-drivers-char.patch
clean-up-duplicate-includes-in-drivers-w1.patch
clean-up-duplicate-includes-in-fs.patch
clean-up-duplicate-includes-in-fs-ecryptfs.patch
clean-up-duplicate-includes-in-kernel.patch
avoid-a-small-unlikely-memory-leak-in-proc_read_escd.patch
docs-ramdisk-initrd-initramfs-corrections.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
clean-up-duplicate-includes-in-documentation.patch
add-a-missing-00-index-file-for-documentation-vm.patch
add-a-missing-00-index-file-for-documentation-vm-fix.patch
add-a-00-index-file-to-documentation-mips.patch
add-a-00-index-file-to-documentation-sysctl.patch
add-a-00-index-file-to-documentation-telephony.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci-fix.patch
cyclades-avoid-label-defined-but-not-used-warning.patch
