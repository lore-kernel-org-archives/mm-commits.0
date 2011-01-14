From: akpm@linux-foundation.org
Subject: + include-gpioh-remove-remaining-__must_check-annotiations.patch added to -mm tree
Date: Fri, 14 Jan 2011 01:17:24 -0800
Message-ID: <201101140920.p0E9K9Ht001918@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59463 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751335Ab1ANJUv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 04:20:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: w.sang@pengutronix.de, gregkh@suse.de


The patch titled
     include/gpio.h: remove remaining __must_check-annotiations
has been added to the -mm tree.  Its filename is
     include-gpioh-remove-remaining-__must_check-annotiations.patch

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
Subject: include/gpio.h: remove remaining __must_check-annotiations
From: Wolfram Sang <w.sang@pengutronix.de>

5f829e405 ("gpiolib: add missing functions to generic fallback") also
introduced two.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Greg KH <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gpio.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/gpio.h~include-gpioh-remove-remaining-__must_check-annotiations include/linux/gpio.h
--- a/include/linux/gpio.h~include-gpioh-remove-remaining-__must_check-annotiations
+++ a/include/linux/gpio.h
@@ -35,13 +35,13 @@ static inline int gpio_request(unsigned 
 	return -ENOSYS;
 }
 
-static inline int __must_check gpio_request_one(unsigned gpio,
+static inline int gpio_request_one(unsigned gpio,
 					unsigned long flags, const char *label)
 {
 	return -ENOSYS;
 }
 
-static inline int __must_check gpio_request_array(struct gpio *array, size_t num)
+static inline int gpio_request_array(struct gpio *array, size_t num)
 {
 	return -ENOSYS;
 }
_

Patches currently in -mm which might be from w.sang@pengutronix.de are

origin.patch
partially-revert-gpiolib-annotate-gpio-intialization-with-__must_check.patch
include-gpioh-remove-remaining-__must_check-annotiations.patch
linux-next.patch

