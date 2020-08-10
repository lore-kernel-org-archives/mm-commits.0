Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DAA5C433DF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:35:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 376FD206C3
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026949;
	bh=n1I/esUU/w0wS6bkYmH2Har9fgJZGvt07isMKpJTyps=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=X6wDE12rx9sDSkY9vpQwevUwU3/Axz8FjjaFeiK31tYByduHZV455sL7trfIgWtoh
	 nifmQDWcHTBqTkZUY707prU1fc2Nt7zPpBfXvJgkk9eV8jeS3/PB8Vo0Rn3d5GjSpt
	 P9CXWOPWv5RiYT2OxGIPhWIj7SPdG6MYiL5pOdqg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgHJCfs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:35:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:39014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCfs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:35:48 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C4B72065D;
        Mon, 10 Aug 2020 02:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026948;
        bh=n1I/esUU/w0wS6bkYmH2Har9fgJZGvt07isMKpJTyps=;
        h=Date:From:To:Subject:From;
        b=jALHVR9WnT1ipMUjSY+2EClScfoBaX7pDM60l28ADAxzWGnL2hC63QFWLs9sqeatM
         q2wfuZJJrh2US6u6MC/ZuYcto4rwySq8bNv2jwOW9eXfGTaT5BXDORPMSKFJ6GMyIf
         n777+5MKomm0kALfhqfZ6tZuvGur55eaO3cDW1Cw=
Date:   Sun, 09 Aug 2020 19:35:47 -0700
From:   akpm@linux-foundation.org
To:     jhubbard@nvidia.com, kirill@shutemov.name,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com, vbabka@suse.cz,
        william.kucharski@oracle.com, willy@infradead.org
Subject:  [merged] mm-switch-dump_page-to-get_kernel_nofault.patch
 removed from -mm tree
Message-ID: <20200810023547.VF-X6Q2fo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug: switch dump_page to get_kernel_nofault
has been removed from the -mm tree.  Its filename was
     mm-switch-dump_page-to-get_kernel_nofault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/debug: switch dump_page to get_kernel_nofault

This is simpler to use than copy_from_kernel_nofault().  Also make some of
the related error messages less verbose.

Link: http://lkml.kernel.org/r/20200709202117.7216-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |   36 ++++++++++++++++--------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

--- a/mm/debug.c~mm-switch-dump_page-to-get_kernel_nofault
+++ a/mm/debug.c
@@ -115,54 +115,50 @@ void __dump_page(struct page *page, cons
 	else if (PageAnon(page))
 		type = "anon ";
 	else if (mapping) {
-		const struct inode *host;
+		struct inode *host;
 		const struct address_space_operations *a_ops;
-		const struct hlist_node *dentry_first;
-		const struct dentry *dentry_ptr;
+		struct hlist_node *dentry_first;
+		struct dentry *dentry_ptr;
 		struct dentry dentry;
 
 		/*
 		 * mapping can be invalid pointer and we don't want to crash
 		 * accessing it, so probe everything depending on it carefully
 		 */
-		if (copy_from_kernel_nofault(&host, &mapping->host,
-					sizeof(struct inode *)) ||
-		    copy_from_kernel_nofault(&a_ops, &mapping->a_ops,
-				sizeof(struct address_space_operations *))) {
-			pr_warn("failed to read mapping->host or a_ops, mapping not a valid kernel address?\n");
+		if (get_kernel_nofault(host, &mapping->host) ||
+		    get_kernel_nofault(a_ops, &mapping->a_ops)) {
+			pr_warn("failed to read mapping contents, not a valid kernel address?\n");
 			goto out_mapping;
 		}
 
 		if (!host) {
-			pr_warn("mapping->a_ops:%ps\n", a_ops);
+			pr_warn("aops:%ps\n", a_ops);
 			goto out_mapping;
 		}
 
-		if (copy_from_kernel_nofault(&dentry_first,
-			&host->i_dentry.first, sizeof(struct hlist_node *))) {
-			pr_warn("mapping->a_ops:%ps with invalid mapping->host inode address %px\n",
-				a_ops, host);
+		if (get_kernel_nofault(dentry_first, &host->i_dentry.first)) {
+			pr_warn("aops:%ps with invalid host inode %px\n",
+					a_ops, host);
 			goto out_mapping;
 		}
 
 		if (!dentry_first) {
-			pr_warn("mapping->a_ops:%ps\n", a_ops);
+			pr_warn("aops:%ps\n", a_ops);
 			goto out_mapping;
 		}
 
 		dentry_ptr = container_of(dentry_first, struct dentry, d_u.d_alias);
-		if (copy_from_kernel_nofault(&dentry, dentry_ptr,
-							sizeof(struct dentry))) {
-			pr_warn("mapping->aops:%ps with invalid mapping->host->i_dentry.first %px\n",
-				a_ops, dentry_ptr);
+		if (get_kernel_nofault(dentry, dentry_ptr)) {
+			pr_warn("aops:%ps with invalid dentry %px\n", a_ops,
+					dentry_ptr);
 		} else {
 			/*
 			 * if dentry is corrupted, the %pd handler may still
 			 * crash, but it's unlikely that we reach here with a
 			 * corrupted struct page
 			 */
-			pr_warn("mapping->aops:%ps dentry name:\"%pd\"\n",
-								a_ops, &dentry);
+			pr_warn("aops:%ps dentry name:\"%pd\"\n", a_ops,
+					&dentry);
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

