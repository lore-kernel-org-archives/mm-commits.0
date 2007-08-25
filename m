From: akpm@linux-foundation.org
Subject: + double-hpet-clocksource-hard-freeze.patch added to -mm tree
Date: Fri, 24 Aug 2007 17:14:20 -0700
Message-ID: <200708250014.l7P0EKvQ021910@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38789 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753224AbXHYAPG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 20:15:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnstul@us.ibm.com, bob.picco@hp.com, ornati@fastwebnet.it, tglx@linutronix.de, tony.luck@intel.com


The patch titled
     fix "double" hpet clocksource && hard freeze
has been added to the -mm tree.  Its filename is
     double-hpet-clocksource-hard-freeze.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix "double" hpet clocksource && hard freeze
From: john stultz <johnstul@us.ibm.com>

The ia64 hpet clocksource was implemented in generic code, and is not yet
ready to replace the i386 and x86_64 implementations.  This results in
multiple hpet clocksources being registered, and if the ia64 one is chosen
on x86_64 some users have experienced hangs.

This patch only allows the generic implementation to be used on ia64, until
the duplicate i386 and x86_64 versions can be merged in and tested.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Paolo Ornati <ornati@fastwebnet.it>
Cc: Bob Picco <bob.picco@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hpet.c |   10 ++++++++++
 1 files changed, 10 insertions(+)

diff -puN drivers/char/hpet.c~double-hpet-clocksource-hard-freeze drivers/char/hpet.c
--- a/drivers/char/hpet.c~double-hpet-clocksource-hard-freeze
+++ a/drivers/char/hpet.c
@@ -78,7 +78,17 @@ static struct clocksource clocksource_hp
         .shift          = 10,
         .flags          = CLOCK_SOURCE_IS_CONTINUOUS,
 };
+
+/* XXX - FIXME: i386, x86_64 and ia64 all have separate 
+ * hpet clocksource implementations. They should be merged 
+ * and this would be a good place for it.
+ * Right now this is ia64 only.
+ */
+#ifdef CONFIG_IA64
 static struct clocksource *hpet_clocksource;
+#else /* this isn't generic enough to use for everyone yet */
+static struct clocksource *hpet_clocksource = (struct clocksource*)0xdead;
+#endif
 
 /* A lock for concurrent access by app and isr hpet activity. */
 static DEFINE_SPINLOCK(hpet_lock);
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

origin.patch
double-hpet-clocksource-hard-freeze.patch
git-acpi.patch
geode-mfgpt-clock-event-device-support.patch
clockevents-remove-unused-inline-function.patch
clockevents-allow-build-without-runtime-use.patch
i386-prepare-sharing-hpet-code.patch
i386-hpet-add-x8664-hpet-bits.patch
x86_64-use-i386-i8253-h.patch
x86_64-preparatory-apic-set-lvtt.patch
x86_64-apic-remove-bogus-pit-synchronization.patch
x86_64-apic-shuffle-calibration-around.patch
x86_64-apic-calibration-remove-divisor.patch
x86_64-apic-change-setup-calling-convention.patch
x86_64-apic-remove-nested-irq-disable.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-apic-add-clockevents-functions.patch
x86_64-convert-to-clockevents.patch
x86_64-remove-unused-code.patch
x86_64-cleanup-apic-c.patch
jiffies-remove-unused-macros.patch
acpi-remove-the-useless-ifdef-code.patch
i386-pit-remove-the-useless-ifdefs.patch
i386-hpet-sharing-optimize.patch
ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer.patch
ich-force-hpet-restructure-hpet-generic-clock-code.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-late-initialization-of-hpet-after-quirk.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch
ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch
hpet-force-enable-on-ich34.patch
hpet-force-enable-on-vt8235-37-chipsets.patch
kernel-time-timekeepingc-cleanups.patch
use-num_possible_cpus-instead-of-nr_cpus-for-timer.patch
kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
