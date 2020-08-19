Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CB22C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 19:01:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79E6E2083B
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 19:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597863691;
	bh=LwbxeHl+wjva9jIxBfoWkRR9gE2tBqW2qMbx3jlS3cY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=iD5oZIQUoQbBlZ3z7jZ8YmckAV7Yzfa+Mew5SV5KmudAkUOlwursQOfzGaGQYbcUB
	 IDgVuH4tAIFlITnKJ0NcXL/OsAKVim1/pd0GPOvKgrOPheQKd/o4dZkAgAbgVHQrWI
	 Cy0kAf9edHI9xEPC+mfvo8TelYrC2+I62bcVPIjw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbgHSTBa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Aug 2020 15:01:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:53420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbgHSTBa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Aug 2020 15:01:30 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB561207DA;
        Wed, 19 Aug 2020 19:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597863689;
        bh=LwbxeHl+wjva9jIxBfoWkRR9gE2tBqW2qMbx3jlS3cY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=aXapT8xQOjvsga0DzCYKlm7nSFAFYY/uHWcn1cGb6f0Xkol4YOuk2byToAL8jyT+l
         fWjeg6/nAEozVU959ypim7T3m6W8wFehs4l+Nu5RY8xGaVyZZfXJaMJo6fkVXc3UpU
         lqH5W21t8vQQRkslR5Jzb2uSaZ8/ap4v/P4vmj4Y=
Date:   Wed, 19 Aug 2020 12:01:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     jhubbard@nvidia.com, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com, vbabka@suse.cz, willy@infradead.org
Subject:  + mm-debug-do-not-dereference-i_ino-blindly.patch added
 to -mm tree
Message-ID: <20200819190128.KNK20LkWZ%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug.c: do not dereference i_ino blindly
has been added to the -mm tree.  Its filename is
     mm-debug-do-not-dereference-i_ino-blindly.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-debug-do-not-dereference-i_ino-blindly.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-debug-do-not-dereference-i_ino-blindly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
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

Patches currently in -mm which might be from willy@infradead.org are

mm-debug-do-not-dereference-i_ino-blindly.patch
mm-account-pmd-tables-like-pte-tables.patch

