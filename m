From: akpm@osdl.org
Subject: + lockdep-missing-barrier.patch added to -mm tree
Date: Tue, 23 Jan 2007 20:26:52 -0800
Message-ID: <200701240426.l0O4QqGP008267@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50703 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965496AbXAXE1Y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 23:27:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, mingo@elte.hu


The patch titled
     lockdep: missing barrier()
has been added to the -mm tree.  Its filename is
     lockdep-missing-barrier.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lockdep: missing barrier()
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

This patch adds a barrier() to lockdep.c lockdep_recursion updates. This
variable behaves like the preemption count and should therefore use similar
memory barriers.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/lockdep.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/lockdep.c~lockdep-missing-barrier kernel/lockdep.c
--- a/kernel/lockdep.c~lockdep-missing-barrier
+++ a/kernel/lockdep.c
@@ -169,12 +169,14 @@ static struct list_head chainhash_table[
 void lockdep_off(void)
 {
 	current->lockdep_recursion++;
+	barrier();
 }
 
 EXPORT_SYMBOL(lockdep_off);
 
 void lockdep_on(void)
 {
+	barrier();
 	current->lockdep_recursion--;
 }
 
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

relay-add-cpu-hotplug-support.patch
local_t-documentation.patch
local_t-documentation-fix.patch
lockdep-missing-barrier.patch
