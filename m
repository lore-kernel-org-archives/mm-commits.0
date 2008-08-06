From: akpm@linux-foundation.org
Subject: + fs-partitions-acornc-remove-dead-code.patch added to -mm tree
Date: Wed, 06 Aug 2008 15:52:14 -0700
Message-ID: <200808062252.m76MqGCb019722@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46423 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753363AbYHFWw2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 18:52:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, rpjday@crashcourse.ca


The patch titled
     fs/partitions/acorn.c: remove dead code
has been added to the -mm tree.  Its filename is
     fs-partitions-acornc-remove-dead-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/partitions/acorn.c: remove dead code
From: Adrian Bunk <bunk@kernel.org>

I missed this when I did the arm26 removal.

Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/acorn.c |   10 ----------
 1 file changed, 10 deletions(-)

diff -puN fs/partitions/acorn.c~fs-partitions-acornc-remove-dead-code fs/partitions/acorn.c
--- a/fs/partitions/acorn.c~fs-partitions-acornc-remove-dead-code
+++ a/fs/partitions/acorn.c
@@ -275,16 +275,6 @@ adfspart_check_ADFS(struct parsed_partit
 	id = data[0x1fc] & 15;
 	put_dev_sector(sect);
 
-#ifdef CONFIG_BLK_DEV_MFM
-	if (MAJOR(bdev->bd_dev) == MFM_ACORN_MAJOR) {
-		extern void xd_set_geometry(struct block_device *,
-			unsigned char, unsigned char, unsigned int);
-		xd_set_geometry(bdev, dr->secspertrack, heads, 1);
-		invalidate_bh_lrus();
-		truncate_inode_pages(bdev->bd_inode->i_mapping, 0);
-	}
-#endif
-
 	/*
 	 * Work out start of non-adfs partition.
 	 */
_

Patches currently in -mm which might be from bunk@kernel.org are

feature-removal-scheduletxt-remove-the-ncr53c9x-entry.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
m32r-dont-offer-config_isa.patch
if-0-ses_match_host.patch
scsi-remove-the-unused-scsi_qlogic_fc_firmware-option.patch
git-block.patch
fs_mbcache-dont-needlessly-make-it-built-in.patch
git-xtensa.patch
uml-remove-the-dead-tty_log-code.patch
include-linux-kernelh-userspace-header-cleanup.patch
make-mm-rmapc-anon_vma_cachep-static.patch
drivers-firmware-iscsi_ibftc-make-3-functions-static.patch
reiser4.patch
fs-partitions-acornc-remove-dead-code.patch
the-overdue-eepro100-removal.patch
pnp-remove-printk-with-outdated-version.patch
telephony-remove-cvs-keywords.patch
reiserfs-procfsc-remove-cvs-keywords.patch
parport-remove-cvs-keywords.patch
quota-remove-cvs-keywords.patch
include-linux-mounth-remove-cvs-keyword.patch
kernel-dmac-remove-a-cvs-keyword.patch
asm-h8300-mdh-remove-cvs-keyword.patch
alpha-miata-remove-dead-url.patch
maintainers-remove-zf-machz-watchdog-entry.patch
maintainers-remove-hga-framebuffer-driver-entry.patch
ntfs-update-homepage.patch
drivers-scsi-a2091c-make-2-functions-static.patch
drivers-scsi-a3000c-make-2-functions-static.patch
m32r-export-empty_zero_page.patch
m32r-export-__ndelay.patch
m32r-kernel-cleanups.patch
binfmt_somc-add-module_license.patch
parisc-lib-make-code-static.patch
drivers-parisc-make-code-static.patch
make-probe_serial_gsc-static.patch
make-ptrace_untrace-static.patch
the-scheduled-serial_coldfire-removal.patch

