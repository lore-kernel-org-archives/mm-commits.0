From: akpm@linux-foundation.org
Subject: + dev-mem-allow-rewinding.patch added to -mm tree
Date: Tue, 06 Apr 2010 12:14:40 -0700
Message-ID: <201004061914.o36JEfhG002405@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36090 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757428Ab0DFTOs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Apr 2010 15:14:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.dumazet@gmail.com, fengguang.wu@intel.com


The patch titled
     /dev/mem: allow rewinding
has been added to the -mm tree.  Its filename is
     dev-mem-allow-rewinding.patch

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
Subject: /dev/mem: allow rewinding
From: Eric Dumazet <eric.dumazet@gmail.com>

commit dcefafb6 ("/dev/mem: dont allow seek to last page") inadvertently
disabled rewinding on /dev/mem.

This broke x86info for example.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN drivers/char/mem.c~dev-mem-allow-rewinding drivers/char/mem.c
--- a/drivers/char/mem.c~dev-mem-allow-rewinding
+++ a/drivers/char/mem.c
@@ -710,11 +710,6 @@ static loff_t memory_lseek(struct file *
 	switch (orig) {
 	case SEEK_CUR:
 		offset += file->f_pos;
-		if ((unsigned long long)offset <
-		    (unsigned long long)file->f_pos) {
-			ret = -EOVERFLOW;
-			break;
-		}
 	case SEEK_SET:
 		/* to avoid userland mistaking f_pos=-9 as -EBADF=-9 */
 		if ((unsigned long long)offset >= ~0xFFFULL) {
_

Patches currently in -mm which might be from eric.dumazet@gmail.com are

origin.patch
linux-next.patch
dev-mem-allow-rewinding.patch

