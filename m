From: akpm@linux-foundation.org
Subject: + qla2xxx-fix-__little_endian-definition-warnings.patch added to -mm tree
Date: Wed, 15 Jul 2009 15:34:21 -0700
Message-ID: <200907152234.n6FMYLCO009445@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39871 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755997AbZGOWek (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Jul 2009 18:34:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davej@redhat.com, James.Bottomley@HansenPartnership.com


The patch titled
     qla2xxx: fix __LITTLE_ENDIAN definition warnings
has been added to the -mm tree.  Its filename is
     qla2xxx-fix-__little_endian-definition-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
qla2xxx-fix-__little_endian-definition-warnings.patch

