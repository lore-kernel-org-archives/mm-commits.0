Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F16E2C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:59:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE6306148E
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:59:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbhD3GA2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:00:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230253AbhD3GA2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:00:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86F5861459;
        Fri, 30 Apr 2021 05:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762380;
        bh=6M22MGtzA2km42CwGlteJPYeFE4Nv/vHK+KYBwdcNAg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=AqWEVPMIbvsfei8GRpB0Z8CkQVnqCHGl1S+GDTHQan45uS7MCj+LUP66BZf289aLk
         xcWXDODHrDGUMvEU+efjrm1+LRu1B/d9SKbi5nKctpvdTtwKz24Wswe/32hjecFvAL
         IJhbogL6NP5/x9w/fh8grqxNb0iFgx7Zl3NIBvlg=
Date:   Thu, 29 Apr 2021 22:59:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net, joe@perches.com,
        linux-mm@kvack.org, lukas.bulwahn@gmail.com,
        mm-commits@vger.kernel.org, ralf.ramsauer@oth-regensburg.de,
        torvalds@linux-foundation.org
Subject:  [patch 126/178] pagewalk: prefix struct kernel-doc
 descriptions
Message-ID: <20210430055940.bXBM5IjXU%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
