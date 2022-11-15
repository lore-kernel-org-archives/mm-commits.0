Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B5E9C43219
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:26:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231788AbiKOW0P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:26:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231423AbiKOW0L (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:26:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66FAE9F
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:26:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59BBAB81B89
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D95C433C1;
        Tue, 15 Nov 2022 22:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551168;
        bh=hZXSEPsJnHAP0ciJKcrN8kPl8/lCk75mKX24uY/E5Z0=;
        h=Date:To:From:Subject:From;
        b=LjWdZeO3SCO27yrxzPTYCNl9/31baooDBNCmGRe4+oldOVJ7UPrJHoAU+aOptDKlo
         3GV6HcgGrxyAIFCQN77adu4O29r/QGQsvCkKriWx9A75+ZPpR5dxEiuFSAmKbRZ5FW
         gqP5RuBxIxd2L/HilW8BzODLDXenlQctg7mMDB8s=
Date:   Tue, 15 Nov 2022 14:26:07 -0800
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu,
        rppt@kernel.org, paul.gortmaker@windriver.com,
        mail@christoph.anton.mitterer.name, kaleshsingh@google.com,
        hannes@cmpxchg.org, david@redhat.com, David.Laight@ACULAB.COM,
        corbet@lwn.net, adobriyan@gmail.com, ivan@cloudflare.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v4.patch removed from -mm tree
Message-Id: <20221115222608.04D95C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v4
has been removed from the -mm tree.  Its filename was
     proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v4.patch

This patch was dropped because it was folded into proc-report-open-files-as-size-in-stat-for-proc-pid-fd.patch

------------------------------------------------------
From: Ivan Babrou <ivan@cloudflare.com>
Subject: proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v4
Date: Mon, 24 Oct 2022 10:31:40 -0700

return errno from proc_fd_getattr() instead of setting negative size

Link: https://lkml.kernel.org/r/20221024173140.30673-1-ivan@cloudflare.com
Signed-off-by: Ivan Babrou <ivan@cloudflare.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/fd.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/fs/proc/fd.c~proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v4
+++ a/fs/proc/fd.c
@@ -280,11 +280,10 @@ out:
 	return 0;
 }
 
-static int proc_readfd_count(struct inode *inode)
+static int proc_readfd_count(struct inode *inode, loff_t *count)
 {
 	struct task_struct *p = get_proc_task(inode);
 	struct fdtable *fdt;
-	unsigned int open_fds = 0;
 
 	if (!p)
 		return -ENOENT;
@@ -294,7 +293,7 @@ static int proc_readfd_count(struct inod
 		rcu_read_lock();
 
 		fdt = files_fdtable(p->files);
-		open_fds = bitmap_weight(fdt->open_fds, fdt->max_fds);
+		*count = bitmap_weight(fdt->open_fds, fdt->max_fds);
 
 		rcu_read_unlock();
 	}
@@ -302,7 +301,7 @@ static int proc_readfd_count(struct inod
 
 	put_task_struct(p);
 
-	return open_fds;
+	return 0;
 }
 
 static int proc_readfd(struct file *file, struct dir_context *ctx)
@@ -350,14 +349,18 @@ static int proc_fd_getattr(struct user_n
 			u32 request_mask, unsigned int query_flags)
 {
 	struct inode *inode = d_inode(path->dentry);
+	int rv = 0;
 
 	generic_fillattr(&init_user_ns, inode, stat);
 
 	/* If it's a directory, put the number of open fds there */
-	if (S_ISDIR(inode->i_mode))
-		stat->size = proc_readfd_count(inode);
+	if (S_ISDIR(inode->i_mode)) {
+		rv = proc_readfd_count(inode, &stat->size);
+		if (rv < 0)
+			return rv;
+	}
 
-	return 0;
+	return rv;
 }
 
 const struct inode_operations proc_fd_inode_operations = {
_

Patches currently in -mm which might be from ivan@cloudflare.com are

proc-report-open-files-as-size-in-stat-for-proc-pid-fd.patch

