From: akpm@linux-foundation.org
Subject: + iosched-remove-redundant-sprintf.patch added to -mm tree
Date: Thu, 05 May 2011 16:01:10 -0700
Message-ID: <201105052301.p45N1Adb008338@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42855 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754107Ab1EEXBP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 May 2011 19:01:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kees.cook@canonical.com, axboe@kernel.dk


The patch titled
     iosched: remove redundant sprintf
has been added to the -mm tree.  Its filename is
     iosched-remove-redundant-sprintf.patch

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
Subject: iosched: remove redundant sprintf
From: Kees Cook <kees.cook@canonical.com>

After the anticipatory scheduler was dropped, there was no need to
special-case the request_module string.  As such, drop the redundant
sprintf and stack variable.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/elevator.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN block/elevator.c~iosched-remove-redundant-sprintf block/elevator.c
--- a/block/elevator.c~iosched-remove-redundant-sprintf
+++ a/block/elevator.c
@@ -155,13 +155,8 @@ static struct elevator_type *elevator_ge
 
 	e = elevator_find(name);
 	if (!e) {
-		char elv[ELV_NAME_MAX + strlen("-iosched")];
-
 		spin_unlock(&elv_list_lock);
-
-		snprintf(elv, sizeof(elv), "%s-iosched", name);
