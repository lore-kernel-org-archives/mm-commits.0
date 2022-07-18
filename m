Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98382CCA480
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:32:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbiGRAch (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232819AbiGRAcg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:32:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD4513E09
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:32:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FD79B80EE3
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:32:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4683FC341CE;
        Mon, 18 Jul 2022 00:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658104349;
        bh=f23lbd7CpNBWzhN3u7Y8KiwcSGkxDclQZOFN3Qw1s54=;
        h=Date:To:From:Subject:From;
        b=oQFIdgf2RLQRNdIv5Q11QdGilFyNS7JHv/b7BMTrZgpunseJkPyfX3ufaGBilhYw0
         aVMZ/HhvDLUzMzLPGNvcLFIIjyUaTIm+IaPG9veJ/y64jgvvSgcvgN3AQXD1gJq/6B
         9MQJE6T+Ny3GJ411AuQcU8Tw0DF4eAVcP11tEZCQ=
Date:   Sun, 17 Jul 2022 17:32:28 -0700
To:     mm-commits@vger.kernel.org, ming.lei@redhat.com, maorg@nvidia.com,
        hch@lst.de, wuchi.zero@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-scatterlist-use-matched-parameter-type-when-call-__sg_free_table.patch removed from -mm tree
Message-Id: <20220718003229.4683FC341CE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/scatterlist: use matched parameter type when calling __sg_free_table()
has been removed from the -mm tree.  Its filename was
     lib-scatterlist-use-matched-parameter-type-when-call-__sg_free_table.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

