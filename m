From: akpm@linux-foundation.org
Subject: + exec-create-initial-stack-independent-of-page_size.patch added to -mm tree
Date: Fri, 12 Feb 2010 11:45:40 -0800
Message-ID: <201002121945.o1CJjeWw022958@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757181Ab0BLTpy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Feb 2010 14:45:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mikey@neuling.org, anton@samba.org, deller@gmx.de, kosaki.motohiro@jp.fujitsu.com, xiyou.wangcong@gmail.com


The patch titled
     exec: create initial stack independent of PAGE_SIZE
has been added to the -mm tree.  Its filename is
     exec-create-initial-stack-independent-of-page_size.patch

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
