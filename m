From: akpm@linux-foundation.org
Subject: + cgroups-save-space-for-the-terminator.patch added to -mm tree
Date: Mon, 12 Jul 2010 13:13:52 -0700
Message-ID: <201007122013.o6CKDqPL026849@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752323Ab0GLUOQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jul 2010 16:14:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, bblum@andrew.cmu.edu, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, serge@hallyn.com


The patch titled
     cgroups: save space for the terminator
has been added to the -mm tree.  Its filename is
     cgroups-save-space-for-the-terminator.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: save space for the terminator
From: Dan Carpenter <error27@gmail.com>

The original code didn't leave enough space for a NULL terminator.  These
strings are copied with strcpy() into fixed length buffers in
cgroup_root_from_opts().

Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Serge E. Hallyn <serge@hallyn.com>
Reviewd-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ben Blum <bblum@andrew.cmu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/cgroup.c~cgroups-save-space-for-the-terminator kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-save-space-for-the-terminator
+++ a/kernel/cgroup.c
@@ -1102,7 +1102,7 @@ static int parse_cgroupfs_options(char *
 			if (opts->release_agent)
 				return -EINVAL;
 			opts->release_agent =
-				kstrndup(token + 14, PATH_MAX, GFP_KERNEL);
+				kstrndup(token + 14, PATH_MAX - 1, GFP_KERNEL);
 			if (!opts->release_agent)
 				return -ENOMEM;
 		} else if (!strncmp(token, "name=", 5)) {
@@ -1123,7 +1123,7 @@ static int parse_cgroupfs_options(char *
 			if (opts->name)
 				return -EINVAL;
 			opts->name = kstrndup(name,
-					      MAX_CGROUP_ROOT_NAMELEN,
+					      MAX_CGROUP_ROOT_NAMELEN - 1,
 					      GFP_KERNEL);
 			if (!opts->name)
 				return -ENOMEM;
_

Patches currently in -mm which might be from error27@gmail.com are

linux-next.patch
mtd-sst25l-check-for-null-consistently.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
9p-strlen-doesnt-count-the-terminator.patch
autofs4-remove-unneeded-null-check-in-try_to_fill_dentry.patch
cgroups-save-space-for-the-terminator.patch

