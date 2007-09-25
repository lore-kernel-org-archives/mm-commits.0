From: akpm@linux-foundation.org
Subject: + cfs-devel-latest-code.patch added to -mm tree
Date: Tue, 25 Sep 2007 01:48:23 -0700
Message-ID: <200709250848.l8P8mNsM009284@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34860 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750786AbXIYIs6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Sep 2007 04:48:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vatsa@linux.vnet.ibm.com, mingo@elte.hu


The patch titled
     git-sched: fix uniprocessor
has been added to the -mm tree.  Its filename is
     cfs-devel-latest-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
cfs-devel-latest-code.patch
