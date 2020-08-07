Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 336F6C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:19:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15EB62177B
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781184;
	bh=7QtTJ3FPkWRiiCZlJHLjLumqsLmAtsFK+JAWD/dAsXE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=EVQ6CttJzTYxTheH7922hn2GEd8P1idy+WWhY479KjOkuCjquwIgwwX1/H2va6f2c
	 KgnnWtgrBQsUL0TAkD9WjwROijxpRYQYVSq2Y0pfybCoxHIygJxMqSj8/yRlQWiEkH
	 cESFmuRPT+mUalBelGIl27qYJS65eeC5TcKGw7Ds=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbgHGGTn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:19:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGTn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:19:43 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB518221E5;
        Fri,  7 Aug 2020 06:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781183;
        bh=7QtTJ3FPkWRiiCZlJHLjLumqsLmAtsFK+JAWD/dAsXE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=OV2wbO+3Xctd4TWvlscu5Vg0/Ysevl1jQb1nI5V/FNontVotj5j5tNhcLm8MUWzaQ
         zjTRJs7aL0De4V1KL62xN/+PS9+1Xkm+6iJ6NIoFUHxakEN6KyJLUX9HxDeRThzySn
         0bCuuUfHZWyW4P6Rej4tbCfiFAn/unSErQHYOPlo=
Date:   Thu, 06 Aug 2020 23:19:42 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jhubbard@nvidia.com,
        kirill@shutemov.name, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        william.kucharski@oracle.com, willy@infradead.org
Subject:  [patch 047/163] mm/debug: switch dump_page to
 get_kernel_nofault
Message-ID: <20200807061942.vp2ZT_bvM%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
