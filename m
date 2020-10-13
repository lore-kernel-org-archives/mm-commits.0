Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 910B6C433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:48:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52D0621D7B
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602632904;
	bh=nujDB+hiUyMiWsHntQziYxMmM4juCjPaiz0u6eIrSig=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=craiXkJQTkJxETGAOAuVLP1rFVq58R0/QaDdV6h63/HixFD2IvX8KiGIZqtHNXTE1
	 sUckmF+9o6JyWzOSkJJUtw78JN0czC0ouSRs9xP7LOYuoWhbS2EfdWfSVfjDPiWNtM
	 ITUEtJmTPwEuZinyiyIMc7brZcjtbCEZguthes9E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389160AbgJMXsY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:48:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:59724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389017AbgJMXsW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:48:22 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDEA621D7A;
        Tue, 13 Oct 2020 23:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602632902;
        bh=nujDB+hiUyMiWsHntQziYxMmM4juCjPaiz0u6eIrSig=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=fKzIzf50uEnKP3G6TC9B6QMENuXOEE8gdZBCRBw6lSUjvoOaUP/SO7lW6JHZi1Tps
         J/VfDLbgxrKBQV668WYoxokiDokUroq20kR3nsa8FjlzK1nREePAqfcOqeTRMPI9tV
         g8egRgGLK7kSjFZ2K931S53PfK6FbCl6Nmz9M/yM=
Date:   Tue, 13 Oct 2020 16:48:21 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, linux-mm@kvack.org, mark@fasheh.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org
Subject:  [patch 015/181] ocfs2: delete repeated words in comments
Message-ID: <20201013234821.17oFfOLFb%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
