Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C6FAC64E7C
	for <mm-commits@archiver.kernel.org>; Sun, 22 Nov 2020 06:17:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51D512137B
	for <mm-commits@archiver.kernel.org>; Sun, 22 Nov 2020 06:17:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YcGUnQou"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbgKVGRU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 22 Nov 2020 01:17:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:55854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726957AbgKVGRU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 22 Nov 2020 01:17:20 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A7E120885;
        Sun, 22 Nov 2020 06:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606025839;
        bh=/2Crv0yoiGPOCLVKKOZFGvlgsyX0gwPsx26XT6y4Hic=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=YcGUnQouy7cmjuVazzFinG4TubZQzc6mgE9014ANI+Of0Wzyf2V1rIVgZM64BropQ
         emsoNSDV1Mc+8webiTxV/YzxwhXOs90vCz4xScg1y7HC11cWADZd7kZtf3OjSrmuiL
         umyGQwpqdqLc8Mhmvbkepf0mbOSh/gmVkTr/8zKY=
Date:   Sat, 21 Nov 2020 22:17:19 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk, yangyicong@hisilicon.com
Subject:  [patch 7/8] libfs: fix error cast of negative value in
 simple_attr_write()
Message-ID: <20201122061719.7voMbHRfP%akpm@linux-foundation.org>
In-Reply-To: <20201121221631.948ae4655e913a319d61700a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
