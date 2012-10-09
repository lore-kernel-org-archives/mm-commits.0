From: akpm@linux-foundation.org
Subject: [merged] rbtree-fix-incorrect-rbtree-node-insertion-in-fs-proc-proc_sysctlc.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:09:02 -0700
Message-ID: <20121009180903.4CE77200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:52095 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756729Ab2JISJF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:09:05 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so364534wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:09:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, David.Woodhouse@intel.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, axboe@kernel.dk, daniel.santos@pobox.com, ebiederm@xmission.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rbtree: fix incorrect rbtree node insertion in fs/proc/proc_sysctl.c
has been removed from the -mm tree.  Its filename was
     rbtree-fix-incorrect-rbtree-node-insertion-in-fs-proc-proc_sysctlc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: rbtree: fix incorrect rbtree node insertion in fs/proc/proc_sysctl.c

The recently added code to use rbtrees in sysctl did not follow the proper
rbtree interface on insertion - it was calling rb_link_node() which
inserts a new node into the binary tree, but missed the call to
rb_insert_color() which properly balances the rbtree and establishes all
expected rbtree invariants.

I found out about this only because faulty commit also used
rb_init_node(), which I am removing within this patchset.  But I think
it's an easy mistake to make, and it makes me wonder if we should change
the rbtree API so that insertions would be done with a single rb_insert()
call (even if its implementation could still inline the rb_link_node()
part and call a private __rb_insert_color function to do the rebalancing).

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: David Woodhouse <David.Woodhouse@intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Daniel Santos <daniel.santos@pobox.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/proc/proc_sysctl.c~rbtree-fix-incorrect-rbtree-node-insertion-in-fs-proc-proc_sysctlc fs/proc/proc_sysctl.c
--- a/fs/proc/proc_sysctl.c~rbtree-fix-incorrect-rbtree-node-insertion-in-fs-proc-proc_sysctlc
+++ a/fs/proc/proc_sysctl.c
@@ -142,6 +142,7 @@ static int insert_entry(struct ctl_table
 	}
 
 	rb_link_node(node, parent, p);
+	rb_insert_color(node, &head->parent->root);
 	return 0;
 }
 
_

Patches currently in -mm which might be from walken@google.com are

origin.patch
prio_tree-remove-fix.patch

