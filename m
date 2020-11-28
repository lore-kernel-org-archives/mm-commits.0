Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEAFDC63798
	for <mm-commits@archiver.kernel.org>; Sat, 28 Nov 2020 02:11:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6342206DF
	for <mm-commits@archiver.kernel.org>; Sat, 28 Nov 2020 02:11:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I/M4t/fy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731450AbgK1CL0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 27 Nov 2020 21:11:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:38538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730991AbgK1CIn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 27 Nov 2020 21:08:43 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 928812222A;
        Sat, 28 Nov 2020 02:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606529322;
        bh=zKp2ZSVgeXNy+DbfHgit/WziOf5p+kuTUOVjMlgUE7I=;
        h=Date:From:To:Subject:From;
        b=I/M4t/fychpBRwb6hJ0G8cGwGACxIKOLjp5btleu3stvV1/bekcDNQhmd7gFuvEb0
         XDYnu5PWG6I3hILYN55IuUQEfmCnk3Gjei4VmQw/caF2kWTaaJZp6WufZgTo/c8SOA
         BXV/Lt59QqNLTItbgnE4Tj1luaztsyrVs2VOrjEk=
Date:   Fri, 27 Nov 2020 18:08:42 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        yangyicong@hisilicon.com
Subject:  [merged]
 libfs-fix-error-cast-of-negative-value-in-simple_attr_write.patch removed
 from -mm tree
Message-ID: <20201128020842.71IWX-rYl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: libfs: fix error cast of negative value in simple_attr_write()
has been removed from the -mm tree.  Its filename was
     libfs-fix-error-cast-of-negative-value-in-simple_attr_write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yicong Yang <yangyicong@hisilicon.com>
Subject: libfs: fix error cast of negative value in simple_attr_write()

The attr->set() receive a value of u64, but simple_strtoll() is used for
doing the conversion.  It will lead to the error cast if user inputs a
negative value.

Use kstrtoull() instead of simple_strtoll() to convert a string got from
the user to an unsigned value.  The former will return '-EINVAL' if it
gets a negetive value, but the latter can't handle the situation
correctly.  Make 'val' unsigned long long as what kstrtoull() takes, this
will eliminate the compile warning on no 64-bit architectures.

Link: https://lkml.kernel.org/r/1605341356-11872-1-git-send-email-yangyicong@hisilicon.com
Fixes: f7b88631a897 ("fs/libfs.c: fix simple_attr_write() on 32bit machines")
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/libfs.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/libfs.c~libfs-fix-error-cast-of-negative-value-in-simple_attr_write
+++ a/fs/libfs.c
@@ -959,7 +959,7 @@ ssize_t simple_attr_write(struct file *f
 			  size_t len, loff_t *ppos)
 {
 	struct simple_attr *attr;
-	u64 val;
+	unsigned long long val;
 	size_t size;
 	ssize_t ret;
 
@@ -977,7 +977,9 @@ ssize_t simple_attr_write(struct file *f
 		goto out;
 
 	attr->set_buf[size] = '\0';
-	val = simple_strtoll(attr->set_buf, NULL, 0);
+	ret = kstrtoull(attr->set_buf, 0, &val);
+	if (ret)
+		goto out;
 	ret = attr->set(attr->data, val);
 	if (ret == 0)
 		ret = len; /* on success, claim we got the whole input */
_

Patches currently in -mm which might be from yangyicong@hisilicon.com are


