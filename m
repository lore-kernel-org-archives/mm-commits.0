Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00996C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:56:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C0BA22250
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602708967;
	bh=f2/YhwG/m8L+RX6+S1M5Wm1tz4mrPxFSoBaGzgpde0M=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=10JFDiG/fsVJSBEthA/ZEBDODQPUF+uaWOGtYBz1q4MJM9JmifsKJShFt81zGh7Dw
	 0NcejBbULWTe9aRa7r94SdgfwHdy3yBYoE/sGyx8UIlhlOUb67FAjvFn2psVQp7j/z
	 ydx12UI7N2sgax3NCytgQcgAMcqkHUoLPGkz4J6o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730412AbgJNU4H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:56:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:46464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727788AbgJNU4H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:56:07 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A18D122253;
        Wed, 14 Oct 2020 20:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602708965;
        bh=f2/YhwG/m8L+RX6+S1M5Wm1tz4mrPxFSoBaGzgpde0M=;
        h=Date:From:To:Subject:From;
        b=LvihehGMWsKAbweuwTvthjYGW6lEqJobVQgcyaD1x+27xxeRwM6TfLXLEZycJ1QLU
         +ewcMVgLAB+0f7PHusW/aID8R9JlWkpFUMR5s6d9dom1IgY2EgqkeuRhaUDDTqaQeT
         Lxto5ZjMp5Wer5GugqZmTjbctJt1RYD8xo/POX/E=
Date:   Wed, 14 Oct 2020 13:56:04 -0700
From:   akpm@linux-foundation.org
To:     jlbec@evilplan.org, joseph.qi@linux.alibaba.com, mark@fasheh.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  [merged] fs-ocfs2-delete-repeated-words-in-comments.patch
 removed from -mm tree
Message-ID: <20201014205604.vHmRzV9Sj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: delete repeated words in comments
has been removed from the -mm tree.  Its filename was
     fs-ocfs2-delete-repeated-words-in-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: ocfs2: delete repeated words in comments

Drop duplicated words {the, and} in comments.

Link: https://lkml.kernel.org/r/20200811021845.25134-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c      |    2 +-
 fs/ocfs2/localalloc.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/alloc.c~fs-ocfs2-delete-repeated-words-in-comments
+++ a/fs/ocfs2/alloc.c
@@ -6013,7 +6013,7 @@ int __ocfs2_flush_truncate_log(struct oc
 		goto out;
 	}
 
-	/* Appending truncate log(TA) and and flushing truncate log(TF) are
+	/* Appending truncate log(TA) and flushing truncate log(TF) are
 	 * two separated transactions. They can be both committed but not
 	 * checkpointed. If crash occurs then, both two transaction will be
 	 * replayed with several already released to global bitmap clusters.
--- a/fs/ocfs2/localalloc.c~fs-ocfs2-delete-repeated-words-in-comments
+++ a/fs/ocfs2/localalloc.c
@@ -677,7 +677,7 @@ int ocfs2_reserve_local_alloc_bits(struc
 		/*
 		 * Under certain conditions, the window slide code
 		 * might have reduced the number of bits available or
-		 * disabled the the local alloc entirely. Re-check
+		 * disabled the local alloc entirely. Re-check
 		 * here and return -ENOSPC if necessary.
 		 */
 		status = -ENOSPC;
_

Patches currently in -mm which might be from rdunlap@infradead.org are

fs-configfs-delete-repeated-words-in-comments.patch
kernel-fix-repeated-words-in-comments.patch
kernel-acctc-fix-some-kernel-doc-nits.patch
lib-bitmap-delete-duplicated-words.patch
lib-libcrc32c-delete-duplicated-words.patch
lib-decompress_bunzip2-delete-duplicated-words.patch
lib-devres-delete-duplicated-words.patch
lib-dynamic_queue_limits-delete-duplicated-words-fix-typo.patch
lib-earlycpio-delete-duplicated-words.patch
lib-radix-tree-delete-duplicated-words.patch
lib-syscall-delete-duplicated-words.patch
lib-test_sysctl-delete-duplicated-words.patch
lib-mpi-fix-spello-of-functions.patch

