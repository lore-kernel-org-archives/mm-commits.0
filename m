From: akpm@linux-foundation.org
Subject: [obsolete]
 dlm-plock-reduce-indentation-by-rearranging-order.patch removed from -mm
 tree
Date: Tue, 12 Aug 2014 12:35:42 -0700
Message-ID: <53ea6c8e.j7vM0SUgib/ey5VG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:64404 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878AbaHLTfn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:35:43 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so2669389pde.1
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:35:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bfields@fieldses.org, ccaulfie@redhat.com, jlayton@poochiereds.net, teigland@redhat.com, trond.myklebust@primarydata.com, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: dlm: plock: reduce indentation by rearranging order
has been removed from the -mm tree.  Its filename was
     dlm-plock-reduce-indentation-by-rearranging-order.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: dlm: plock: reduce indentation by rearranging order

if blocks that have a goto at the end of one branch can be
simplified by reordering and unindenting.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Teigland <teigland@redhat.com>
Reviewed-by: Jeff Layton <jlayton@poochiereds.net>
Cc: Christine Caulfield <ccaulfie@redhat.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dlm/plock.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff -puN fs/dlm/plock.c~dlm-plock-reduce-indentation-by-rearranging-order fs/dlm/plock.c
--- a/fs/dlm/plock.c~dlm-plock-reduce-indentation-by-rearranging-order
+++ a/fs/dlm/plock.c
@@ -144,23 +144,23 @@ int dlm_posix_lock(dlm_lockspace_t *lock
 
 	send_op(op);
 
-	if (xop->callback == NULL) {
-		rv = wait_event_killable(recv_wq, (op->done != 0));
-		if (rv == -ERESTARTSYS) {
-			log_debug(ls, "dlm_posix_lock: wait killed %llx",
-				  (unsigned long long)number);
-			spin_lock(&ops_lock);
-			list_del(&op->list);
-			spin_unlock(&ops_lock);
-			kfree(xop);
-			do_unlock_close(ls, number, file, fl);
-			goto out;
-		}
-	} else {
+	if (xop->callback) {
 		rv = FILE_LOCK_DEFERRED;
 		goto out;
 	}
 
+	rv = wait_event_killable(recv_wq, (op->done != 0));
+	if (rv == -ERESTARTSYS) {
+		log_debug(ls, "dlm_posix_lock: wait killed %llx",
+			  (unsigned long long)number);
+		spin_lock(&ops_lock);
+		list_del(&op->list);
+		spin_unlock(&ops_lock);
+		kfree(xop);
+		do_unlock_close(ls, number, file, fl);
+		goto out;
+	}
+
 	spin_lock(&ops_lock);
 	if (!list_empty(&op->list)) {
 		log_error(ls, "dlm_posix_lock: op on list %llx",
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

