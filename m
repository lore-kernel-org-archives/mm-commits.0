Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E3DCC07E99
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 22:42:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57B71613C5
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 22:42:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbhGIWo4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 18:44:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:54528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229542AbhGIWoy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 18:44:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B843613B7;
        Fri,  9 Jul 2021 22:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625870529;
        bh=Gvp2IDQYnJLZSvn8JOdUBW0WK8iaDq+OA9Izqq3b8fM=;
        h=Date:From:To:Subject:From;
        b=yUPH3hKF57GlKPoOjK6XwXA0FlgqjvZNIFssGruPltg4c7akTlgZsV/OXiwUffZ4W
         DZU4AO20AKUowd/8fweK26uOMxy+HXQHtvA1LAaj3BqhHGYJhBOm49wEpb1YHiiyYl
         UiwDXECGPsVhe7/bzC3kckPK7ttQZxgMtw5bGLNw=
Date:   Fri, 09 Jul 2021 15:42:09 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, surenb@google.com,
        keescook@chromium.org, jannh@google.com, hridya@google.com,
        ebiederm@xmission.com, christian.koenig@amd.com,
        christian.brauner@ubuntu.com, kaleshsingh@google.com
Subject:  +
 procfs-prevent-unpriveleged-processes-accessing-fdinfo.patch added to -mm
 tree
Message-ID: <20210709224209.GR1Hi%akpm@linux-foundation.org>
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
has been added to the -mm tree.  Its filename is
     procfs-prevent-unpriveleged-processes-accessing-fdinfo.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/procfs-prevent-unpriveleged-p=
rocesses-accessing-fdinfo.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/procfs-prevent-unpriveleged-p=
rocesses-accessing-fdinfo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

procfs-prevent-unpriveleged-processes-accessing-fdinfo.patch

