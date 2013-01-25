From: akpm@linux-foundation.org
Subject: + unhide-config_panic_on_oops.patch added to -mm tree
Date: Thu, 24 Jan 2013 16:31:14 -0800
Message-ID: <20130125003114.9254A5A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:41200 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab3AYAbP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Jan 2013 19:31:15 -0500
Received: by mail-qa0-f74.google.com with SMTP id r4so126735qaq.5
        for <mm-commits@vger.kernel.org>; Thu, 24 Jan 2013 16:31:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kyle@redhat.com, mingo@elte.hu


The patch titled
     Subject: lib/Kconfig.debug: unhide CONFIG_PANIC_ON_OOPS
has been added to the -mm tree.  Its filename is
     unhide-config_panic_on_oops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kyle McMartin <kyle@redhat.com>
Subject: lib/Kconfig.debug: unhide CONFIG_PANIC_ON_OOPS

CONFIG_EXPERT doesn't really make sense, and hides it unintentionally. 
Remove superfluous "default n" pointed out by Ingo as well.

Signed-off-by: Kyle McMartin <kyle@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN lib/Kconfig.debug~unhide-config_panic_on_oops lib/Kconfig.debug
--- a/lib/Kconfig.debug~unhide-config_panic_on_oops
+++ a/lib/Kconfig.debug
@@ -243,8 +243,7 @@ config BOOTPARAM_SOFTLOCKUP_PANIC_VALUE
 	default 1 if BOOTPARAM_SOFTLOCKUP_PANIC
 
 config PANIC_ON_OOPS
-	bool "Panic on Oops" if EXPERT
-	default n
+	bool "Panic on Oops"
 	help
 	  Say Y here to enable the kernel to panic when it oopses. This
 	  has the same effect as setting oops=panic on the kernel command
_

Patches currently in -mm which might be from kyle@redhat.com are

unhide-config_panic_on_oops.patch

