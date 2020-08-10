Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07D63C433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:35:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC00E206C3
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026951;
	bh=3ZloiBBZh7di3Mtb/vIbSpe/VJaiwSLJq+ah9eVi4T8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=oDcNuYC6RN5Do9Zt7bRKh3R7C/ZUZO6vmoyLIPxBZiNtKt12qN3sOEjqFtGPXPg19
	 bU4C/+PZilO0eTmJgu3RzZDogyl47uzIYOiv17SiH4IeZy+iNmarRC2IKVJCL6mg5O
	 1fR2Bxhmy7Fi5iMPppWJOu1aqS1gTDbomR32jKHU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgHJCfv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:35:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCfv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:35:51 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 931D72065D;
        Mon, 10 Aug 2020 02:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026950;
        bh=3ZloiBBZh7di3Mtb/vIbSpe/VJaiwSLJq+ah9eVi4T8=;
        h=Date:From:To:Subject:From;
        b=WOQk5M065IC4VZIm9zCXOWgF9L6ieDGWZ8kZ3oaGmUU6WDdx98ZzMzl3ZJX/iHL3K
         KV4rWQco/RR+PW1mwqe1vI1hKPBE/LRFthP9M2RnqasPwVXXd8RZHIEbj2qlSJ/ACz
         0/lcPfBWjZhKWwjzSthMyYiLKxK+5HlCkrJKCZA8=
Date:   Sun, 09 Aug 2020 19:35:50 -0700
From:   akpm@linux-foundation.org
To:     jhubbard@nvidia.com, kirill@shutemov.name,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com, vbabka@suse.cz,
        william.kucharski@oracle.com, willy@infradead.org
Subject:  [merged] mm-print-the-inode-number-in-dump_page.patch
 removed from -mm tree
Message-ID: <20200810023550.w2QgkH241%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug: print the inode number in dump_page
has been removed from the -mm tree.  Its filename was
     mm-print-the-inode-number-in-dump_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/debug: print the inode number in dump_page

The inode number helps correlate this page with debug messages elsewhere
in the kernel.

Link: http://lkml.kernel.org/r/20200709202117.7216-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/debug.c~mm-print-the-inode-number-in-dump_page
+++ a/mm/debug.c
@@ -143,7 +143,7 @@ void __dump_page(struct page *page, cons
 		}
 
 		if (!dentry_first) {
-			pr_warn("aops:%ps\n", a_ops);
+			pr_warn("aops:%ps ino:%lx\n", a_ops, host->i_ino);
 			goto out_mapping;
 		}
 
@@ -157,8 +157,8 @@ void __dump_page(struct page *page, cons
 			 * crash, but it's unlikely that we reach here with a
 			 * corrupted struct page
 			 */
-			pr_warn("aops:%ps dentry name:\"%pd\"\n", a_ops,
-					&dentry);
+			pr_warn("aops:%ps ino:%lx dentry name:\"%pd\"\n",
+					a_ops, host->i_ino, &dentry);
 		}
 	}
 out_mapping:
_

Patches currently in -mm which might be from willy@infradead.org are

mm-store-compound_nr-as-well-as-compound_order.patch
mm-move-page-flags-include-to-top-of-file.patch
mm-add-thp_order.patch
mm-add-thp_size.patch
mm-replace-hpage_nr_pages-with-thp_nr_pages.patch
mm-add-thp_head.patch
mm-introduce-offset_in_thp.patch
poison-remove-obsolete-comment.patch

