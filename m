From: akpm@linux-foundation.org
Subject: - i386-fix-nmi-watchdog-not-reserving-its-msrs.patch removed from -mm tree
Date: Sat, 23 Jun 2007 12:26:55 -0700
Message-ID: <200706231926.l5NJQtW2022014@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43454 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752993AbXFWT1H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 15:27:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: B.Steinbrink@gmx.de, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     i386: fix NMI watchdog not reserving its MSRs
has been removed from the -mm tree.  Its filename was
     i386-fix-nmi-watchdog-not-reserving-its-msrs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: fix NMI watchdog not reserving its MSRs
From: Bjorn Steinbrink <B.Steinbrink@gmx.de>

At system boot time, the NMI watchdog no longer reserved its MSRs, allowing
other subsystems to mess with them.  Fix that.

Signed-off-by: Bjorn Steinbrink <B.Steinbrink@gmx.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/perfctr-watchdog.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN arch/i386/kernel/cpu/perfctr-watchdog.c~i386-fix-nmi-watchdog-not-reserving-its-msrs arch/i386/kernel/cpu/perfctr-watchdog.c
--- a/arch/i386/kernel/cpu/perfctr-watchdog.c~i386-fix-nmi-watchdog-not-reserving-its-msrs
+++ a/arch/i386/kernel/cpu/perfctr-watchdog.c
@@ -614,6 +614,12 @@ int lapic_watchdog_init(unsigned nmi_hz)
 		probe_nmi_watchdog();
 		if (!wd_ops)
 			return -1;
+
+		if (!wd_ops->reserve()) {
+			printk(KERN_ERR
+				"NMI watchdog: cannot reserve perfctrs\n");
+			return -1;
+		}
 	}
 
 	if (!(wd_ops->setup(nmi_hz))) {
_

Patches currently in -mm which might be from B.Steinbrink@gmx.de are
