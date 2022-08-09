Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61A3DC00140
	for <mm-commits@archiver.kernel.org>; Tue,  9 Aug 2022 01:15:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244868AbiHIBPl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Aug 2022 21:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239691AbiHIBPK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 Aug 2022 21:15:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178A01E3C4
        for <mm-commits@vger.kernel.org>; Mon,  8 Aug 2022 18:14:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFD0CB81116
        for <mm-commits@vger.kernel.org>; Tue,  9 Aug 2022 01:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C61C433D7;
        Tue,  9 Aug 2022 01:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660007679;
        bh=YwD0J03t6WQn4hVjeHMsaoky2nBBt8UOgX58PEBI5NE=;
        h=Date:To:From:Subject:From;
        b=trvIqLIyvw4PtLvBVTsMUs/eS0LDpTGcNs2CIzSwLorF9Z5jQw9HXMoHGP94AjG1M
         jsXpCJA70DXbssnrhzlLKfDCOhNlqzQ0T0ySUEsWkreYeBzFZ8Tbg5OvlERYnnA/VH
         aRX+cGaEvCgRYQMfAdv+FZhWxIn6izXXRZisMiGY=
Date:   Mon, 08 Aug 2022 18:14:38 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        vbabka@suse.cz, tglx@linutronix.de, rppt@linux.ibm.com,
        pcc@google.com, ira.weiny@intel.com, corbet@lwn.net,
        catalin.marinas@arm.com, bigeasy@linutronix.de,
        fmdefrancesco@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] documentation-mm-avoid-invalid-use-of-addresses-from-kmap_local_page.patch removed from -mm tree
Message-Id: <20220809011439.83C61C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Documentation/mm: avoid invalid use of addresses from kmap_local_page()
has been removed from the -mm tree.  Its filename was
     documentation-mm-avoid-invalid-use-of-addresses-from-kmap_local_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


