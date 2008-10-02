From: akpm@linux-foundation.org
Subject: + scsi-gdthc-use-unaligned-access-helpers.patch added to -mm tree
Date: Wed, 01 Oct 2008 23:09:09 -0700
Message-ID: <200810020609.m926995l023617@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43771 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751552AbYJBGJU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Oct 2008 02:09:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com


The patch titled
     scsi: gdth.c use unaligned access helpers
has been added to the -mm tree.  Its filename is
     scsi-gdthc-use-unaligned-access-helpers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi: gdth.c use unaligned access helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Remove two now unnecessary local vars.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/gdth.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff -puN drivers/scsi/gdth.c~scsi-gdthc-use-unaligned-access-helpers drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c~scsi-gdthc-use-unaligned-access-helpers
+++ a/drivers/scsi/gdth.c
@@ -131,6 +131,7 @@
 #include <asm/system.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
+#include <asm/unaligned.h>
 #include <linux/spinlock.h>
 #include <linux/blkdev.h>
 #include <linux/scatterlist.h>
@@ -2429,8 +2430,8 @@ static int gdth_fill_cache_cmd(gdth_ha_s
 {
     register gdth_cmd_str *cmdp;
     struct gdth_cmndinfo *cmndinfo = gdth_cmnd_priv(scp);
-    ulong32 cnt, blockcnt;
-    ulong64 no, blockno;
+    ulong32 blockcnt;
+    ulong64 blockno;
     int i, cmd_index, read_write, sgcnt, mode64;
 
     cmdp = ha->pccb;
@@ -2498,19 +2499,15 @@ static int gdth_fill_cache_cmd(gdth_ha_s
 
     if (read_write) {
         if (scp->cmd_len == 16) {
-            memcpy(&no, &scp->cmnd[2], sizeof(ulong64));
-            blockno = be64_to_cpu(no);
-            memcpy(&cnt, &scp->cmnd[10], sizeof(ulong32));
-            blockcnt = be32_to_cpu(cnt);
+		blockno = get_unaligned_be64(&scp->cmnd[2]);
+		blockcnt = get_unaligned_be32(&scp->cmnd[10]);
         } else if (scp->cmd_len == 10) {
-            memcpy(&no, &scp->cmnd[2], sizeof(ulong32));
-            blockno = be32_to_cpu(no);
-            memcpy(&cnt, &scp->cmnd[7], sizeof(ushort));
-            blockcnt = be16_to_cpu(cnt);
+		blockno = get_unaligned_be32(&scp->cmnd[2]);
+		blockcnt = get_unaligned_be16(&scp->cmnd[7]);
         } else {
-            memcpy(&no, &scp->cmnd[0], sizeof(ulong32));
-            blockno = be32_to_cpu(no) & 0x001fffffUL;
-            blockcnt= scp->cmnd[4]==0 ? 0x100 : scp->cmnd[4];
+		blockno = get_unaligned_be32(&scp->cmnd[2]);
+		blockno &= 0x001fffffUL;
+		blockcnt = scp->cmnd[4] == 0 ? 0x100 : scp->cmnd[4];
         }
         if (mode64) {
             cmdp->u.cache64.BlockNo = blockno;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

fbcon-fix-monochrome-color-value-calculation.patch
git-avr32.patch
git-powerpc.patch
git-x86.patch
git-xtensa.patch
git-hid.patch
git-v4l-dvb.patch
git-xfs.patch
git-net.patch
git-sound.patch
git-block.patch
git-pcmcia.patch
git-battery.patch
acpi-toshiba_acpic-fix-sparse-signedness-mismatch-warnings.patch
cifs-remove-global_extern-macro.patch
input-ads7846c-sparse-lock-annotation.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
include-replace-__function__-with-__func__.patch
misc-replace-__function__-with-__func__.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch
char-moxac-sparse-annotation.patch
byteorder-add-new-headers-for-make-headers-install.patch
byteorder-use-generic-c-version-for-value-byteswapping.patch
lib-pull-base-guessing-logic-to-helper-function.patch
lib-trivial-whitespace-tidy.patch
lib-remove-defining-macros-for-strict_strto.patch

