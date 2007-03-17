From: akpm@linux-foundation.org
Subject: - make-config_paravirt-require-no_hz.patch removed from -mm tree
Date: Fri, 16 Mar 2007 17:17:31 -0700
Message-ID: <200703170019.l2H0JOax025169@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43850 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932162AbXCQAU0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Mar 2007 20:20:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chrisw@sous-sol.org, ak@suse.de, jeremy@goop.org, mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, zach@vmware.com, mm-commits@vger.kernel.org


The patch titled
     make CONFIG_PARAVIRT require NO_HZ
has been removed from the -mm tree.  Its filename was
     make-config_paravirt-require-no_hz.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: make CONFIG_PARAVIRT require NO_HZ
From: Chris Wright <chrisw@sous-sol.org>

Require NO_HZ when CONFIG_PARAVIRT.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Zachary Amsden <zach@vmware.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/Kconfig~make-config_paravirt-require-no_hz arch/i386/Kconfig
--- a/arch/i386/Kconfig~make-config_paravirt-require-no_hz
+++ a/arch/i386/Kconfig
@@ -208,7 +208,7 @@ endchoice
 
 config PARAVIRT
 	bool "Paravirtualization support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	depends on EXPERIMENTAL && NO_HZ
 	depends on !(X86_VISWS || X86_VOYAGER)
 	select NO_HZ
 	help
_

Patches currently in -mm which might be from chrisw@sous-sol.org are

make-config_paravirt-require-no_hz.patch
implement-file-posix-capabilities.patch
file-capabilities-accomodate-future-64-bit-caps.patch
allow-access-to-proc-pid-fd-after-setuid.patch
mprotect-patch-for-use-by-slim.patch
integrity-service-api-and-dummy-provider.patch
slim-main-patch.patch
slim-secfs-patch.patch
slim-make-and-config-stuff.patch
slim-debug-output.patch
slim-documentation.patch
