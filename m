From: akpm@linux-foundation.org
Subject: + tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl-v3.patch added to -mm tree
Date: Tue, 21 Jun 2011 16:54:30 -0700
Message-ID: <201106212354.p5LNsUKZ032546@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43471 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757484Ab1FUXyg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jun 2011 19:54:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca, hughd@google.com, rdunlap@xenotime.net


The patch titled
     tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl-v3
has been added to the -mm tree.  Its filename is
     tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl-v3.patch

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
Subject: tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl-v3
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Expand the fs/Kconfig "help" info to clarify why you might need to select
the TMPFS_POSIX_ACL config variable.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN fs/Kconfig~tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl-v3 fs/Kconfig
--- a/fs/Kconfig~tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl-v3
+++ a/fs/Kconfig
@@ -132,11 +132,12 @@ config TMPFS_POSIX_ACL
 	  and this option selects support for ACLs specifically for tmpfs
 	  filesystems.
 
-	  If you've selected TMPFS, you almost certainly want this option
-	  as well since a number of user space features (e.g., ALSA sound)
-	  require POSIX ACL support under /dev to work properly.  In other
-	  words, if you're not sure and you have no *compelling* reason to
-	  deselect this feature, say Y.
+	  If you've selected TMPFS, it's possible that you'll also need
+	  this option as there are a number of Linux distros that require
+	  POSIX ACL support under /dev for certain features to work properly.
+	  For example, some distros need this feature for ALSA-related /dev
+	  files for sound to work properly.  In short, if you're not sure,
+	  say Y.
 
 	  To learn more about Access Control Lists, visit the POSIX ACLs for
 	  Linux website <http://acl.bestbits.at/>.
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

linux-next.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl-v3.patch

