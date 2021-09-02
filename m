Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 624C3C43217
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:58:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C67D610A0
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:58:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347643AbhIBV7V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:59:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:54782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347971AbhIBV7K (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:59:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 598F76056B;
        Thu,  2 Sep 2021 21:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619891;
        bh=/JgA1jgQyXsUoPq3Y5Yi5i6Me75aWSXQHxBfVoRdUUc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=fL2CE9P2VGbe0vf9xNkRymd2yKCRsZyH8QeJZaxY+V1vPZrI1my00rnmUstcrb64k
         9rnPp6mzetZ5d9F3dy6ystgx3wufc2c2mxMCA3uT3dggQOTR2RVK4dJSfGGWDJq3cy
         mo4jFSvlDJqTAzIFuphCiJtp+m7RUDuQ9OZ1ydsU=
Date:   Thu, 02 Sep 2021 14:58:10 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org
Subject:  [patch 155/212] mm/page_alloc: make alloc_node_mem_map()
 __init rather than __ref
Message-ID: <20210902215810.mo6b3m0mv%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm/page_alloc: make alloc_node_mem_map() __init rather than __ref

alloc_node_mem_map() is never only called from free_area_init_node() that
is an __init function.

Make the actual alloc_node_mem_map() also __init and its stub version
static inline.

Link: https://lkml.kernel.org/r/20210716064124.31865-1-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-make-alloc_node_mem_map-__init-rather-than-__ref
+++ a/mm/page_alloc.c
@@ -7515,7 +7515,7 @@ static void __init free_area_init_core(s
 }
 
 #ifdef CONFIG_FLATMEM
-static void __ref alloc_node_mem_map(struct pglist_data *pgdat)
+static void __init alloc_node_mem_map(struct pglist_data *pgdat)
 {
 	unsigned long __maybe_unused start = 0;
 	unsigned long __maybe_unused offset = 0;
@@ -7561,7 +7561,7 @@ static void __ref alloc_node_mem_map(str
 #endif
 }
 #else
-static void __ref alloc_node_mem_map(struct pglist_data *pgdat) { }
+static inline void alloc_node_mem_map(struct pglist_data *pgdat) { }
 #endif /* CONFIG_FLATMEM */
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
_
