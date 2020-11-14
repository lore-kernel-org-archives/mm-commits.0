Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90F45C5519F
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 18:38:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CB3B22263
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 18:38:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="qbmgSj76"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgKNSiR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Nov 2020 13:38:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:46538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726107AbgKNSiR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 14 Nov 2020 13:38:17 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8C0922254;
        Sat, 14 Nov 2020 18:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605379095;
        bh=l2s+QXrrCULXOmAsqpf5Ahdhva0aqe6dh9i+rB0HX8M=;
        h=Date:From:To:Subject:From;
        b=qbmgSj76+AhT8vfnloI5Lip+S1lLxm1GVSsDDdBuLGIwXJ+DWJF2cJCfdH6wM6Jb7
         LHpyQECFNskStfWSsYLuzl0baHc0MgsYRatKCXtfJLyPJ76Gl0IOcbvlaezVjAbIom
         YUteK/nYxTsxWgexDKaq+UfNpMbNqtfLu4Zj1ywg=
Date:   Sat, 14 Nov 2020 10:38:15 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        yangyicong@hisilicon.com
Subject:  +
 libfs-fix-error-cast-of-negative-value-in-simple_attr_write.patch added to
 -mm tree
Message-ID: <20201114183815.pmjzY5WZC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: libfs: fix error cast of negative value in simple_attr_write()
has been added to the -mm tree.  Its filename is
     libfs-fix-error-cast-of-negative-value-in-simple_attr_write.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/libfs-fix-error-cast-of-negative-value-in-simple_attr_write.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/libfs-fix-error-cast-of-negative-value-in-simple_attr_write.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

libfs-fix-error-cast-of-negative-value-in-simple_attr_write.patch

