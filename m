From: akpm@linux-foundation.org
Subject: [merged] dev-mem-allow-rewinding.patch removed from -mm tree
Date: Wed, 07 Apr 2010 11:50:17 -0400
Message-ID: <201004071851.o37IphQ7001323@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40799 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756232Ab0DGSvr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Apr 2010 14:51:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.dumazet@gmail.com, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     /dev/mem: allow rewinding
has been removed from the -mm tree.  Its filename was
     dev-mem-allow-rewinding.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

