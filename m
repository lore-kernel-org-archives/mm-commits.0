From: akpm@linux-foundation.org
Subject: + fix-altix-boot-breakage-in-acpi.patch added to -mm tree
Date: Sat, 17 May 2008 09:40:06 -0700
Message-ID: <200805171640.m4HGe6oe007121@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751523AbYEQQlK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 May 2008 12:41:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rja@sgi.com, lenb@kernel.org, mingo@elte.hu, tony.luck@intel.com


The patch titled
     Fix Altix boot breakage in ACPI
has been added to the -mm tree.  Its filename is
     fix-altix-boot-breakage-in-acpi.patch

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
Subject: Fix Altix boot breakage in ACPI
From: Russ Anderson <rja@sgi.com>

A recent ACPI change (commit 5dc90c0b2d4bd0127624bab67cec159b2c6c4daf)
inadvertently broke Altix boot.  This patch allow Altix to boot.

Signed-off-by: Russ Anderson <rja@sgi.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/Kconfig    |    4 ++++
 include/linux/acpi.h |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN arch/ia64/Kconfig~fix-altix-boot-breakage-in-acpi arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~fix-altix-boot-breakage-in-acpi
+++ a/arch/ia64/Kconfig
@@ -60,6 +60,10 @@ config RWSEM_XCHGADD_ALGORITHM
 	bool
 	default y
 
+config HAVE_ARCH_PARSE_SRAT
+	bool
+	default y
+
 config ARCH_HAS_ILOG2_U32
 	bool
 	default n
diff -puN include/linux/acpi.h~fix-altix-boot-breakage-in-acpi include/linux/acpi.h
--- a/include/linux/acpi.h~fix-altix-boot-breakage-in-acpi
+++ a/include/linux/acpi.h
@@ -93,7 +93,7 @@ int acpi_parse_mcfg (struct acpi_table_h
 void acpi_table_print_madt_entry (struct acpi_subtable_header *madt);
 
 /* the following four functions are architecture-dependent */
-#ifdef CONFIG_HAVE_ARCH_PARSE_SRAT
+#if defined(CONFIG_HAVE_ARCH_PARSE_SRAT) && !defined(NR_NODE_MEMBLKS)
 #define NR_NODE_MEMBLKS MAX_NUMNODES
 #define acpi_numa_slit_init(slit) do {} while (0)
 #define acpi_numa_processor_affinity_init(pa) do {} while (0)
_

Patches currently in -mm which might be from rja@sgi.com are

fix-altix-boot-breakage-in-acpi.patch

