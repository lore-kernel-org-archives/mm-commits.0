Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E19A8C43460
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:39:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C88BA6140E
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:39:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbhEHWkl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:40:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:43888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229648AbhEHWkk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:40:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 897CA6141E;
        Sat,  8 May 2021 22:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513578;
        bh=NlHrVcXe+ZNmOciHkyoO7b/9fGWSDCD6A0PGNbUyyos=;
        h=Date:From:To:Subject:From;
        b=q9uF53jqJQ2ygnz5e7QGD51W753ONx5L5jVCuljLn6+IN29gHQZ4o7Bb+PoO16F+F
         zqfTba6yeIfb6MHGlTBKzzJv/a2qB1tp/IjL/rGVDBUduAvZ28tFdPuyZdDaWE4knE
         PZCnJ7OzI0y1ZIEWfnZs+tK5W2314/4VxUdM8Jkk=
Date:   Sat, 08 May 2021 15:39:38 -0700
From:   akpm@linux-foundation.org
To:     dhowells@redhat.com, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, viro@zeniv.linux.org.uk
Subject:  [merged] vfs-fs_parser-clean-up-kernel-doc-warnings.patch
 removed from -mm tree
Message-ID: <20210508223938.habnQ6ofN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vfs: fs_parser: clean up kernel-doc warnings
has been removed from the -mm tree.  Its filename was
     vfs-fs_parser-clean-up-kernel-doc-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


