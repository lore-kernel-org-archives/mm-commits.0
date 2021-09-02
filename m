Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C0CFC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:57:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E46796056B
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:57:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347923AbhIBV6F (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:58:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347609AbhIBV6E (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:58:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0999260E8B;
        Thu,  2 Sep 2021 21:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619825;
        bh=702ZXylp8++uRznDT57BajIwC366b3r4RkMeHYSL64A=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Q3ZhH9JvHPgBVTTBryAX427mI5aPLZlObInhv3WlRnnWiZNdp8/Dz3Qy4iwHpfOg5
         bv72n3e92dtnCJ5syNva/imzbiu0K8KQjDv0iIHj30rQcqMpaplW3LCr+tt219jhQ+
         Snz3ZmcLY8xGOvI/CkY6dHR1KmK9ZlLnCvDfvR20=
Date:   Thu, 02 Sep 2021 14:57:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com, david@redhat.com,
        linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        ohoono.kwon@samsung.com, rppt@linux.ibm.com,
        torvalds@linux-foundation.org
Subject:  [patch 133/212] mm: sparse: remove __section_nr()
 function
Message-ID: <20210902215704._ats9uMt7%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Ohhoon Kwon <ohoono.kwon@samsung.com>
Subject: mm: sparse: remove __section_nr() function

As the last users of __section_nr() are gone, let's remove unused function
__section_nr().

Link: https://lkml.kernel.org/r/20210707150212.855-4-ohoono.kwon@samsung.com
Signed-off-by: Ohhoon Kwon <ohoono.kwon@samsung.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    1 -
 mm/sparse.c            |   26 --------------------------
 2 files changed, 27 deletions(-)

--- a/include/linux/mmzone.h~mm-sparse-remove-__section_nr-function
+++ a/include/linux/mmzone.h
@@ -1342,7 +1342,6 @@ static inline struct mem_section *__nr_t
 		return NULL;
 	return &mem_section[SECTION_NR_TO_ROOT(nr)][nr & SECTION_ROOT_MASK];
 }
-extern unsigned long __section_nr(struct mem_section *ms);
 extern size_t mem_section_usage_size(void);
 
 /*
--- a/mm/sparse.c~mm-sparse-remove-__section_nr-function
+++ a/mm/sparse.c
@@ -109,32 +109,6 @@ static inline int sparse_index_init(unsi
 }
 #endif
 
-#ifdef CONFIG_SPARSEMEM_EXTREME
-unsigned long __section_nr(struct mem_section *ms)
-{
-	unsigned long root_nr;
-	struct mem_section *root = NULL;
-
-	for (root_nr = 0; root_nr < NR_SECTION_ROOTS; root_nr++) {
-		root = __nr_to_section(root_nr * SECTIONS_PER_ROOT);
-		if (!root)
-			continue;
-
-		if ((ms >= root) && (ms < (root + SECTIONS_PER_ROOT)))
-		     break;
-	}
-
-	VM_BUG_ON(!root);
-
-	return (root_nr * SECTIONS_PER_ROOT) + (ms - root);
-}
-#else
-unsigned long __section_nr(struct mem_section *ms)
-{
-	return (unsigned long)(ms - mem_section[0]);
-}
-#endif
-
 /*
  * During early boot, before section_mem_map is used for an actual
  * mem_map, we use section_mem_map to store the section's NUMA
_
