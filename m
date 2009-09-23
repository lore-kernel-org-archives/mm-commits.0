From: akpm@linux-foundation.org
Subject: [merged] ncpfs-read-buffer-overflow.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:57:24 -0700
Message-ID: <200909231957.n8NJvOAT006860@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37515 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753751AbZIWT6F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:58:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, VANDROVE@vc.cvut.cz, mm-commits@vger.kernel.org


The patch titled
     ncpfs: read buffer overflow
has been removed from the -mm tree.  Its filename was
     ncpfs-read-buffer-overflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ncpfs: read buffer overflow
From: Roel Kluin <roel.kluin@gmail.com>

This function uses signed integers for the unix_date and local variables -
if a negative number is supplied and the leap-year condition is not met,
month will be 0, leading to a later read of day_n[-1]

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Petr Vandrovec <VANDROVE@vc.cvut.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ncpfs/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ncpfs/dir.c~ncpfs-read-buffer-overflow fs/ncpfs/dir.c
--- a/fs/ncpfs/dir.c~ncpfs-read-buffer-overflow
+++ a/fs/ncpfs/dir.c
@@ -1241,7 +1241,7 @@ ncp_date_unix2dos(int unix_date, __le16 
 		month = 2;
 	} else {
 		nl_day = (year & 3) || day <= 59 ? day : day - 1;
-		for (month = 0; month < 12; month++)
+		for (month = 1; month < 12; month++)
 			if (day_n[month] > nl_day)
 				break;
 	}
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
dm-strncpy-does-not-null-terminate-string.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
msp71xx-request_irq-failure-ignored-in-msp_pcibios_config_access.patch
hfc_usb-fix-read-buffer-overflow.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
st-fix-test-of-value-range-in-st_set_options.patch
drivers-staging-octeon-ethernet-rgmiic-dont-ignore-request_irq-return-code.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
mwave-fix-read-buffer-overflow.patch
adfs-remove-redundant-test-on-unsigned.patch
gru-allocation-may-fail-in-quicktest1.patch

