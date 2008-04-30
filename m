From: akpm@linux-foundation.org
Subject: - nbd-delete-superfluous-test-for-__gnuc__.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:47:59 -0700
Message-ID: <200804300547.m3U5lxqt029748@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58374 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758657AbYD3Fss (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:48:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, paul.clements@steeleye.com, mm-commits@vger.kernel.org


The patch titled
     nbd: delete superfluous test for __GNUC__
has been removed from the -mm tree.  Its filename was
     nbd-delete-superfluous-test-for-__gnuc__.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nbd: delete superfluous test for __GNUC__
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Since <linux/compiler.h> already tests for __GNUC__, there's no point in nbd.h
repeating that test.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: Paul Clements <paul.clements@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nbd.h |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN include/linux/nbd.h~nbd-delete-superfluous-test-for-__gnuc__ include/linux/nbd.h
--- a/include/linux/nbd.h~nbd-delete-superfluous-test-for-__gnuc__
+++ a/include/linux/nbd.h
@@ -88,11 +88,7 @@ struct nbd_request {
 	char handle[8];
 	__be64 from;
 	__be32 len;
-}
-#ifdef __GNUC__
-	__attribute__ ((packed))
-#endif
-;
+} __attribute__ ((packed));
 
 /*
  * This is the reply packet that nbd-server sends back to the client after
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
git-dvb.patch
git-mtd.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
remove-ifdef-__kernel__-checks-from-unexported-headers.patch
remove-__kernel__-tests-of-unexported-headers-under-asm-generic.patch
drop-the-exporting-of-empty-linux-byteorder-generich.patch

