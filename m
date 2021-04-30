Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5784C43460
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:54:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA2AB6145B
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:54:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbhD3FzD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:55:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230315AbhD3FzD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:55:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57F306145D;
        Fri, 30 Apr 2021 05:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762055;
        bh=EwG6g1/QgxWni1+66+uc12pIdtTnaaztegccQJdzGwA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ztSxkD7LT2P+Z9nnAZkh3XlNOKQgslbhzr5GXE3xDSR/eK+s6kehsZ2JOAMwayABE
         BK3TR4ApxoA1LDFNlX5wAQGXR7PEAIPvehVBQV+cC7rGspqBj/Axjc5U0gU/CiMFTH
         Ag4RaZ1fynCK0HVzKbOzlHOpcg9NC14TFa/v+1N8=
Date:   Thu, 29 Apr 2021 22:54:15 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.carpenter@oracle.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        stefani@seibold.net, torvalds@linux-foundation.org
Subject:  [patch 020/178] kfifo: fix ternary sign extension bugs
Message-ID: <20210430055415.MjLQ2XY4b%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
