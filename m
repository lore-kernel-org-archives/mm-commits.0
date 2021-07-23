Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5CF1C4320A
	for <mm-commits@archiver.kernel.org>; Fri, 23 Jul 2021 19:43:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB7C560F36
	for <mm-commits@archiver.kernel.org>; Fri, 23 Jul 2021 19:43:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbhGWTDV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jul 2021 15:03:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229530AbhGWTDU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 23 Jul 2021 15:03:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D0E860E99;
        Fri, 23 Jul 2021 19:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627069433;
        bh=PXVpudlwhjjS+/Ce4vF7zGOda6HnrxVSZSuRVxMmAK4=;
        h=Date:From:To:Subject:From;
        b=fS2H9lGhdeR8j30IJsVUx/EglXdsoUlH5axStNxFZ/yDvQBfSTuyePl3Pa/9cihNa
         XdLFBntdBuzXLtE0CY2qwBUWy9pRWoalpOwARMr7fQG9NslP+S1cewcYga1j+Dkqcu
         hVG/W5N0df/kIMNQlnXltHMCEzCJ7K9D0BfiSvow=
Date:   Fri, 23 Jul 2021 12:43:52 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, surenb@google.com,
        keescook@chromium.org, jannh@google.com, hridya@google.com,
        ebiederm@xmission.com, christian.koenig@amd.com,
        christian.brauner@ubuntu.com, kaleshsingh@google.com
Subject:  [to-be-updated]
 procfs-prevent-unpriveleged-processes-accessing-fdinfo.patch removed from -mm
 tree
Message-ID: <20210723194352.nEQZy%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: prevent unprivileged processes accessing fdinfo
has been removed from the -mm tree.  Its filename was
     procfs-prevent-unpriveleged-processes-accessing-fdinfo.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kalesh Singh <kaleshsingh@google.com>
Subject: procfs: prevent unprivileged processes accessing fdinfo

The file permissions on the fdinfo dir from were changed from
S_IRUSR|S_IXUSR to S_IRUGO|S_IXUGO, and a PTRACE_MODE_READ check was added
for opening the fdinfo files [1].  However, the ptrace permission check
was not added to the directory, allowing anyone to get the open FD numbers
by reading the fdinfo directory.

Add the missing ptrace permission check for opening the fdinfo directory.=
=20
The check is also added for readdir, lseek in the case that an
unprivileged process inherits an open FD to the fdinfo dir after an exec.

For the same reason, similar checks are added for fdinfo files which
previously only checked the ptrace permission in open.

[1] https://lkml.kernel.org/r/20210308170651.919148-1-kaleshsingh@google.com

Link: https://lkml.kernel.org/r/20210708155647.44208-1-kaleshsingh@google.c=
om
Fixes: 7bc3fa0172a4 ("procfs: allow reading fdinfo with PTRACE_MODE_READ")
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Christian K=C3=B6nig <christian.koenig@amd.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Hridya Valsaraju <hridya@google.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/fd.c |   65 +++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 61 insertions(+), 4 deletions(-)

--- a/fs/proc/fd.c~procfs-prevent-unpriveleged-processes-accessing-fdinfo
+++ a/fs/proc/fd.c
@@ -72,7 +72,7 @@ out:
 	return 0;
 }
=20
-static int seq_fdinfo_open(struct inode *inode, struct file *file)
+static int proc_fdinfo_access_allowed(struct inode *inode)
 {
 	bool allowed =3D false;
 	struct task_struct *task =3D get_proc_task(inode);
@@ -86,13 +86,44 @@ static int seq_fdinfo_open(struct inode
 	if (!allowed)
 		return -EACCES;
=20
+	return 0;
+}
+
+static int seq_fdinfo_open(struct inode *inode, struct file *file)
+{
+	int ret =3D proc_fdinfo_access_allowed(inode);
+
+	if (ret)
+		return ret;
+
 	return single_open(file, seq_show, inode);
 }
=20
+static ssize_t seq_fdinfo_read(struct file *file, char __user *buf, size_t=
 size,
+		loff_t *ppos)
+{
+	int ret =3D proc_fdinfo_access_allowed(file_inode(file));
+
+	if (ret)
+		return ret;
+
+	return seq_read(file, buf, size, ppos);
+}
+
+static loff_t seq_fdinfo_lseek(struct file *file, loff_t offset, int whenc=
e)
+{
+	int ret =3D proc_fdinfo_access_allowed(file_inode(file));
+
+	if (ret)
+		return ret;
+
+	return seq_lseek(file, offset, whence);
+}
+
 static const struct file_operations proc_fdinfo_file_operations =3D {
 	.open		=3D seq_fdinfo_open,
-	.read		=3D seq_read,
-	.llseek		=3D seq_lseek,
+	.read		=3D seq_fdinfo_read,
+	.llseek		=3D seq_fdinfo_lseek,
 	.release	=3D single_release,
 };
=20
@@ -344,17 +375,43 @@ proc_lookupfdinfo(struct inode *dir, str
=20
 static int proc_readfdinfo(struct file *file, struct dir_context *ctx)
 {
+	int ret =3D proc_fdinfo_access_allowed(file_inode(file));
+
+	if (ret)
+		return ret;
+
 	return proc_readfd_common(file, ctx,
 				  proc_fdinfo_instantiate);
 }
=20
+static loff_t proc_llseek_fdinfo(struct file *file, loff_t offset, int whe=
nce)
+{
+	int ret =3D proc_fdinfo_access_allowed(file_inode(file));
+
+	if (ret)
+		return ret;
+
+	return generic_file_llseek(file, offset, whence);
+}
+
+static int proc_open_fdinfo(struct inode *inode, struct file *file)
+{
+	int ret =3D proc_fdinfo_access_allowed(inode);
+
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 const struct inode_operations proc_fdinfo_inode_operations =3D {
 	.lookup		=3D proc_lookupfdinfo,
 	.setattr	=3D proc_setattr,
 };
=20
 const struct file_operations proc_fdinfo_operations =3D {
+	.open		=3D proc_open_fdinfo,
 	.read		=3D generic_read_dir,
 	.iterate_shared	=3D proc_readfdinfo,
-	.llseek		=3D generic_file_llseek,
+	.llseek		=3D proc_llseek_fdinfo,
 };
_

Patches currently in -mm which might be from kaleshsingh@google.com are


