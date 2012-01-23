From: akpm@linux-foundation.org
Subject: [merged] kprobes-initialize-before-using-a-hlist.patch removed from -mm tree
Date: Mon, 23 Jan 2012 12:21:26 -0800
Message-ID: <20120123202126.D26441E0058@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:58337 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174Ab2AWUV1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jan 2012 15:21:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ananth@in.ibm.com, jkenisto@us.ibm.com, masami.hiramatsu.pt@hitachi.com, srinivasa@in.ibm.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kprobes: initialize before using a hlist
has been removed from the -mm tree.  Its filename was
     kprobes-initialize-before-using-a-hlist.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: kprobes: initialize before using a hlist

Commit ef53d9c5e ("kprobes: improve kretprobe scalability with hashed
locking") introduced a bug where we can potentially leak
kretprobe_instances since we initialize a hlist head after having used it.

Initialize the hlist head before using it.

Reported by: Jim Keniston <jkenisto@us.ibm.com>
Acked-by: Jim Keniston <jkenisto@us.ibm.com>
Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srinivasa D S <srinivasa@in.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/kprobes.c~kprobes-initialize-before-using-a-hlist kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-initialize-before-using-a-hlist
+++ a/kernel/kprobes.c
@@ -1077,6 +1077,7 @@ void __kprobes kprobe_flush_task(struct 
 		/* Early boot.  kretprobe_table_locks not yet initialized. */
 		return;
 
+	INIT_HLIST_HEAD(&empty_rp);
 	hash = hash_ptr(tk, KPROBE_HASH_BITS);
 	head = &kretprobe_inst_table[hash];
 	kretprobe_table_lock(hash, &flags);
@@ -1085,7 +1086,6 @@ void __kprobes kprobe_flush_task(struct 
 			recycle_rp_inst(ri, &empty_rp);
 	}
 	kretprobe_table_unlock(hash, &flags);
-	INIT_HLIST_HEAD(&empty_rp);
 	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
 		hlist_del(&ri->hlist);
 		kfree(ri);
_

Patches currently in -mm which might be from ananth@in.ibm.com are

origin.patch
linux-next.patch

