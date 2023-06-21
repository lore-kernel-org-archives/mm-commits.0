Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E575EB64D7
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jun 2023 20:14:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbjFUUOp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Jun 2023 16:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbjFUUO2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Jun 2023 16:14:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE6B1BDA
        for <mm-commits@vger.kernel.org>; Wed, 21 Jun 2023 13:14:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2B10616C2
        for <mm-commits@vger.kernel.org>; Wed, 21 Jun 2023 20:14:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43EFCC433C8;
        Wed, 21 Jun 2023 20:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687378462;
        bh=gmkqP3i4u2jD1tRFrmsTyYg+QYaiPkTR1plE1akOMSY=;
        h=Date:To:From:Subject:From;
        b=J+57MgujYnYSfhfJDijl1hLkWnFkiF7lU5YmqTEydQa4+IdVI6tOpJnf4cch3RsXe
         zkHDx871ONZQ2+JphVFmrJeSCeSAO2DFmKzIh6pgVjJRbIXQujMvmeNqqoYYnEw7Eb
         YmIxiAPA0SssZDLpuM9iqo9MmNrO9p5fpnTZqRL0=
Date:   Wed, 21 Jun 2023 13:14:21 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + pagevec-rename-fbatch_count.patch added to mm-unstable branch
Message-Id: <20230621201422.43EFCC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: pagevec: rename fbatch_count()
has been added to the -mm mm-unstable branch.  Its filename is
     pagevec-rename-fbatch_count.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/pagevec-rename-fbatch_count.patch

This patch will later appear in the mm-unstable branch at
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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: pagevec: rename fbatch_count()
Date: Wed, 21 Jun 2023 17:45:51 +0100

This should always have been called folio_batch_count().

Link: https://lkml.kernel.org/r/20230621164557.3510324-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagevec.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/pagevec.h~pagevec-rename-fbatch_count
+++ a/include/linux/pagevec.h
@@ -105,7 +105,7 @@ static inline unsigned int folio_batch_c
 	return fbatch->nr;
 }
 
-static inline unsigned int fbatch_space(struct folio_batch *fbatch)
+static inline unsigned int folio_batch_space(struct folio_batch *fbatch)
 {
 	return PAGEVEC_SIZE - fbatch->nr;
 }
@@ -124,7 +124,7 @@ static inline unsigned folio_batch_add(s
 		struct folio *folio)
 {
 	fbatch->folios[fbatch->nr++] = folio;
-	return fbatch_space(fbatch);
+	return folio_batch_space(fbatch);
 }
 
 static inline void __folio_batch_release(struct folio_batch *fbatch)
_

Patches currently in -mm which might be from willy@infradead.org are

afs-convert-pagevec-to-folio_batch-in-afs_extend_writeback.patch
mm-add-__folio_batch_release.patch
scatterlist-add-sg_set_folio.patch
i915-convert-shmem_sg_free_table-to-use-a-folio_batch.patch
drm-convert-drm_gem_put_pages-to-use-a-folio_batch.patch
mm-remove-check_move_unevictable_pages.patch
pagevec-rename-fbatch_count.patch
i915-convert-i915_gpu_error-to-use-a-folio_batch.patch
net-convert-sunrpc-from-pagevec-to-folio_batch.patch
mm-remove-struct-pagevec.patch
mm-rename-invalidate_mapping_pagevec-to-mapping_try_invalidate.patch
mm-remove-references-to-pagevec.patch
mm-remove-unnecessary-pagevec-includes.patch

