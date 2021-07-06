Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E42DC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:22:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC16461CA8
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:22:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbhGFTZH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:25:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:58420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230098AbhGFTZH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:25:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67EF461CA3;
        Tue,  6 Jul 2021 19:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599347;
        bh=COsIp9dCvg5VQrCxrUEObsdQjGxngu6Lqy9AgVSeYuI=;
        h=Date:From:To:Subject:From;
        b=PKMZFi/b/Jf++dXXWsKzlo8xwyEqJtLZJ+INaks8Eei9iPbkkVewlAjHmWuFDdgxj
         YS7xxLgdARSdzbaJcBAurIM0/QXqyQ+JC6JQ9G2oMuHW57ZsnyuzzM8fc9nJR/t+dd
         mLhu/9/g6UA8P57fuTNRnRCQ1aHtvxaK/Z9Y8ZxI=
Date:   Tue, 06 Jul 2021 12:22:27 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, bfields@fieldses.org,
        chuck.lever@oracle.com, mm-commits@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject:  [merged]
 seq_file-convert-seq_escape-to-use-seq_escape_str.patch removed from -mm
 tree
Message-ID: <20210706192227.tm4-MzfUN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: seq_file: convert seq_escape() to use seq_escape_str()
has been removed from the -mm tree.  Its filename was
     seq_file-convert-seq_escape-to-use-seq_escape_str.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: seq_file: convert seq_escape() to use seq_escape_str()

Convert seq_escape() to use seq_escape_str() rather than open coding it.

Note, for now we leave it as an exported symbol due to some old code that
can't tolerate ctype.h being (indirectly) included.

Link: https://lkml.kernel.org/r/20210504180819.73127-14-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/fs/seq_file.c~seq_file-convert-seq_escape-to-use-seq_escape_str
+++ a/fs/seq_file.c
@@ -392,12 +392,7 @@ EXPORT_SYMBOL(seq_escape_mem);
  */
 void seq_escape(struct seq_file *m, const char *s, const char *esc)
 {
-	char *buf;
-	size_t size = seq_get_buf(m, &buf);
-	int ret;
-
-	ret = string_escape_str(s, buf, size, ESCAPE_OCTAL, esc);
-	seq_commit(m, ret < size ? ret : -1);
+	seq_escape_str(m, s, ESCAPE_OCTAL, esc);
 }
 EXPORT_SYMBOL(seq_escape);
 
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


