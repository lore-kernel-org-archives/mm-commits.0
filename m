From: akpm@linux-foundation.org
Subject: + gcov-disable-config_constructors-when-not-needed-by-config_gcov_kernel.patch added to -mm tree
Date: Tue, 14 Jun 2011 18:27:14 -0700
Message-ID: <201106150124.p5F1OVUh031947@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37222 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754293Ab1FOBZK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Jun 2011 21:25:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: josh@joshtriplett.org, peter.oberparleiter@de.ibm.com, xiyou.wangcong@gmail.com


The patch titled
     gcov: disable CONFIG_CONSTRUCTORS when not needed by CONFIG_GCOV_KERNEL
has been added to the -mm tree.  Its filename is
     gcov-disable-config_constructors-when-not-needed-by-config_gcov_kernel.patch

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
Subject: gcov: disable CONFIG_CONSTRUCTORS when not needed by CONFIG_GCOV_KERNEL
From: Josh Triplett <josh@joshtriplett.org>

CONFIG_CONSTRUCTORS controls support for running constructor functions at
kernel init time.  According to commit b99b87f70c7785ab ("kernel:
constructor support"), gcov (CONFIG_GCOV_KERNEL) needs this.  However,
CONFIG_CONSTRUCTORS currently defaults to y, with no option to disable it,
and CONFIG_GCOV_KERNEL depends on it.  Instead, default it to n and have
CONFIG_GCOV_KERNEL select it, so that the normal case of
CONFIG_GCOV_KERNEL=n will result in CONFIG_CONSTRUCTORS=n.

Observed in the short list of =y values in a minimal kernel configuration.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Acked-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig        |    1 -
 kernel/gcov/Kconfig |    3 ++-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN init/Kconfig~gcov-disable-config_constructors-when-not-needed-by-config_gcov_kernel init/Kconfig
--- a/init/Kconfig~gcov-disable-config_constructors-when-not-needed-by-config_gcov_kernel
+++ a/init/Kconfig
@@ -19,7 +19,6 @@ config DEFCONFIG_LIST
 config CONSTRUCTORS
 	bool
 	depends on !UML
-	default y
 
 config HAVE_IRQ_WORK
 	bool
diff -puN kernel/gcov/Kconfig~gcov-disable-config_constructors-when-not-needed-by-config_gcov_kernel kernel/gcov/Kconfig
--- a/kernel/gcov/Kconfig~gcov-disable-config_constructors-when-not-needed-by-config_gcov_kernel
+++ a/kernel/gcov/Kconfig
@@ -2,7 +2,8 @@ menu "GCOV-based kernel profiling"
 
 config GCOV_KERNEL
 	bool "Enable gcov-based kernel profiling"
-	depends on DEBUG_FS && CONSTRUCTORS
+	depends on DEBUG_FS
+	select CONSTRUCTORS
 	default n
 	---help---
 	This option enables gcov-based code profiling (e.g. for code coverage
_

Patches currently in -mm which might be from josh@joshtriplett.org are

uts-make-default-hostname-configurable-rather-than-always-using-none.patch
gcov-disable-config_constructors-when-not-needed-by-config_gcov_kernel.patch
linux-next.patch

