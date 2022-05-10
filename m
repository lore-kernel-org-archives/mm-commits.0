Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1AB0C43217
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235921AbiEJENh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235886AbiEJEN2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:13:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5537F20957F
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:09:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4873615E8
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D2DC385C2;
        Tue, 10 May 2022 04:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155770;
        bh=3OicNKzX9uYnoxFafczXmr3M5xFRZjSDHCbS3L91l3U=;
        h=Date:To:From:Subject:From;
        b=0Od2cKpEhzTXmnrWjEYkdwmQH4uiu12KbEDkAd+ljR6vkkI4dB8q+wi3luZWEayJ6
         JImP+Aoc4BmkYovlZgehb9upHhcR+1n30jhI9dafIpXd7jM9htIkhkC021d+pKGs5l
         uVlPWrd+DipFRfz8Sw4Zi1EMbASTTwon7awLQl5I=
Date:   Mon, 09 May 2022 21:09:29 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        keescook@chromium.org, jannh@google.com, hridya@google.com,
        ebiederm@xmission.com, christian.brauner@ubuntu.com,
        kaleshsingh@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] procfs-prevent-unpriveleged-processes-accessing-fdinfo-dir.patch removed from -mm tree
Message-Id: <20220510040930.46D2DC385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: procfs: prevent unprivileged processes accessing fdinfo dir
has been removed from the -mm tree.  Its filename was
     procfs-prevent-unpriveleged-processes-accessing-fdinfo-dir.patch

This patch was dropped because it was merged into mm-hotfixes-stable

------------------------------------------------------
From: Kalesh Singh <kaleshsingh@google.com>
Subject: procfs: prevent unprivileged processes accessing fdinfo dir

The file permissions on the fdinfo dir from were changed from
S_IRUSR|S_IXUSR to S_IRUGO|S_IXUGO, and a PTRACE_MODE_READ check was added
for opening the fdinfo files [1].  However, the ptrace permission check
was not added to the directory, allowing anyone to get the open FD numbers
by reading the fdinfo directory.

Add the missing ptrace permission check for opening the fdinfo directory.

[1] https://lkml.kernel.org/r/20210308170651.919148-1-kaleshsingh@google.com

Link: https://lkml.kernel.org/r/20210713162008.1056986-1-kaleshsingh@google.com
Fixes: 7bc3fa0172a4 ("procfs: allow reading fdinfo with PTRACE_MODE_READ")
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Hridya Valsaraju <hridya@google.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/fd.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

--- a/fs/proc/fd.c~procfs-prevent-unpriveleged-processes-accessing-fdinfo-dir
+++ a/fs/proc/fd.c
@@ -72,7 +72,7 @@ out:
 	return 0;
 }
 
-static int seq_fdinfo_open(struct inode *inode, struct file *file)
+static int proc_fdinfo_access_allowed(struct inode *inode)
 {
 	bool allowed = false;
 	struct task_struct *task = get_proc_task(inode);
@@ -86,6 +86,16 @@ static int seq_fdinfo_open(struct inode
 	if (!allowed)
 		return -EACCES;
 
+	return 0;
+}
+
+static int seq_fdinfo_open(struct inode *inode, struct file *file)
+{
+	int ret = proc_fdinfo_access_allowed(inode);
+
+	if (ret)
+		return ret;
+
 	return single_open(file, seq_show, inode);
 }
 
@@ -348,12 +358,23 @@ static int proc_readfdinfo(struct file *
 				  proc_fdinfo_instantiate);
 }
 
+static int proc_open_fdinfo(struct inode *inode, struct file *file)
+{
+	int ret = proc_fdinfo_access_allowed(inode);
+
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 const struct inode_operations proc_fdinfo_inode_operations = {
 	.lookup		= proc_lookupfdinfo,
 	.setattr	= proc_setattr,
 };
 
 const struct file_operations proc_fdinfo_operations = {
+	.open		= proc_open_fdinfo,
 	.read		= generic_read_dir,
 	.iterate_shared	= proc_readfdinfo,
 	.llseek		= generic_file_llseek,
_

Patches currently in -mm which might be from kaleshsingh@google.com are


