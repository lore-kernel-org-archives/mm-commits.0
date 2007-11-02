From: akpm@linux-foundation.org
Subject: + i8k-adds-i8k-driver-to-the-x86_64-kconfig.patch added to -mm tree
Date: Fri, 02 Nov 2007 14:17:59 -0700
Message-ID: <200711022117.lA2LHx5m011402@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54692 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753702AbXKBVSH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Nov 2007 17:18:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bradjsmith@btinternet.com, frank@tuxrocks.com, jeff@garzik.org


The patch titled
     I8K: add i8k driver to the x86_64 Kconfig
has been added to the -mm tree.  Its filename is
     i8k-adds-i8k-driver-to-the-x86_64-kconfig.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: I8K: add i8k driver to the x86_64 Kconfig
From: Bradley Smith <bradjsmith@btinternet.com>

Adds i8k driver to the x86_64 Kconfig.

Signed-off-by: Bradley Smith <bradjsmith@btinternet.com>
Cc: Frank Sorenson <frank@tuxrocks.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig.x86_64 |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff -puN arch/x86/Kconfig.x86_64~i8k-adds-i8k-driver-to-the-x86_64-kconfig arch/x86/Kconfig.x86_64
--- a/arch/x86/Kconfig.x86_64~i8k-adds-i8k-driver-to-the-x86_64-kconfig
+++ a/arch/x86/Kconfig.x86_64
@@ -224,6 +224,26 @@ config X86_GOOD_APIC
 	bool
 	default y
 
+config I8K
+	tristate "Dell laptop support"
+	---help---
+	  This adds a driver to safely access the System Management Mode
+	  of the CPU on the Dell Inspiron 8000. The System Management Mode
+	  is used to read cpu temperature and cooling fan status and to
+	  control the fans on the I8K portables.
+
+	  This driver has been tested only on the Inspiron 8000 but it may
+	  also work with other Dell laptops. You can force loading on other
+	  models by passing the parameter `force=1' to the module. Use at
+	  your own risk.
+
+	  For information on utilities to make use of this driver see the
+	  I8K Linux utilities web site at:
+	  <http://people.debian.org/~dz/i8k/>
+
+	  Say Y if you intend to run this kernel on a Dell Inspiron 8000.
+	  Say N otherwise.
+
 config MICROCODE
 	tristate "/dev/cpu/microcode - Intel CPU microcode support"
 	select FW_LOADER
_

Patches currently in -mm which might be from bradjsmith@btinternet.com are

i8k-allow-i8k-driver-to-be-built-on-x86_64-systems.patch
i8k-adds-i8k-driver-to-the-x86_64-kconfig.patch
i8k-inspiron-e1705-fix.patch
