From: akpm@linux-foundation.org
Subject: [merged] random-make-it-possible-to-enable-debugging-without-rebuild.patch removed from -mm tree
Date: Mon, 29 Oct 2012 12:50:43 -0700
Message-ID: <20121029195044.11D2D5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:37303 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab2J2Tuq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Oct 2012 15:50:46 -0400
Received: by mail-lb0-f202.google.com with SMTP id l12so337158lbo.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Oct 2012 12:50:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: random: make it possible to enable debugging without rebuild
has been removed from the -mm tree.  Its filename was
     random-make-it-possible-to-enable-debugging-without-rebuild.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

