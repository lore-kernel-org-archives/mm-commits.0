From: akpm@linux-foundation.org
Subject: + acpi-annote-acpi_processor_add-with-__cpuinit.patch added to -mm tree
Date: Thu, 08 Oct 2009 15:56:25 -0700
Message-ID: <200910082256.n98MuPCe031023@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932481AbZJHW6Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Oct 2009 18:58:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rakib.mullick@gmail.com, lenb@kernel.org


The patch titled
     acpi: Annote acpi_processor_add with __cpuinit
has been added to the -mm tree.  Its filename is
     acpi-annote-acpi_processor_add-with-__cpuinit.patch

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
Subject: acpi: Annote acpi_processor_add with __cpuinit
From: Rakib Mullick <rakib.mullick@gmail.com>

Annote acpi_processor_add with cpuinit since it calls a cpuinit function
acpi_processor_power_init and fixes a section mismatch warning.

 We were warned by the following warning:

 LD      drivers/acpi/processor.o
WARNING: drivers/acpi/processor.o(.text+0x1829): Section mismatch in
reference from the function acpi_processor_add() to the function
.cpuinit.text:acpi_processor_power_init()
The function acpi_processor_add() references
the function __cpuinit acpi_processor_power_init().
This is often because acpi_processor_add lacks a __cpuinit
annotation or the annotation of acpi_processor_power_init is wrong.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/acpi/processor_core.c~acpi-annote-acpi_processor_add-with-__cpuinit drivers/acpi/processor_core.c
--- a/drivers/acpi/processor_core.c~acpi-annote-acpi_processor_add-with-__cpuinit
+++ a/drivers/acpi/processor_core.c
@@ -770,7 +770,7 @@ static struct notifier_block acpi_cpu_no
 	    .notifier_call = acpi_cpu_soft_notify,
 };
 
-static int acpi_processor_add(struct acpi_device *device)
+static int __cpuinit acpi_processor_add(struct acpi_device *device)
 {
 	struct acpi_processor *pr = NULL;
 	int result = 0;
_

Patches currently in -mm which might be from rakib.mullick@gmail.com are

linux-next.patch
acpi-annote-acpi_processor_add-with-__cpuinit.patch

