From: akpm@osdl.org
Subject: + change-constant-zero-to-notify_done-in-ratelimit_handler.patch added to -mm tree
Date: Mon, 29 Jan 2007 19:12:30 -0800
Message-ID: <200701300312.l0U3CUuC007777@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39657 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532AbXA3DNn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jan 2007 22:13:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com


The patch titled
     Change constant zero to NOTIFY_DONE in ratelimit_handler()
has been added to the -mm tree.  Its filename is
     change-constant-zero-to-notify_done-in-ratelimit_handler.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Change constant zero to NOTIFY_DONE in ratelimit_handler()
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Change a hard-coded constant 0 to the symbolic equivalent NOTIFY_DONE in
the ratelimit_handler() CPU notifier handler function.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page-writeback.c~change-constant-zero-to-notify_done-in-ratelimit_handler mm/page-writeback.c
--- a/mm/page-writeback.c~change-constant-zero-to-notify_done-in-ratelimit_handler
+++ a/mm/page-writeback.c
@@ -536,7 +536,7 @@ static int __cpuinit
 ratelimit_handler(struct notifier_block *self, unsigned long u, void *v)
 {
 	writeback_set_ratelimit();
-	return 0;
+	return NOTIFY_DONE;
 }
 
 static struct notifier_block __cpuinitdata ratelimit_nb = {
_

Patches currently in -mm which might be from paulmck@linux.vnet.ibm.com are

git-block.patch
add-an-rcu-version-of-list-splicing.patch
add-an-rcu-version-of-list-splicing-fix.patch
ipmi-fix-some-rcu-problems.patch
change-constant-zero-to-notify_done-in-ratelimit_handler.patch
