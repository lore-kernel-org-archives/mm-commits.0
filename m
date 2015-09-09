From: akpm@linux-foundation.org
Subject: [folded-merged]
 procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
 removed from -mm tree
Date: Wed, 09 Sep 2015 15:30:20 -0700
Message-ID: <55f0b2fc.fjiOtKv3rzEcGEQX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58298 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbbIIWaV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 18:30:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, calvinowens@fb.com, gorcunov@openvz.org, joe@perches.com, keescook@chromium.org, kirill@shutemov.name, luto@amacapital.net, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix
has been removed from the -mm tree.  Its filename was
     procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch

This patch was dropped because it was folded into procfs-always-expose-proc-pid-map_files-and-make-it-readable.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix

git it correcter

Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Calvin Owens <calvinowens@fb.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Joe Perches <joe@perches.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/proc/base.c~procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix fs/proc/base.c
--- a/fs/proc/base.c~procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix
+++ a/fs/proc/base.c
@@ -1955,8 +1955,8 @@ struct map_files_info {
  * symlinks may be used to bypass permissions on ancestor directories in the
  * path to the file in question.
  */
-static void *
-proc_map_files_follow_link(struct dentry *dentry, struct nameidata *nd)
+static const char *
+proc_map_files_follow_link(struct dentry *dentry, void **cookie)
 {
 	if (!capable(CAP_SYS_ADMIN))
 		return ERR_PTR(-EPERM);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

procfs-always-expose-proc-pid-map_files-and-make-it-readable.patch

