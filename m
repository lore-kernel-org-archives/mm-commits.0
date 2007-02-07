From: akpm@linux-foundation.org
Subject: + lockdep-forward-declare-struct-task_struct.patch added to -mm tree
Date: Wed, 07 Feb 2007 14:48:48 -0800
Message-ID: <200702072248.l17MmnsU030043@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43041 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030299AbXBGWu1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 17:50:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, mingo@elte.hu, schwidefsky@de.ibm.com, stable@kernel.org


The patch titled
     lockdep: forward declare struct task_struct
has been added to the -mm tree.  Its filename is
     lockdep-forward-declare-struct-task_struct.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lockdep.h |    2 ++
 1 files changed, 2 insertions(+)

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
ehca-fix-memleak-on-module-unloading.patch
git-s390.patch
lockdep-forward-declare-struct-task_struct.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed.patch
slab-use-cpu_lock_.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-s390.patch
