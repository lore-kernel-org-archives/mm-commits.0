From: akpm@linux-foundation.org
Subject: + fs-namespacec-bound-mount-propagation-fix.patch added to -mm tree
Date: Thu, 21 Apr 2011 13:04:26 -0700
Message-ID: <201104212004.p3LK4QrA027342@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35167 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754379Ab1DUUFc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Apr 2011 16:05:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ext-roman.borisov@nokia.com, cebbert@redhat.com, hch@lst.de, vda.linux@googlemail.com, viro@zeniv.linux.org.uk, virtuoso@slind.org


The patch titled
     fs/namespace.c: bound mount propagation fix
has been added to the -mm tree.  Its filename is
     fs-namespacec-bound-mount-propagation-fix.patch

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
Subject: fs/namespace.c: bound mount propagation fix
From: Roman Borisov <ext-roman.borisov@nokia.com>

This issue was discovered by users of busybox.  Apparently, mount is
called with and without MS_SILENT, and this affects mount() behaviour. 
But MS_SILENT is only supposed to affect kernel logging verbosity.

The following script was run in an empty test directory:

mkdir -p mount.dir mount.shared1 mount.shared2
touch mount.dir/a mount.dir/b
mount -vv --bind         mount.shared1 mount.shared1
mount -vv --make-rshared mount.shared1
mount -vv --bind         mount.shared2 mount.shared2
mount -vv --make-rshared mount.shared2
mount -vv --bind mount.shared2 mount.shared1
mount -vv --bind mount.dir     mount.shared2
ls -R mount.dir mount.shared1 mount.shared2
umount mount.dir mount.shared1 mount.shared2 2>/dev/null
umount mount.dir mount.shared1 mount.shared2 2>/dev/null
umount mount.dir mount.shared1 mount.shared2 2>/dev/null
rm -f mount.dir/a mount.dir/b mount.dir/c
rmdir mount.dir mount.shared1 mount.shared2


mount -vv was used to show the mount() call arguments and result.
Output shows that flag argument has 0x00008000 = MS_SILENT bit:

mount: mount('mount.shared1','mount.shared1','(null)',0x00009000,'(null)'):0
mount: mount('','mount.shared1','',0x0010c000,''):0
mount: mount('mount.shared2','mount.shared2','(null)',0x00009000,'(null)'):0
mount: mount('','mount.shared2','',0x0010c000,''):0
mount: mount('mount.shared2','mount.shared1','(null)',0x00009000,'(null)'):0
mount: mount('mount.dir','mount.shared2','(null)',0x00009000,'(null)'):0
mount.dir:
a
b

mount.shared1:

mount.shared2:
a
b


After adding --loud option to remove MS_SILENT bit from just one mount cmd:

mkdir -p mount.dir mount.shared1 mount.shared2
touch mount.dir/a mount.dir/b
mount -vv --bind         mount.shared1 mount.shared1 2>&1
mount -vv --make-rshared mount.shared1               2>&1
mount -vv --bind         mount.shared2 mount.shared2 2>&1
mount -vv --loud --make-rshared mount.shared2               2>&1  # <-HERE
mount -vv --bind mount.shared2 mount.shared1         2>&1
mount -vv --bind mount.dir     mount.shared2         2>&1
ls -R mount.dir mount.shared1 mount.shared2      2>&1
umount mount.dir mount.shared1 mount.shared2 2>/dev/null
umount mount.dir mount.shared1 mount.shared2 2>/dev/null
umount mount.dir mount.shared1 mount.shared2 2>/dev/null
rm -f mount.dir/a mount.dir/b mount.dir/c
rmdir mount.dir mount.shared1 mount.shared2


The result is different now - look closely at mount.shared1 directory listing.
Now it does show files 'a' and 'b':

mount: mount('mount.shared1','mount.shared1','(null)',0x00009000,'(null)'):0
mount: mount('','mount.shared1','',0x0010c000,''):0
mount: mount('mount.shared2','mount.shared2','(null)',0x00009000,'(null)'):0
mount: mount('','mount.shared2','',0x00104000,''):0
mount: mount('mount.shared2','mount.shared1','(null)',0x00009000,'(null)'):0
mount: mount('mount.dir','mount.shared2','(null)',0x00009000,'(null)'):0

mount.dir:
a
b

mount.shared1:
a
b

mount.shared2:
a
b


Moreover, the recently added flags_to_propagation_type() function doesn't
allow us to do such operations as --make-[r]private --make-[r]shared etc. 
when MS_SILENT is on.  The idea or clearing the MS_SILENT flag came from
to Denys Vlasenko.

Signed-off-by: Roman Borisov <ext-roman.borisov@nokia.com>
Reported-by: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Cc: Alexander Shishkin <virtuoso@slind.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/namespace.c~fs-namespacec-bound-mount-propagation-fix fs/namespace.c
--- a/fs/namespace.c~fs-namespacec-bound-mount-propagation-fix
+++ a/fs/namespace.c
@@ -1695,7 +1695,7 @@ static int graft_tree(struct vfsmount *m
 
 static int flags_to_propagation_type(int flags)
 {
-	int type = flags & ~MS_REC;
+	int type = flags & ~(MS_REC | MS_SILENT);
 
 	/* Fail if any non-propagation flags are set */
 	if (type & ~(MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
_

Patches currently in -mm which might be from ext-roman.borisov@nokia.com are

fs-namespacec-bound-mount-propagation-fix.patch

