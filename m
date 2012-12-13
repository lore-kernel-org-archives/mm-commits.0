From: akpm@linux-foundation.org
Subject: + kconfig-fix-irq-subsystem-menu.patch added to -mm tree
Date: Thu, 13 Dec 2012 14:31:18 -0800
Message-ID: <20121213223118.9E216100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:60599 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117Ab2LMWbU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Dec 2012 17:31:20 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so276160qcq.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Dec 2012 14:31:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: set.mailinglist@gmail.com, grant.likely@secretlab.ca, tglx@linutronix.de


The patch titled
     Subject: Kconfig: fix Irq Subsystem menu
has been added to the -mm tree.  Its filename is
     kconfig-fix-irq-subsystem-menu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Paul Thompson <set.mailinglist@gmail.com>
Subject: Kconfig: fix Irq Subsystem menu

In menuconfig, General setup -> Irq subsystem contains two possible
menu-items.  Sometimes, neither menu-item exists.  This patch prevents the
Irq susystem menu from appearing at all unless it will contain at least
one menu-item, preventing a confusing, empty menu.

Cc: Paul Thompson <set.mailinglist@gmail.com>
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
