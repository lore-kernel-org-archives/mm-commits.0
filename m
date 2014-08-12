From: akpm@linux-foundation.org
Subject: [obsolete] dlm-plock-add-argument-descriptions-to-notify.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:35:38 -0700
Message-ID: <53ea6c8a.j0T6rJN8XLk/ju3j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f73.google.com ([209.85.218.73]:52986 "EHLO
	mail-oi0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878AbaHLTfj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:35:39 -0400
Received: by mail-oi0-f73.google.com with SMTP id u20so1910493oif.4
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:35:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bfields@fieldses.org, ccaulfie@redhat.com, jlayton@poochiereds.net, teigland@redhat.com, trond.myklebust@primarydata.com, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/dlm/plock.c: add argument descriptions to notify
has been removed from the -mm tree.  Its filename was
     dlm-plock-add-argument-descriptions-to-notify.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: fs/dlm/plock.c: add argument descriptions to notify

Function pointer arguments without type names
are not very clear.  Add them.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Teigland <teigland@redhat.com>
Cc: Jeff Layton <jlayton@poochiereds.net>
Cc: Christine Caulfield <ccaulfie@redhat.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dlm/plock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/dlm/plock.c~dlm-plock-add-argument-descriptions-to-notify fs/dlm/plock.c
--- a/fs/dlm/plock.c~dlm-plock-add-argument-descriptions-to-notify
+++ a/fs/dlm/plock.c
@@ -30,7 +30,7 @@ struct plock_op {
 
 struct plock_xop {
 	struct plock_op xop;
-	void *callback;
+	int (*callback)(struct file_lock *, struct file_lock *, int);
 	void *fl;
 	void *file;
 	struct file_lock flc;
@@ -190,7 +190,7 @@ static int dlm_plock_callback(struct plo
 	struct file *file;
 	struct file_lock *fl;
 	struct file_lock *flc;
-	int (*notify)(void *, void *, int) = NULL;
+	int (*notify)(struct file_lock *fl, struct file_lock *cont, int result) = NULL;
 	struct plock_xop *xop = (struct plock_xop *)op;
 	int rv = 0;
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
dlm-fs-remove-unused-conf-from-lm_grant.patch
dlm-plock-reduce-indentation-by-rearranging-order.patch

