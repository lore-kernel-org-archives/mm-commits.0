From: akpm@linux-foundation.org
Subject: [merged] leds-add-new-field-to-led_classdev-struct-to-save-activation-state.patch removed from -mm tree
Date: Thu, 31 May 2012 12:19:36 -0700
Message-ID: <20120531191936.699DAA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:64206 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933068Ab2EaTTh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:19:37 -0400
Received: by vbnl22 with SMTP id l22so134584vbn.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:19:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shuahkhan@gmail.com, bryan.wu@canonical.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: leds: add new field to led_classdev struct to save activation state
has been removed from the -mm tree.  Its filename was
     leds-add-new-field-to-led_classdev-struct-to-save-activation-state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
Cc: Bryan Wu <bryan.wu@canonical.com>
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

Patches currently in -mm which might be from shuahkhan@gmail.com are

origin.patch

