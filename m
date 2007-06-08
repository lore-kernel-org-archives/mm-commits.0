From: akpm@linux-foundation.org
Subject: + i386-fix-nmi-watchdog-not-reserving-its-msrs.patch added to -mm tree
Date: Fri, 08 Jun 2007 14:20:43 -0700
Message-ID: <200706082120.l58LKh9w012514@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59196 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759655AbXFHVUy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 17:20:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: B.Steinbrink@gmx.de, ak@suse.de


The patch titled
     i386: fix NMI watchdog not reserving its MSRs
has been added to the -mm tree.  Its filename is
     i386-fix-nmi-watchdog-not-reserving-its-msrs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 6 insertions(+)

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

i386-fix-nmi-watchdog-not-reserving-its-msrs.patch
i386-use-the-right-wrapper-to-disable-the-nmi-watchdog.patch
fix-interchanged-parameters-to-release_evntselperfctr_nmi.patch
