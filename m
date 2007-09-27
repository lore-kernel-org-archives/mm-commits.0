From: akpm@linux-foundation.org
Subject: - cfs-devel-latest-code.patch removed from -mm tree
Date: Wed, 26 Sep 2007 18:43:48 -0700
Message-ID: <200709270143.l8R1hmDI013992@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34502 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752681AbXI0Bvb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 21:51:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vatsa@linux.vnet.ibm.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     git-sched: fix uniprocessor
has been removed from the -mm tree.  Its filename was
     cfs-devel-latest-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: git-sched: fix uniprocessor
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

On Tue, Sep 25, 2007 at 12:41:20AM -0700, Andrew Morton wrote:
> This doornails the Vaio.  After grub handover the screen remains black
> and the fan goes whir.
>
> http://userweb.kernel.org/~akpm/config-sony.txt

This seems to be UP regression. Sorry abt that. I could recreate
the problem very easily with CONFIG_SMP turned off.

Can you check if this patch works? Works for me here.

--

Fix UP breakage.

Signed-off-by : Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sched.c~cfs-devel-latest-code kernel/sched.c
--- a/kernel/sched.c~cfs-devel-latest-code
+++ a/kernel/sched.c
@@ -1029,8 +1029,8 @@ static inline void __set_task_cpu(struct
 {
 #ifdef CONFIG_SMP
 	task_thread_info(p)->cpu = cpu;
-	set_task_cfs_rq(p);
 #endif
+	set_task_cfs_rq(p);
 }
 
 #ifdef CONFIG_SMP
_

Patches currently in -mm which might be from vatsa@linux.vnet.ibm.com are

git-sched.patch
