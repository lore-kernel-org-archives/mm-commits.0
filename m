From: akpm@linux-foundation.org
Subject: + config_panic_on_oops-should-be-shown-if-debug_kernel.patch added to -mm tree
Date: Wed, 23 Jan 2013 14:04:10 -0800
Message-ID: <20130123220410.9BA305A419C@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:44977 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab3AWWEL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Jan 2013 17:04:11 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so1002212yen.2
        for <mm-commits@vger.kernel.org>; Wed, 23 Jan 2013 14:04:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kyle@redhat.com, mingo@elte.hu


The patch titled
     Subject: lib/Kconfig.debug: CONFIG_PANIC_ON_OOPS should be shown if DEBUG_KERNEL
has been added to the -mm tree.  Its filename is
     config_panic_on_oops-should-be-shown-if-debug_kernel.patch

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
Subject: lib/Kconfig.debug: CONFIG_PANIC_ON_OOPS should be shown if DEBUG_KERNEL

CONFIG_EXPERT is a bit silly a place for this, and hides it unnecessarily.
CONFIG_DEBUG_KERNEL makes much more sense.

Signed-off-by: Kyle McMartin <kyle@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/Kconfig.debug~config_panic_on_oops-should-be-shown-if-debug_kernel lib/Kconfig.debug
--- a/lib/Kconfig.debug~config_panic_on_oops-should-be-shown-if-debug_kernel
+++ a/lib/Kconfig.debug
@@ -243,7 +243,7 @@ config BOOTPARAM_SOFTLOCKUP_PANIC_VALUE
 	default 1 if BOOTPARAM_SOFTLOCKUP_PANIC
 
 config PANIC_ON_OOPS
-	bool "Panic on Oops" if EXPERT
+	bool "Panic on Oops" if DEBUG_KERNEL
 	default n
 	help
 	  Say Y here to enable the kernel to panic when it oopses. This
_

Patches currently in -mm which might be from kyle@redhat.com are

config_panic_on_oops-should-be-shown-if-debug_kernel.patch

