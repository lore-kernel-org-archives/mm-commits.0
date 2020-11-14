Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 075A0C63697
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 18:37:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A57C522265
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 18:37:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="xY+VIxWk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgKNShV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Nov 2020 13:37:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:46458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726174AbgKNShS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 14 Nov 2020 13:37:18 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C6BE22254;
        Sat, 14 Nov 2020 18:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605379037;
        bh=4LAVAlBHm9T2MWpuuh8keceRMYnIVza3gLOaAMoX3MM=;
        h=Date:From:To:Subject:From;
        b=xY+VIxWkIKhhyhy5auZmOpqCx3DUL2f7hpivFhVYfYykisI3vt0/FL2EAjcDUSSw/
         a+8snd5e4weSt6KO9JlR00H2aACzjPxDLOnGu8ODTXXA3i8nhvUqiHFoYKaN+qu5ai
         PxV3w+B464wN9t2LAOM6UJJ9rIZfcUDx4qflZYdo=
Date:   Sat, 14 Nov 2020 10:37:16 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        yangyicong@hisilicon.com
Subject:  [to-be-updated]
 libfs-fix-error-cast-of-negative-value-in-simple_attr_write.patch removed
 from -mm tree
Message-ID: <20201114183716.d3JmUuKIQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: libfs: fix error cast of negative value in simple_attr_write()
has been removed from the -mm tree.  Its filename was
     libfs-fix-error-cast-of-negative-value-in-simple_attr_write.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Yicong Yang <yangyicong@hisilicon.com>
Subject: libfs: fix error cast of negative value in simple_attr_write()

The attr->set() receive a value of u64, but simple_strtoll() is used
for doing the conversion. It will lead to the error cast if user inputs
a negative value.

Use kstrtoull() instead of simple_strtoll() to convert a string got
from the user to an unsigned value. The former will return '-EINVAL' if
it gets a negetive value, but the latter can't handle the situation
correctly.

Link: https://lkml.kernel.org/r/1605000324-7428-1-git-send-email-yangyicong@hisilicon.com
Fixes: f7b88631a897 ("fs/libfs.c: fix simple_attr_write() on 32bit machines")
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/libfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/libfs.c~libfs-fix-error-cast-of-negative-value-in-simple_attr_write
+++ a/fs/libfs.c
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


