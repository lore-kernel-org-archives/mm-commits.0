Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09E70C43334
	for <mm-commits@archiver.kernel.org>; Wed, 29 Jun 2022 23:44:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbiF2Xoe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Jun 2022 19:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbiF2Xoe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Jun 2022 19:44:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383541A83E
        for <mm-commits@vger.kernel.org>; Wed, 29 Jun 2022 16:44:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D50D8B826BE
        for <mm-commits@vger.kernel.org>; Wed, 29 Jun 2022 23:44:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84999C34114;
        Wed, 29 Jun 2022 23:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656546270;
        bh=5bYxK9H2V37ctUJsmVvvCKCIAOdwPbc9FxGMnz4WmdU=;
        h=Date:To:From:Subject:From;
        b=Hz1wg1FOFb5O8cse5q4/kzXMCH56k0uF3nBml8bA56nyUOoB5ZKe1+C5MwVBX4orj
         ez44Dk89Fvn4ZwwfUDgIEflblsH1Dv4sYvqfaCuEQ0Mh70oUwFh8m9sTY2gh++HqXG
         89vLqUOIZufbAuwJE5lopFKqVottA8fmZ547AStw=
Date:   Wed, 29 Jun 2022 16:44:29 -0700
To:     mm-commits@vger.kernel.org, ming.lei@redhat.com, maorg@nvidia.com,
        hch@lst.de, wuchi.zero@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-scatterlist-use-matched-parameter-type-when-call-__sg_free_table.patch added to mm-nonmm-unstable branch
Message-Id: <20220629234430.84999C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/scatterlist: use matched parameter type when calling __sg_free_table()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-scatterlist-use-matched-parameter-type-when-call-__sg_free_table.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-scatterlist-use-matched-parameter-type-when-call-__sg_free_table.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: wuchi <wuchi.zero@gmail.com>
Subject: lib/scatterlist: use matched parameter type when calling __sg_free_table()
Date: Wed, 29 Jun 2022 11:02:41 +0800

commit 4635873c561a ("scsi: lib/sg_pool.c: improve APIs for allocating sg
pool") changeed @(bool)skip_first_chunk of __sg_free_table() to @(unsigned
int)nents_first_chunk, so use unsigend int type instead of bool type
(false -> 0) when calling the function in sg_free_append_table() and
sg_free_table().

Link: https://lkml.kernel.org/r/20220629030241.84559-1-wuchi.zero@gmail.com
Signed-off-by: wuchi <wuchi.zero@gmail.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Cc: Maor Gottlieb <maorg@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/scatterlist.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/scatterlist.c~lib-scatterlist-use-matched-parameter-type-when-call-__sg_free_table
+++ a/lib/scatterlist.c
@@ -240,7 +240,7 @@ EXPORT_SYMBOL(__sg_free_table);
  **/
 void sg_free_append_table(struct sg_append_table *table)
 {
-	__sg_free_table(&table->sgt, SG_MAX_SINGLE_ALLOC, false, sg_kfree,
+	__sg_free_table(&table->sgt, SG_MAX_SINGLE_ALLOC, 0, sg_kfree,
 			table->total_nents);
 }
 EXPORT_SYMBOL(sg_free_append_table);
@@ -253,7 +253,7 @@ EXPORT_SYMBOL(sg_free_append_table);
  **/
 void sg_free_table(struct sg_table *table)
 {
-	__sg_free_table(table, SG_MAX_SINGLE_ALLOC, false, sg_kfree,
+	__sg_free_table(table, SG_MAX_SINGLE_ALLOC, 0, sg_kfree,
 			table->orig_nents);
 }
 EXPORT_SYMBOL(sg_free_table);
_

Patches currently in -mm which might be from wuchi.zero@gmail.com are

lib-debugobjects-fix-stat-count-and-optimize-debug_objects_mem_init.patch
lib-lru_cache-fix-error-free-handing-in-lc_create.patch
net-lib-once-remove-net_get_random_once_wait-macro.patch
lib-error-inject-traverse-list-with-mutex.patch
lib-radix-tree-remove-unused-argument-of-insert_entries.patch
lib-scatterlist-use-matched-parameter-type-when-call-__sg_free_table.patch

