From: akpm@linux-foundation.org
Subject: + init-kconfig-fix-expert-menu-list.patch added to -mm tree
Date: Tue, 26 Apr 2011 12:54:30 -0700
Message-ID: <201104261954.p3QJsU5t015166@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47422 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756696Ab1DZTyp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Apr 2011 15:54:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, pefoley2@verizon.net, rientjes@google.com


The patch titled
     init/Kconfig: fix EXPERT menu list
has been added to the -mm tree.  Its filename is
     init-kconfig-fix-expert-menu-list.patch

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
Subject: init/Kconfig: fix EXPERT menu list
From: Randy Dunlap <randy.dunlap@oracle.com>

The EXPERT menu list was recently broken by the insertion of a kconfig
symbol (EMBEDDED) at the beginning of the EXPERT list of kconfig items. 
Broken by:

  commit 6a108a14fa356ef607be308b68337939e56ea94e
  Author: David Rientjes <rientjes@google.com>
  Date:   Thu Jan 20 14:44:16 2011 -0800
    kconfig: rename CONFIG_EMBEDDED to CONFIG_EXPERT

Restore the EXPERT menu list -- don't inject a symbol (EMBEDDED) that does
not depend on EXPERT into the list.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Peter Foley <pefoley2@verizon.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN init/Kconfig~init-kconfig-fix-expert-menu-list init/Kconfig
--- a/init/Kconfig~init-kconfig-fix-expert-menu-list
+++ a/init/Kconfig
@@ -929,14 +929,6 @@ menuconfig EXPERT
           environments which can tolerate a "non-standard" kernel.
           Only use this if you really know what you are doing.
 
-config EMBEDDED
-	bool "Embedded system"
-	select EXPERT
-	help
-	  This option should be enabled if compiling the kernel for
-	  an embedded system so certain expert options are available
-	  for configuration.
-
 config UID16
 	bool "Enable 16-bit UID system calls" if EXPERT
 	depends on ARM || BLACKFIN || CRIS || FRV || H8300 || X86_32 || M68K || (S390 && !64BIT) || SUPERH || SPARC32 || (SPARC64 && COMPAT) || UML || (X86_64 && IA32_EMULATION)
@@ -1103,6 +1095,14 @@ config AIO
           by some high performance threaded applications. Disabling
           this option saves about 7k.
 
+config EMBEDDED
+	bool "Embedded system"
+	select EXPERT
+	help
+	  This option should be enabled if compiling the kernel for
+	  an embedded system so certain expert options are available
+	  for configuration.
+
 config HAVE_PERF_EVENTS
 	bool
 	help
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
uml-fix-hppfs-build.patch
init-kconfig-fix-expert-menu-list.patch
drivers-leds-leds-pca9532c-add-gpio-capability.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
drivers-scsi-megaraidc-fix-sparse-warnings.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

