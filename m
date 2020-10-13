Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB413C43467
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:51:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FA9E22227
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633080;
	bh=14h5JVSX5S20cCgYTwBecA2dIRGDsgHKElMk4lApZH8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=TxX7SQOeKGRGZpGPC3Oh159o1719kM0TtHYHu08ZFr3FSmKt2cNLQwr+5siny7SvT
	 LuLzKQdjEKAvZUGrEYBv9XgMiNKsKZrU+5TG6vDU54czHvIhH/Ppff6+OOVYYkoDsJ
	 hLzUEENoVDENzAfP624sJCdz86uMRgv15ax7p/Lc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730409AbgJMXvU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:51:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730402AbgJMXvM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:51:12 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 312EE22201;
        Tue, 13 Oct 2020 23:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633072;
        bh=14h5JVSX5S20cCgYTwBecA2dIRGDsgHKElMk4lApZH8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=fVnhFks4Hp9360oFLyMM6jyylrMNHBq48ZArzu0Nnx8UB8csLS+yCHPsLnmwU/O5I
         1PZWq8Aq5mhOM62B6bya/mArZczRmmG7mCXXYqRej8+DqH0TN55RweC+Rj0A5bE/No
         FWZfmhnE2mGETe5M5Yr352oFqFWMWXgQMpwo0Fqc=
Date:   Tue, 13 Oct 2020 16:51:10 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jhubbard@nvidia.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org
Subject:  [patch 052/181] mm/debug.c: do not dereference i_ino
 blindly
Message-ID: <20201013235110.NHDW__01-%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/debug.c: do not dereference i_ino blindly

__dump_page() checks i_dentry is fetchable and i_ino is earlier in the
struct than i_ino, so it ought to work fine, but it's possible that struct
randomisation has reordered i_ino after i_dentry and the pointer is just
wild enough that i_dentry is fetchable and i_ino isn't.

Also print the inode number if the dentry is invalid.

Link: https://lkml.kernel.org/r/20200819185710.28180-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/mm/debug.c~mm-debug-do-not-dereference-i_ino-blindly
+++ a/mm/debug.c
@@ -120,6 +120,7 @@ void __dump_page(struct page *page, cons
 		struct hlist_node *dentry_first;
 		struct dentry *dentry_ptr;
 		struct dentry dentry;
+		unsigned long ino;
 
 		/*
 		 * mapping can be invalid pointer and we don't want to crash
@@ -136,21 +137,22 @@ void __dump_page(struct page *page, cons
 			goto out_mapping;
 		}
 
-		if (get_kernel_nofault(dentry_first, &host->i_dentry.first)) {
+		if (get_kernel_nofault(dentry_first, &host->i_dentry.first) ||
+		    get_kernel_nofault(ino, &host->i_ino)) {
 			pr_warn("aops:%ps with invalid host inode %px\n",
 					a_ops, host);
 			goto out_mapping;
 		}
 
 		if (!dentry_first) {
-			pr_warn("aops:%ps ino:%lx\n", a_ops, host->i_ino);
+			pr_warn("aops:%ps ino:%lx\n", a_ops, ino);
 			goto out_mapping;
 		}
 
 		dentry_ptr = container_of(dentry_first, struct dentry, d_u.d_alias);
 		if (get_kernel_nofault(dentry, dentry_ptr)) {
-			pr_warn("aops:%ps with invalid dentry %px\n", a_ops,
-					dentry_ptr);
+			pr_warn("aops:%ps ino:%lx with invalid dentry %px\n",
+					a_ops, ino, dentry_ptr);
 		} else {
 			/*
 			 * if dentry is corrupted, the %pd handler may still
@@ -158,7 +160,7 @@ void __dump_page(struct page *page, cons
 			 * corrupted struct page
 			 */
 			pr_warn("aops:%ps ino:%lx dentry name:\"%pd\"\n",
-					a_ops, host->i_ino, &dentry);
+					a_ops, ino, &dentry);
 		}
 	}
 out_mapping:
_
