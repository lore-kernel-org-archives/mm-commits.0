Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2F0BC67871
	for <mm-commits@archiver.kernel.org>; Mon, 24 Oct 2022 22:11:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbiJXWLu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Oct 2022 18:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbiJXWLU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Oct 2022 18:11:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB2D3037B4
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 13:26:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BE156158B
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 20:24:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B42C43470;
        Mon, 24 Oct 2022 20:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666643046;
        bh=CIAAfQ9MhkAVbZ6EDX3Xxuf6OGq/ueEDN1tZOukCgxY=;
        h=Date:To:From:Subject:From;
        b=RriGKdmxpcmMm2Z0PpK95P8hsqW0x2tZQiyiyEd9TpDlYarJA9UFrSi1tu+ju7vIe
         OftrEqXjB8jGPOOnsf52/GQmO2YR/ct72RwjMfXQ3cgUD+ZQpc+fwowwNvZPS0Xizl
         4W2z0CUQNi2SetWGo2UmOoVpvzYdvn7Sz7kGm75s=
Date:   Mon, 24 Oct 2022 13:24:05 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu,
        rppt@kernel.org, paul.gortmaker@windriver.com,
        mail@christoph.anton.mitterer.name, kaleshsingh@google.com,
        hannes@cmpxchg.org, david@redhat.com, David.Laight@ACULAB.COM,
        corbet@lwn.net, adobriyan@gmail.com, ivan@cloudflare.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v4.patch added to mm-nonmm-unstable branch
Message-Id: <20221024202406.63B42C43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v4
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v4.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3.patch
proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v4.patch

