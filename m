From: akpm@linux-foundation.org
Subject: [merged] sys_swapon-move-setting-of-swapfilepages-near-use.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:37:40 -0700
Message-ID: <201103232041.p2NKfGLt028622@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933421Ab1CWUl5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:41:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, emunson@mgebm.net, hughd@google.com, jj@chaosbits.net, kamezawa.hiroyu@jp.fujitsu.com, penberg@kernel.org, mm-commits@vger.kernel.org


The patch titled
     sys_swapon: move setting of swapfilepages near use
has been removed from the -mm tree.  Its filename was
     sys_swapon-move-setting-of-swapfilepages-near-use.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sys_swapon: move setting of swapfilepages near use
From: Cesar Eduardo Barros <cesarb@cesarb.net>

There is no reason I can see to read inode->i_size long before it is
needed. Move its read to just before it is needed, to reduce the
variable lifetime.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
Reviewed-by: Jesper Juhl <jj@chaosbits.net>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/swapfile.c~sys_swapon-move-setting-of-swapfilepages-near-use mm/swapfile.c
--- a/mm/swapfile.c~sys_swapon-move-setting-of-swapfilepages-near-use
+++ a/mm/swapfile.c
@@ -1975,8 +1975,6 @@ SYSCALL_DEFINE2(swapon, const char __use
 	if (unlikely(error))
 		goto bad_swap;
 
-	swapfilepages = i_size_read(inode) >> PAGE_SHIFT;
