Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62D9DC19F2B
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jul 2022 18:35:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbiG1Sf4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Jul 2022 14:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiG1Sfv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2022 14:35:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B921B6E8A7
        for <mm-commits@vger.kernel.org>; Thu, 28 Jul 2022 11:35:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5419F61DD6
        for <mm-commits@vger.kernel.org>; Thu, 28 Jul 2022 18:35:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5CD3C433D6;
        Thu, 28 Jul 2022 18:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659033349;
        bh=sAeQglxhv6IbWiE03sd4KpePvBU9wCT9BfSmg9/ulQw=;
        h=Date:To:From:Subject:From;
        b=olJf3+viR8x0068CSOGaNv4tbhptkT+p/VGUJTTxOXoJvGOHIW+IBpcBNPCASGtDo
         ClqfngxFVIz3K6Zh8weyailyM+KGteXAvlWsT1bSKY2BitOB0X0P4YWChuqbBNmWVc
         sGlN4rcphET+zR66QhXZqTWS9c07eq0YE7/yYB60=
Date:   Thu, 28 Jul 2022 11:35:48 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        vbabka@suse.cz, tglx@linutronix.de, rppt@linux.ibm.com,
        pcc@google.com, ira.weiny@intel.com, corbet@lwn.net,
        catalin.marinas@arm.com, bigeasy@linutronix.de,
        fmdefrancesco@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-mm-prefer-kmap_local_page-and-avoid-kmap.patch added to mm-unstable branch
Message-Id: <20220728183549.A5CD3C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/mm: rrefer kmap_local_page() and avoid kmap()
has been added to the -mm mm-unstable branch.  Its filename is
     documentation-mm-prefer-kmap_local_page-and-avoid-kmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-mm-prefer-kmap_local_page-and-avoid-kmap.patch

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
Subject: Documentation/mm: rrefer kmap_local_page() and avoid kmap()
Date: Thu, 28 Jul 2022 17:48:42 +0200

The reasoning for converting kmap() to kmap_local_page() was questioned
recently.[1]

There are two main problems with kmap(): (1) It comes with an overhead as
mapping space is restricted and protected by a global lock for
synchronization and (2) kmap() also requires global TLB invalidation when
its pool wraps and it might block when the mapping space is fully utilized
until a slot becomes available.

Warn users to avoid the use of kmap() and instead use kmap_local_page(),
by designing their code to map pages in the same context the mapping will
be used.

[1] https://lore.kernel.org/lkml/1891319.taCxCBeP46@opensuse/

Link: https://lkml.kernel.org/r/20220728154844.10874-6-fmdefrancesco@gmail.com
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

 Documentation/mm/highmem.rst |    5 +++++
 1 file changed, 5 insertions(+)

--- a/Documentation/mm/highmem.rst~documentation-mm-prefer-kmap_local_page-and-avoid-kmap
+++ a/Documentation/mm/highmem.rst
@@ -84,6 +84,11 @@ list shows them in order of preference o
   be absolutely sure to keep the use of the return address local to the
   thread which mapped it.
 
+  Most code can be designed to use thread local mappings. User should
+  therefore try to design their code to avoid the use of kmap() by mapping
+  pages in the same thread the address will be used and prefer
+  kmap_local_page().
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

