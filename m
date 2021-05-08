Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89F9CC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:39:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67178613EA
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:39:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbhEHWkj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:40:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:43828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229552AbhEHWkj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:40:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E0EB6141D;
        Sat,  8 May 2021 22:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513576;
        bh=hijJxqr59EyCDbyTr0c2/oyhEnEi3CdiuWlrhlPkTVc=;
        h=Date:From:To:Subject:From;
        b=g3IlYJ/u+m8p2/coMgCWLwmduDOy1Ay9nL6Ygk1UkHcA+aAl63FOqeTJNIal2q3IU
         39R5jtIArxa7mYCjQl7Pg3k9lYvXGP2XjY7AXBBaa8tJiJo6RTuUALFXhCqZpRW05w
         ww/LfHEo/clnqdNSi07W4OwhRL6wtGlUYTT8Ns/E=
Date:   Sat, 08 May 2021 15:39:36 -0700
From:   akpm@linux-foundation.org
To:     dan.carpenter@oracle.com, mm-commits@vger.kernel.org,
        stefani@seibold.net
Subject:  [merged] kfifo-fix-ternary-sign-extension-bugs.patch
 removed from -mm tree
Message-ID: <20210508223936.K55Sytpu_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfifo: fix ternary sign extension bugs
has been removed from the -mm tree.  Its filename was
     kfifo-fix-ternary-sign-extension-bugs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: kfifo: fix ternary sign extension bugs

The intent with this code was to return negative error codes but instead
it returns positives.

The problem is how type promotion works with ternary operations.  These
functions return long, "ret" is an int and "copied" is a u32.  The
negative error code is first cast to u32 so it becomes a high positive and
then cast to long where it's still a positive.

We could fix this by declaring "ret" as a ssize_t but let's just get rid
of the ternaries instead.

Link: https://lkml.kernel.org/r/YIE+/cK1tBzSuQPU@mwanda
Fixes: 5bf2b19320ec ("kfifo: add example files to the kernel sample directory")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/kfifo/bytestream-example.c |    8 ++++++--
 samples/kfifo/inttype-example.c    |    8 ++++++--
 samples/kfifo/record-example.c     |    8 ++++++--
 3 files changed, 18 insertions(+), 6 deletions(-)

--- a/samples/kfifo/bytestream-example.c~kfifo-fix-ternary-sign-extension-bugs
+++ a/samples/kfifo/bytestream-example.c
@@ -122,8 +122,10 @@ static ssize_t fifo_write(struct file *f
 	ret = kfifo_from_user(&test, buf, count, &copied);
 
 	mutex_unlock(&write_lock);
+	if (ret)
+		return ret;
 
-	return ret ? ret : copied;
+	return copied;
 }
 
 static ssize_t fifo_read(struct file *file, char __user *buf,
@@ -138,8 +140,10 @@ static ssize_t fifo_read(struct file *fi
 	ret = kfifo_to_user(&test, buf, count, &copied);
 
 	mutex_unlock(&read_lock);
+	if (ret)
+		return ret;
 
-	return ret ? ret : copied;
+	return copied;
 }
 
 static const struct proc_ops fifo_proc_ops = {
--- a/samples/kfifo/inttype-example.c~kfifo-fix-ternary-sign-extension-bugs
+++ a/samples/kfifo/inttype-example.c
@@ -115,8 +115,10 @@ static ssize_t fifo_write(struct file *f
 	ret = kfifo_from_user(&test, buf, count, &copied);
 
 	mutex_unlock(&write_lock);
+	if (ret)
+		return ret;
 
-	return ret ? ret : copied;
+	return copied;
 }
 
 static ssize_t fifo_read(struct file *file, char __user *buf,
@@ -131,8 +133,10 @@ static ssize_t fifo_read(struct file *fi
 	ret = kfifo_to_user(&test, buf, count, &copied);
 
 	mutex_unlock(&read_lock);
+	if (ret)
+		return ret;
 
-	return ret ? ret : copied;
+	return copied;
 }
 
 static const struct proc_ops fifo_proc_ops = {
--- a/samples/kfifo/record-example.c~kfifo-fix-ternary-sign-extension-bugs
+++ a/samples/kfifo/record-example.c
@@ -129,8 +129,10 @@ static ssize_t fifo_write(struct file *f
 	ret = kfifo_from_user(&test, buf, count, &copied);
 
 	mutex_unlock(&write_lock);
+	if (ret)
+		return ret;
 
-	return ret ? ret : copied;
+	return copied;
 }
 
 static ssize_t fifo_read(struct file *file, char __user *buf,
@@ -145,8 +147,10 @@ static ssize_t fifo_read(struct file *fi
 	ret = kfifo_to_user(&test, buf, count, &copied);
 
 	mutex_unlock(&read_lock);
+	if (ret)
+		return ret;
 
-	return ret ? ret : copied;
+	return copied;
 }
 
 static const struct proc_ops fifo_proc_ops = {
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are


