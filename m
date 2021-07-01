Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C347C11F69
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:55:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A2AA61476
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:55:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238550AbhGAB6I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:58:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:48050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238463AbhGAB6I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:58:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BC5661469;
        Thu,  1 Jul 2021 01:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104538;
        bh=P3jDuOZjcaumvHKBj7ainPYIEpwGa34rc1WEuesTvd0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=KwBdUcZ97uPJHQAtawrJJ237/JkBLhQcavIFzUPBwncUxQfmIR1S5/iciQJkJzD+o
         NKTooYqzwNswa6RQwXJ9YE4TPcEF6GTZ/KA3r+LQt2hFtroCqVSpxMkm4++8pyCrSD
         iCTaxc4LitGpAW+bqqTekZlLQFlTze6YB759FHiE=
Date:   Wed, 30 Jun 2021 18:55:37 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        bfields@fieldses.org, chuck.lever@oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject:  [patch 159/192] seq_file: add seq_escape_str() as replica
 of string_escape_str()
Message-ID: <20210701015537.nylTt3S3W%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: seq_file: add seq_escape_str() as replica of string_escape_str()

In some cases we want to escape characters from NULL-terminated strings. 
Add seq_escape_str() as replica of string_escape_str() for that.

Link: https://lkml.kernel.org/r/20210504180819.73127-13-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/seq_file.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/include/linux/seq_file.h~seq_file-add-seq_escape_str-as-replica-of-string_escape_str
+++ a/include/linux/seq_file.h
@@ -128,6 +128,13 @@ void seq_put_hex_ll(struct seq_file *m,
 
 void seq_escape_mem(struct seq_file *m, const char *src, size_t len,
 		    unsigned int flags, const char *esc);
+
+static inline void seq_escape_str(struct seq_file *m, const char *src,
+				  unsigned int flags, const char *esc)
+{
+	seq_escape_mem(m, src, strlen(src), flags, esc);
+}
+
 void seq_escape(struct seq_file *m, const char *s, const char *esc);
 void seq_escape_mem_ascii(struct seq_file *m, const char *src, size_t isz);
 
_
