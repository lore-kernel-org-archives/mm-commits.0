From: akpm@linux-foundation.org
Subject: + panic-add-taint-flag-taint_firmware_workaround-i.patch added to -mm tree
Date: Mon, 22 Mar 2010 22:50:08 -0400
Message-ID: <201003230551.o2N5oxkn016719@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753930Ab0CWFvb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Mar 2010 01:51:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@decadent.org.uk, David.Woodhouse@intel.com, arnd@arndb.de, benh@kernel.crashing.org, ddaney@caviumnetworks.com, deller@gmx.de, heiko.carstens@de.ibm.com, jbarnes@virtuousgeek.org, jesper.nilsson@axis.com, lethal@linux-sh.org, matt@console-pimps.org, schwidefsky@de.ibm.com


The patch titled
     panic: add taint flag TAINT_FIRMWARE_WORKAROUND ('I')
has been added to the -mm tree.  Its filename is
     panic-add-taint-flag-taint_firmware_workaround-i.patch

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
Subject: panic: add taint flag TAINT_FIRMWARE_WORKAROUND ('I')
From: Ben Hutchings <ben@decadent.org.uk>

This taint flag will initially be used when warning about invalid ACPI
DMAR tables.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Helge Deller <deller@gmx.de>
Cc: David Daney <ddaney@caviumnetworks.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    1 +
 kernel/panic.c         |    2 ++
 2 files changed, 3 insertions(+)

diff -puN include/linux/kernel.h~panic-add-taint-flag-taint_firmware_workaround-i include/linux/kernel.h
--- a/include/linux/kernel.h~panic-add-taint-flag-taint_firmware_workaround-i
+++ a/include/linux/kernel.h
@@ -344,6 +344,7 @@ extern enum system_states {
 #define TAINT_OVERRIDDEN_ACPI_TABLE	8
 #define TAINT_WARN			9
 #define TAINT_CRAP			10
+#define TAINT_FIRMWARE_WORKAROUND	11
 
 extern void dump_stack(void) __cold;
 
diff -puN kernel/panic.c~panic-add-taint-flag-taint_firmware_workaround-i kernel/panic.c
--- a/kernel/panic.c~panic-add-taint-flag-taint_firmware_workaround-i
+++ a/kernel/panic.c
@@ -178,6 +178,7 @@ static const struct tnt tnts[] = {
 	{ TAINT_OVERRIDDEN_ACPI_TABLE,	'A', ' ' },
 	{ TAINT_WARN,			'W', ' ' },
 	{ TAINT_CRAP,			'C', ' ' },
+	{ TAINT_FIRMWARE_WORKAROUND,	'I', ' ' },
 };
 
 /**
@@ -194,6 +195,7 @@ static const struct tnt tnts[] = {
  *  'A' - ACPI table overridden.
  *  'W' - Taint on warning.
  *  'C' - modules from drivers/staging are loaded.
+ *  'I' - Firmware workaround was required.
  *
  *	The string is overwritten by the next call to print_tainted().
  */
_

Patches currently in -mm which might be from ben@decadent.org.uk are

linux-next.patch
mptscsih-fix-first-line-of-kernel-doc-for-a-few-functions.patch
panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn.patch
panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn-checkpatch-fixes.patch
panic-add-taint-flag-taint_firmware_workaround-i.patch
pci-dmar-combine-the-bios-dmar-table-warning-messages.patch
pci-dmar-tone-down-warnings-about-invalid-bios-dmar-tables.patch

