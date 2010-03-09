From: akpm@linux-foundation.org
Subject: [merged] exec-create-initial-stack-independent-of-page_size.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:06:39 -0800
Message-ID: <201003091906.o29J6dRC031271@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43563 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756035Ab0CITW0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mikey@neuling.org, anton@samba.org, deller@gmx.de, kosaki.motohiro@jp.fujitsu.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     exec: create initial stack independent of PAGE_SIZE
has been removed from the -mm tree.  Its filename was
     exec-create-initial-stack-independent-of-page_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: exec: create initial stack independent of PAGE_SIZE
From: Michael Neuling <mikey@neuling.org>

Currently we create the initial stack based on the PAGE_SIZE.  This is
unnecessary.

This creates this initial stack independent of the PAGE_SIZE.

It also bumps up the number of 4k pages allocated from 20 to 32, to
align with 64K page systems.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Cc: Helge Deller <deller@gmx.de>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Americo Wang <xiyou.wangcong@gmail.com>
Cc: Anton Blanchard <anton@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN fs/exec.c~exec-create-initial-stack-independent-of-page_size fs/exec.c
--- a/fs/exec.c~exec-create-initial-stack-independent-of-page_size
+++ a/fs/exec.c
@@ -556,8 +556,6 @@ static int shift_arg_pages(struct vm_are
 	return 0;
 }
 
-#define EXTRA_STACK_VM_PAGES	20	/* random */
