From: akpm@linux-foundation.org
Subject: + move-log_buf_shift-to-a-more-sensible-place.patch added to -mm tree
Date: Fri, 27 Apr 2007 16:24:29 -0700
Message-ID: <200704272324.l3RNOTg2010522@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757881AbXD0XYo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 19:24:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: s0348365@sms.ed.ac.uk, randy.dunlap@oracle.com


The patch titled
     Move LOG_BUF_SHIFT to a more sensible place
has been added to the -mm tree.  Its filename is
     move-log_buf_shift-to-a-more-sensible-place.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Move LOG_BUF_SHIFT to a more sensible place
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>

Several people have observed that perhaps LOG_BUF_SHIFT should be in a more
obvious place than under DEBUG_KERNEL. Under some circumstances (such as the
PARISC architecture), DEBUG_KERNEL can increase kernel size, which is an
undesirable trade off for something as trivial as increasing the kernel log
buffer size.

Instead, move LOG_BUF_SHIFT into "General Setup", so that people are more
likely to be able to change it such a circumstance that the default buffer
size is insufficient.

Signed-off-by: Alistair John Strachan <s0348365@sms.ed.ac.uk>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig      |   17 +++++++++++++++++
 lib/Kconfig.debug |   17 -----------------
 2 files changed, 17 insertions(+), 17 deletions(-)

diff -puN init/Kconfig~move-log_buf_shift-to-a-more-sensible-place init/Kconfig
--- a/init/Kconfig~move-log_buf_shift-to-a-more-sensible-place
+++ a/init/Kconfig
@@ -266,6 +266,23 @@ config IKCONFIG_PROC
 	  This option enables access to the kernel configuration file
 	  through /proc/config.gz.
 
+config LOG_BUF_SHIFT
+	int "Kernel log buffer size (16 => 64KB, 17 => 128KB)"
+	range 12 21
+	default 17 if S390 || LOCKDEP
+	default 16 if X86_NUMAQ || IA64
+	default 15 if SMP
+	default 14
+	help
+	  Select kernel log buffer size as a power of 2.
+	  Defaults and Examples:
+	  	     17 => 128 KB for S/390
+		     16 => 64 KB for x86 NUMAQ or IA-64
+	             15 => 32 KB for SMP
+	             14 => 16 KB for uniprocessor
+		     13 =>  8 KB
+		     12 =>  4 KB
+
 config CPUSETS
 	bool "Cpuset support"
 	depends on SMP
diff -puN lib/Kconfig.debug~move-log_buf_shift-to-a-more-sensible-place lib/Kconfig.debug
--- a/lib/Kconfig.debug~move-log_buf_shift-to-a-more-sensible-place
+++ a/lib/Kconfig.debug
@@ -86,23 +86,6 @@ config DEBUG_SHIRQ
 	  Drivers ought to be able to handle interrupts coming in at those
 	  points; some don't and need to be caught.
 
-config LOG_BUF_SHIFT
-	int "Kernel log buffer size (16 => 64KB, 17 => 128KB)" if DEBUG_KERNEL
-	range 12 21
-	default 17 if S390 || LOCKDEP
-	default 16 if X86_NUMAQ || IA64
-	default 15 if SMP
-	default 14
-	help
-	  Select kernel log buffer size as a power of 2.
-	  Defaults and Examples:
-	  	     17 => 128 KB for S/390
-		     16 => 64 KB for x86 NUMAQ or IA-64
-	             15 => 32 KB for SMP
-	             14 => 16 KB for uniprocessor
-		     13 =>  8 KB
-		     12 =>  4 KB
-
 config DETECT_SOFTLOCKUP
 	bool "Detect Soft Lockups"
 	depends on DEBUG_KERNEL && !S390
_

Patches currently in -mm which might be from s0348365@sms.ed.ac.uk are

move-log_buf_shift-to-a-more-sensible-place.patch
