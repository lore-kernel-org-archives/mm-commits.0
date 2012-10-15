From: akpm@linux-foundation.org
Subject: + random-make-it-possible-to-enable-debugging-without-rebuild.patch added to -mm tree
Date: Mon, 15 Oct 2012 15:13:00 -0700
Message-ID: <20121015221301.9CF8420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:41059 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079Ab2JOWNE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Oct 2012 18:13:04 -0400
Received: by mail-bk0-f74.google.com with SMTP id q16so347680bkw.1
        for <mm-commits@vger.kernel.org>; Mon, 15 Oct 2012 15:13:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jkosina@suse.cz, tytso@mit.edu


The patch titled
     Subject: random: make it possible to enable debugging without rebuild
has been added to the -mm tree.  Its filename is
     random-make-it-possible-to-enable-debugging-without-rebuild.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jiri Kosina <jkosina@suse.cz>
Subject: random: make it possible to enable debugging without rebuild

The module parameter that turns debugging mode (which basically means
printing a few extra lines during runtime) is in '#if 0' block.  Forcing
everyone who would like to see how entropy is behaving on his system to
rebuild seems to be a little bit too harsh.

If we were concerned about speed, we could potentially turn 'debug' into a
static key, but I don't think it's necessary.

Drop the '#if 0' block to allow using the 'debug' parameter without
rebuilding.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/char/random.c~random-make-it-possible-to-enable-debugging-without-rebuild drivers/char/random.c
--- a/drivers/char/random.c~random-make-it-possible-to-enable-debugging-without-rebuild
+++ a/drivers/char/random.c
@@ -399,7 +399,6 @@ static DECLARE_WAIT_QUEUE_HEAD(random_re
 static DECLARE_WAIT_QUEUE_HEAD(random_write_wait);
 static struct fasync_struct *fasync;
 
-#if 0
 static bool debug;
 module_param(debug, bool, 0644);
 #define DEBUG_ENT(fmt, arg...) do { \
@@ -410,9 +409,6 @@ module_param(debug, bool, 0644);
 		blocking_pool.entropy_count,\
 		nonblocking_pool.entropy_count,\
 		## arg); } while (0)
-#else
-#define DEBUG_ENT(fmt, arg...) do {} while (0)
-#endif
 
 /**********************************************************************
  *
_

Patches currently in -mm which might be from jkosina@suse.cz are

linux-next.patch
random-make-it-possible-to-enable-debugging-without-rebuild.patch
random-fix-debug-format-strings.patch

