Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E330C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:57:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A39860FA0
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:57:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347881AbhIBV57 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:57:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:53402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347609AbhIBV56 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:57:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CA0A60F21;
        Thu,  2 Sep 2021 21:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619819;
        bh=hnKVaFD2JIennZPvq3nC9EYwyc/KHLhw2+RmZICvjaM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=LeuOpQlcaUXsIAUp+1TxvUCoAlPtdJ/ThXeIQQA1DmgbxBXM9c/zTj3xLzbQIMYao
         4dAAht93Ah3uuG8St37Q0/pfhGbZtSwIsxp1XTWYxj0XhYGPyxt/aQTivb2ZsZ0CyW
         BDBv5BgK8EXlk+tA+qEYm3BqqzjAHD2z5eAJ7acA=
Date:   Thu, 02 Sep 2021 14:56:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com, david@redhat.com,
        linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        ohoono.kwon@samsung.com, rppt@linux.ibm.com,
        torvalds@linux-foundation.org
Subject:  [patch 131/212] mm: sparse: pass section_nr to
 section_mark_present
Message-ID: <20210902215658.oeXWHpOcy%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Ohhoon Kwon <ohoono.kwon@samsung.com>
Subject: mm: sparse: pass section_nr to section_mark_present

Patch series "mm: sparse: remove __section_nr() function", v4.


This patch (of 3):

With CONFIG_SPARSEMEM_EXTREME enabled, __section_nr() which converts
mem_section to section_nr could be costly since it iterates all section
roots to check if the given mem_section is in its range.

Since both callers of section_mark_present already know section_nr, let's
also pass section_nr as well as mem_section in order to reduce costly
translation.

Link: https://lkml.kernel.org/r/20210707150212.855-1-ohoono.kwon@samsung.com
Link: https://lkml.kernel.org/r/20210707150212.855-2-ohoono.kwon@samsung.com
Signed-off-by: Ohhoon Kwon <ohoono.kwon@samsung.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/sparse.c~mm-sparse-pass-section_nr-to-section_mark_present
+++ a/mm/sparse.c
@@ -187,10 +187,9 @@ void __meminit mminit_validate_memmodel_
  * those loops early.
  */
 unsigned long __highest_present_section_nr;
-static void section_mark_present(struct mem_section *ms)
+static void __section_mark_present(struct mem_section *ms,
+		unsigned long section_nr)
 {
-	unsigned long section_nr = __section_nr(ms);
-
 	if (section_nr > __highest_present_section_nr)
 		__highest_present_section_nr = section_nr;
 
@@ -280,7 +279,7 @@ static void __init memory_present(int ni
 		if (!ms->section_mem_map) {
 			ms->section_mem_map = sparse_encode_early_nid(nid) |
 							SECTION_IS_ONLINE;
-			section_mark_present(ms);
+			__section_mark_present(ms, section);
 		}
 	}
 }
@@ -934,7 +933,7 @@ int __meminit sparse_add_section(int nid
 
 	ms = __nr_to_section(section_nr);
 	set_section_nid(section_nr, nid);
-	section_mark_present(ms);
+	__section_mark_present(ms, section_nr);
 
 	/* Align memmap to section boundary in the subsection case */
 	if (section_nr_to_pfn(section_nr) != start_pfn)
_
