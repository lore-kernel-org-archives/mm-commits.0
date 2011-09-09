From: akpm@linux-foundation.org
Subject: + leds-set-leds_triggers-as-tristate.patch added to -mm tree
Date: Fri, 09 Sep 2011 16:55:19 -0700
Message-ID: <201109092355.p89NtJvS013872@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753308Ab1IIXzU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2011 19:55:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@canonical.com, richard.purdie@linuxfoundation.org


The patch titled
     leds: set LEDS_TRIGGERS as tristate
has been added to the -mm tree.  Its filename is
     leds-set-leds_triggers-as-tristate.patch

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
Subject: leds: set LEDS_TRIGGERS as tristate
From: Bryan Wu <bryan.wu@canonical.com>

LEDS_TRIGGERS depends on LEDS_CLASSS, which should be tristate.  So set it
as tristate too and update header files as well.

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
Cc: Richard Purdie <richard.purdie@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig |    2 +-
 drivers/leds/leds.h  |    2 +-
 include/linux/leds.h |    7 ++++---
 3 files changed, 6 insertions(+), 5 deletions(-)

diff -puN drivers/leds/Kconfig~leds-set-leds_triggers-as-tristate drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~leds-set-leds_triggers-as-tristate
+++ a/drivers/leds/Kconfig
@@ -391,7 +391,7 @@ config LEDS_RENESAS_TPU
 	  Brightness control is supported but hardware blinking is not.
 
 config LEDS_TRIGGERS
-	bool "LED Trigger support"
+	tristate "LED Trigger support"
 	depends on LEDS_CLASS
 	help
 	  This option enables trigger support for the leds class.
diff -puN drivers/leds/leds.h~leds-set-leds_triggers-as-tristate drivers/leds/leds.h
--- a/drivers/leds/leds.h~leds-set-leds_triggers-as-tristate
+++ a/drivers/leds/leds.h
@@ -35,7 +35,7 @@ static inline int led_get_brightness(str
 extern struct rw_semaphore leds_list_lock;
 extern struct list_head leds_list;
 
-#ifdef CONFIG_LEDS_TRIGGERS
+#if defined(CONFIG_LEDS_TRIGGERS) || defined(CONFIG_LEDS_TRIGGERS_MODULE)
 void led_trigger_set_default(struct led_classdev *led_cdev);
 void led_trigger_set(struct led_classdev *led_cdev,
 			struct led_trigger *trigger);
diff -puN include/linux/leds.h~leds-set-leds_triggers-as-tristate include/linux/leds.h
--- a/include/linux/leds.h~leds-set-leds_triggers-as-tristate
+++ a/include/linux/leds.h
@@ -66,7 +66,7 @@ struct led_classdev {
 	struct timer_list	 blink_timer;
 	int			 blink_brightness;
 
-#ifdef CONFIG_LEDS_TRIGGERS
+#if defined(CONFIG_LEDS_TRIGGERS) || defined(CONFIG_LEDS_TRIGGERS_MODULE)
 	/* Protects the trigger data below */
 	struct rw_semaphore	 trigger_lock;
 
@@ -115,7 +115,7 @@ extern void led_brightness_set(struct le
 /*
  * LED Triggers
  */
-#ifdef CONFIG_LEDS_TRIGGERS
+#if defined(CONFIG_LEDS_TRIGGERS) || defined(CONFIG_LEDS_TRIGGERS_MODULE)
 
 #define TRIG_NAME_MAX 50
 
@@ -161,7 +161,8 @@ extern void led_trigger_blink(struct led
 #endif
 
 /* Trigger specific functions */
-#ifdef CONFIG_LEDS_TRIGGER_IDE_DISK
+#if defined(CONFIG_LEDS_TRIGGER_IDE_DISK) || \
+	defined(CONFIG_LEDS_TRIGGER_IDE_DISK_MODULE)
 extern void ledtrig_ide_activity(void);
 #else
 #define ledtrig_ide_activity() do {} while(0)
_

Patches currently in -mm which might be from bryan.wu@canonical.com are

origin.patch
leds-class-change-back-leds_class-to-tristate-instead-of-bool.patch
documentation-leds-class-fix-a-typo.patch
leds-set-leds_triggers-as-tristate.patch

