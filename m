From: akpm@linux-foundation.org
Subject: + fs-writebackc-bitfields-should-be-unsigned.patch added to -mm tree
Date: Fri, 02 Apr 2010 16:48:50 -0700
Message-ID: <201004022348.o32NmolW012073@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56252 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751387Ab0DBXsw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Apr 2010 19:48:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hartleys@visionengravers.com, hsweeten@visionengravers.com, viro@zeniv.linux.org.uk


The patch titled
     fs-writeback.c: bitfields should be unsigned
has been added to the -mm tree.  Its filename is
     fs-writebackc-bitfields-should-be-unsigned.patch

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
Subject: fs-writeback.c: bitfields should be unsigned
From: H Hartley Sweeten <hartleys@visionengravers.com>

This fixes sparse noise:
  error: dubious one-bit signed bitfield

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/fs-writeback.c~fs-writebackc-bitfields-should-be-unsigned fs/fs-writeback.c
--- a/fs/fs-writeback.c~fs-writebackc-bitfields-should-be-unsigned
+++ a/fs/fs-writeback.c
@@ -42,9 +42,9 @@ struct wb_writeback_args {
 	long nr_pages;
 	struct super_block *sb;
 	enum writeback_sync_modes sync_mode;
-	int for_kupdate:1;
-	int range_cyclic:1;
-	int for_background:1;
+	unsigned int for_kupdate:1;
+	unsigned int range_cyclic:1;
+	unsigned int for_background:1;
 };
 
 /*
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

linux-next.patch
matrix_keypad-allow-platform-to-disable-key-autorepeat.patch
scsi-sdc-quiet-all-sparse-noise.patch
fs-writebackc-bitfields-should-be-unsigned.patch

