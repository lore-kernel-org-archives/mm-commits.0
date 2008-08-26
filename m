From: akpm@linux-foundation.org
Subject: - acpi-add-support-for-addressrangeunusuable-acpi-memory-type.patch removed from -mm tree
Date: Tue, 26 Aug 2008 11:44:49 -0700
Message-ID: <200808261844.m7QIinld021343@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38240 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757536AbYHZSpv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Aug 2008 14:45:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.cihula@intel.com, andi@firstfloor.org, gang.wei@intel.com, mingo@elte.hu, shane.wang@intel.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     acpi: add support for AddressRangeUnusuable ACPI memory type
has been removed from the -mm tree.  Its filename was
     acpi-add-support-for-addressrangeunusuable-acpi-memory-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: add support for AddressRangeUnusuable ACPI memory type
From: "Cihula, Joseph" <joseph.cihula@intel.com>

Add support for the E820_UNUSABLE memory type, which is defined in
Revision 3.0b (Oct.  10, 2006) of the ACPI Specification on p.  394 Table
14-1:

  AddressRangeUnusuable This range of address contains memory in which
  errors have been detected.  This range must not be used by the OSPM.

Signed-off-by: Joseph Cihula <joseph.cihula@intel.com>
Signed-off-by: Shane Wang <shane.wang@intel.com>
Signed-off-by: Gang Wei <gang.wei@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/e820.c |    4 ++++
 include/asm-x86/e820.h |    1 +
 2 files changed, 5 insertions(+)

diff -puN arch/x86/kernel/e820.c~acpi-add-support-for-addressrangeunusuable-acpi-memory-type arch/x86/kernel/e820.c
--- a/arch/x86/kernel/e820.c~acpi-add-support-for-addressrangeunusuable-acpi-memory-type
+++ a/arch/x86/kernel/e820.c
@@ -148,6 +148,9 @@ void __init e820_print_map(char *who)
 		case E820_NVS:
 			printk(KERN_CONT "(ACPI NVS)\n");
 			break;
+		case E820_UNUSABLE:
+			printk("(unusable)\n");
+			break;
 		default:
 			printk(KERN_CONT "type %u\n", e820.map[i].type);
 			break;
@@ -1260,6 +1263,7 @@ static inline const char *e820_type_to_s
 	case E820_RAM:	return "System RAM";
 	case E820_ACPI:	return "ACPI Tables";
 	case E820_NVS:	return "ACPI Non-volatile Storage";
+	case E820_UNUSABLE:	return "Unusable memory";
 	default:	return "reserved";
 	}
 }
diff -puN include/asm-x86/e820.h~acpi-add-support-for-addressrangeunusuable-acpi-memory-type include/asm-x86/e820.h
--- a/include/asm-x86/e820.h~acpi-add-support-for-addressrangeunusuable-acpi-memory-type
+++ a/include/asm-x86/e820.h
@@ -43,6 +43,7 @@
 #define E820_RESERVED	2
 #define E820_ACPI	3
 #define E820_NVS	4
+#define E820_UNUSABLE	5
 
 /* reserved RAM used by kernel itself */
 #define E820_RESERVED_KERN        128
_

Patches currently in -mm which might be from joseph.cihula@intel.com are

linux-next.patch

