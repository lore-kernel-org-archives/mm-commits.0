From: akpm@linux-foundation.org
Subject: - ipmi-documentation-fixes.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:46:16 -0700
Message-ID: <200710190346.l9J3kG50013316@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60836 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764000AbXJSDzS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cminyard@mvista.com, mm-commits@vger.kernel.org


The patch titled
     IPMI: documentation fixes
has been removed from the -mm tree.  Its filename was
     ipmi-documentation-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: IPMI: documentation fixes
From: Corey Minyard <cminyard@mvista.com>

Clean up IPMI documentation to remove references to high-res timers and add
info about the polling thread.  Also fix an doc error for a parameter.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/IPMI.txt |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff -puN Documentation/IPMI.txt~ipmi-documentation-fixes Documentation/IPMI.txt
--- a/Documentation/IPMI.txt~ipmi-documentation-fixes
+++ a/Documentation/IPMI.txt
@@ -441,17 +441,20 @@ ACPI, and if none of those then a KCS de
 0xca2.  If you want to turn this off, set the "trydefaults" option to
 false.
 
-If you have high-res timers compiled into the kernel, the driver will
-use them to provide much better performance.  Note that if you do not
-have high-res timers enabled in the kernel and you don't have
-interrupts enabled, the driver will run VERY slowly.  Don't blame me,
+If your IPMI interface does not support interrupts and is a KCS or
+SMIC interface, the IPMI driver will start a kernel thread for the
+interface to help speed things up.  This is a low-priority kernel
+thread that constantly polls the IPMI driver while an IPMI operation
+is in progress.  The force_kipmid module parameter will all the user to
+force this thread on or off.  If you force it off and don't have
+interrupts, the driver will run VERY slowly.  Don't blame me,
 these interfaces suck.
 
 The driver supports a hot add and remove of interfaces.  This way,
 interfaces can be added or removed after the kernel is up and running.
-This is done using /sys/modules/ipmi_si/hotmod, which is a write-only
-parameter.  You write a string to this interface.  The string has the
-format:
+This is done using /sys/modules/ipmi_si/parameters/hotmod, which is a
+write-only parameter.  You write a string to this interface.  The string
+has the format:
    <op1>[:op2[:op3...]]
 The "op"s are:
    add|remove,kcs|bt|smic,mem|i/o,<address>[,<opt1>[,<opt2>[,...]]]
_

Patches currently in -mm which might be from cminyard@mvista.com are

origin.patch
