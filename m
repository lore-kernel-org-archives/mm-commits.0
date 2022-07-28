Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCA90C04A68
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jul 2022 18:35:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbiG1Sfz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Jul 2022 14:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiG1Sfu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2022 14:35:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F1F6E88D
        for <mm-commits@vger.kernel.org>; Thu, 28 Jul 2022 11:35:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE2BD61DD0
        for <mm-commits@vger.kernel.org>; Thu, 28 Jul 2022 18:35:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ACEFC433D7;
        Thu, 28 Jul 2022 18:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659033348;
        bh=JDvCGEKqS9dY54p/ORR2TKwbmzndEd314mwYhKKP0IA=;
        h=Date:To:From:Subject:From;
        b=j5U90hpT+ItoHdqr7tx0J4uWz3l/ct0CKvE6UQxhc6GnS/rQU9srcaE4WV7CIe20/
         wccc+QMiZJXaFhojJnIWDfe00jV5+IIHWzeCjnVX8MUbiMdI6vxERFdN41BZU6oOwY
         EUo6wblWIoZDkcp5hHOoTqh1BmEA76C18P57o6L8=
Date:   Thu, 28 Jul 2022 11:35:45 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        vbabka@suse.cz, tglx@linutronix.de, rppt@linux.ibm.com,
        pcc@google.com, ira.weiny@intel.com, corbet@lwn.net,
        catalin.marinas@arm.com, bigeasy@linutronix.de,
        fmdefrancesco@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-mm-avoid-invalid-use-of-addresses-from-kmap_local_page.patch added to mm-unstable branch
Message-Id: <20220728183548.1ACEFC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/mm: avoid invalid use of addresses from kmap_local_page()
has been added to the -mm mm-unstable branch.  Its filename is
     documentation-mm-avoid-invalid-use-of-addresses-from-kmap_local_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-mm-avoid-invalid-use-of-addresses-from-kmap_local_page.patch

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
Subject: Documentation/mm: avoid invalid use of addresses from kmap_local_page()
Date: Thu, 28 Jul 2022 17:48:41 +0200

Users of kmap_local_page() must be absolutely sure to not hand kernel
virtual address obtained calling kmap_local_page() on highmem pages to
other contexts because those pointers are thread local, therefore, they
are no longer valid across different contexts.

Extend the documentation of kmap_local_page() to warn users about the
above-mentioned potential invalid use of pointers returned by
kmap_local_page().

Link: https://lkml.kernel.org/r/20220728154844.10874-5-fmdefrancesco@gmail.com
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

 Documentation/mm/highmem.rst |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/Documentation/mm/highmem.rst~documentation-mm-avoid-invalid-use-of-addresses-from-kmap_local_page
+++ a/Documentation/mm/highmem.rst
@@ -77,6 +77,13 @@ list shows them in order of preference o
   for pages which are known to not come from ZONE_HIGHMEM. However, it is
   always safe to use kmap_local_page() / kunmap_local().
 
+  While it is significantly faster than kmap(), for the higmem case it
+  comes with restrictions about the pointers validity. Contrary to kmap()
+  mappings, the local mappings are only valid in the context of the caller
+  and cannot be handed to other contexts. This implies that users must
+  be absolutely sure to keep the use of the return address local to the
+  thread which mapped it.
+
   Nesting kmap_local_page() and kmap_atomic() mappings is allowed to a certain
   extent (up to KMAP_TYPE_NR) but their invocations have to be strictly ordered
   because the map implementation is stack based. See kmap_local_page() kdocs
_

Patches currently in -mm which might be from fmdefrancesco@gmail.com are

highmem-remove-unneeded-spaces-in-kmap_local_page-kdocs.patch
highmem-specify-that-kmap_local_page-is-callable-from-interrupts.patch
documentation-mm-dont-kmap-pages-which-cant-come-from-highmem.patch
documentation-mm-avoid-invalid-use-of-addresses-from-kmap_local_page.patch
documentation-mm-prefer-kmap_local_page-and-avoid-kmap.patch
highmem-delete-a-sentence-from-kmap_local_page-kdocs.patch
documentation-mm-add-details-about-kmap_local_page-and-preemption.patch

