Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87D49C04A68
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jul 2022 18:35:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiG1Sf6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Jul 2022 14:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbiG1Sfz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2022 14:35:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56FEC6FA13
        for <mm-commits@vger.kernel.org>; Thu, 28 Jul 2022 11:35:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6A1B61DB2
        for <mm-commits@vger.kernel.org>; Thu, 28 Jul 2022 18:35:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E554C433C1;
        Thu, 28 Jul 2022 18:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659033353;
        bh=tIOWlHtgg+niZHodlONTCdZ4Ynq2tjR8oHzG5ZP7rfM=;
        h=Date:To:From:Subject:From;
        b=AMeLQVpAORCuNXpDu8OgJP2ozUKPxnUXrUx/pyL4fJFJHYpJkvNd+6dBRFQ05wDD0
         v7xEZFBUb3AsgHMnn/dyLfl1yFf/GAMEHICSjn8n0olEKuWiu37BIat2s7BAh7y3Ha
         rglvKiylOqTTeR5fhnAK6eJWRlgrGydsoMeR/g+s=
Date:   Thu, 28 Jul 2022 11:35:50 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        vbabka@suse.cz, tglx@linutronix.de, rppt@linux.ibm.com,
        pcc@google.com, ira.weiny@intel.com, corbet@lwn.net,
        catalin.marinas@arm.com, bigeasy@linutronix.de,
        fmdefrancesco@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + highmem-delete-a-sentence-from-kmap_local_page-kdocs.patch added to mm-unstable branch
Message-Id: <20220728183553.3E554C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: highmem: delete a sentence from kmap_local_page() kdocs
has been added to the -mm mm-unstable branch.  Its filename is
     highmem-delete-a-sentence-from-kmap_local_page-kdocs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/highmem-delete-a-sentence-from-kmap_local_page-kdocs.patch

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

highmem-remove-unneeded-spaces-in-kmap_local_page-kdocs.patch
highmem-specify-that-kmap_local_page-is-callable-from-interrupts.patch
documentation-mm-dont-kmap-pages-which-cant-come-from-highmem.patch
documentation-mm-avoid-invalid-use-of-addresses-from-kmap_local_page.patch
documentation-mm-prefer-kmap_local_page-and-avoid-kmap.patch
highmem-delete-a-sentence-from-kmap_local_page-kdocs.patch
documentation-mm-add-details-about-kmap_local_page-and-preemption.patch

