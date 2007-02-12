From: akpm@linux-foundation.org
Subject: - lockdep-forward-declare-struct-task_struct.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:44:03 -0800
Message-ID: <200702122244.l1CMi3tX013548@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45097 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030294AbXBLWp1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:45:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, mingo@elte.hu, schwidefsky@de.ibm.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     lockdep: forward declare struct task_struct
has been removed from the -mm tree.  Its filename was
     lockdep-forward-declare-struct-task_struct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lockdep: forward declare struct task_struct
From: Heiko Carstens <heiko.carstens@de.ibm.com>

3117df0453828bd045c16244e6f50e5714667a8a causes this:

In file included from arch/s390/kernel/early.c:13:
include/linux/lockdep.h:300: warning:
		"struct task_struct" declared inside parameter list
include/linux/lockdep.h:300:
		warning: its scope is only this definition or
		declaration, which is probably not what you want

Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lockdep.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/lockdep.h~lockdep-forward-declare-struct-task_struct include/linux/lockdep.h
--- a/include/linux/lockdep.h~lockdep-forward-declare-struct-task_struct
+++ a/include/linux/lockdep.h
@@ -8,6 +8,8 @@
 #ifndef __LINUX_LOCKDEP_H
 #define __LINUX_LOCKDEP_H
 
+struct task_struct;
+
 #ifdef CONFIG_LOCKDEP
 
 #include <linux/linkage.h>
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
git-infiniband.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed.patch
slab-use-cpu_lock_.patch
