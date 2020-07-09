From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-switch-dump_page-to-get_kernel_nofault.patch added
 to -mm tree
Date: Thu, 09 Jul 2020 16:09:27 -0700
Message-ID: <20200709230927.clO9-o5ne%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726222AbgGIXJ2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Jul 2020 19:09:28 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jhubbard@nvidia.com, kirill@shutemov.name, mm-commits@vger.kernel.org, rppt@linux.ibm.com, vbabka@suse.cz, william.kucharski@oracle.com, willy@infradead.org


The patch titled
     Subject: mm/debug: switch dump_page to get_kernel_nofault
has been added to the -mm tree.  Its filename is
     mm-switch-dump_page-to-get_kernel_nofault.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-switch-dump_page-to-get_kernel_nofault.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-switch-dump_page-to-get_kernel_nofault.patch

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
Subject: mm/debug: switch dump_page to get_kernel_nofault

This is simpler to use than copy_from_kernel_nofault().  Also make some of
the related error messages less verbose.

Link: http://lkml.kernel.org/r/20200709202117.7216-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |   36 ++++++++++++++++--------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

--- a/mm/debug.c~mm-switch-dump_page-to-get_kernel_nofault
+++ a/mm/debug.c
@@ -109,54 +109,50 @@ void __dump_page(struct page *page, cons
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

mm-handle-page-mapping-better-in-dump_page.patch
mm-dump-compound-page-information-on-a-second-line.patch
mm-print-head-flags-in-dump_page.patch
mm-switch-dump_page-to-get_kernel_nofault.patch
mm-print-the-inode-number-in-dump_page.patch
mm-print-hashed-address-of-struct-page.patch
vmalloc-convert-to-xarray.patch
mm-store-compound_nr-as-well-as-compound_order.patch
mm-move-page-flags-include-to-top-of-file.patch
mm-add-thp_order.patch
mm-add-thp_size.patch
mm-replace-hpage_nr_pages-with-thp_nr_pages.patch
mm-add-thp_head.patch
mm-introduce-offset_in_thp.patch
