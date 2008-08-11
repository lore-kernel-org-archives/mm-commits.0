From: akpm@linux-foundation.org
Subject: + x86-fix-shadowed-variable-warning.patch added to -mm tree
Date: Mon, 11 Aug 2008 16:55:20 -0700
Message-ID: <200808112355.m7BNtKnw028715@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57337 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755789AbYHKXzX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Aug 2008 19:55:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     x86: fix shadowed variable warning
has been added to the -mm tree.  Its filename is
     x86-fix-shadowed-variable-warning.patch

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
Subject: x86: fix shadowed variable warning
From: Harvey Harrison <harvey.harrison@gmail.com>

arch/x86/kernel/pvclock.c:102:6: warning: symbol 'tsc_khz' shadows an earlier one
include/asm/tsc.h:18:21: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/pvclock.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN arch/x86/kernel/pvclock.c~x86-fix-shadowed-variable-warning arch/x86/kernel/pvclock.c
--- a/arch/x86/kernel/pvclock.c~x86-fix-shadowed-variable-warning
+++ a/arch/x86/kernel/pvclock.c
@@ -99,14 +99,14 @@ static unsigned pvclock_get_time_values(
 
 unsigned long pvclock_tsc_khz(struct pvclock_vcpu_time_info *src)
 {
-	u64 tsc_khz = 1000000ULL << 32;
+	u64 pv_tsc_khz = 1000000ULL << 32;
 
-	do_div(tsc_khz, src->tsc_to_system_mul);
+	do_div(pv_tsc_khz, src->tsc_to_system_mul);
 	if (src->tsc_shift < 0)
-		tsc_khz <<= -src->tsc_shift;
+		pv_tsc_khz <<= -src->tsc_shift;
 	else
-		tsc_khz >>= src->tsc_shift;
-	return tsc_khz;
+		pv_tsc_khz >>= src->tsc_shift;
+	return pv_tsc_khz;
 }
 
 cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src)
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

linux-next.patch
x86-fix-shadowed-variable-warning.patch
cifs-remove-global_extern-macro.patch
ppc-use-the-common-ascii-hex-helpers.patch
powerpc-replace-__function__-with-__func__.patch
v4l-drx397xdc-sparse-annotations.patch
input-ads7846c-sparse-lock-annotation.patch
kvm-make-functions-static.patch
drivers-net-replace-__function__-with-__func__.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
wireless-replace-__function__-with-__func__.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
byteorder-add-a-new-include-linux-swabh-to-define-byteswapping-functions.patch
byteorder-add-include-linux-byteorderh-to-define-endian-helpers.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
include-replace-__function__-with-__func__.patch
misc-replace-__function__-with-__func__.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch

