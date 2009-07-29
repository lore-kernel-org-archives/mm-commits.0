From: akpm@linux-foundation.org
Subject: [merged] powerpc-cell-replace-strncpy-by-strlcpy.patch removed from -mm tree
Date: Wed, 29 Jul 2009 12:35:13 -0700
Message-ID: <200907291935.n6TJZD4Y003215@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40736 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751202AbZG2TfY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jul 2009 15:35:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, arnd@arndb.de, benh@kernel.crashing.org, ken.kawakami@toshiba.co.jp, mm-commits@vger.kernel.org


The patch titled
     powerpc/cell: replace strncpy by strlcpy
has been removed from the -mm tree.  Its filename was
     powerpc-cell-replace-strncpy-by-strlcpy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc/cell: replace strncpy by strlcpy
From: Roel Kluin <roel.kluin@gmail.com>

Replace strncpy() and explicit null-termination by strlcpy()

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Ken Kawakami <ken.kawakami@toshiba.co.jp>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/celleb_setup.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/powerpc/platforms/cell/celleb_setup.c~powerpc-cell-replace-strncpy-by-strlcpy arch/powerpc/platforms/cell/celleb_setup.c
--- a/arch/powerpc/platforms/cell/celleb_setup.c~powerpc-cell-replace-strncpy-by-strlcpy
+++ a/arch/powerpc/platforms/cell/celleb_setup.c
@@ -80,8 +80,7 @@ static void celleb_show_cpuinfo(struct s
 
 static int __init celleb_machine_type_hack(char *ptr)
 {
-	strncpy(celleb_machine_type, ptr, sizeof(celleb_machine_type));
-	celleb_machine_type[sizeof(celleb_machine_type)-1] = 0;
+	strlcpy(celleb_machine_type, ptr, sizeof(celleb_machine_type));
 	return 0;
 }
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
stmp3xxx-deallocation-with-negative-index-of-descriptors.patch
dm-strncpy-does-not-null-terminate-string.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
i915-fix-read-outside-array-bounds.patch
media-strncpy-does-not-null-terminate-string.patch
ivtv-read-buffer-overflow.patch
siano-read-buffer-overflow.patch
drivers-media-video-bw-qcamc-fix-read-buffer-overflow.patch
stk-webcam-read-buffer-overflow.patch
ipath-strncpy-does-not-null-terminate-string.patch
mips-decrease-size-of-au1xxx_dbdma_pm_regs.patch
irda-fix-read-buffer-overflow.patch
atlx-strncpy-does-not-null-terminate-string.patch
ext4-remove-redundant-test-on-unsigned.patch
ocfs2-keep-index-within-status_map.patch
cyclades-read-buffer-overflow.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
libertas-fix-read-outside-array-bounds.patch
libertas-read-buffer-overflow.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m32r-remove-redundant-tests-on-unsigned.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
dme1737-keep-index-within-pwm_config.patch
ncpfs-read-buffer-overflow.patch
smbfs-read-buffer-overflow.patch
platinumfb-misplaced-parenthesis.patch
sisfb-read-buffer-overflow.patch
documentation-strncpy-does-not-null-terminate-string.patch
adfs-remove-redundant-test-on-unsigned.patch

