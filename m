From: akpm@linux-foundation.org
Subject: - net-em_cmpc-use-unaligned-access-helpers.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:50:50 -0700
Message-ID: <200810012150.m91LooLs005873@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753773AbYJAVvA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:51:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, tgraf@suug.ch, mm-commits@vger.kernel.org


The patch titled
     net: em_cmp.c use unaligned access helpers
has been removed from the -mm tree.  Its filename was
     net-em_cmpc-use-unaligned-access-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net: em_cmp.c use unaligned access helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Thomas Graf <tgraf@suug.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sched/em_cmp.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN net/sched/em_cmp.c~net-em_cmpc-use-unaligned-access-helpers net/sched/em_cmp.c
--- a/net/sched/em_cmp.c~net-em_cmpc-use-unaligned-access-helpers
+++ a/net/sched/em_cmp.c
@@ -14,6 +14,7 @@
 #include <linux/kernel.h>
 #include <linux/skbuff.h>
 #include <linux/tc_ematch/tc_em_cmp.h>
+#include <asm/unaligned.h>
 #include <net/pkt_cls.h>
 
 static inline int cmp_needs_transformation(struct tcf_em_cmp *cmp)
@@ -37,8 +38,7 @@ static int em_cmp_match(struct sk_buff *
 			break;
 
 		case TCF_EM_ALIGN_U16:
-			val = *ptr << 8;
-			val |= *(ptr+1);
+			val = get_unaligned_be16(ptr);
 
 			if (cmp_needs_transformation(cmp))
 				val = be16_to_cpu(val);
@@ -47,10 +47,7 @@ static int em_cmp_match(struct sk_buff *
 		case TCF_EM_ALIGN_U32:
 			/* Worth checking boundries? The branching seems
 			 * to get worse. Visit again. */
-			val = *ptr << 24;
-			val |= *(ptr+1) << 16;
-			val |= *(ptr+2) << 8;
-			val |= *(ptr+3);
+			val = get_unaligned_be32(ptr);
 
 			if (cmp_needs_transformation(cmp))
 				val = be32_to_cpu(val);
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

