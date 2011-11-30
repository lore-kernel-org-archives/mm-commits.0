From: akpm@linux-foundation.org
Subject: + init-do_mountsc-create-root-if-it-does-not-exist.patch added to -mm tree
Date: Wed, 30 Nov 2011 12:57:30 -0800
Message-ID: <201111302057.pAUKvUVV013881@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:59467 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab1K3U5e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2011 15:57:34 -0500
Received: by faaq16 with SMTP id q16so39235faa.1
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2011 12:57:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tempname2@hotmail.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: init/do_mounts.c: create /root if it does not exist
has been added to the -mm tree.  Its filename is
     init-do_mountsc-create-root-if-it-does-not-exist.patch

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
From: YanHong <tempname2@hotmail.com>
Subject: init/do_mounts.c: create /root if it does not exist

If someone supplies an initramfs without /root in it, and we fail to
execute rdinit, we will try to mount root device and fail, for the mount
point does not exits.

But we get error message "VFS: Cannot open root device".  It's confusing.

We can give a more detailed error message, or we can go further: if /root
does not exit, create it.

Signed-off-by: YanHong <tempname2@hotmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN init/do_mounts.c~init-do_mountsc-create-root-if-it-does-not-exist init/do_mounts.c
--- a/init/do_mounts.c~init-do_mountsc-create-root-if-it-does-not-exist
+++ a/init/do_mounts.c
@@ -350,6 +350,9 @@ void __init mount_block_root(char *name,
 	const char *b = name;
 #endif
 
+	if (sys_access((const char __user *) "/root", 0) != 0)
+		sys_mkdir((const char __user *) "/root", 0700);
+
 	get_fs_names(fs_names);
 retry:
 	for (p = fs_names; *p; p += strlen(p)+1) {
_
Subject: Subject: init/do_mounts.c: create /root if it does not exist

Patches currently in -mm which might be from tempname2@hotmail.com are

init-do_mountsc-create-root-if-it-does-not-exist.patch

