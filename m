Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7BBCC4338F
	for <mm-commits@archiver.kernel.org>; Fri, 23 Jul 2021 19:44:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B93FA60E99
	for <mm-commits@archiver.kernel.org>; Fri, 23 Jul 2021 19:44:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbhGWTEI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Jul 2021 15:04:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231337AbhGWTEH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 23 Jul 2021 15:04:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A49660E97;
        Fri, 23 Jul 2021 19:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627069480;
        bh=+vk1hn/dR+b22Cn3v4Mh643d503TV3Ed+1uxRvyTjLo=;
        h=Date:From:To:Subject:From;
        b=1rNYjBwRAQoiBgMlO7wt7qaNI7J2NiCfuUGu4nZ1tLjEhoBmwTFT0SHjfck92WjWs
         8YC+AIcNZlMOrn5zOmuKBcP3drqDxZdsx5Zwm7pjNQOHqIwcPg3jjX0JbOTvExh9MO
         zanClpoGWAszig8x04f6IP07dWpgDgHD8XqWEg8k=
Date:   Fri, 23 Jul 2021 12:44:39 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, surenb@google.com,
        keescook@chromium.org, jannh@google.com, hridya@google.com,
        ebiederm@xmission.com, christian.koenig@amd.com,
        christian.brauner@ubuntu.com, kaleshsingh@google.com
Subject:  +
 procfs-prevent-unpriveleged-processes-accessing-fdinfo-dir.patch added to -mm
 tree
Message-ID: <20210723194439.LZABz%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: prevent unpriveleged processes accessing fdinfo dir
has been added to the -mm tree.  Its filename is
     procfs-prevent-unpriveleged-processes-accessing-fdinfo-dir.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/procfs-prevent-unpriveleged-p=
rocesses-accessing-fdinfo-dir.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/procfs-prevent-unpriveleged-p=
rocesses-accessing-fdinfo-dir.patch

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
Subject: procfs: prevent unpriveleged processes accessing fdinfo dir

The file permissions on the fdinfo dir from were changed from
S_IRUSR|S_IXUSR to S_IRUGO|S_IXUGO, and a PTRACE_MODE_READ check was added
for opening the fdinfo files [1].  However, the ptrace permission check
was not added to the directory, allowing anyone to get the open FD numbers
by reading the fdinfo directory.

Add the missing ptrace permission check for opening the fdinfo directory.

[1] https://lkml.kernel.org/r/20210308170651.919148-1-kaleshsingh@google.com

Link: https://lkml.kernel.org/r/20210713162008.1056986-1-kaleshsingh@google=
.com
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

 fs/proc/fd.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

--- a/fs/proc/fd.c~procfs-prevent-unpriveleged-processes-accessing-fdinfo-d=
ir
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
@@ -86,6 +86,16 @@ static int seq_fdinfo_open(struct inode
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
@@ -348,12 +358,23 @@ static int proc_readfdinfo(struct file *
 				  proc_fdinfo_instantiate);
 }
=20
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
 	.llseek		=3D generic_file_llseek,
_

Patches currently in -mm which might be from kaleshsingh@google.com are

procfs-prevent-unpriveleged-processes-accessing-fdinfo-dir.patch

