Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C151EC4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:30:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 826CB2246B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:30:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725819AbgLODaW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:30:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:36356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726427AbgLODI3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:08:29 -0500
Date:   Mon, 14 Dec 2020 19:07:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001669;
        bh=gakWNfMVf2au/J/2nH7LnI+MZMWRX7zc0qFqmFtkkqU=;
        h=From:To:Subject:In-Reply-To:From;
        b=HHGzYvJ5Tmc29E+LBZ+vebYS2ula7eIWZYBZqG1p02x5qtDu8Bi69Ht4RMwinqxHW
         an2RJZCF3GGe9L3dRMaPueRtBKEeDDngB1dxVm/GOnvfNKX3t+RPlFAvbU+PGerwOs
         9JeBSNuWbdgP0lMbrvY7S+rLgyFJx88cVGo84WCM=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        corbet@lwn.net, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, torvalds@linux-foundation.org
Subject:  [patch 079/200] mm/mapping_dirty_helpers: enhance the
 kernel-doc markups
Message-ID: <20201215030748.MULOtjnS5%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/mapping_dirty_helpers: enhance the kernel-doc markups

Add and change parameter explanation for wp_pte and clean_record_pte, to
avoid W1 warning:
mm/mapping_dirty_helpers.c:34: warning: Function parameter or member
'end' not described in 'wp_pte'
mm/mapping_dirty_helpers.c:88: warning: Function parameter or member
'end' not described in 'clean_record_pte'

Link: https://lkml.kernel.org/r/1605605088-30668-2-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mapping_dirty_helpers.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/mapping_dirty_helpers.c~mm-mapping_dirty_helpers-enhance-the-kernel-doc-markups
+++ a/mm/mapping_dirty_helpers.c
@@ -23,7 +23,8 @@ struct wp_walk {
 /**
  * wp_pte - Write-protect a pte
  * @pte: Pointer to the pte
- * @addr: The virtual page address
+ * @addr: The start of protecting virtual address
+ * @end: The end of protecting virtual address
  * @walk: pagetable walk callback argument
  *
  * The function write-protects a pte and records the range in
@@ -74,7 +75,8 @@ struct clean_walk {
  * clean_record_pte - Clean a pte and record its address space offset in a
  * bitmap
  * @pte: Pointer to the pte
- * @addr: The virtual page address
+ * @addr: The start of virtual address to be clean
+ * @end: The end of virtual address to be clean
  * @walk: pagetable walk callback argument
  *
  * The function cleans a pte and records the range in
_
