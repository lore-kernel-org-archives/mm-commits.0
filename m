From: akpm@linux-foundation.org
Subject: [merged] qla2xxx-fix-__little_endian-definition-warnings.patch removed from -mm tree
Date: Thu, 30 Jul 2009 13:38:34 -0700
Message-ID: <200907302038.n6UKcYPr013316@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752788AbZG3Uiv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 16:38:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davej@redhat.com, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     qla2xxx: fix __LITTLE_ENDIAN definition warnings
has been removed from the -mm tree.  Its filename was
     qla2xxx-fix-__little_endian-definition-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: qla2xxx: fix __LITTLE_ENDIAN definition warnings
From: Dave Jones <davej@redhat.com>

On ppc64, gcc 4.4 spews lots of..

drivers/scsi/qla2xxx/qla_def.h:1485:7: warning: "__LITTLE_ENDIAN" is not defined

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/qla2xxx/qla_def.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/qla2xxx/qla_def.h~qla2xxx-fix-__little_endian-definition-warnings drivers/scsi/qla2xxx/qla_def.h
--- a/drivers/scsi/qla2xxx/qla_def.h~qla2xxx-fix-__little_endian-definition-warnings
+++ a/drivers/scsi/qla2xxx/qla_def.h
@@ -1482,7 +1482,7 @@ typedef union {
 		uint8_t domain;
 		uint8_t area;
 		uint8_t al_pa;
-#elif __LITTLE_ENDIAN
+#elif defined(__LITTLE_ENDIAN)
 		uint8_t al_pa;
 		uint8_t area;
 		uint8_t domain;
_

Patches currently in -mm which might be from davej@redhat.com are

origin.patch
linux-next.patch
kernel-core-add-smp_call_function_any.patch
kernel-core-add-smp_call_function_any-update.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch

