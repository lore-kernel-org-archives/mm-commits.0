From: akpm@linux-foundation.org
Subject: - acpi-preserve-the-ebx-value-in-acpi_copy_wakeup_routine.patch removed from -mm tree
Date: Mon, 25 Jun 2007 02:21:30 -0700
Message-ID: <200706250921.l5P9LUbk031121@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41319 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751414AbXFYJZJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 05:25:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kevin.tian@intel.com, ak@suse.de, lenb@kernel.org, pavel@ucw.cz, rjw@sisk.pl, rui.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     ACPI: preserve the ebx value in acpi_copy_wakeup_routine
has been removed from the -mm tree.  Its filename was
     acpi-preserve-the-ebx-value-in-acpi_copy_wakeup_routine.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ACPI: preserve the ebx value in acpi_copy_wakeup_routine
From: Tian Kevin <kevin.tian@intel.com>

Register %ebx serves as the "global offset table base register" for
position-independent code.  For absolute code, %ebx serves as a local
register and has no specified role in the function calling sequence.  In
either case, a function must preserve the register value for the caller.

acpi_copy_wakeup_routine overrides %ebx without saving it, this may corrupt
the called data.

Kevin found that most time the value of Sx is saved in %esi, however
sometimes compiler also uses %ebx.  When this happens, suspends fails since
sleep value in ebx is changed by acpi_copy_wakeup_routine.

The same funtion in X86_64 doesn't have this problem.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Looks-okay-to: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>
Acked-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/acpi/wakeup.S |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/i386/kernel/acpi/wakeup.S~acpi-preserve-the-ebx-value-in-acpi_copy_wakeup_routine arch/i386/kernel/acpi/wakeup.S
--- a/arch/i386/kernel/acpi/wakeup.S~acpi-preserve-the-ebx-value-in-acpi_copy_wakeup_routine
+++ a/arch/i386/kernel/acpi/wakeup.S
@@ -230,6 +230,7 @@ bogus_magic:
 #
 ENTRY(acpi_copy_wakeup_routine)
 
+	pushl	%ebx
 	sgdt	saved_gdt
 	sidt	saved_idt
 	sldt	saved_ldt
@@ -263,6 +264,7 @@ ENTRY(acpi_copy_wakeup_routine)
 	movl	%edx, video_flags - wakeup_start (%eax)
 	movl	$0x12345678, real_magic - wakeup_start (%eax)
 	movl	$0x12345678, saved_magic
+	popl	%ebx
 	ret
 
 save_registers:
_

Patches currently in -mm which might be from kevin.tian@intel.com are
