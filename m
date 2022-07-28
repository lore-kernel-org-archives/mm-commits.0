Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28DA5C04A68
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jul 2022 18:35:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiG1Sfs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Jul 2022 14:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiG1Sfo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2022 14:35:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E99246E2F8
        for <mm-commits@vger.kernel.org>; Thu, 28 Jul 2022 11:35:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 759A6B80905
        for <mm-commits@vger.kernel.org>; Thu, 28 Jul 2022 18:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C0EC433C1;
        Thu, 28 Jul 2022 18:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659033341;
        bh=wG9GsTSbjqT5UQzybmeneYj0u/ce/vVtwi5hICgSNbQ=;
        h=Date:To:From:Subject:From;
        b=Lm3zBDPgBA7ZRoSj22KN+mRYErcL4Zew5vqW/+fzbfikDyNV7PhQshZioFxAXnqpR
         iNSClhLIXxbenI1U9ENSJnwh7NdiSQ1AfB+5UX7bujjBjJCDnw1cackzznliOo60gL
         bFOTnAt7vJQVENQUXcyMLiZ+ELQlo0m+m7pkTr6E=
Date:   Thu, 28 Jul 2022 11:35:40 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        vbabka@suse.cz, tglx@linutronix.de, rppt@linux.ibm.com,
        pcc@google.com, ira.weiny@intel.com, corbet@lwn.net,
        catalin.marinas@arm.com, bigeasy@linutronix.de,
        fmdefrancesco@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + highmem-specify-that-kmap_local_page-is-callable-from-interrupts.patch added to mm-unstable branch
Message-Id: <20220728183541.08C0EC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: highmem: specify that kmap_local_page() is callable from interrupts
has been added to the -mm mm-unstable branch.  Its filename is
     highmem-specify-that-kmap_local_page-is-callable-from-interrupts.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/highmem-specify-that-kmap_local_page-is-callable-from-interrupts.patch

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
Subject: highmem: specify that kmap_local_page() is callable from interrupts
Date: Thu, 28 Jul 2022 17:48:39 +0200

In a recent thread about converting kmap() to kmap_local_page(), the
safety of calling kmap_local_page() was questioned.[1]

"any context" should probably be enough detail for users who want to know
whether or not kmap_local_page() can be called from interrupts.  However,
Linux still has kmap_atomic() which might make users think they must use
the latter in interrupts.

Add "including interrupts" for better clarity.

[1] https://lore.kernel.org/lkml/3187836.aeNJFYEL58@opensuse/

Link: https://lkml.kernel.org/r/20220728154844.10874-3-fmdefrancesco@gmail.com
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Suggested-by: Ira Weiny <ira.weiny@intel.com>
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

 include/linux/highmem.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/highmem.h~highmem-specify-that-kmap_local_page-is-callable-from-interrupts
+++ a/include/linux/highmem.h
@@ -64,7 +64,7 @@ static inline void kmap_flush_unused(voi
  *
  * Returns: The virtual address of the mapping
  *
- * Can be invoked from any context.
+ * Can be invoked from any context, including interrupts.
  *
  * Requires careful handling when nesting multiple mappings because the map
  * management is stack based. The unmap has to be in the reverse order of
_

Patches currently in -mm which might be from fmdefrancesco@gmail.com are

highmem-remove-unneeded-spaces-in-kmap_local_page-kdocs.patch
highmem-specify-that-kmap_local_page-is-callable-from-interrupts.patch
documentation-mm-dont-kmap-pages-which-cant-come-from-highmem.patch
documentation-mm-avoid-invalid-use-of-addresses-from-kmap_local_page.patch
documentation-mm-prefer-kmap_local_page-and-avoid-kmap.patch
highmem-delete-a-sentence-from-kmap_local_page-kdocs.patch
documentation-mm-add-details-about-kmap_local_page-and-preemption.patch

