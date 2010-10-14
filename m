From: akpm@linux-foundation.org
Subject: + vfs-fix-overflow-in-direct-io-subsystem.patch added to -mm tree
Date: Thu, 14 Oct 2010 16:20:59 -0700
Message-ID: <201010142320.o9ENKxTX025495@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755038Ab0JNXVU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Oct 2010 19:21:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: edward.shishkin@gmail.com, edward@redhat.com, hch@lst.de, jmoyer@redhat.com


The patch titled
     fs/direct-io.c: fix truncation error in dio_complete() return
has been added to the -mm tree.  Its filename is
     vfs-fix-overflow-in-direct-io-subsystem.patch

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
Subject: fs/direct-io.c: fix truncation error in dio_complete() return
From: Edward Shishkin <edward.shishkin@gmail.com>

Fix up truncation (ssize_t->int).

Signed-off-by: Edward Shishkin <edward@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/direct-io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/direct-io.c~vfs-fix-overflow-in-direct-io-subsystem fs/direct-io.c
--- a/fs/direct-io.c~vfs-fix-overflow-in-direct-io-subsystem
+++ a/fs/direct-io.c
@@ -218,7 +218,7 @@ static struct page *dio_get_page(struct 
  * filesystems can use it to hold additional state between get_block calls and
  * dio_complete.
  */
-static int dio_complete(struct dio *dio, loff_t offset, int ret, bool is_async)
+static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret, bool is_async)
 {
 	ssize_t transferred = 0;
 
_

Patches currently in -mm which might be from edward.shishkin@gmail.com are

vfs-fix-overflow-in-direct-io-subsystem.patch
vfs-relax-count-check-in-rw_verify_area.patch

