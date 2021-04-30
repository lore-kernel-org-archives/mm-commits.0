Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A08FBC433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:54:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 898B761459
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:54:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbhD3FzG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:55:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:46500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230315AbhD3FzF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:55:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A8296144F;
        Fri, 30 Apr 2021 05:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762058;
        bh=lSJmxzWCAdCEMsusJsQckD5hp6JV8tu4J89TqZ7V+lE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=MhS0py09Pm4eONTsnKfDxkR47lJMn6W3ax5hMRGVcktPIPnyOJIKND3bnVUm7JjNY
         0s3QINUvINlbGOY/uzXcXfRKZdmUNCNTMIBrh922XRMkAj4VlApNubz7WQm3FUJTtj
         8+AIHNxous4CY9YaftE5TdFvWEIP/2pizERL70QE=
Date:   Thu, 29 Apr 2021 22:54:17 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dhowells@redhat.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject:  [patch 021/178] vfs: fs_parser: clean up kernel-doc
 warnings
Message-ID: <20210430055417.dtK5DZEOq%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: vfs: fs_parser: clean up kernel-doc warnings

Fix kernel-doc notation function arguments to eliminate two kernel-doc
warnings:

fs_parser.c:322: warning: Excess function parameter 'name' description in 'validate_constant_table'
fs_parser.c:367: warning: Function parameter or member 'name' not described in 'fs_validate_description'

Link: https://lkml.kernel.org/r/20210407033743.9701-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs_parser.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fs_parser.c~vfs-fs_parser-clean-up-kernel-doc-warnings
+++ a/fs/fs_parser.c
@@ -310,7 +310,6 @@ EXPORT_SYMBOL(fs_param_is_path);
 #ifdef CONFIG_VALIDATE_FS_PARSER
 /**
  * validate_constant_table - Validate a constant table
- * @name: Name to use in reporting
  * @tbl: The constant table to validate.
  * @tbl_size: The size of the table.
  * @low: The lowest permissible value.
@@ -360,6 +359,7 @@ bool validate_constant_table(const struc
 
 /**
  * fs_validate_description - Validate a parameter description
+ * @name: The parameter name to search for.
  * @desc: The parameter description to validate.
  */
 bool fs_validate_description(const char *name,
_
