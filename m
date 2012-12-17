From: akpm@linux-foundation.org
Subject: [failures] kconfig-fix-irq-subsystem-menu.patch removed from -mm tree
Date: Mon, 17 Dec 2012 12:51:12 -0800
Message-ID: <20121217205113.7717320004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:53378 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab2LQUvQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Dec 2012 15:51:16 -0500
Received: by mail-lb0-f202.google.com with SMTP id s4so421lbc.1
        for <mm-commits@vger.kernel.org>; Mon, 17 Dec 2012 12:51:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: set.mailinglist@gmail.com, grant.likely@secretlab.ca, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: Kconfig: fix Irq Subsystem menu
has been removed from the -mm tree.  Its filename was
     kconfig-fix-irq-subsystem-menu.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Paul Thompson <set.mailinglist@gmail.com>
Subject: Kconfig: fix Irq Subsystem menu

In menuconfig, General setup -> Irq subsystem contains two possible
menu-items.  Sometimes, neither menu-item exists.  This patch prevents the
Irq susystem menu from appearing at all unless it will contain at least
one menu-item, preventing a confusing, empty menu.

Signed-off-by: Paul Thompson <set.mailinglist@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/Kconfig |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN kernel/irq/Kconfig~kconfig-fix-irq-subsystem-menu kernel/irq/Kconfig
--- a/kernel/irq/Kconfig~kconfig-fix-irq-subsystem-menu
+++ a/kernel/irq/Kconfig
@@ -3,7 +3,6 @@ config HAVE_GENERIC_HARDIRQS
 	bool
 
 if HAVE_GENERIC_HARDIRQS
-menu "IRQ subsystem"
 #
 # Interrupt subsystem related configuration options
 #
@@ -56,6 +55,13 @@ config GENERIC_IRQ_CHIP
 config IRQ_DOMAIN
 	bool
 
+# Support forced irq threading
+config IRQ_FORCED_THREADING
+       bool
+
+menu "IRQ subsystem"
+	depends on ( IRQ_DOMAIN && DEBUG_FS ) || MAY_HAVE_SPARSE_IRQ
+
 config IRQ_DOMAIN_DEBUG
 	bool "Expose hardware/virtual IRQ mapping via debugfs"
 	depends on IRQ_DOMAIN && DEBUG_FS
@@ -66,10 +72,6 @@ config IRQ_DOMAIN_DEBUG
 
 	  If you don't know what this means you don't need it.
 
-# Support forced irq threading
-config IRQ_FORCED_THREADING
-       bool
