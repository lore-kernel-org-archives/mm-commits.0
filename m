Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90095C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:35:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AB87611C9
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:35:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232974AbhKKCht (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:37:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:46284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232646AbhKKCht (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:37:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E965161208;
        Thu, 11 Nov 2021 02:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598101;
        bh=lMGUbvmZKJOS7GxYdfAFr6B5T0ZFj03oMnS+9pPsGto=;
        h=Date:From:To:Subject:From;
        b=NbbexBZFzBsOz0OcDCHUkQgrB4eKsHWJeKb9fE+YglrOfxN9G1k0ll9zFsSiZh4OY
         HtbuxbwBXRU3wHS8GK2VR0hg23O8dQ0cUdCNG5YXFN947y+n1o8xVcf7CU4FnCBB7e
         mZB0N8M9Z2ZM2HpsoniAdxWjBZwXYvMSaqKzhVE4=
Date:   Wed, 10 Nov 2021 18:35:00 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        shy828301@gmail.com, willy@infradead.org
Subject:  [obsolete]
 =?US-ASCII?Q?mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-pa?=
 =?US-ASCII?Q?ge-fault-vs-folios.patch?= removed from -mm tree
Message-ID: <20211111023500.zzZADfsIw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault-vs-folios
has been removed from the -mm tree.  Its filename was
     mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault-vs-folios.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault-vs-folios

fix
mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault.patch
for folio tree PAGEFLAG_FALSE() change.

Cc: Yang Shi <shy828301@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/page-flags.h~mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault-vs-folios
+++ a/include/linux/page-flags.h
@@ -803,8 +803,8 @@ PAGEFLAG_FALSE(DoubleMap, double_map)
 PAGEFLAG(HasHWPoisoned, has_hwpoisoned, PF_SECOND)
 	TESTSCFLAG(HasHWPoisoned, has_hwpoisoned, PF_SECOND)
 #else
-PAGEFLAG_FALSE(HasHWPoisoned)
-	TESTSCFLAG_FALSE(HasHWPoisoned)
+PAGEFLAG_FALSE(HasHWPoisoned, has_hwpoisoned)
+	TESTSCFLAG_FALSE(HasHWPoisoned, has_hwpoisoned)
 #endif
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-test-use-underlying-string-helpers-checkpatch-fixes.patch
mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-page_ownerc-modify-the-type-of-argument-order-in-some-functions-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

