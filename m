Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0781C11F68
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:55:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD8796147D
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:55:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238504AbhGAB6L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:58:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:48108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238463AbhGAB6L (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:58:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29C7B61420;
        Thu,  1 Jul 2021 01:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104541;
        bh=X3E4436PzFkfXdyT61o/JSkrqgwMOa6MEDcYQWSLNDY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=jrzVdYCaTaK4RodLv+kJLhlbvTvQ4/tyWEKWX2FqZHsWEMuqnr1v7a4BwH5RZhJqK
         /FByUPCf/Fvok2E48AymaB6vykVs1H2foI7sElk0ocPHhR3wzz25R/kkIctH1xoOnj
         B8PGp/e4uZVbrZKU4MJWIjl/kEq+tyd4SasVxer8=
Date:   Wed, 30 Jun 2021 18:55:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        bfields@fieldses.org, chuck.lever@oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject:  [patch 160/192] seq_file: convert seq_escape() to use
 seq_escape_str()
Message-ID: <20210701015540.8J5zoxl9V%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
