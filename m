From: akpm@linux-foundation.org
Subject: - propagate-errors-from-find-in-scripts-gen_initramfs_listsh.patch removed from -mm tree
Date: Thu, 03 May 2007 12:31:14 -0700
Message-ID: <200705031931.l43JVEUm018251@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53099 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767847AbXECTdV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 15:33:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael@ellerman.id.au, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     Propagate errors from find in scripts/gen_initramfs_list.sh
has been removed from the -mm tree.  Its filename was
     propagate-errors-from-find-in-scripts-gen_initramfs_listsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Propagate errors from find in scripts/gen_initramfs_list.sh
From: Michael Ellerman <michael@ellerman.id.au>

If the find(1) in scripts/gen_initramfs_list.sh generates any errors, it
will cause gen_initramfs_list.sh to fail (because of "set -e"), however
the errors from find are not printed to the user. This is rather confusing:

~/src/powerpc$ make O=~/build/powerpc-cell32/
make[2]: *** [usr/initramfs_data.cpio.gz] Error 1
make[1]: *** [usr] Error 2
make[1]: *** Waiting for unfinished jobs....
make[1]: *** wait: No child processes.  Stop.
make: *** [_all] Error 2

It is much easier to work out what the problem is if we let the errors
from find hit the console, eg:

~/src/powerpc$ make O=~/build/powerpc-cell32/
find: /home/michael/initramfs-source/home: Permission denied
find: /home/michael/initramfs-source/lost+found: Permission denied
find: /home/michael/initramfs-source/opt: Permission denied
find: /home/michael/initramfs-source/root: Permission denied
make[2]: *** [usr/initramfs_data.cpio.gz] Error 1
make[1]: *** [usr] Error 2
make[1]: *** Waiting for unfinished jobs....
make[1]: *** wait: No child processes.  Stop.
make: *** [_all] Error 2

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gen_initramfs_list.sh |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/gen_initramfs_list.sh~propagate-errors-from-find-in-scripts-gen_initramfs_listsh scripts/gen_initramfs_list.sh
--- a/scripts/gen_initramfs_list.sh~propagate-errors-from-find-in-scripts-gen_initramfs_listsh
+++ a/scripts/gen_initramfs_list.sh
@@ -171,7 +171,7 @@ dir_filelist() {
 	${dep_list}header "$1"
 
 	srcdir=$(echo "$1" | sed -e 's://*:/:g')
-	dirlist=$(find "${srcdir}" -printf "%p %m %U %G\n" 2>/dev/null)
+	dirlist=$(find "${srcdir}" -printf "%p %m %U %G\n")
 
 	# If $dirlist is only one line, then the directory is empty
 	if [  "$(echo "${dirlist}" | wc -l)" -gt 1 ]; then
_

Patches currently in -mm which might be from michael@ellerman.id.au are

origin.patch
git-powerpc.patch
git-kbuild.patch
document-spin_lock_unlocked-rw_lock_unlocked-deprecation.patch
