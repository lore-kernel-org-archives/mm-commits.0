From: akpm@linux-foundation.org
Subject: + adjust-hard-lockup-related-kconfig-options.patch added to -mm tree
Date: Wed, 12 Sep 2012 12:06:28 -0700
Message-ID: <20120912190628.A73531E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:56317 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab2ILTGa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Sep 2012 15:06:30 -0400
Received: by qafl39 with SMTP id l39so235345qaf.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Sep 2012 12:06:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: JBeulich@suse.com, a.p.zijlstra@chello.nl, dzickus@redhat.com, jbeulich@suse.com


The patch titled
     Subject: lib/Kconfig.debug: adjust hard-lockup related Kconfig options
has been added to the -mm tree.  Its filename is
     adjust-hard-lockup-related-kconfig-options.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Jan Beulich" <JBeulich@suse.com>
Subject: lib/Kconfig.debug: adjust hard-lockup related Kconfig options

The main option should not appear in the resulting .config when the
dependencies aren't met (i.e.  use "depends on" rather than directly
setting the default from the combined dependency values).

The sub-options should depend on the main option rather than a more
generic higher level one.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Acked-by: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN lib/Kconfig.debug~adjust-hard-lockup-related-kconfig-options lib/Kconfig.debug
--- a/lib/Kconfig.debug~adjust-hard-lockup-related-kconfig-options
+++ a/lib/Kconfig.debug
@@ -196,12 +196,13 @@ config LOCKUP_DETECTOR
 	  thresholds can be controlled through the sysctl watchdog_thresh.
 
 config HARDLOCKUP_DETECTOR
-	def_bool LOCKUP_DETECTOR && PERF_EVENTS && HAVE_PERF_EVENTS_NMI && \
-		 !HAVE_NMI_WATCHDOG
+	def_bool y
+	depends on LOCKUP_DETECTOR && !HAVE_NMI_WATCHDOG
+	depends on PERF_EVENTS && HAVE_PERF_EVENTS_NMI
 
 config BOOTPARAM_HARDLOCKUP_PANIC
 	bool "Panic (Reboot) On Hard Lockups"
-	depends on LOCKUP_DETECTOR
+	depends on HARDLOCKUP_DETECTOR
 	help
 	  Say Y here to enable the kernel to panic on "hard lockups",
 	  which are bugs that cause the kernel to loop in kernel
@@ -212,7 +213,7 @@ config BOOTPARAM_HARDLOCKUP_PANIC
 
 config BOOTPARAM_HARDLOCKUP_PANIC_VALUE
 	int
-	depends on LOCKUP_DETECTOR
+	depends on HARDLOCKUP_DETECTOR
 	range 0 1
 	default 0 if !BOOTPARAM_HARDLOCKUP_PANIC
 	default 1 if BOOTPARAM_HARDLOCKUP_PANIC
_

Patches currently in -mm which might be from JBeulich@suse.com are

linux-next.patch
adjust-hard-lockup-related-kconfig-options.patch

