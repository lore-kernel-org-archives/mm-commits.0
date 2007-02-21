From: akpm@linux-foundation.org
Subject: - missing-__user-in-pointer-referenced-within-copy_from_user.patch removed from -mm tree
Date: Wed, 21 Feb 2007 02:46:23 -0800
Message-ID: <200702211046.l1LAkNaG006466@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46958 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932526AbXBUKqe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 05:46:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gcosta@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Missing __user in pointer referenced within copy_from_user
has been removed from the -mm tree.  Its filename was
     missing-__user-in-pointer-referenced-within-copy_from_user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Missing __user in pointer referenced within copy_from_user
From: Glauber de Oliveira Costa <gcosta@redhat.com>

Pointers to user data should be marked with a __user hint.  This one is
missing.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/base.c~missing-__user-in-pointer-referenced-within-copy_from_user fs/proc/base.c
--- a/fs/proc/base.c~missing-__user-in-pointer-referenced-within-copy_from_user
+++ a/fs/proc/base.c
@@ -581,7 +581,7 @@ out_no_task:
 
 #ifndef mem_write
 /* This is a security hazard */
-static ssize_t mem_write(struct file * file, const char * buf,
+static ssize_t mem_write(struct file * file, const char __user *buf,
 			 size_t count, loff_t *ppos)
 {
 	int copied;
_

Patches currently in -mm which might be from gcosta@redhat.com are
