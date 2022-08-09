Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89325C00140
	for <mm-commits@archiver.kernel.org>; Tue,  9 Aug 2022 01:15:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244816AbiHIBP0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Aug 2022 21:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244817AbiHIBOw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 Aug 2022 21:14:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 438A618362
        for <mm-commits@vger.kernel.org>; Mon,  8 Aug 2022 18:14:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8BAA6116C
        for <mm-commits@vger.kernel.org>; Tue,  9 Aug 2022 01:14:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AAB9C433D6;
        Tue,  9 Aug 2022 01:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660007677;
        bh=GN0deJjazFRG2b3wpaZEwGOpFntUbQ2UgSkNE3POlrw=;
        h=Date:To:From:Subject:From;
        b=iGHGHjAF6dtaErJ/K46VVBuvcw9+DpN9LRXmyjnuYvENQF+5Hg5W8QUZn2hvAEdH0
         J+R7p2HRXGUQo6c+PmBUxDJgHsRSNzHu6hhLVcgGZfdaWKR8rUkIne/YytgbA4lV8F
         AOdKMiKt+CU4wbhXd+DOr/LTinwQfsXaSMEO2pAs=
Date:   Mon, 08 Aug 2022 18:14:36 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, will@kernel.org,
        vbabka@suse.cz, tglx@linutronix.de, rppt@linux.ibm.com,
        pcc@google.com, ira.weiny@intel.com, corbet@lwn.net,
        catalin.marinas@arm.com, bigeasy@linutronix.de,
        fmdefrancesco@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] highmem-specify-that-kmap_local_page-is-callable-from-interrupts.patch removed from -mm tree
Message-Id: <20220809011437.3AAB9C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: highmem: specify that kmap_local_page() is callable from interrupts
has been removed from the -mm tree.  Its filename was
     highmem-specify-that-kmap_local_page-is-callable-from-interrupts.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


