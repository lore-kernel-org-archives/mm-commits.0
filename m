From: akpm@linux-foundation.org
Subject: [merged] sys_swapon-remove-initial-value-of-name-variable.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:37:24 -0700
Message-ID: <201103232041.p2NKf0a7028580@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933528Ab1CWUzj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:55:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, emunson@mgebm.net, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, penberg@kernel.org, mm-commits@vger.kernel.org


The patch titled
     sys_swapon: remove initial value of name variable
has been removed from the -mm tree.  Its filename was
     sys_swapon-remove-initial-value-of-name-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sys_swapon: remove initial value of name variable
From: Cesar Eduardo Barros <cesarb@cesarb.net>

Now there is nothing which jumps to the cleanup blocks before the name
variable is set. There is no need to set it initially to NULL anymore.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/swapfile.c~sys_swapon-remove-initial-value-of-name-variable mm/swapfile.c
--- a/mm/swapfile.c~sys_swapon-remove-initial-value-of-name-variable
+++ a/mm/swapfile.c
@@ -1892,7 +1892,7 @@ static struct swap_info_struct *alloc_sw
 SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 {
 	struct swap_info_struct *p;
-	char *name = NULL;
+	char *name;
 	struct block_device *bdev = NULL;
 	struct file *swap_file = NULL;
 	struct address_space *mapping;
_

Patches currently in -mm which might be from cesarb@cesarb.net are

origin.patch

