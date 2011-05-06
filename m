From: akpm@linux-foundation.org
Subject: [merged] iosched-remove-redundant-sprintf.patch removed from -mm tree
Date: Fri, 06 May 2011 12:54:23 -0700
Message-ID: <201105061947.p46JlohO000307@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52775 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932222Ab1EFTr5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 May 2011 15:47:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kees.cook@canonical.com, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     iosched: remove redundant sprintf
has been removed from the -mm tree.  Its filename was
     iosched-remove-redundant-sprintf.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
