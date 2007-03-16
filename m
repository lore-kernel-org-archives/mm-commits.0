From: akpm@linux-foundation.org
Subject: + make-config_paravirt-require-no_hz.patch added to -mm tree
Date: Fri, 16 Mar 2007 03:05:31 -0800
Message-ID: <200703161105.l2GB5Vms009650@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41153 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186AbXCPLFy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Mar 2007 07:05:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chrisw@sous-sol.org, ak@suse.de, jeremy@goop.org, mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, zach@vmware.com


The patch titled
     make CONFIG_PARAVIRT require NO_HZ
has been added to the -mm tree.  Its filename is
     make-config_paravirt-require-no_hz.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
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
