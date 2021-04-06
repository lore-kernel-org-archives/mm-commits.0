Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35EA5C433ED
	for <mm-commits@archiver.kernel.org>; Tue,  6 Apr 2021 02:22:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F19A1613A9
	for <mm-commits@archiver.kernel.org>; Tue,  6 Apr 2021 02:22:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243353AbhDFCWp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Apr 2021 22:22:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238828AbhDFCWo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 5 Apr 2021 22:22:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3F486139B;
        Tue,  6 Apr 2021 02:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617675758;
        bh=A7OPgPpWKie0qmGl1SBHT5D04+lKj3w2NGJCMvQ8MMg=;
        h=Date:From:To:Subject:From;
        b=tBP766PXUyqQK4Yxl8MypaOy5dLr2c5NrDPBNVcUsB3JNUKLylgEhcMien1qxUrR8
         8dh2aIxv/FQrb/UhQCZ/5RKXy6rZvvW4VZClT1AfclgYmhUpcRF7c1si1sVV6sK7Ir
         +ZnVlll2t8sf7/C0DZZTwT89QdKc2IPvCrLJoJDA=
Date:   Mon, 05 Apr 2021 19:22:37 -0700
From:   akpm@linux-foundation.org
To:     alexey.skidanov@intel.com, alexs@kernel.org,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        sjhuang@iluvatar.ai, unixbhaskar@gmail.com
Subject:  +
 lib-genalloc-add-parameter-description-to-fix-doc-compile-warning.patch
 added to -mm tree
Message-ID: <20210406022237.xdgRw6JUz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/genalloc: add parameter description to fix doc compile warning
has been added to the -mm tree.  Its filename is
     lib-genalloc-add-parameter-description-to-fix-doc-compile-warning.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-genalloc-add-parameter-description-to-fix-doc-compile-warning.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-genalloc-add-parameter-description-to-fix-doc-compile-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

lib-percpu_counter-tame-kernel-doc-compile-warning.patch
lib-genalloc-add-parameter-description-to-fix-doc-compile-warning.patch

