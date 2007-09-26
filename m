From: akpm@linux-foundation.org
Subject: + lguest-example-launcher-truncates-block-device-file-to-0.patch added to -mm tree
Date: Wed, 26 Sep 2007 02:08:07 -0700
Message-ID: <200709260908.l8Q9877O029915@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34476 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752497AbXIZJKw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 05:10:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mail@chrismalley.co.uk, rusty@rustcorp.com.au


The patch titled
     lguest example launcher truncates block device file to 0 length on problems
has been added to the -mm tree.  Its filename is
     lguest-example-launcher-truncates-block-device-file-to-0.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lguest example launcher truncates block device file to 0 length on problems
From: Chris Malley <mail@chrismalley.co.uk>

The function should also use ftruncate64() rather than ftruncate() to
prevent files over 4GB (not uncommon for a root filesystem) being zeroed.

Signed-off-by: Chris Malley <mail@chrismalley.co.uk>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/lguest/lguest.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/lguest/lguest.c~lguest-example-launcher-truncates-block-device-file-to-0 Documentation/lguest/lguest.c
--- a/Documentation/lguest/lguest.c~lguest-example-launcher-truncates-block-device-file-to-0
+++ a/Documentation/lguest/lguest.c
@@ -882,7 +882,7 @@ static u32 handle_block_output(int fd, c
 		 * of the block file (possibly extending it). */
 		if (off + len > device_len) {
 			/* Trim it back to the correct length */
-			ftruncate(dev->fd, device_len);
+			ftruncate64(dev->fd, device_len);
 			/* Die, bad Guest, die. */
 			errx(1, "Write past end %llu+%u", off, len);
 		}
_

Patches currently in -mm which might be from mail@chrismalley.co.uk are

lguest-example-launcher-truncates-block-device-file-to-0.patch
