Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA2A2C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:41:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D35456127A
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:41:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbhKEUnn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:43:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:38404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233226AbhKEUnm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:43:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE1F86126A;
        Fri,  5 Nov 2021 20:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144862;
        bh=jOuwn8Guu8VA46qSiznSZUNIlcH+vRKwNXz6m3zXcJw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Vvk+XD7m9HKDmD0xTclQgKcVv8ETRrKeaW6DWXXyDdTyMlxCxsZiphnvxQc/9Acza
         iQ7sE/a4LmuBdEAsProEjcF9jp2WqgV7+hDu0CEyXhp5Q2UhEOmrgDdH88mgFtPmHQ
         YiDUd8xBjWvPcwe3AvF+yGFp56GB/ITEmnitkOKY=
Date:   Fri, 05 Nov 2021 13:41:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, rikard.falkeborn@gmail.com,
        torvalds@linux-foundation.org
Subject:  [patch 122/262] mm/memory_failure: constify static
 mm_walk_ops
Message-ID: <20211105204101.8OnxznkNy%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Subject: mm/memory_failure: constify static mm_walk_ops

The only usage of hwp_walk_ops is to pass its address to walk_page_range()
which takes a pointer to const mm_walk_ops as argument.  Make it const to
allow the compiler to put it in read-only memory.

Link: https://lkml.kernel.org/r/20211014075042.17174-3-rikard.falkeborn@gmail.com
Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-memory_failure-constify-static-mm_walk_ops
+++ a/mm/memory-failure.c
@@ -674,7 +674,7 @@ static int hwpoison_hugetlb_range(pte_t
 #define hwpoison_hugetlb_range	NULL
 #endif
 
-static struct mm_walk_ops hwp_walk_ops = {
+static const struct mm_walk_ops hwp_walk_ops = {
 	.pmd_entry = hwpoison_pte_range,
 	.hugetlb_entry = hwpoison_hugetlb_range,
 };
_
