From: akpm@linux-foundation.org
Subject: + jbd-jbd-debug-and-jbd2-debug-should-be-writable.patch added to -mm tree
Date: Fri, 04 Dec 2009 15:48:59 -0800
Message-ID: <200912042348.nB4NmxYm006177@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34173 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932472AbZLDXtK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Dec 2009 18:49:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kangkai.yin@intel.com, aneesh.kumar@linux.vnet.ibm.com, jack@ucw.cz


The patch titled
     jbd: jbd-debug and jbd2-debug should be writable
has been added to the -mm tree.  Its filename is
     jbd-jbd-debug-and-jbd2-debug-should-be-writable.patch

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
Subject: jbd: jbd-debug and jbd2-debug should be writable
From: Yin Kangkai <kangkai.yin@intel.com>

jbd-debug and jbd2-debug is currently read-only (S_IRUGO), which is not
correct. Make it writable so that we can start debuging.

Signed-off-by: Yin Kangkai <kangkai.yin@intel.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Jan Kara <jack@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/journal.c  |    2 +-
 fs/jbd2/journal.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/jbd/journal.c~jbd-jbd-debug-and-jbd2-debug-should-be-writable fs/jbd/journal.c
--- a/fs/jbd/journal.c~jbd-jbd-debug-and-jbd2-debug-should-be-writable
+++ a/fs/jbd/journal.c
@@ -1913,7 +1913,7 @@ static void __init jbd_create_debugfs_en
 {
 	jbd_debugfs_dir = debugfs_create_dir("jbd", NULL);
 	if (jbd_debugfs_dir)
-		jbd_debug = debugfs_create_u8("jbd-debug", S_IRUGO,
+		jbd_debug = debugfs_create_u8("jbd-debug", S_IRUGO | S_IWUSR,
 					       jbd_debugfs_dir,
 					       &journal_enable_debug);
 }
diff -puN fs/jbd2/journal.c~jbd-jbd-debug-and-jbd2-debug-should-be-writable fs/jbd2/journal.c
--- a/fs/jbd2/journal.c~jbd-jbd-debug-and-jbd2-debug-should-be-writable
+++ a/fs/jbd2/journal.c
@@ -2110,7 +2110,8 @@ static void __init jbd2_create_debugfs_e
 {
 	jbd2_debugfs_dir = debugfs_create_dir("jbd2", NULL);
 	if (jbd2_debugfs_dir)
-		jbd2_debug = debugfs_create_u8(JBD2_DEBUG_NAME, S_IRUGO,
+		jbd2_debug = debugfs_create_u8(JBD2_DEBUG_NAME,
+					       S_IRUGO | S_IWUSR,
 					       jbd2_debugfs_dir,
 					       &jbd2_journal_enable_debug);
 }
_

Patches currently in -mm which might be from kangkai.yin@intel.com are

jbd-jbd-debug-and-jbd2-debug-should-be-writable.patch

