From: akpm@linux-foundation.org
Subject: + memory-resource-controller-use-strstrip-while-parsing-arguments.patch added to -mm tree
Date: Mon, 25 Feb 2008 10:56:15 -0800
Message-ID: <200802251857.m1PIv6O7014438@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:48107 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754962AbYBYS5Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Feb 2008 13:57:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, menage@google.com


The patch titled
     Memory Resource Controller use strstrip while parsing arguments
has been added to the -mm tree.  Its filename is
     memory-resource-controller-use-strstrip-while-parsing-arguments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Memory Resource Controller use strstrip while parsing arguments
From: Balbir Singh <balbir@linux.vnet.ibm.com>

The memory controller has a requirement that while writing values, we need
to use echo -n. This patch fixes the problem and makes the UI more consistent.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/controllers/memory.txt |    6 +++---
 kernel/res_counter.c                 |    1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN Documentation/controllers/memory.txt~memory-resource-controller-use-strstrip-while-parsing-arguments Documentation/controllers/memory.txt
--- a/Documentation/controllers/memory.txt~memory-resource-controller-use-strstrip-while-parsing-arguments
+++ a/Documentation/controllers/memory.txt
@@ -164,7 +164,7 @@ c. Enable CONFIG_CGROUP_MEM_CONT
 
 Since now we're in the 0 cgroup,
 We can alter the memory limit:
-# echo -n 4M > /cgroups/0/memory.limit_in_bytes
+# echo 4M > /cgroups/0/memory.limit_in_bytes
 
 NOTE: We can use a suffix (k, K, m, M, g or G) to indicate values in kilo,
 mega or gigabytes.
@@ -185,7 +185,7 @@ number of factors, such as rounding up t
 availability of memory on the system.  The user is required to re-read
 this file after a write to guarantee the value committed by the kernel.
 
-# echo -n 1 > memory.limit_in_bytes
+# echo 1 > memory.limit_in_bytes
 # cat memory.limit_in_bytes
 4096
 
@@ -197,7 +197,7 @@ caches, RSS and Active pages/Inactive pa
 
 The memory.force_empty gives an interface to drop *all* charges by force.
 
-# echo -n 1 > memory.force_empty
+# echo 1 > memory.force_empty
 
 will drop all charges in cgroup. Currently, this is maintained for test.
 
diff -puN kernel/res_counter.c~memory-resource-controller-use-strstrip-while-parsing-arguments kernel/res_counter.c
--- a/kernel/res_counter.c~memory-resource-controller-use-strstrip-while-parsing-arguments
+++ a/kernel/res_counter.c
@@ -113,6 +113,7 @@ ssize_t res_counter_write(struct res_cou
 
 	ret = -EINVAL;
 
+	strstrip(buf);
 	if (write_strategy) {
 		if (write_strategy(buf, &tmp)) {
 			goto out_free;
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

memory-resource-controller-use-strstrip-while-parsing-arguments.patch
git-kvm.patch
git-sched.patch
memory-controller-rename-to-memory-resource-controller.patch
