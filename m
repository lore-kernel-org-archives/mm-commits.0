From: akpm@linux-foundation.org
Subject: + r-o-bind-mounts-track-number-of-mount-writers-fix.patch added to -mm tree
Date: Sun, 14 Oct 2007 18:02:47 -0700
Message-ID: <200710150102.l9F12lch010638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54430 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752186AbXJOBD3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 14 Oct 2007 21:03:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jblunck@suse.de, haveblue@us.ibm.com


The patch titled
     r/o bind mounts: Accept passing a mnt NULL pointer to mnt_drop_write()
has been added to the -mm tree.  Its filename is
     r-o-bind-mounts-track-number-of-mount-writers-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: r/o bind mounts: Accept passing a mnt NULL pointer to mnt_drop_write()
From: Jan Blunck <jblunck@suse.de>

In case of somebody opens a file with dentry_open(dentry, NULL, ...) we
don't want to stumble on the NULL pointer mnt in struct file.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Cc: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/namespace.c~r-o-bind-mounts-track-number-of-mount-writers-fix fs/namespace.c
--- a/fs/namespace.c~r-o-bind-mounts-track-number-of-mount-writers-fix
+++ a/fs/namespace.c
@@ -249,6 +249,9 @@ void mnt_drop_write(struct vfsmount *mnt
 	int must_check_underflow = 0;
 	struct mnt_writer *cpu_writer;
 
+	if (!mnt)
+		return;
+
 	cpu_writer = &get_cpu_var(mnt_writers);
 	spin_lock(&cpu_writer->lock);
 
_

Patches currently in -mm which might be from jblunck@suse.de are

r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime-fix.patch
r-o-bind-mounts-track-number-of-mount-writers-fix.patch
