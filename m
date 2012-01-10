From: akpm@linux-foundation.org
Subject: [folded] x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-v2.patch removed from -mm tree
Date: Tue, 10 Jan 2012 15:35:38 -0800
Message-ID: <20120110233539.5E7122000C2@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:64832 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756633Ab2AJXfm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2012 18:35:42 -0500
Received: by eekd41 with SMTP id d41so4362eek.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2012 15:35:41 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dsd@laptop.org, dilinger@queued.net, hpa@zytor.com, mingo@elte.hu, mjg@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-v2
has been removed from the -mm tree.  Its filename was
     x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-v2.patch

This patch was dropped because it was folded into x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Daniel Drake <dsd@laptop.org>
Subject: x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-v2

v2: Fix sscanf usage error and add an explanatory comment in the code, both pointed out by Andrew Morton. Thanks!

Signed-off-by: Daniel Drake <dsd@laptop.org>
Cc: Andres Salomon <dilinger@queued.net>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/platform/olpc/olpc-xo15-sci.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN arch/x86/platform/olpc/olpc-xo15-sci.c~x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-v2 arch/x86/platform/olpc/olpc-xo15-sci.c
--- a/arch/x86/platform/olpc/olpc-xo15-sci.c~x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-v2
+++ a/arch/x86/platform/olpc/olpc-xo15-sci.c
@@ -26,6 +26,17 @@
 static unsigned long xo15_sci_gpe;
 static bool lid_wake_on_close;
 
+/*
+ * The normal ACPI LID wakeup behavior is wake-on-open, but not
+ * wake-on-close. This is implemented as standard by the XO-1.5 DSDT.
+ *
+ * We provide here a sysfs attribute that will additionally enable
+ * wake-on-close behavior. This is useful (e.g.) when we oportunistically
+ * suspend with the display running; if the lid is then closed, we want to
+ * wake up to turn the display off.
+ *
+ * This is controlled through a custom method in the XO-1.5 DSDT.
+ */
 static int set_lid_wake_behavior(bool wake_on_close)
 {
 	struct acpi_object_list arg_list;
@@ -39,7 +50,7 @@ static int set_lid_wake_behavior(bool wa
 	status = acpi_evaluate_object(NULL, "\\_SB.PCI0.LID.LIDW", &arg_list,
 				      NULL);
 	if (ACPI_FAILURE(status)) {
-		pr_warning(PFX "failed to set lid behaviour\n");
+		pr_warning(PFX "failed to set lid behavior\n");
 		return 1;
 	}
 
_

Patches currently in -mm which might be from dsd@laptop.org are

origin.patch
linux-next.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
x86-olpc-add-debugfs-interface-for-ec-commands.patch

