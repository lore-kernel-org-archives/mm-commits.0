Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34947C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 23:38:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03F0C619F8
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 23:38:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235431AbhCXXiN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Mar 2021 19:38:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:36440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231775AbhCXXiE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Mar 2021 19:38:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AAA961A1F;
        Wed, 24 Mar 2021 23:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616629083;
        bh=8vdgvf9cfZzq7FADWDbemKxk5P8Vo18WPp3orF+9A7w=;
        h=Date:From:To:Subject:From;
        b=z5MgqJazelE+zw+1fqot28xN1EI1ZX4m3xUgS9oVw2cG9q7Z2+bHrtv3OJiL4Gz96
         Aostjp/o3iE/FrIrIGnXk0ONA0YdPTy0d3OyFlLwSF0o0hbqQOozhR58l2/k/ApvKg
         0g24KTAcJ/1S/ZjZMwjRqAua3nuVVqIvhoW/eZpg=
Date:   Wed, 24 Mar 2021 16:38:03 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ralf.ramsauer@oth-regensburg.de,
        joe@perches.com, corbet@lwn.net, lukas.bulwahn@gmail.com
Subject:  + pagewalk-prefix-struct-kernel-doc-descriptions.patch
 added to -mm tree
Message-ID: <20210324233803.YsyYY%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: pagewalk: prefix struct kernel-doc descriptions
has been added to the -mm tree.  Its filename is
     pagewalk-prefix-struct-kernel-doc-descriptions.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/pagewalk-prefix-struct-kernel-doc-descriptions.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/pagewalk-prefix-struct-kernel-doc-descriptions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: pagewalk: prefix struct kernel-doc descriptions

The script './scripts/kernel-doc -none ./include/linux/pagewalk.h' reports:

  include/linux/pagewalk.h:37: warning: cannot understand function prototype: 'struct mm_walk_ops '
  include/linux/pagewalk.h:85: warning: cannot understand function prototype: 'struct mm_walk '

A kernel-doc description for a structure requires to prefix the struct
name with the keyword 'struct'.  So, do that such that no further
kernel-doc warnings are reported for this file.

Link: https://lkml.kernel.org/r/20210322122542.15072-3-lukas.bulwahn@gmail.com
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Ralf Ramsauer <ralf.ramsauer@oth-regensburg.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagewalk.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/pagewalk.h~pagewalk-prefix-struct-kernel-doc-descriptions
+++ a/include/linux/pagewalk.h
@@ -7,7 +7,7 @@
 struct mm_walk;
 
 /**
- * mm_walk_ops - callbacks for walk_page_range
+ * struct mm_walk_ops - callbacks for walk_page_range
  * @pgd_entry:		if set, called for each non-empty PGD (top-level) entry
  * @p4d_entry:		if set, called for each non-empty P4D entry
  * @pud_entry:		if set, called for each non-empty PUD entry
@@ -71,7 +71,7 @@ enum page_walk_action {
 };
 
 /**
- * mm_walk - walk_page_range data
+ * struct mm_walk - walk_page_range data
  * @ops:	operation to call during the walk
  * @mm:		mm_struct representing the target process of page table walk
  * @pgd:	pointer to PGD; only valid with no_vma (otherwise set to NULL)
_

Patches currently in -mm which might be from lukas.bulwahn@gmail.com are

maintainers-assign-pagewalkh-to-memory-management.patch
pagewalk-prefix-struct-kernel-doc-descriptions.patch

