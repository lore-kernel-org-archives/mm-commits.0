From: akpm@linux-foundation.org
Subject: + afs-build-fix.patch added to -mm tree
Date: Wed, 18 Jul 2007 23:25:55 -0700
Message-ID: <200707190630.l6J6UL68017805@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35362 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754898AbXGSGam (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 02:30:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, bfields@fieldses.org, dhowells@redhat.com


The patch titled
     afs build fix
has been added to the -mm tree.  Its filename is
     afs-build-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: afs build fix
From: Andrew Morton <akpm@linux-foundation.org>

Bruce and David's patches clashed.

fs/afs/flock.c: In function 'afs_do_getlk':
fs/afs/flock.c:459: error: void value not ignored as it ought to be

Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/flock.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/afs/flock.c~afs-build-fix fs/afs/flock.c
--- a/fs/afs/flock.c~afs-build-fix
+++ a/fs/afs/flock.c
@@ -456,7 +456,8 @@ static int afs_do_getlk(struct file *fil
 
 	/* check local lock records first */
 	ret = 0;
-	if (posix_test_lock(file, fl) == 0) {
+	posix_test_lock(file, fl);
+	if (fl->fl_type == F_UNLCK) {
 		/* no local locks; consult the server */
 		ret = afs_vnode_fetch_status(vnode, NULL, key);
 		if (ret < 0)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-fault-feedback-2.patch
freezer-run-show_state-when-freezing-times-out.patch
pm-introduce-hibernation-and-suspend-notifiers.patch
pm-disable-usermode-helper-before-hibernation-and-suspend.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
lockstat-core-infrastructure.patch
lockstat-human-readability-tweaks.patch
lockdep-various-fixes.patch
lockstat-measure-lock-bouncing.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
dequeue_huge_page-warning-fix.patch
lguest-the-host-code.patch
lguest-the-net-driver.patch
drivers-edac-new-i82443bxgz-mc-driver-broken.patch
drivers-edac-fix-e752x-reversed-csrows-fix.patch
drivers-edac-new-pasemi-driver-fix.patch
drivers-edac-new-i82975x-driver-fix.patch
kernel-sysctlc-finish-off-the-warning-comments.patch
afs-build-fix.patch
