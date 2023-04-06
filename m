Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3492C761A6
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:53:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234998AbjDFCxc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234978AbjDFCxS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:53:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B56DB2
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:52:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13F3F638AB
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:52:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 693BEC433D2;
        Thu,  6 Apr 2023 02:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749576;
        bh=3okeXXjqSw3eX3XENHoUe9no9Ap8dw/8mKhOMcDdoEE=;
        h=Date:To:From:Subject:From;
        b=MWmNCRbH/tGqxSQe5svH6xXgHQs+5h7XRigRLzewgKAxVVJ7IAtgs2Kd6As4Dm5na
         Wked9WpZ3pCxviA2kL/g73lNpzQv0DVzlwGwWNcJpQkkpZSQ9Kw4qvlV8/DmO+Tj2M
         vWKKcD8MBa8U/qp5CXXTxrkQqxg/2AB8R4Nh7oo8=
Date:   Wed, 05 Apr 2023 19:52:55 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, rdunlap@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ia64-mm-contig-fix-section-mismatch-warning-error.patch removed from -mm tree
Message-Id: <20230406025256.693BEC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ia64: mm/contig: fix section mismatch warning/error
has been removed from the -mm tree.  Its filename was
     ia64-mm-contig-fix-section-mismatch-warning-error.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: ia64: mm/contig: fix section mismatch warning/error
Date: Wed, 22 Feb 2023 19:42:58 -0800

alloc_per_cpu_data() is called by find_memory(), which is marked as
__init.  Therefore alloc_per_cpu_data() can also be marked as __init to
remedy this modpost problem.

WARNING: modpost: vmlinux.o: section mismatch in reference: alloc_per_cpu_data (section: .text) -> memblock_alloc_try_nid (section: .init.text)

Link: https://lkml.kernel.org/r/20230223034258.12917-1-rdunlap@infradead.org
Fixes: 4b9ddc7cf272 ("[IA64] Fix section mismatch in contig.c version of per_cpu_init()")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/contig.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/ia64/mm/contig.c~ia64-mm-contig-fix-section-mismatch-warning-error
+++ a/arch/ia64/mm/contig.c
@@ -77,7 +77,7 @@ skip:
 	return __per_cpu_start + __per_cpu_offset[smp_processor_id()];
 }
 
-static inline void
+static inline __init void
 alloc_per_cpu_data(void)
 {
 	size_t size = PERCPU_PAGE_SIZE * num_possible_cpus();
_

Patches currently in -mm which might be from rdunlap@infradead.org are


