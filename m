From: akpm@linux-foundation.org
Subject: [merged] ocfs2-use-swap-in-swap_refcount_rec.patch removed from
 -mm tree
Date: Mon, 29 Jun 2015 13:36:51 -0700
Message-ID: <5591ac63.mrdHVMzEXVWdVWPQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50175 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976AbbF2Ugw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:36:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, jlbec@evilplan.org, julia.lawall@lip6.fr, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: use swap() in swap_refcount_rec()
has been removed from the -mm tree.  Its filename was
     ocfs2-use-swap-in-swap_refcount_rec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: ocfs2: use swap() in swap_refcount_rec()

Use kernel.h macro definition.

Thanks to Julia Lawall for Coccinelle scripting support.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/refcounttree.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/ocfs2/refcounttree.c~ocfs2-use-swap-in-swap_refcount_rec fs/ocfs2/refcounttree.c
--- a/fs/ocfs2/refcounttree.c~ocfs2-use-swap-in-swap_refcount_rec
+++ a/fs/ocfs2/refcounttree.c
@@ -1406,11 +1406,9 @@ static int cmp_refcount_rec_by_cpos(cons
 
 static void swap_refcount_rec(void *a, void *b, int size)
 {
-	struct ocfs2_refcount_rec *l = a, *r = b, tmp;
+	struct ocfs2_refcount_rec *l = a, *r = b;
 
-	tmp = *l;
-	*l = *r;
-	*r = tmp;
+	swap(*l, *r);
 }
 
 /*
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-affs-inodec-remove-unneeded-initialization.patch
fs-affs-amigaffsc-remove-unneeded-initialization.patch
fs-affs-symlinkc-remove-unneeded-err-variable.patch
w1-masters-omap_hdq-add-support-for-1-wire-mode.patch
linux-next.patch

