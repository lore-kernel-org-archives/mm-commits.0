From: akpm@linux-foundation.org
Subject: + input-route-kbd-leds-through-the-generic-leds-layer-fix.patch
 added to -mm tree
Date: Wed, 30 Oct 2013 14:24:12 -0700
Message-ID: <527178fc.hMFfJkIXuoainYJy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48226 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab3J3VYN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Oct 2013 17:24:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, samuel.thibault@ens-lyon.org, ralf@linux-mips.org, dmitry.torokhov@gmail.com, blogic@openwrt.org

Subject: + input-route-kbd-leds-through-the-generic-leds-layer-fix.patch added to -mm tree
To: blogic@openwrt.org,dmitry.torokhov@gmail.com,ralf@linux-mips.org,samuel.thibault@ens-lyon.org
From: akpm@linux-foundation.org
Date: Wed, 30 Oct 2013 14:24:12 -0700


The patch titled
     Subject: input: CONFIG_INPUT_LEDS stubs should be static inline
has been added to the -mm tree.  Its filename is
     input-route-kbd-leds-through-the-generic-leds-layer-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/input-route-kbd-leds-through-the-generic-leds-layer-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/input-route-kbd-leds-through-the-generic-leds-layer-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: John Crispin <blogic@openwrt.org>
Subject: input: CONFIG_INPUT_LEDS stubs should be static inline

The following commit breaks compile when CONFIG_INPUT_LEDS is not selected.

commit 0eb6ee2db914ebb594cb9bc8ae97e3c362c3475a
Author: Samuel Thibault <samuel.thibault@ens-lyon.org>
Date:   Wed Oct 30 11:45:16 2013 +1100
input: route kbd LEDs through the generic LEDs layer

Signed-off-by: John Crispin <blogic@openwrt.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/input.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/input.h~input-route-kbd-leds-through-the-generic-leds-layer-fix include/linux/input.h
--- a/include/linux/input.h~input-route-kbd-leds-through-the-generic-leds-layer-fix
+++ a/include/linux/input.h
@@ -540,12 +540,12 @@ void input_led_disconnect(struct input_d
 
 #else
 
-int input_led_connect(struct input_dev *dev)
+static inline int input_led_connect(struct input_dev *dev)
 {
 	return 0;
 }
 
-void input_led_disconnect(struct input_dev *dev)
+static inline void input_led_disconnect(struct input_dev *dev)
 {
 }
 
_

Patches currently in -mm which might be from blogic@openwrt.org are

input-route-kbd-leds-through-the-generic-leds-layer-fix.patch
linux-next.patch

