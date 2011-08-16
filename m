From: akpm@linux-foundation.org
Subject: [merged] tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl.patch removed from -mm tree
Date: Tue, 16 Aug 2011 11:51:30 -0700
Message-ID: <201108161848.p7GImbMF015354@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751295Ab1HPSyi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 14:54:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, hughd@google.com, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     tmpfs: expand "help" to explain value of TMPFS_POSIX_ACL
has been removed from the -mm tree.  Its filename was
     tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tmpfs: expand "help" to explain value of TMPFS_POSIX_ACL
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Expand the fs/Kconfig "help" info to clarify why it's a bad idea to
deselect the TMPFS_POSIX_ACL config variable.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN fs/Kconfig~tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl fs/Kconfig
--- a/fs/Kconfig~tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl
+++ a/fs/Kconfig
@@ -127,14 +127,21 @@ config TMPFS_POSIX_ACL
 	select TMPFS_XATTR
 	select GENERIC_ACL
 	help
-	  POSIX Access Control Lists (ACLs) support permissions for users and
-	  groups beyond the owner/group/world scheme.
+	  POSIX Access Control Lists (ACLs) support additional access rights
+	  for users and groups beyond the standard owner/group/world scheme,
+	  and this option selects support for ACLs specifically for tmpfs
+	  filesystems.
+
+	  If you've selected TMPFS, it's possible that you'll also need
+	  this option as there are a number of Linux distros that require
+	  POSIX ACL support under /dev for certain features to work properly.
+	  For example, some distros need this feature for ALSA-related /dev
+	  files for sound to work properly.  In short, if you're not sure,
+	  say Y.
 
 	  To learn more about Access Control Lists, visit the POSIX ACLs for
 	  Linux website <http://acl.bestbits.at/>.
 
-	  If you don't know what Access Control Lists are, say N.
