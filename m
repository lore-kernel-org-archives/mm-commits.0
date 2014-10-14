From: akpm@linux-foundation.org
Subject: [merged] thinkpad_acpi-replace-strnicmp-with-strncasecmp.patch
 removed from -mm tree
Date: Tue, 14 Oct 2014 11:22:28 -0700
Message-ID: <543d69e4.p5BAHOO2wciB3E9q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44518 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590AbaJNSW1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:22:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, dvhart@infradead.org, ibm-acpi@hmh.eng.br, mm-commits@vger.kernel.org


The patch titled
     Subject: thinkpad_acpi: replace strnicmp with strncasecmp
has been removed from the -mm tree.  Its filename was
     thinkpad_acpi-replace-strnicmp-with-strncasecmp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

