From: akpm@linux-foundation.org
Subject: + missing-__user-in-pointer-referenced-within-copy_from_user.patch added to -mm tree
Date: Thu, 15 Feb 2007 15:01:17 -0800
Message-ID: <200702152301.l1FN1HNN011389@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37900 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161644AbXBOXBa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 18:01:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gcosta@redhat.com


The patch titled
     Missing __user in pointer referenced within copy_from_user
has been added to the -mm tree.  Its filename is
     missing-__user-in-pointer-referenced-within-copy_from_user.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Missing __user in pointer referenced within copy_from_user
From: Glauber de Oliveira Costa <gcosta@redhat.com>

Pointers to user data should be marked with a __user hint.  This one is
missing.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/base.c~missing-__user-in-pointer-referenced-within-copy_from_user fs/proc/base.c
--- a/fs/proc/base.c~missing-__user-in-pointer-referenced-within-copy_from_user
+++ a/fs/proc/base.c
@@ -617,7 +617,7 @@ out_no_task:
 
 #ifndef mem_write
 /* This is a security hazard */
-static ssize_t mem_write(struct file * file, const char * buf,
+static ssize_t mem_write(struct file * file, const char __user *buf,
 			 size_t count, loff_t *ppos)
 {
 	int copied;
_

Patches currently in -mm which might be from gcosta@redhat.com are

missing-__user-in-pointer-referenced-within-copy_from_user.patch
