From: akpm@linux-foundation.org
Subject: - xen-disable-all-non-virtual-devices.patch removed from -mm tree
Date: Sat, 23 Jun 2007 12:28:26 -0700
Message-ID: <200706231928.l5NJSQNs022147@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60029 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753975AbXFWTer (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 15:34:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@xensource.com, ak@suse.de, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     xen: disable all non-virtual devices
has been removed from the -mm tree.  Its filename was
     xen-disable-all-non-virtual-devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: xen: disable all non-virtual devices
From: Jeremy Fitzhardinge <jeremy@xensource.com>

A domU Xen environment has no non-virtual drivers, so make sure they're all
disabled at once.  This noticeably speeds up boot time.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/xen/setup.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/i386/xen/setup.c~xen-disable-all-non-virtual-devices arch/i386/xen/setup.c
--- a/arch/i386/xen/setup.c~xen-disable-all-non-virtual-devices
+++ a/arch/i386/xen/setup.c
@@ -93,4 +93,6 @@ void __init xen_arch_setup(void)
 	/* fill cpus_possible with all available cpus */
 	xen_fill_possible_map();
 #endif
+
+	paravirt_disable_iospace();
 }
_

Patches currently in -mm which might be from jeremy@xensource.com are

git-kbuild.patch
add-kstrndup-fix.patch
more-fix-x86_64-mm-xen-xen-smp-guest-support.patch
x86-use-elfnoteh-to-generate-vsyscall-notes-fix.patch
paravirt-helper-to-disable-all-io-space-fix.patch
paravirt-helper-to-disable-all-io-space-fix-2.patch
paravirt-helper-to-disable-all-io-space-fix-3.patch
