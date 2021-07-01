Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5CDFC11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:54:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FF7D61476
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:54:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238540AbhGAB5U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:57:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238539AbhGAB5U (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:57:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD33961468;
        Thu,  1 Jul 2021 01:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104490;
        bh=j9bb7KCpT+WlaIRcv9TsKm+fpCcSh6Z1jLwWQXqKbUQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=opFHlEd/NqhKB5Oz+D4QcKsQ/qQG1gMDK/SzN1JmkIgWiflagzt1qwT+yOBnifKLM
         /ArzE2lux5fG1RtPQH9zDUoi4F7IssKjflkebn4k6iaZTtJmfrHf+M18k1x/8dT/jb
         IXGyk6Wgc12fc+j7xPsHippdrOTMjugk+qPu7ecU=
Date:   Wed, 30 Jun 2021 18:54:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org, avagin@gmail.com,
        bernd.edlinger@hotmail.de, christian.brauner@ubuntu.com,
        christian.koenig@amd.com, corbet@lwn.net, deller@gmx.de,
        ebiederm@xmission.com, gladkov.alexey@gmail.com, hridya@google.com,
        jamorris@linux.microsoft.com, jannh@google.com, jeffv@google.com,
        kaleshsingh@google.com, keescook@chromium.org, linux-mm@kvack.org,
        mchehab+huawei@kernel.org, mhocko@suse.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        surenb@google.com, szabolcs.nagy@arm.com,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        walken@google.com, willy@infradead.org
Subject:  [patch 143/192] procfs/dmabuf: add inode number to
 /proc/*/fdinfo
Message-ID: <20210701015449.VAmBDscYI%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: Kalesh Singh <kaleshsingh@google.com>
Subject: procfs/dmabuf: add inode number to /proc/*/fdinfo

And 'ino' field to /proc/<pid>/fdinfo/<FD> and
/proc/<pid>/task/<tid>/fdinfo/<FD>.

The inode numbers can be used to uniquely identify DMA buffers in user
space and avoids a dependency on /proc/<pid>/fd/* when accounting
per-process DMA buffer sizes.

Link: https://lkml.kernel.org/r/20210308170651.919148-2-kaleshsingh@google.=
com
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Christian K=C3=B6nig <christian.koenig@amd.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jeff Vander Stoep <jeffv@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Hridya Valsaraju <hridya@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: Szabolcs Nagy <szabolcs.nagy@arm.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Helge Deller <deller@gmx.de>
Cc: James Morris <jamorris@linux.microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |   37 ++++++++++++++++++++++-----
 fs/proc/fd.c                       |    5 ++-
 2 files changed, 34 insertions(+), 8 deletions(-)

--- a/Documentation/filesystems/proc.rst~procfs-dmabuf-add-inode-number-to-=
proc-fdinfo
+++ a/Documentation/filesystems/proc.rst
@@ -1920,18 +1920,20 @@ if precise results are needed.
 3.8	/proc/<pid>/fdinfo/<fd> - Information about opened file
 ---------------------------------------------------------------
 This file provides information associated with an opened file. The regular
-files have at least three fields -- 'pos', 'flags' and 'mnt_id'. The 'pos'
-represents the current offset of the opened file in decimal form [see lsee=
k(2)
-for details], 'flags' denotes the octal O_xxx mask the file has been
-created with [see open(2) for details] and 'mnt_id' represents mount ID of
-the file system containing the opened file [see 3.5 /proc/<pid>/mountinfo
-for details].
+files have at least four fields -- 'pos', 'flags', 'mnt_id' and 'ino'.
+The 'pos' represents the current offset of the opened file in decimal
+form [see lseek(2) for details], 'flags' denotes the octal O_xxx mask the
+file has been created with [see open(2) for details] and 'mnt_id' represen=
ts
+mount ID of the file system containing the opened file [see 3.5
+/proc/<pid>/mountinfo for details]. 'ino' represents the inode number of
+the file.
=20
 A typical output is::
=20
 	pos:	0
 	flags:	0100002
 	mnt_id:	19
+	ino:	63107
=20
 All locks associated with a file descriptor are shown in its fdinfo too::
=20
@@ -1948,6 +1950,7 @@ Eventfd files
 	pos:	0
 	flags:	04002
 	mnt_id:	9
+	ino:	63107
 	eventfd-count:	5a
=20
 where 'eventfd-count' is hex value of a counter.
@@ -1960,6 +1963,7 @@ Signalfd files
 	pos:	0
 	flags:	04002
 	mnt_id:	9
+	ino:	63107
 	sigmask:	0000000000000200
=20
 where 'sigmask' is hex value of the signal mask associated
@@ -1973,6 +1977,7 @@ Epoll files
 	pos:	0
 	flags:	02
 	mnt_id:	9
+	ino:	63107
 	tfd:        5 events:       1d data: ffffffffffffffff pos:0 ino:61af sdev=
:7
=20
 where 'tfd' is a target file descriptor number in decimal form,
@@ -1989,6 +1994,8 @@ For inotify files the format is the foll
=20
 	pos:	0
 	flags:	02000000
+	mnt_id:	9
+	ino:	63107
 	inotify wd:3 ino:9e7e sdev:800013 mask:800afce ignored_mask:0 fhandle-byt=
es:8 fhandle-type:1 f_handle:7e9e0000640d1b6d
=20
 where 'wd' is a watch descriptor in decimal form, i.e. a target file
@@ -2011,6 +2018,7 @@ For fanotify files the format is::
 	pos:	0
 	flags:	02
 	mnt_id:	9
+	ino:	63107
 	fanotify flags:10 event-flags:0
 	fanotify mnt_id:12 mflags:40 mask:38 ignored_mask:40000003
 	fanotify ino:4f969 sdev:800013 mflags:0 mask:3b ignored_mask:40000000 fha=
ndle-bytes:8 fhandle-type:1 f_handle:69f90400c275b5b4
@@ -2035,6 +2043,7 @@ Timerfd files
 	pos:	0
 	flags:	02
 	mnt_id:	9
+	ino:	63107
 	clockid: 0
 	ticks: 0
 	settime flags: 01
@@ -2049,6 +2058,22 @@ details]. 'it_value' is remaining time u
 with TIMER_ABSTIME option which will be shown in 'settime flags', but 'it_=
value'
 still exhibits timer's remaining time.
=20
+DMA Buffer files
+~~~~~~~~~~~~~~~~
+
+::
+
+	pos:	0
+	flags:	04002
+	mnt_id:	9
+	ino:	63107
+	size:   32768
+	count:  2
+	exp_name:  system-heap
+
+where 'size' is the size of the DMA buffer in bytes. 'count' is the file c=
ount of
+the DMA buffer file. 'exp_name' is the name of the DMA buffer exporter.
+
 3.9	/proc/<pid>/map_files - Information about memory mapped files
 ---------------------------------------------------------------------
 This directory contains symbolic links which represent memory mapped files
--- a/fs/proc/fd.c~procfs-dmabuf-add-inode-number-to-proc-fdinfo
+++ a/fs/proc/fd.c
@@ -54,9 +54,10 @@ static int seq_show(struct seq_file *m,
 	if (ret)
 		return ret;
=20
-	seq_printf(m, "pos:\t%lli\nflags:\t0%o\nmnt_id:\t%i\n",
+	seq_printf(m, "pos:\t%lli\nflags:\t0%o\nmnt_id:\t%i\nino:\t%lu\n",
 		   (long long)file->f_pos, f_flags,
-		   real_mount(file->f_path.mnt)->mnt_id);
+		   real_mount(file->f_path.mnt)->mnt_id,
+		   file_inode(file)->i_ino);
=20
 	/* show_fd_locks() never deferences files so a stale value is safe */
 	show_fd_locks(m, file, files);
_
