From: akpm@linux-foundation.org
Subject: [merged] reiserfs-make-sure-va_end-is-always-called-after-va_start.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:08:18 -0800
Message-ID: <201101132010.p0DKAx79030110@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933651Ab1AMULg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:11:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jj@chaosbits.net, edward.shishkin@gmail.com, jeffm@suse.com, mm-commits@vger.kernel.org


The patch titled
     reiserfs: make sure va_end() is always called after va_start().
has been removed from the -mm tree.  Its filename was
     reiserfs-make-sure-va_end-is-always-called-after-va_start.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiserfs: make sure va_end() is always called after va_start().
From: Jesper Juhl <jj@chaosbits.net>

A call to va_start() must always be followed by a call to va_end() in the
same function.  In fs/reiserfs/prints.c::print_block() this is not always
the case.  If 'bh' is NULL we'll return without calling va_end().

One could add a call to va_end() before the 'return' statement, but it's
nicer to just move the call to va_start() after the test for 'bh' being
NULL.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Acked-by: Edward Shishkin <edward.shishkin@gmail.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/prints.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/reiserfs/prints.c~reiserfs-make-sure-va_end-is-always-called-after-va_start fs/reiserfs/prints.c
--- a/fs/reiserfs/prints.c~reiserfs-make-sure-va_end-is-always-called-after-va_start
+++ a/fs/reiserfs/prints.c
@@ -586,13 +586,13 @@ void print_block(struct buffer_head *bh,
 	va_list args;
 	int mode, first, last;
 
-	va_start(args, bh);
