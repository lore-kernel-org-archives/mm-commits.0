From: akpm@linux-foundation.org
Subject: [folded-merged]
 debugging-keep-track-of-page-owner-now-depends-on-stacktrace_support.patch
 removed from -mm tree
Date: Fri, 15 Nov 2013 14:24:10 -0800
Message-ID: <52869f0a.iPeq7Z7/00bF9Aie%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36365 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab3KOWYL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 17:24:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fengguang.wu@intel.com, dave@linux.vnet.ibm.com

Subject: [folded-merged] debugging-keep-track-of-page-owner-now-depends-on-stacktrace_support.patch removed from -mm tree
To: dave@linux.vnet.ibm.com,fengguang.wu@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 14:24:10 -0800


The patch titled
     Subject: PAGE_OWNER now depends on STACKTRACE_SUPPORT
has been removed from the -mm tree.  Its filename was
     debugging-keep-track-of-page-owner-now-depends-on-stacktrace_support.patch

This patch was dropped because it was folded into debugging-keep-track-of-page-owners.patch

------------------------------------------------------
From: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: PAGE_OWNER now depends on STACKTRACE_SUPPORT

One of the enhancements I made to the PAGE_OWNER code was to make
it use the generic stack trace support.  However, there are some
architectures that do not support it, like m68k.  So, make
PAGE_OWNER also depend on having STACKTRACE_SUPPORT.

This isn't ideal since it restricts the number of places
PAGE_OWNER runs now, but it at least hits all the major
architectures.

tree:   git://git.cmpxchg.org/linux-mmotm.git master
head:   83b324c5ff5cca85bbeb2ba913d465f108afe472
commit: 2a561c9d47c295ed91984c2b916a4dd450ee0279 [484/499] debugging-keep-track-of-page-owners-fix
config: make ARCH=m68k allmodconfig

All warnings:

warning: (PAGE_OWNER && STACK_TRACER && BLK_DEV_IO_TRACE && KMEMCHECK) selects STACKTRACE which has unmet direct dependencies (STACKTRACE_SUPPORT)

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/Kconfig.debug~debugging-keep-track-of-page-owner-now-depends-on-stacktrace_support lib/Kconfig.debug
--- a/lib/Kconfig.debug~debugging-keep-track-of-page-owner-now-depends-on-stacktrace_support
+++ a/lib/Kconfig.debug
@@ -205,7 +205,7 @@ config UNUSED_SYMBOLS
 
 config PAGE_OWNER
 	bool "Track page owner"
-	depends on DEBUG_KERNEL
+	depends on DEBUG_KERNEL && STACKTRACE_SUPPORT
 	select DEBUG_FS
 	select STACKTRACE
 	help
_

Patches currently in -mm which might be from dave@linux.vnet.ibm.com are

debugging-keep-track-of-page-owners.patch

