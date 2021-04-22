Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 036EDC433ED
	for <mm-commits@archiver.kernel.org>; Thu, 22 Apr 2021 23:07:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCDA46141C
	for <mm-commits@archiver.kernel.org>; Thu, 22 Apr 2021 23:07:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239650AbhDVXIH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Apr 2021 19:08:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236896AbhDVXIH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Apr 2021 19:08:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C969D61360;
        Thu, 22 Apr 2021 23:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619132852;
        bh=kQST3A8M/CyxUDzKl8fYYH4OAcRW/k1uwZXgj4a7nLo=;
        h=Date:From:To:Subject:From;
        b=FQbFYpvEYlbSRjKk7sc+Y8pWQvQbbhckdZJczGM8NO96TXILjAU0anSDf1VYBgrCH
         o9PbkXru+vGjQfEyyDzTU+5MSZuhnxJniL1qR7C1h3He5eyLQK2hnslc0RZuAP5wjE
         e1t5AZlxQhT2UdEL7nbGMEvFYfrGSCxyCE0TEYEs=
Date:   Thu, 22 Apr 2021 16:07:31 -0700
From:   akpm@linux-foundation.org
To:     dan.carpenter@oracle.com, mm-commits@vger.kernel.org,
        stefani@seibold.net
Subject:  + kfifo-fix-ternary-sign-extension-bugs.patch added to
 -mm tree
Message-ID: <20210422230731.3Hht0ZytI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfifo: fix ternary sign extension bugs
has been added to the -mm tree.  Its filename is
     kfifo-fix-ternary-sign-extension-bugs.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kfifo-fix-ternary-sign-extension-bugs.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kfifo-fix-ternary-sign-extension-bugs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kfifo-fix-ternary-sign-extension-bugs.patch

