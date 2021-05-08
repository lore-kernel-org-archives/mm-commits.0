Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD137C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:53:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 911E461424
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:53:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbhEHWyI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:54:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:41700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229620AbhEHWyH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:54:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F0AD610FA;
        Sat,  8 May 2021 22:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514385;
        bh=MuhV6EeDlTF1gRqB+Z+onNQcpjk95J7vi2Q8gHO8Go8=;
        h=Date:From:To:Subject:From;
        b=OkiYjQX0vs8iPLYA7CIpOTFgAHg8iN7p3k4quL6WJ68dLTT6j3cwJFeSG2OpZOEqT
         i67UX0+4gwZdS7tbX6k1lA9EUNqpQasWqJQVwRxqkD+I/W/sb2HLD6fFzRJF5JWC0P
         id/MpA/NnF/RXSrW0chBXRRp63dbRc9LwSevvYbc=
Date:   Sat, 08 May 2021 15:53:05 -0700
From:   akpm@linux-foundation.org
To:     alexey.skidanov@intel.com, alexs@kernel.org,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        sjhuang@iluvatar.ai, unixbhaskar@gmail.com
Subject:  [merged]
 lib-genalloc-add-parameter-description-to-fix-doc-compile-warning.patch
 removed from -mm tree
Message-ID: <20210508225305.i1v_lwFKp%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/genalloc: add parameter description to fix doc compile warning
has been removed from the -mm tree.  Its filename was
     lib-genalloc-add-parameter-description-to-fix-doc-compile-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alex Shi <alexs@kernel.org>
Subject: lib/genalloc: add parameter description to fix doc compile warning

commit 52fbf1134d47 ("lib/genalloc.c: fix allocation of aligned buffer
 from non-aligned chunk") add a new parameter 'start_addr' w/o
description for it. That cause some doc compile warning:

lib/genalloc.c:649: warning: Function parameter or member 'start_addr' not described in 'gen_pool_first_fit'
lib/genalloc.c:667: warning: Function parameter or member 'start_addr' not described in 'gen_pool_first_fit_align'
lib/genalloc.c:694: warning: Function parameter or member 'start_addr' not described in 'gen_pool_fixed_alloc'
lib/genalloc.c:729: warning: Function parameter or member 'start_addr' not described in 'gen_pool_first_fit_order_align'
lib/genalloc.c:752: warning: Function parameter or member 'start_addr' not described in 'gen_pool_best_fit'

This patch fix this by adding parameter descriptions.

Link: https://lkml.kernel.org/r/20210405132021.131231-1-alexs@kernel.org
Signed-off-by: Alex Shi <alexs@kernel.org>
Cc: Alexey Skidanov <alexey.skidanov@intel.com>
Cc: Huang Shijie <sjhuang@iluvatar.ai>
Cc: Alex Shi <alexs@kernel.org>
Cc: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/genalloc.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/lib/genalloc.c~lib-genalloc-add-parameter-description-to-fix-doc-compile-warning
+++ a/lib/genalloc.c
@@ -642,6 +642,7 @@ EXPORT_SYMBOL(gen_pool_set_algo);
  * @nr: The number of zeroed bits we're looking for
  * @data: additional data - unused
  * @pool: pool to find the fit region memory from
+ * @start_addr: not used in this function
  */
 unsigned long gen_pool_first_fit(unsigned long *map, unsigned long size,
 		unsigned long start, unsigned int nr, void *data,
@@ -660,6 +661,7 @@ EXPORT_SYMBOL(gen_pool_first_fit);
  * @nr: The number of zeroed bits we're looking for
  * @data: data for alignment
  * @pool: pool to get order from
+ * @start_addr: start addr of alloction chunk
  */
 unsigned long gen_pool_first_fit_align(unsigned long *map, unsigned long size,
 		unsigned long start, unsigned int nr, void *data,
@@ -687,6 +689,7 @@ EXPORT_SYMBOL(gen_pool_first_fit_align);
  * @nr: The number of zeroed bits we're looking for
  * @data: data for alignment
  * @pool: pool to get order from
+ * @start_addr: not used in this function
  */
 unsigned long gen_pool_fixed_alloc(unsigned long *map, unsigned long size,
 		unsigned long start, unsigned int nr, void *data,
@@ -721,6 +724,7 @@ EXPORT_SYMBOL(gen_pool_fixed_alloc);
  * @nr: The number of zeroed bits we're looking for
  * @data: additional data - unused
  * @pool: pool to find the fit region memory from
+ * @start_addr: not used in this function
  */
 unsigned long gen_pool_first_fit_order_align(unsigned long *map,
 		unsigned long size, unsigned long start,
@@ -742,6 +746,7 @@ EXPORT_SYMBOL(gen_pool_first_fit_order_a
  * @nr: The number of zeroed bits we're looking for
  * @data: additional data - unused
  * @pool: pool to find the fit region memory from
+ * @start_addr: not used in this function
  *
  * Iterate over the bitmap to find the smallest free region
  * which we can allocate the memory.
_

Patches currently in -mm which might be from alexs@kernel.org are


