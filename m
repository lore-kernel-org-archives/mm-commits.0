Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CE2CC433EF
	for <mm-commits@archiver.kernel.org>; Sat, 12 Feb 2022 00:21:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbiBLAVO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Feb 2022 19:21:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349149AbiBLAVN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Feb 2022 19:21:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E61D7C
        for <mm-commits@vger.kernel.org>; Fri, 11 Feb 2022 16:21:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38E3CB82DED
        for <mm-commits@vger.kernel.org>; Sat, 12 Feb 2022 00:21:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6BD1C340E9;
        Sat, 12 Feb 2022 00:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644625269;
        bh=0Nmp0WceBHtA1Blkh3/+lKZ8rSClyr/L6jFYBciq4mY=;
        h=Date:To:From:Subject:From;
        b=gPldN3JMUPmD01wWb3fqHCQnFQpWz0H7xugppDQncC7Aa4SgrzOKiaHA2l+uSVImx
         JL285PX9NK+l+ed4Ww6HeNL421PFtECPBqmLeXPb34e+vAu/nssrE3jOc5L7bgAXHy
         8IsobpCTfhInsxtNji70FQTDEvbSKkBLz/FvSbFc=
Date:   Fri, 11 Feb 2022 16:21:08 -0800
To:     mm-commits@vger.kernel.org, adobriyan@gmail.com, nathan@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] proc-avoid-unused-variable-warning-in-pagemap_pmd_range.patch removed from -mm tree
Message-Id: <20220212002108.E6BD1C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: avoid unused variable warning in pagemap_pmd_range()
has been removed from the -mm tree.  Its filename was
     proc-avoid-unused-variable-warning-in-pagemap_pmd_range.patch

This patch was dropped because it was folded into fs-proc-task_mmuc-dont-read-mapcount-for-migration-entry.patch

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: proc: avoid unused variable warning in pagemap_pmd_range()

When building with CONFIG_TRANSPARENT_HUGEPAGE=n, there is a warning about
migration being unused:

  fs/proc/task_mmu.c:1444:7: warning: unused variable 'migration' [-Wunused-variable]
          bool migration = false;
               ^
  1 warning generated.

Move the ifdef preprocessor directive up to include migration so it is
only included in the file when it is used.

Link: https://lkml.kernel.org/r/20220207171049.1102239-1-nathan@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/proc/task_mmu.c~proc-avoid-unused-variable-warning-in-pagemap_pmd_range
+++ a/fs/proc/task_mmu.c
@@ -1441,9 +1441,9 @@ static int pagemap_pmd_range(pmd_t *pmdp
 	spinlock_t *ptl;
 	pte_t *pte, *orig_pte;
 	int err = 0;
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	bool migration = false;
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	ptl = pmd_trans_huge_lock(pmdp, vma);
 	if (ptl) {
 		u64 flags = 0, frame = 0;
_

Patches currently in -mm which might be from nathan@kernel.org are

fs-proc-task_mmuc-dont-read-mapcount-for-migration-entry.patch

