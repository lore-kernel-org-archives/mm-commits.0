From: akpm@linux-foundation.org
Subject: + tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl.patch added to -mm tree
Date: Tue, 21 Jun 2011 16:47:56 -0700
Message-ID: <201106212347.p5LNluHv032180@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756665Ab1FUXsD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jun 2011 19:48:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca, hughd@google.com, rdunlap@xenotime.net


The patch titled
     tmpfs: expand "help" to explain value of TMPFS_POSIX_ACL
has been added to the -mm tree.  Its filename is
     tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl.patch

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
Subject: tmpfs: expand "help" to explain value of TMPFS_POSIX_ACL
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Expand the fs/Kconfig "help" info to clarify why it's a bad idea to
deselect the TMPFS_POSIX_ACL config variable.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN fs/Kconfig~tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl fs/Kconfig
--- a/fs/Kconfig~tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl
+++ a/fs/Kconfig
@@ -127,14 +127,20 @@ config TMPFS_POSIX_ACL
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
+	  If you've selected TMPFS, you almost certainly want this option
+	  as well since a number of user space features (e.g., ALSA sound)
+	  require POSIX ACL support under /dev to work properly.  In other
+	  words, if you're not sure and you have no *compelling* reason to
+	  deselect this feature, say Y.
 
 	  To learn more about Access Control Lists, visit the POSIX ACLs for
 	  Linux website <http://acl.bestbits.at/>.
 
-	  If you don't know what Access Control Lists are, say N.
