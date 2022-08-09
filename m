Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23300C25B08
	for <mm-commits@archiver.kernel.org>; Tue,  9 Aug 2022 01:15:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244851AbiHIBP1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Aug 2022 21:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244805AbiHIBOy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 Aug 2022 21:14:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B351E3C7
        for <mm-commits@vger.kernel.org>; Mon,  8 Aug 2022 18:14:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06CDA6116D
        for <mm-commits@vger.kernel.org>; Tue,  9 Aug 2022 01:14:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 605FCC433C1;
        Tue,  9 Aug 2022 01:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660007678;
        bh=b69ZLT5/USuR4T45gyxmw/+KcX+6QbzyuP+K1JkvLbs=;
        h=Date:To:From:Subject:From;
        b=wV5UqWA8VE7IhwE/+IzQv2qsleYLafCjwudBa4X1BBRiXpumg7hPrp1KNOnrT63W0
         +U6pQlmJi0pumWvH1mebKBmFR1QYWfYPbw0WVzTL1PnRrGBaeyPv3IbWqwfIhTnNnP
         /C87zDO6jWvpGh6bL3gsoCuim41UN9aZjV0wPXCE=
Date:   Mon, 08 Aug 2022 18:14:37 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        vbabka@suse.cz, tglx@linutronix.de, rppt@linux.ibm.com,
        pcc@google.com, ira.weiny@intel.com, corbet@lwn.net,
        catalin.marinas@arm.com, bigeasy@linutronix.de,
        fmdefrancesco@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] documentation-mm-dont-kmap-pages-which-cant-come-from-highmem.patch removed from -mm tree
Message-Id: <20220809011438.605FCC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Documentation/mm: don't kmap*() pages which can't come from HIGHMEM
has been removed from the -mm tree.  Its filename was
     documentation-mm-dont-kmap-pages-which-cant-come-from-highmem.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Subject: Documentation/mm: don't kmap*() pages which can't come from HIGHMEM
Date: Thu, 28 Jul 2022 17:48:40 +0200

There is no need to kmap*() pages which are guaranteed to come from
ZONE_NORMAL (or lower).  Linux has currently several call sites of
kmap{,_atomic,_local_page}() on pages which are clearly known which can't
come from ZONE_HIGHMEM.

Therefore, add a paragraph to highmem.rst, to explain better that a plain
page_address() may be used for getting the address of pages which cannot
come from ZONE_HIGHMEM, although it is always safe to use
kmap_local_page() / kunmap_local() also on those pages.

Link: https://lkml.kernel.org/r/20220728154844.10874-4-fmdefrancesco@gmail.com
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

 Documentation/mm/highmem.rst |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/Documentation/mm/highmem.rst~documentation-mm-dont-kmap-pages-which-cant-come-from-highmem
+++ a/Documentation/mm/highmem.rst
@@ -71,6 +71,12 @@ list shows them in order of preference o
   kmap_local_page() always returns a valid virtual address and it is assumed
   that kunmap_local() will never fail.
 
+  On CONFIG_HIGHMEM=n kernels and for low memory pages this returns the
+  virtual address of the direct mapping. Only real highmem pages are
+  temporarily mapped. Therefore, users may call a plain page_address()
+  for pages which are known to not come from ZONE_HIGHMEM. However, it is
+  always safe to use kmap_local_page() / kunmap_local().
+
   Nesting kmap_local_page() and kmap_atomic() mappings is allowed to a certain
   extent (up to KMAP_TYPE_NR) but their invocations have to be strictly ordered
   because the map implementation is stack based. See kmap_local_page() kdocs
_

Patches currently in -mm which might be from fmdefrancesco@gmail.com are


