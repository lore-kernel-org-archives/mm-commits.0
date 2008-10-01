From: akpm@linux-foundation.org
Subject: - x86-fix-shadowed-variable-warning.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:07:59 -0700
Message-ID: <200810012108.m91L7xM9004000@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752378AbYJAVIC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:08:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     x86: fix shadowed variable warning
has been removed from the -mm tree.  Its filename was
     x86-fix-shadowed-variable-warning.patch

This patch was dropped because it is obsolete

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
x86-fix-shadowed-variable-warning.patch
net-em_cmpc-use-unaligned-access-helpers.patch
misdn-endian-annotations-for-struct-zt.patch
misdn-annotate-iomem-pointer-and-add-statics.patch
drivers-net-replace-__function__-with-__func__.patch
bq27x00_battery-use-unaligned-access-helper.patch
rcu-fix-sparse-shadowed-variable-warning.patch
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

