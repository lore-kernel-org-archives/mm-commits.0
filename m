From: akpm@linux-foundation.org
Subject: + md-check-for-memory-allocation-failure-in-faulty-personality.patch added to -mm tree
Date: Thu, 11 Sep 2008 12:00:42 -0700
Message-ID: <200809111900.m8BJ0gMk011330@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752771AbYIKTAu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Sep 2008 15:00:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sven.wegener@stealer.net, neilb@suse.de


The patch titled
     md: check for memory allocation failure in faulty personality
has been added to the -mm tree.  Its filename is
     md-check-for-memory-allocation-failure-in-faulty-personality.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: check for memory allocation failure in faulty personality
From: Sven Wegener <sven.wegener@stealer.net>

It's a fault injection module, but I don't think we should oops here.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/faulty.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/md/faulty.c~md-check-for-memory-allocation-failure-in-faulty-personality drivers/md/faulty.c
--- a/drivers/md/faulty.c~md-check-for-memory-allocation-failure-in-faulty-personality
+++ a/drivers/md/faulty.c
@@ -287,6 +287,8 @@ static int run(mddev_t *mddev)
 	int i;
 
 	conf_t *conf = kmalloc(sizeof(*conf), GFP_KERNEL);
+	if (!conf)
+		return -ENOMEM;
 
 	for (i=0; i<Modes; i++) {
 		atomic_set(&conf->counters[i], 0);
_

Patches currently in -mm which might be from sven.wegener@stealer.net are

linux-next.patch
i2c-dev-return-correct-error-code-on-class_create-failure.patch
leds-avoid-needless-strlen-for-attributes.patch
leds-wrap-use-default-on-trigger-for-power-led.patch
leds-fsg-change-order-of-initialization-and-deinitialization.patch
leds-pca955x-add-proper-error-handling-and-fix-bogus-memory-handling.patch
md-check-for-memory-allocation-failure-in-faulty-personality.patch

