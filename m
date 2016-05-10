From: akpm@linux-foundation.org
Subject: +
 mm-add-config-option-to-select-the-initial-overcommit-mode.patch added to
 -mm tree
Date: Tue, 10 May 2016 12:28:13 -0700
Message-ID: <5732364d.mgsGjF5u7uAPbR6D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54681 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbcEJT2O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2016 15:28:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sf84@laposte.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add config option to select the initial overcommit mode
has been added to the -mm tree.  Its filename is
     mm-add-config-option-to-select-the-initial-overcommit-mode.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-config-option-to-select-the-initial-overcommit-mode.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-config-option-to-select-the-initial-overcommit-mode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sebastian Frias <sf84@laposte.net>
Subject: mm: add config option to select the initial overcommit mode

Currently the initial value of the overcommit mode is OVERCOMMIT_GUESS. 
However, on embedded systems it is usually better to disable overcommit to
avoid waking up the OOM-killer and its well known undesirable
side-effects.

This config option allows to setup the initial overcommit mode to any of
the 3 available values, OVERCOMMIT_GUESS (which remains as default),
OVERCOMMIT_ALWAYS and OVERCOMMIT_NEVER.  The overcommit mode can still be
changed thru sysctl after the system boots up.

This config option depends on CONFIG_EXPERT.
This patch does not introduces functional changes.

Link: http://lkml.kernel.org/r/5731CC6E.3080807@laposte.net
Signed-off-by: Sebastian Frias <sf84@laposte.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |   32 ++++++++++++++++++++++++++++++++
 mm/util.c  |    6 ++++++
 2 files changed, 38 insertions(+)

diff -puN mm/Kconfig~mm-add-config-option-to-select-the-initial-overcommit-mode mm/Kconfig
--- a/mm/Kconfig~mm-add-config-option-to-select-the-initial-overcommit-mode
+++ a/mm/Kconfig
@@ -438,6 +438,38 @@ choice
 	  benefit.
 endchoice
 
+choice
+	prompt "Overcommit Mode"
+	default OVERCOMMIT_GUESS
+	depends on EXPERT
+	help
+	  Selects the initial value for Overcommit mode.
+
+	  NOTE: The overcommit mode can be changed dynamically through sysctl.
+
+	config OVERCOMMIT_GUESS
+		bool "Guess"
+	help
+	  Selecting this option forces the initial value of overcommit mode to
+	  "Guess" overcommits. This is the default value.
+	  See Documentation/vm/overcommit-accounting for more information.
+
+	config OVERCOMMIT_ALWAYS
+		bool "Always"
+	help
+	  Selecting this option forces the initial value of overcommit mode to
+	  "Always" overcommit.
+	  See Documentation/vm/overcommit-accounting for more information.
+
+	config OVERCOMMIT_NEVER
+		bool "Never"
+	help
+	  Selecting this option forces the initial value of overcommit mode to
+	  "Never" overcommit.
+	  See Documentation/vm/overcommit-accounting for more information.
+
+endchoice
+
 #
 # UP and nommu archs use km based percpu allocator
 #
diff -puN mm/util.c~mm-add-config-option-to-select-the-initial-overcommit-mode mm/util.c
--- a/mm/util.c~mm-add-config-option-to-select-the-initial-overcommit-mode
+++ a/mm/util.c
@@ -417,7 +417,13 @@ int __page_mapcount(struct page *page)
 }
 EXPORT_SYMBOL_GPL(__page_mapcount);
 
+#if defined(CONFIG_OVERCOMMIT_NEVER)
+int sysctl_overcommit_memory __read_mostly = OVERCOMMIT_NEVER;
+#elif defined(CONFIG_OVERCOMMIT_ALWAYS)
+int sysctl_overcommit_memory __read_mostly = OVERCOMMIT_ALWAYS;
+#else
 int sysctl_overcommit_memory __read_mostly = OVERCOMMIT_GUESS;
+#endif
 int sysctl_overcommit_ratio __read_mostly = 50;
 unsigned long sysctl_overcommit_kbytes __read_mostly;
 int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
_

Patches currently in -mm which might be from sf84@laposte.net are

mm-add-config-option-to-select-the-initial-overcommit-mode.patch

