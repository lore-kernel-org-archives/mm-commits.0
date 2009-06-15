From: akpm@linux-foundation.org
Subject: + config_file_locking-should-not-depend-on-config_block.patch added to -mm tree
Date: Mon, 15 Jun 2009 14:45:19 -0700
Message-ID: <200906152145.n5FLjJlh006730@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37999 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762594AbZFOVqs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Jun 2009 17:46:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: szepe@pinerecords.com, stable@kernel.org


The patch titled
     CONFIG_FILE_LOCKING should not depend on CONFIG_BLOCK
has been added to the -mm tree.  Its filename is
     config_file_locking-should-not-depend-on-config_block.patch

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
Subject: CONFIG_FILE_LOCKING should not depend on CONFIG_BLOCK
From: Tomas Szepe <szepe@pinerecords.com>

CONFIG_FILE_LOCKING should not depend on CONFIG_BLOCK.

This makes it possible to run complete systems out of an initramfs on
current kernels again (this last worked on 2.6.27.*).

Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/Kconfig~config_file_locking-should-not-depend-on-config_block fs/Kconfig
--- a/fs/Kconfig~config_file_locking-should-not-depend-on-config_block
+++ a/fs/Kconfig
@@ -39,6 +39,13 @@ config FS_POSIX_ACL
 	bool
 	default n
 
+source "fs/xfs/Kconfig"
+source "fs/gfs2/Kconfig"
+source "fs/ocfs2/Kconfig"
+source "fs/btrfs/Kconfig"
+
+endif # BLOCK
+
 config FILE_LOCKING
 	bool "Enable POSIX file locking API" if EMBEDDED
 	default y
@@ -47,13 +54,6 @@ config FILE_LOCKING
           for filesystems like NFS and for the flock() system
           call. Disabling this option saves about 11k.
 
-source "fs/xfs/Kconfig"
-source "fs/gfs2/Kconfig"
-source "fs/ocfs2/Kconfig"
-source "fs/btrfs/Kconfig"
-
-endif # BLOCK
