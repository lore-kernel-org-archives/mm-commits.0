From: akpm@linux-foundation.org
Subject: + acpi-add-checking-for-null-early-param.patch added to -mm tree
Date: Tue, 22 Jul 2008 02:53:44 -0700
Message-ID: <200807220953.m6M9riwL021908@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49512 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751131AbYGVJxu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 05:53:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, andi@firstfloor.org


The patch titled
     acpi: add checking for NULL early param
has been added to the -mm tree.  Its filename is
     acpi-add-checking-for-null-early-param.patch

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
Subject: acpi: add checking for NULL early param
From: Cyrill Gorcunov <gorcunov@gmail.com>

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/tables.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/acpi/tables.c~acpi-add-checking-for-null-early-param drivers/acpi/tables.c
--- a/drivers/acpi/tables.c~acpi-add-checking-for-null-early-param
+++ a/drivers/acpi/tables.c
@@ -300,6 +300,8 @@ int __init acpi_table_init(void)
 
 static int __init acpi_parse_apic_instance(char *str)
 {
+	if (!str)
+		return -EINVAL;
 
 	acpi_apic_instance = simple_strtoul(str, NULL, 0);
 
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
linux-next.patch
acpi-add-checking-for-null-early-param.patch

