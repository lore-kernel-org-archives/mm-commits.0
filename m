Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF295C2BBD4
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:13:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4BF22247F
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:13:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727665AbgLODNK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:13:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:36620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728079AbgLODNG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:13:06 -0500
Date:   Mon, 14 Dec 2020 19:12:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001922;
        bh=/zma8upw1GtgfWonvUI1cGG/FV1sYMp6mLRNoG3lQTQ=;
        h=From:To:Subject:In-Reply-To:From;
        b=TbCmk5sVBp4/NhX7Ulqpglxno0eNOru6Zii4RmBNZi8DMQ9jC7gONxpkaE8JwCnr0
         lTvX9mITIMH6A4DnAXg5qsdDdN8HpO6P7zKxifJbH/dmuGqyFw07OIo2TEbu6wrdF+
         eow8J2Opc+L8aXBuOlosA+ilOQlOOLNnU7x2RxGk=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        corbet@lwn.net, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, torvalds@linux-foundation.org
Subject:  [patch 148/200] khugepaged: add parameter explanations
 for kernel-doc markup
Message-ID: <20201215031201.ZDdS7g_uW%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: khugepaged: add parameter explanations for kernel-doc markup

Add missed parameter explanation for some kernel-doc warnings:
mm/khugepaged.c:102: warning: Function parameter or member
'nr_pte_mapped_thp' not described in 'mm_slot'
mm/khugepaged.c:102: warning: Function parameter or member
'pte_mapped_thp' not described in 'mm_slot'
mm/khugepaged.c:1424: warning: Function parameter or member 'mm' not
described in 'collapse_pte_mapped_thp'
mm/khugepaged.c:1424: warning: Function parameter or member 'addr' not
described in 'collapse_pte_mapped_thp'
mm/khugepaged.c:1626: warning: Function parameter or member 'mm' not
described in 'collapse_file'
mm/khugepaged.c:1626: warning: Function parameter or member 'file' not
described in 'collapse_file'
mm/khugepaged.c:1626: warning: Function parameter or member 'start' not
described in 'collapse_file'
mm/khugepaged.c:1626: warning: Function parameter or member 'hpage' not
described in 'collapse_file'
mm/khugepaged.c:1626: warning: Function parameter or member 'node' not
described in 'collapse_file'

Link: https://lkml.kernel.org/r/1605597325-25284-1-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/mm/khugepaged.c~khugepaged-add-couples-parameter-explanation-for-kernel-doc-markup
+++ a/mm/khugepaged.c
@@ -90,6 +90,8 @@ static struct kmem_cache *mm_slot_cache
  * @hash: hash collision list
  * @mm_node: khugepaged scan list headed in khugepaged_scan.mm_head
  * @mm: the mm that this information is valid for
+ * @nr_pte_mapped_thp: number of pte mapped THP
+ * @pte_mapped_thp: address array corresponding pte mapped THP
  */
 struct mm_slot {
 	struct hlist_node hash;
@@ -1414,7 +1416,11 @@ static int khugepaged_add_pte_mapped_thp
 }
 
 /**
- * Try to collapse a pte-mapped THP for mm at address haddr.
+ * collapse_pte_mapped_thp - Try to collapse a pte-mapped THP for mm at
+ * address haddr.
+ *
+ * @mm: process address space where collapse happens
+ * @addr: THP collapse address
  *
  * This function checks whether all the PTEs in the PMD are pointing to the
  * right THP. If so, retract the page table so the THP can refault in with
@@ -1605,6 +1611,12 @@ static void retract_page_tables(struct a
 /**
  * collapse_file - collapse filemap/tmpfs/shmem pages into huge one.
  *
+ * @mm: process address space where collapse happens
+ * @file: file that collapse on
+ * @start: collapse start address
+ * @hpage: new allocated huge page for collapse
+ * @node: appointed node the new huge page allocate from
+ *
  * Basic scheme is simple, details are more complex:
  *  - allocate and lock a new huge page;
  *  - scan page cache replacing old pages with the new one
_
