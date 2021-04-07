Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 324AFC433ED
	for <mm-commits@archiver.kernel.org>; Wed,  7 Apr 2021 03:57:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB446613A9
	for <mm-commits@archiver.kernel.org>; Wed,  7 Apr 2021 03:57:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243974AbhDGD5l (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Apr 2021 23:57:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233392AbhDGD5k (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Apr 2021 23:57:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A35956139E;
        Wed,  7 Apr 2021 03:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617767851;
        bh=tGMPmdVyWUpxqj2P0SbG8aSY79TQZSbo69IorVycJ6Y=;
        h=Date:From:To:Subject:From;
        b=tADwpNLb7xlOdpwySZcC9y3ykEMFGUBkDglQsGwkTqGfhuinLKpPzBM6w6hq/2g4F
         HCGzPlnU3gE188LWRdNP8oiFp+WO6G+8UE5gwZdPh144P+Taqb6+kh+VuYISZ4aiAY
         A44A1Ie3ihkaPZUdimVqy4xiS8R/ZFQpjIgtzWNg=
Date:   Tue, 06 Apr 2021 20:57:31 -0700
From:   akpm@linux-foundation.org
To:     dhowells@redhat.com, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, viro@zeniv.linux.org.uk
Subject:  + vfs-fs_parser-clean-up-kernel-doc-warnings.patch added
 to -mm tree
Message-ID: <20210407035731.PGWz9fS-a%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vfs: fs_parser: clean up kernel-doc warnings
has been added to the -mm tree.  Its filename is
     vfs-fs_parser-clean-up-kernel-doc-warnings.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/vfs-fs_parser-clean-up-kernel-doc-warnings.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/vfs-fs_parser-clean-up-kernel-doc-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from rdunlap@infradead.org are

vfs-fs_parser-clean-up-kernel-doc-warnings.patch
lib-parser-clean-up-kernel-doc.patch

