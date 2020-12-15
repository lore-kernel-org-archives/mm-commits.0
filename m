Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 802B6C2BB48
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:08:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4583522D06
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:08:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbgLODIP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:08:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:35702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbgLODII (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:08:08 -0500
Date:   Mon, 14 Dec 2020 19:07:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001672;
        bh=gbbLBWj91eaLbRfXkLT76aHaFpLeI153eqSuiSkknN4=;
        h=From:To:Subject:In-Reply-To:From;
        b=hjPWxJ/ULCUp4WAbY3qHNXEMRbxlKWOLm0uJ1Xh8ds3d1b3YzbzvWRfyADNGHoeeG
         6S2/ZOAewDMSHq0Lwmz83HAEZqHzGnNocrhHmOlJtCDFOou8LU8I/MnL6v9DiUmqzh
         doiqzTzSsaZU4QDrnUZ5Ken+LlFpgGj304jcDRCg=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        corbet@lwn.net, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, torvalds@linux-foundation.org
Subject:  [patch 080/200] mm/page_vma_mapped.c: add colon to fix
 kernel-doc markups error for check_pte
Message-ID: <20201215030751.8RPSaXytT%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/page_vma_mapped.c: add colon to fix kernel-doc markups error for check_pte

check_pte() needs a correct colon for kernel-doc markup, otherwise, gcc
has the following warning for W=1, mm/page_vma_mapped.c:86: warning:
Function parameter or member 'pvmw' not described in 'check_pte'

Link: https://lkml.kernel.org/r/1605597167-25145-1-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_vma_mapped.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/page_vma_mapped.c~mm-add-colon-to-fix-kernel-doc-markups-error-for-check_pte
+++ a/mm/page_vma_mapped.c
@@ -66,18 +66,19 @@ static inline bool pfn_is_match(struct p
 
 /**
  * check_pte - check if @pvmw->page is mapped at the @pvmw->pte
+ * @pvmw: page_vma_mapped_walk struct, includes a pair pte and page for checking
  *
  * page_vma_mapped_walk() found a place where @pvmw->page is *potentially*
  * mapped. check_pte() has to validate this.
  *
- * @pvmw->pte may point to empty PTE, swap PTE or PTE pointing to arbitrary
- * page.
+ * pvmw->pte may point to empty PTE, swap PTE or PTE pointing to
+ * arbitrary page.
  *
  * If PVMW_MIGRATION flag is set, returns true if @pvmw->pte contains migration
  * entry that points to @pvmw->page or any subpage in case of THP.
  *
- * If PVMW_MIGRATION flag is not set, returns true if @pvmw->pte points to
- * @pvmw->page or any subpage in case of THP.
+ * If PVMW_MIGRATION flag is not set, returns true if pvmw->pte points to
+ * pvmw->page or any subpage in case of THP.
  *
  * Otherwise, return false.
  *
_
