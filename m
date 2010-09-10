From: akpm@linux-foundation.org
Subject: + ipmi-fix-acpi-probe-print.patch added to -mm tree
Date: Fri, 10 Sep 2010 16:43:08 -0700
Message-ID: <201009102343.o8ANh8on009850@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754986Ab0IJXnL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Sep 2010 19:43:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghai@kernel.org, cminyard@mvista.com


The patch titled
     ipmi: fix acpi probe print
has been added to the -mm tree.  Its filename is
     ipmi-fix-acpi-probe-print.patch

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
Subject: ipmi: fix acpi probe print
From: Yinghai Lu <yinghai@kernel.org>

After
|commit d9e1b6c45059ccfff647a120769ae86da78dfdc4
|
|    ipmi: fix ACPI detection with regspacing

got
[   11.026326] ipmi_si: probing via ACPI
[   11.030019] ipmi_si 00:09: (null) regsize 1 spacing 1 irq 0
[   11.035594] ipmi_si: Adding ACPI-specified kcs state machine

on old system with only one range for ipmi kcs range.

Try to fix it by adding another res pointer.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-fix-acpi-probe-print drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-fix-acpi-probe-print
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -2126,7 +2126,7 @@ static int __devinit ipmi_pnp_probe(stru
 {
 	struct acpi_device *acpi_dev;
 	struct smi_info *info;
-	struct resource *res;
+	struct resource *res, *res_second;
 	acpi_handle handle;
 	acpi_status status;
 	unsigned long long tmp;
@@ -2182,13 +2182,13 @@ static int __devinit ipmi_pnp_probe(stru
 	info->io.addr_data = res->start;
 
 	info->io.regspacing = DEFAULT_REGSPACING;
-	res = pnp_get_resource(dev,
+	res_second = pnp_get_resource(dev,
 			       (info->io.addr_type == IPMI_IO_ADDR_SPACE) ?
 					IORESOURCE_IO : IORESOURCE_MEM,
 			       1);
-	if (res) {
-		if (res->start > info->io.addr_data)
-			info->io.regspacing = res->start - info->io.addr_data;
+	if (res_second) {
+		if (res_second->start > info->io.addr_data)
+			info->io.regspacing = res_second->start - info->io.addr_data;
 	}
 	info->io.regsize = DEFAULT_REGSPACING;
 	info->io.regshift = 0;
_

Patches currently in -mm which might be from yinghai@kernel.org are

ipmi-fix-acpi-probe-print.patch
linux-next.patch

