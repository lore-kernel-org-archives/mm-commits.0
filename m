From: akpm@linux-foundation.org
Subject: + utrace-nommu-fixup-support-utrace.patch added to -mm tree
Date: Mon, 05 Mar 2007 23:42:36 -0800
Message-ID: <200703060742.l267gakb015779@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54555 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933983AbXCFHmr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 02:42:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@analog.com, roland@redhat.com


The patch titled
     utrace: nommu fixup support utrace
has been added to the -mm tree.  Its filename is
     utrace-nommu-fixup-support-utrace.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: utrace: nommu fixup support utrace
From: "Wu, Bryan" <bryan.wu@analog.com>

When adding utrace support to blackfin architecture, I found a compiling
error in nommu related utrace stuff.  Then this little patch will fix this
for nommu arch utrace.

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/nommu.c~utrace-nommu-fixup-support-utrace mm/nommu.c
--- a/mm/nommu.c~utrace-nommu-fixup-support-utrace
+++ a/mm/nommu.c
@@ -673,7 +673,11 @@ static unsigned long determine_vm_flags(
 	 * it's being traced - otherwise breakpoints set in it may interfere
 	 * with another untraced process
 	 */
+#ifdef CONFIG_UTRACE
+	if (flags & MAP_PRIVATE)
+#else
 	if ((flags & MAP_PRIVATE) && (current->ptrace & PT_PTRACED))
+#endif
 		vm_flags &= ~VM_MAYSHARE;
 
 	return vm_flags;
_

Patches currently in -mm which might be from bryan.wu@analog.com are

blackfin-Documentation.patch
blackfin-arch.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
blackfin-on-chip-ethernet-mac-controller-driver.patch
blackfin-on-chip-ethernet-mac-controller-driver-update.patch
blackfin-patch-add-blackfin-support-in-smc91x.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
blackfin-blackfin-utrace-patch.patch
utrace-nommu-fixup-support-utrace.patch
