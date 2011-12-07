From: akpm@linux-foundation.org
Subject: + x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-v2.patch added to -mm tree
Date: Wed, 07 Dec 2011 15:16:28 -0800
Message-ID: <201112072316.pB7NGT7A008720@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:57346 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab1LGXQj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Dec 2011 18:16:39 -0500
Received: by eekc14 with SMTP id c14so24677eek.1
        for <mm-commits@vger.kernel.org>; Wed, 07 Dec 2011 15:16:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dsd@laptop.org, dilinger@queued.net, hpa@zytor.com, mingo@elte.hu, mjg@redhat.com, tglx@linutronix.de


The patch titled
     Subject: x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-v2
has been added to the -mm tree.  Its filename is
     x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-v2.patch

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
Subject: Subject: x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-v2

Patches currently in -mm which might be from dsd@laptop.org are

linux-next.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-fix.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs-v2.patch
x86-olpc-add-debugfs-interface-for-ec-commands.patch

