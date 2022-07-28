Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14F3FC04A68
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jul 2022 18:35:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbiG1Sfo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Jul 2022 14:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiG1Sfn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2022 14:35:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD886E2F8
        for <mm-commits@vger.kernel.org>; Thu, 28 Jul 2022 11:35:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0E68B824A0
        for <mm-commits@vger.kernel.org>; Thu, 28 Jul 2022 18:35:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C10C433D6;
        Thu, 28 Jul 2022 18:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659033339;
        bh=6lp0GfdM45ML/LsdJhA8+dqbZOIfp3xs7RZbPfISl48=;
        h=Date:To:From:Subject:From;
        b=kAeGnaCniGzhIeil1J3rOxxQXK5CNe4pwB4s5biSVxRvW3xAnCIHt7cbSub3jld/N
         nhROSAs+vKmdo/0h4MK+W3s4FI3lw0U7izKw+SzkkPZUE9LACP4h+8JDXagADWSCaj
         zt1vnRLbNnD3X5Bg5EnkTeLnCt2cNQ4UiNhft+0M=
Date:   Thu, 28 Jul 2022 11:35:38 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        vbabka@suse.cz, tglx@linutronix.de, rppt@linux.ibm.com,
        pcc@google.com, ira.weiny@intel.com, corbet@lwn.net,
        catalin.marinas@arm.com, bigeasy@linutronix.de,
        fmdefrancesco@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + highmem-remove-unneeded-spaces-in-kmap_local_page-kdocs.patch added to mm-unstable branch
Message-Id: <20220728183539.76C10C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: highmem: remove unneeded spaces in kmap_local_page() kdocs
has been added to the -mm mm-unstable branch.  Its filename is
     highmem-remove-unneeded-spaces-in-kmap_local_page-kdocs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/highmem-remove-unneeded-spaces-in-kmap_local_page-kdocs.patch

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
Subject: highmem: remove unneeded spaces in kmap_local_page() kdocs
Date: Thu, 28 Jul 2022 17:48:38 +0200

Patch series "highmem: Extend kmap_local_page() documentation", v2.

The Highmem interface is evolving and the current documentation does not
reflect the intended uses of each of the calls.  Furthermore, after a
recent series of reworks, the differences of the calls can still be
confusing and may lead to the expanded use of calls which are deprecated.

This series is the second round of changes towards an enhanced
documentation of the Highmem's interface; at this stage the patches are
only focused to kmap_local_page().

In addition it also contains some minor clean ups.


This patch (of 7):

In the kdocs of kmap_local_page(), the description of @page starts after
several unnecessary spaces.

Therefore, remove those spaces.

Link: https://lkml.kernel.org/r/20220728154844.10874-1-fmdefrancesco@gmail.com
Link: https://lkml.kernel.org/r/20220728154844.10874-2-fmdefrancesco@gmail.com
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Suggested-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/highmem.h~highmem-remove-unneeded-spaces-in-kmap_local_page-kdocs
+++ a/include/linux/highmem.h
@@ -60,7 +60,7 @@ static inline void kmap_flush_unused(voi
 
 /**
  * kmap_local_page - Map a page for temporary usage
- * @page:	Pointer to the page to be mapped
+ * @page: Pointer to the page to be mapped
  *
  * Returns: The virtual address of the mapping
  *
_

Patches currently in -mm which might be from fmdefrancesco@gmail.com are

highmem-remove-unneeded-spaces-in-kmap_local_page-kdocs.patch
highmem-specify-that-kmap_local_page-is-callable-from-interrupts.patch
documentation-mm-dont-kmap-pages-which-cant-come-from-highmem.patch
documentation-mm-avoid-invalid-use-of-addresses-from-kmap_local_page.patch
documentation-mm-prefer-kmap_local_page-and-avoid-kmap.patch
highmem-delete-a-sentence-from-kmap_local_page-kdocs.patch
documentation-mm-add-details-about-kmap_local_page-and-preemption.patch

