Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25771EB64D8
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jun 2023 20:14:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjFUUOQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Jun 2023 16:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbjFUUOP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Jun 2023 16:14:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D3B419A1
        for <mm-commits@vger.kernel.org>; Wed, 21 Jun 2023 13:14:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEEF6616C5
        for <mm-commits@vger.kernel.org>; Wed, 21 Jun 2023 20:14:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE8DC433B7;
        Wed, 21 Jun 2023 20:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687378453;
        bh=9z3n5LUnPEKxxRXPDVsYl6fqILFUNVWJlM4qaS7dGbQ=;
        h=Date:To:From:Subject:From;
        b=lhgsqtnfRDmdLnOdhlNjEGFZ0HBSqQPgZQNDYC/3ENbN66X3DdzWKPd/4ZvhrACQO
         T9wGTNXXQ5nN+S+hoZ1xMqhZo+u7lrasOkoOD2g0apk8a1SkT+kgJPYllZAvESCNbv
         bS15I9azRRcENK3aQXffARQ+YEs19vSC09ifYg1I=
Date:   Wed, 21 Jun 2023 13:14:12 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-__folio_batch_release.patch added to mm-unstable branch
Message-Id: <20230621201413.1BE8DC433B7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add __folio_batch_release()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-__folio_batch_release.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-__folio_batch_release.patch

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
Subject: mm: add __folio_batch_release()
Date: Wed, 21 Jun 2023 17:45:46 +0100

This performs the same role as __pagevec_release(), ie skipping the check
for batch length of 0.

Link: https://lkml.kernel.org/r/20230621164557.3510324-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagevec.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/include/linux/pagevec.h~mm-add-__folio_batch_release
+++ a/include/linux/pagevec.h
@@ -127,9 +127,15 @@ static inline unsigned folio_batch_add(s
 	return fbatch_space(fbatch);
 }
 
+static inline void __folio_batch_release(struct folio_batch *fbatch)
+{
+	__pagevec_release((struct pagevec *)fbatch);
+}
+
 static inline void folio_batch_release(struct folio_batch *fbatch)
 {
-	pagevec_release((struct pagevec *)fbatch);
+	if (folio_batch_count(fbatch))
+		__folio_batch_release(fbatch);
 }
 
 void folio_batch_remove_exceptionals(struct folio_batch *fbatch);
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

