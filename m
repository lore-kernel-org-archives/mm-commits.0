Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6B13C07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:22:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D04C261CA3
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:22:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbhGFTZF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:25:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230098AbhGFTZE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:25:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B69B461CAA;
        Tue,  6 Jul 2021 19:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599344;
        bh=oFbgfr8X1EAOk5a62LP/LTgTUzyDO+LpsQVr1PDXtnw=;
        h=Date:From:To:Subject:From;
        b=DW8cDTrF6lmBbuuTjXL0xV8GdLxKxnTJDybE+iFnMxUnS4n6D1DiGXp3hpGe+WHTY
         ABuyJ5nFEoDAVx5RXiE4LKHbqfS40srSVYm17ECNE8G29CPYGPo2DDlVntSPtB40mv
         BOZMaZdi3FIurq3hZz8MCDhmR7OM6R3mgyFHsqVg=
Date:   Tue, 06 Jul 2021 12:22:24 -0700
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, bfields@fieldses.org,
        chuck.lever@oracle.com, mm-commits@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject:  [merged]
 seq_file-add-seq_escape_str-as-replica-of-string_escape_str.patch removed
 from -mm tree
Message-ID: <20210706192224.fl20GyT3B%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: seq_file: add seq_escape_str() as replica of string_escape_str()
has been removed from the -mm tree.  Its filename was
     seq_file-add-seq_escape_str-as-replica-of-string_escape_str.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


