From: akpm@linux-foundation.org
Subject: + thinkpad_acpi-replace-strnicmp-with-strncasecmp.patch added to
 -mm tree
Date: Thu, 18 Sep 2014 14:36:21 -0700
Message-ID: <541b5055.0CqlV8SGX6RmOOqX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41776 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757372AbaIRVgW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Sep 2014 17:36:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, dvhart@infradead.org, ibm-acpi@hmh.eng.br, mm-commits@vger.kernel.org


The patch titled
     Subject: thinkpad_acpi: replace strnicmp with strncasecmp
has been added to the -mm tree.  Its filename is
     thinkpad_acpi-replace-strnicmp-with-strncasecmp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thinkpad_acpi-replace-strnicmp-with-strncasecmp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thinkpad_acpi-replace-strnicmp-with-strncasecmp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: thinkpad_acpi: replace strnicmp with strncasecmp

The kernel used to contain two functions for length-delimited,
case-insensitive string comparison, strnicmp with correct semantics and a
slightly buggy strncasecmp.  The latter is the POSIX name, so strnicmp was
renamed to strncasecmp, and strnicmp made into a wrapper for the new
strncasecmp to avoid breaking existing users.

To allow the compat wrapper strnicmp to be removed at some point in the
future, and to avoid the extra indirection cost, do
s/strnicmp/strncasecmp/g.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>
Cc: Darren Hart <dvhart@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/thinkpad_acpi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/platform/x86/thinkpad_acpi.c~thinkpad_acpi-replace-strnicmp-with-strncasecmp drivers/platform/x86/thinkpad_acpi.c
--- a/drivers/platform/x86/thinkpad_acpi.c~thinkpad_acpi-replace-strnicmp-with-strncasecmp
+++ a/drivers/platform/x86/thinkpad_acpi.c
@@ -8878,13 +8878,13 @@ static int __must_check __init get_think
 	}
 
 	s = dmi_get_system_info(DMI_PRODUCT_VERSION);
-	if (s && !(strnicmp(s, "ThinkPad", 8) && strnicmp(s, "Lenovo", 6))) {
+	if (s && !(strncasecmp(s, "ThinkPad", 8) && strncasecmp(s, "Lenovo", 6))) {
 		tp->model_str = kstrdup(s, GFP_KERNEL);
 		if (!tp->model_str)
 			return -ENOMEM;
 	} else {
 		s = dmi_get_system_info(DMI_BIOS_VENDOR);
-		if (s && !(strnicmp(s, "Lenovo", 6))) {
+		if (s && !(strncasecmp(s, "Lenovo", 6))) {
 			tp->model_str = kstrdup(s, GFP_KERNEL);
 			if (!tp->model_str)
 				return -ENOMEM;
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

linux-next.patch
lib-string-remove-duplicated-function.patch
lib-string-make-all-calls-to-strnicmp-into-calls-to-strncasecmp.patch
arm-replace-strnicmp-with-strncasecmp.patch
block-replace-strnicmp-with-strncasecmp.patch
netfilter-replace-strnicmp-with-strncasecmp.patch
video-fbdev-replace-strnicmp-with-strncasecmp.patch
cifs-replace-strnicmp-with-strncasecmp.patch
ocfs2-replace-strnicmp-with-strncasecmp.patch
isofs-replace-strnicmp-with-strncasecmp.patch
batman-adv-replace-strnicmp-with-strncasecmp.patch
acpi-battery-replace-strnicmp-with-strncasecmp.patch
cpufreq-replace-strnicmp-with-strncasecmp.patch
cpuidle-replace-strnicmp-with-strncasecmp.patch
scsi-replace-strnicmp-with-strncasecmp.patch
ib_srpt-replace-strnicmp-with-strncasecmp.patch
input-edt-ft5x06-replace-strnicmp-with-strncasecmp.patch
altera-stapl-replace-strnicmp-with-strncasecmp.patch
thinkpad_acpi-replace-strnicmp-with-strncasecmp.patch
pnp-replace-strnicmp-with-strncasecmp.patch
s390-cio-replace-strnicmp-with-strncasecmp.patch
staging-r8188eu-replace-strnicmp-with-strncasecmp.patch
thermal-replace-strnicmp-with-strncasecmp.patch
kdb-replace-strnicmp-with-strncasecmp.patch

