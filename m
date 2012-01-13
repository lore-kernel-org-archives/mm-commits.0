From: akpm@linux-foundation.org
Subject: + kprobes-initialize-before-using-a-hlist.patch added to -mm tree
Date: Fri, 13 Jan 2012 13:43:44 -0800
Message-ID: <20120113214344.A7834100100@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:37230 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048Ab2AMVnp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 16:43:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ananth@in.ibm.com, jkenisto@us.ibm.com, masami.hiramatsu.pt@hitachi.com, srinivasa@in.ibm.com, stable@vger.kernel.org


The patch titled
     Subject: kprobes: initialize before using a hlist
has been added to the -mm tree.  Its filename is
     kprobes-initialize-before-using-a-hlist.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: <stable@vger.kernel.org>
Cc: Srinivasa D S <srinivasa@in.ibm.com>
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
Subject: Subject: kprobes: initialize before using a hlist

Patches currently in -mm which might be from ananth@in.ibm.com are

origin.patch
linux-next.patch
kprobes-initialize-before-using-a-hlist.patch

