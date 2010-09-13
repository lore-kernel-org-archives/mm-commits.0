From: akpm@linux-foundation.org
Subject: + w1-dont-allow-arbitrary-users-to-remove-w1-devices.patch added to -mm tree
Date: Mon, 13 Sep 2010 15:48:57 -0700
Message-ID: <201009132248.o8DMmvB4025749@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33411 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752103Ab0IMWtP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Sep 2010 18:49:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: swetland@google.com, johnpol@2ka.mipt.ru, linus.walleij@stericsson.com


The patch titled
     w1: don't allow arbitrary users to remove w1 devices
has been added to the -mm tree.  Its filename is
     w1-dont-allow-arbitrary-users-to-remove-w1-devices.patch

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
Subject: w1: don't allow arbitrary users to remove w1 devices
From: Brian Swetland <swetland@google.com>

The search/pullup/add/remove device attributes were 0666 which would allow
arbitrary users to affect the 1 wire bus.  Change to 0664 to prevent that.

I found this patch in the Android tree, apparently this has never been
sent upstream so doing it now.

Signed-off-by: Brian Swetland <swetland@google.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/w1/w1.c~w1-dont-allow-arbitrary-users-to-remove-w1-devices drivers/w1/w1.c
--- a/drivers/w1/w1.c~w1-dont-allow-arbitrary-users-to-remove-w1-devices
+++ a/drivers/w1/w1.c
@@ -517,10 +517,10 @@ static W1_MASTER_ATTR_RO(max_slave_count
 static W1_MASTER_ATTR_RO(attempts, S_IRUGO);
 static W1_MASTER_ATTR_RO(timeout, S_IRUGO);
 static W1_MASTER_ATTR_RO(pointer, S_IRUGO);
-static W1_MASTER_ATTR_RW(search, S_IRUGO | S_IWUGO);
-static W1_MASTER_ATTR_RW(pullup, S_IRUGO | S_IWUGO);
-static W1_MASTER_ATTR_RW(add, S_IRUGO | S_IWUGO);
-static W1_MASTER_ATTR_RW(remove, S_IRUGO | S_IWUGO);
+static W1_MASTER_ATTR_RW(search, S_IRUGO | S_IWUSR | S_IWGRP);
+static W1_MASTER_ATTR_RW(pullup, S_IRUGO | S_IWUSR | S_IWGRP);
+static W1_MASTER_ATTR_RW(add, S_IRUGO | S_IWUSR | S_IWGRP);
+static W1_MASTER_ATTR_RW(remove, S_IRUGO | S_IWUSR | S_IWGRP);
 
 static struct attribute *w1_master_default_attrs[] = {
 	&w1_master_attribute_name.attr,
_

Patches currently in -mm which might be from swetland@google.com are

w1-dont-allow-arbitrary-users-to-remove-w1-devices.patch

