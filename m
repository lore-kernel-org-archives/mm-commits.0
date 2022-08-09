Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86E06C25B0C
	for <mm-commits@archiver.kernel.org>; Tue,  9 Aug 2022 01:15:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244649AbiHIBPm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Aug 2022 21:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244736AbiHIBPL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 Aug 2022 21:15:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 514FF1E3D5
        for <mm-commits@vger.kernel.org>; Mon,  8 Aug 2022 18:14:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1292EB81116
        for <mm-commits@vger.kernel.org>; Tue,  9 Aug 2022 01:14:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C307EC433C1;
        Tue,  9 Aug 2022 01:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660007681;
        bh=9pZRJ843bwyC96KKTvome1O3uDyAGRxpm7G512qi/oM=;
        h=Date:To:From:Subject:From;
        b=u7/lhyerA6La8OP6pVrWbv1SLuUC/X+DX+EyZh6hFzyHkajHloi4ylOPIFAbSQ9sc
         Ki7nHfyhocgFk65LKFQgCjUK2GtbM3umS4sqA8XNa1Er4njkXpXfs9IPQydidwNQeI
         xXJy2nuQ+RNxY85xe5m3OF72aFolxTySetFqHkWw=
Date:   Mon, 08 Aug 2022 18:14:41 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        vbabka@suse.cz, tglx@linutronix.de, rppt@linux.ibm.com,
        pcc@google.com, ira.weiny@intel.com, corbet@lwn.net,
        catalin.marinas@arm.com, bigeasy@linutronix.de,
        fmdefrancesco@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] highmem-delete-a-sentence-from-kmap_local_page-kdocs.patch removed from -mm tree
Message-Id: <20220809011441.C307EC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: highmem: delete a sentence from kmap_local_page() kdocs
has been removed from the -mm tree.  Its filename was
     highmem-delete-a-sentence-from-kmap_local_page-kdocs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Subject: highmem: delete a sentence from kmap_local_page() kdocs
Date: Thu, 28 Jul 2022 17:48:43 +0200

kmap_local_page() should always be preferred in place of kmap() and
kmap_atomic().  "Only use when really necessary." is not consistent with
the Documentation/mm/highmem.rst and these kdocs it embeds.

Therefore, delete the above-mentioned sentence from kdocs.

Link: https://lkml.kernel.org/r/20220728154844.10874-7-fmdefrancesco@gmail.com
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Suggested-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/highmem.h~highmem-delete-a-sentence-from-kmap_local_page-kdocs
+++ a/include/linux/highmem.h
@@ -86,8 +86,7 @@ static inline void kmap_flush_unused(voi
  * temporarily mapped.
  *
  * While it is significantly faster than kmap() for the higmem case it
- * comes with restrictions about the pointer validity. Only use when really
- * necessary.
+ * comes with restrictions about the pointer validity.
  *
  * On HIGHMEM enabled systems mapping a highmem page has the side effect of
  * disabling migration in order to keep the virtual address stable across
_

Patches currently in -mm which might be from fmdefrancesco@gmail.com are


