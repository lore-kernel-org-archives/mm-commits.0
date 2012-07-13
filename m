From: akpm@linux-foundation.org
Subject: + rbtree-fix-incorrect-rbtree-node-insertion-in-fs-proc-proc_sysctlc.patch added to -mm tree
Date: Fri, 13 Jul 2012 13:30:43 -0700
Message-ID: <20120713203044.5E9AB1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:44602 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab2GMUap (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 16:30:45 -0400
Received: by qabg24 with SMTP id g24so95310qab.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 13:30:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, axboe@kernel.dk, daniel.santos@pobox.com, dwmw2@infradead.org, ebiederm@xmission.com, riel@redhat.com


The patch titled
     Subject: rbtree: fix incorrect rbtree node insertion in fs/proc/proc_sysctl.c
has been added to the -mm tree.  Its filename is
     rbtree-fix-incorrect-rbtree-node-insertion-in-fs-proc-proc_sysctlc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: David Woodhouse <dwmw2@infradead.org>
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
Subject: Subject: rbtree: fix incorrect rbtree node insertion in fs/proc/proc_sysctl.c

Patches currently in -mm which might be from walken@google.com are

slab-do-not-call-compound_head-in-page_get_cache.patch
rbtree-reference-documentation-rbtreetxt-for-usage-instructions.patch
rbtree-empty-nodes-have-no-color.patch
rbtree-fix-incorrect-rbtree-node-insertion-in-fs-proc-proc_sysctlc.patch
rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec.patch
rbtree-performance-and-correctness-test.patch
rbtree-break-out-of-rb_insert_color-loop-after-tree-rotation.patch
rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary.patch
rbtree-low-level-optimizations-in-rb_insert_color.patch
rbtree-adjust-node-color-in-__rb_erase_color-only-when-necessary.patch
rbtree-optimize-case-selection-logic-in-__rb_erase_color.patch
rbtree-low-level-optimizations-in-__rb_erase_color.patch
rbtree-coding-style-adjustments.patch

