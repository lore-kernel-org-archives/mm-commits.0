Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBEE5C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:24:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377817AbiATVYh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:24:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377844AbiATVYe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:24:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B463BC061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:24:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52D2F60B08
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:24:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891C3C340E0;
        Thu, 20 Jan 2022 21:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713873;
        bh=rlwI+HynvESo/ASfAzaMjjNqmULRVy2fLtvTD+Cs+z4=;
        h=Date:From:To:Subject:From;
        b=n9WhGmxv8mbyPJ05qbsZY4LjMMNu6C/vma9rKIH+Xp+0fw48qetNWN5p7n53GUj/6
         8oLiXlWUCIz+lGX69rY6vVrklYr78wppNSQcpibEO6gEmschx/AQJI7iYecc4BbJVz
         thOPwsv9/K2PT6F7EBOiyp6W7I1LpNctVeOqxPms=
Date:   Thu, 20 Jan 2022 13:24:33 -0800
From:   akpm@linux-foundation.org
To:     mhocko@suse.com, mm-commits@vger.kernel.org, vbabka@suse.cz,
        william.kucharski@oracle.com, willy@infradead.org
Subject:  [merged] mmfs-split-dump_mapping-out-from-dump_page.patch
 removed from -mm tree
Message-ID: <20220120212433.1b81CDv6v%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,fs: split dump_mapping() out from dump_page()
has been removed from the -mm tree.  Its filename was
     mmfs-split-dump_mapping-out-from-dump_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm,fs: split dump_mapping() out from dump_page()

dump_mapping() is a big chunk of dump_page(), and it'd be handy to be able
to call it when we don't have a struct page.  Split it out and move it to
fs/inode.c.  Take the opportunity to simplify some of the debug messages a
little.

Link: https://lkml.kernel.org/r/20211121121056.2870061-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c         |   49 ++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h |    1 
 mm/debug.c         |   52 +------------------------------------------
 3 files changed, 52 insertions(+), 50 deletions(-)

--- a/fs/inode.c~mmfs-split-dump_mapping-out-from-dump_page
+++ a/fs/inode.c
@@ -526,6 +526,55 @@ void __remove_inode_hash(struct inode *i
 }
 EXPORT_SYMBOL(__remove_inode_hash);
 
+void dump_mapping(const struct address_space *mapping)
+{
+	struct inode *host;
+	const struct address_space_operations *a_ops;
+	struct hlist_node *dentry_first;
+	struct dentry *dentry_ptr;
+	struct dentry dentry;
+	unsigned long ino;
+
+	/*
+	 * If mapping is an invalid pointer, we don't want to crash
+	 * accessing it, so probe everything depending on it carefully.
+	 */
+	if (get_kernel_nofault(host, &mapping->host) ||
+	    get_kernel_nofault(a_ops, &mapping->a_ops)) {
+		pr_warn("invalid mapping:%px\n", mapping);
+		return;
+	}
+
+	if (!host) {
+		pr_warn("aops:%ps\n", a_ops);
+		return;
+	}
+
+	if (get_kernel_nofault(dentry_first, &host->i_dentry.first) ||
+	    get_kernel_nofault(ino, &host->i_ino)) {
+		pr_warn("aops:%ps invalid inode:%px\n", a_ops, host);
+		return;
+	}
+
+	if (!dentry_first) {
+		pr_warn("aops:%ps ino:%lx\n", a_ops, ino);
+		return;
+	}
+
+	dentry_ptr = container_of(dentry_first, struct dentry, d_u.d_alias);
+	if (get_kernel_nofault(dentry, dentry_ptr)) {
+		pr_warn("aops:%ps ino:%lx invalid dentry:%px\n",
+				a_ops, ino, dentry_ptr);
+		return;
+	}
+
+	/*
+	 * if dentry is corrupted, the %pd handler may still crash,
+	 * but it's unlikely that we reach here with a corrupt mapping
+	 */
+	pr_warn("aops:%ps ino:%lx dentry name:\"%pd\"\n", a_ops, ino, &dentry);
+}
+
 void clear_inode(struct inode *inode)
 {
 	/*
--- a/include/linux/fs.h~mmfs-split-dump_mapping-out-from-dump_page
+++ a/include/linux/fs.h
@@ -3152,6 +3152,7 @@ extern void unlock_new_inode(struct inod
 extern void discard_new_inode(struct inode *);
 extern unsigned int get_next_ino(void);
 extern void evict_inodes(struct super_block *sb);
+void dump_mapping(const struct address_space *);
 
 /*
  * Userspace may rely on the the inode number being non-zero. For example, glibc
--- a/mm/debug.c~mmfs-split-dump_mapping-out-from-dump_page
+++ a/mm/debug.c
@@ -112,56 +112,8 @@ static void __dump_page(struct page *pag
 		type = "ksm ";
 	else if (PageAnon(page))
 		type = "anon ";
-	else if (mapping) {
-		struct inode *host;
-		const struct address_space_operations *a_ops;
-		struct hlist_node *dentry_first;
-		struct dentry *dentry_ptr;
-		struct dentry dentry;
-		unsigned long ino;
-
-		/*
-		 * mapping can be invalid pointer and we don't want to crash
-		 * accessing it, so probe everything depending on it carefully
-		 */
-		if (get_kernel_nofault(host, &mapping->host) ||
-		    get_kernel_nofault(a_ops, &mapping->a_ops)) {
-			pr_warn("failed to read mapping contents, not a valid kernel address?\n");
-			goto out_mapping;
-		}
-
-		if (!host) {
-			pr_warn("aops:%ps\n", a_ops);
-			goto out_mapping;
-		}
-
-		if (get_kernel_nofault(dentry_first, &host->i_dentry.first) ||
-		    get_kernel_nofault(ino, &host->i_ino)) {
-			pr_warn("aops:%ps with invalid host inode %px\n",
-					a_ops, host);
-			goto out_mapping;
-		}
-
-		if (!dentry_first) {
-			pr_warn("aops:%ps ino:%lx\n", a_ops, ino);
-			goto out_mapping;
-		}
-
-		dentry_ptr = container_of(dentry_first, struct dentry, d_u.d_alias);
-		if (get_kernel_nofault(dentry, dentry_ptr)) {
-			pr_warn("aops:%ps ino:%lx with invalid dentry %px\n",
-					a_ops, ino, dentry_ptr);
-		} else {
-			/*
-			 * if dentry is corrupted, the %pd handler may still
-			 * crash, but it's unlikely that we reach here with a
-			 * corrupted struct page
-			 */
-			pr_warn("aops:%ps ino:%lx dentry name:\"%pd\"\n",
-					a_ops, ino, &dentry);
-		}
-	}
-out_mapping:
+	else if (mapping)
+		dump_mapping(mapping);
 	BUILD_BUG_ON(ARRAY_SIZE(pageflag_names) != __NR_PAGEFLAGS + 1);
 
 	pr_warn("%sflags: %pGp%s\n", type, &head->flags,
_

Patches currently in -mm which might be from willy@infradead.org are


