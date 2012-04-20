From: akpm@linux-foundation.org
Subject: + leds-add-new-field-to-led_classdev-struct-to-save-activation-state.patch added to -mm tree
Date: Fri, 20 Apr 2012 14:02:37 -0700
Message-ID: <20120420210237.80172A03CD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:55593 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab2DTVCk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Apr 2012 17:02:40 -0400
Received: by lbol12 with SMTP id l12so292680lbo.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Apr 2012 14:02:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shuahkhan@gmail.com, rpurdie@rpsys.net


The patch titled
     Subject: leds: add new field to led_classdev struct to save activation state
has been added to the -mm tree.  Its filename is
     leds-add-new-field-to-led_classdev-struct-to-save-activation-state.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shuah Khan <shuahkhan@gmail.com>
Subject: leds: add new field to led_classdev struct to save activation state

Add a new field to led_classdev to save activattion state after activate
routine is successful.  This saved state is used in deactivate routine to
do cleanup such as removing device files, and free memory allocated during
activation.  Currently trigger_data not being null is used for this
purpose.

Existing triggers will need changes to use this new field.

Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/leds.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/leds.h~leds-add-new-field-to-led_classdev-struct-to-save-activation-state include/linux/leds.h
--- a/include/linux/leds.h~leds-add-new-field-to-led_classdev-struct-to-save-activation-state
+++ a/include/linux/leds.h
@@ -73,6 +73,8 @@ struct led_classdev {
 	struct led_trigger	*trigger;
 	struct list_head	 trig_list;
 	void			*trigger_data;
+	/* true if activated - deactivate routine uses it to do cleanup */
+	bool			activated;
 #endif
 };
 
_
Subject: Subject: leds: add new field to led_classdev struct to save activation state

Patches currently in -mm which might be from shuahkhan@gmail.com are

linux-next.patch
leds-add-led-driver-for-lm3556-chip.patch
leds-simple_strtoul-cleanup.patch
leds-add-new-field-to-led_classdev-struct-to-save-activation-state.patch
leds-change-existing-triggers-to-use-activated-flag.patch
leds-change-ledtrig-timer-to-use-activated-flag.patch

