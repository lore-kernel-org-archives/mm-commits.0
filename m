From: akpm@linux-foundation.org
Subject: + net-em_cmpc-use-unaligned-access-helpers.patch added to -mm tree
Date: Fri, 19 Sep 2008 16:00:25 -0700
Message-ID: <200809192300.m8JN0P13010891@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750846AbYISXAf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Sep 2008 19:00:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, tgraf@suug.ch


The patch titled
     net: em_cmp.c use unaligned access helpers
has been added to the -mm tree.  Its filename is
     net-em_cmpc-use-unaligned-access-helpers.patch

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

linux-next.patch
acpi-toshiba_acpic-fix-sparse-signedness-mismatch-warnings.patch
x86-fix-shadowed-variable-warning.patch
cifs-remove-global_extern-macro.patch
input-ads7846c-sparse-lock-annotation.patch
net-em_cmpc-use-unaligned-access-helpers.patch
misdn-endian-annotations-for-struct-zt.patch
misdn-annotate-iomem-pointer-and-add-statics.patch
drivers-net-replace-__function__-with-__func__.patch
bq27x00_battery-use-unaligned-access-helper.patch
rcu-fix-sparse-shadowed-variable-warning.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
fbcon-fix-monochrome-color-value-calculation.patch
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

