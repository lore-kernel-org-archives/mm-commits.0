Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 572B5EE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 21:29:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbjHUV33 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 17:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbjHUV30 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 17:29:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D3ABC7
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 14:29:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E6D463072
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 21:29:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 628EDC433C8;
        Mon, 21 Aug 2023 21:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692653363;
        bh=qZS+zpowX5udEnOHmCVaMCTOAPu2DXzXtxH8W6IlWic=;
        h=Date:To:From:Subject:From;
        b=Kvo8S/zdybbVSYoBBYjjTWVU70PrAbauvKLxIPE87eVaJEtGG5xLkphIbOsO1fvtd
         Yzt0sJWO7TkTbo0q4hGCGpQ5sRxk5p1UqesyEfLk/tSyyhzyFDmYd3HkQrIRdLiaiQ
         mD38XYc5j+qoDwf1gSAe+iuQPoSwP7kWrBCizOwk=
Date:   Mon, 21 Aug 2023 14:29:22 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        torvalds@linux-foundation.org, shuah@kernel.org, peterx@redhat.com,
        pbonzini@redhat.com, mgorman@techsingularity.net, mgorman@suse.de,
        liubo254@huawei.com, jhubbard@nvidia.com, jgg@ziepe.ca,
        hughd@google.com, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] pgtable-improve-pte_protnone-comment.patch removed from -mm tree
Message-Id: <20230821212923.628EDC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: pgtable: improve pte_protnone() comment
has been removed from the -mm tree.  Its filename was
     pgtable-improve-pte_protnone-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: pgtable: improve pte_protnone() comment
Date: Thu, 3 Aug 2023 16:32:06 +0200

Especially the "For PROT_NONE VMAs, the PTEs are not marked
_PAGE_PROTNONE" part is wrong: doing an mprotect(PROT_NONE) will end up
marking all PTEs on x86_64 as _PAGE_PROTNONE, making pte_protnone()
indicate "yes".

So let's improve the comment, so it's easier to grasp which semantics
pte_protnone() actually has.

Link: https://lkml.kernel.org/r/20230803143208.383663-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: liubo <liubo254@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/include/linux/pgtable.h~pgtable-improve-pte_protnone-comment
+++ a/include/linux/pgtable.h
@@ -1333,12 +1333,16 @@ static inline int pud_trans_unstable(pud
 
 #ifndef CONFIG_NUMA_BALANCING
 /*
- * Technically a PTE can be PROTNONE even when not doing NUMA balancing but
- * the only case the kernel cares is for NUMA balancing and is only ever set
- * when the VMA is accessible. For PROT_NONE VMAs, the PTEs are not marked
- * _PAGE_PROTNONE so by default, implement the helper as "always no". It
- * is the responsibility of the caller to distinguish between PROT_NONE
- * protections and NUMA hinting fault protections.
+ * In an inaccessible (PROT_NONE) VMA, pte_protnone() may indicate "yes". It is
+ * perfectly valid to indicate "no" in that case, which is why our default
+ * implementation defaults to "always no".
+ *
+ * In an accessible VMA, however, pte_protnone() reliably indicates PROT_NONE
+ * page protection due to NUMA hinting. NUMA hinting faults only apply in
+ * accessible VMAs.
+ *
+ * So, to reliably identify PROT_NONE PTEs that require a NUMA hinting fault,
+ * looking at the VMA accessibility is sufficient.
  */
 static inline int pte_protnone(pte_t pte)
 {
_

Patches currently in -mm which might be from david@redhat.com are

mm-swap-stop-using-page-private-on-tail-pages-for-thp_swap.patch
mm-swap-inline-folio_set_swap_entry-and-folio_swap_entry.patch
mm-huge_memory-work-on-folio-swap-instead-of-page-private-when-splitting-folio.patch

