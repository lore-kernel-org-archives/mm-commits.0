From: akpm@linux-foundation.org
Subject: [merged] ocfs2-use-swap-in-dx_leaf_sort_swap.patch removed from
 -mm tree
Date: Mon, 29 Jun 2015 13:36:49 -0700
Message-ID: <5591ac61.kicf6QXjAUfl7TFY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50170 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973AbbF2Ugt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:36:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, jlbec@evilplan.org, julia.lawall@lip6.fr, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: use swap() in dx_leaf_sort_swap()
has been removed from the -mm tree.  Its filename was
     ocfs2-use-swap-in-dx_leaf_sort_swap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: ocfs2: use swap() in dx_leaf_sort_swap()

Use kernel.h macro definition.

Thanks to Julia Lawall for Coccinelle scripting support.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dir.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN fs/ocfs2/dir.c~ocfs2-use-swap-in-dx_leaf_sort_swap fs/ocfs2/dir.c
--- a/fs/ocfs2/dir.c~ocfs2-use-swap-in-dx_leaf_sort_swap
+++ a/fs/ocfs2/dir.c
@@ -3543,13 +3543,10 @@ static void dx_leaf_sort_swap(void *a, v
 {
 	struct ocfs2_dx_entry *entry1 = a;
 	struct ocfs2_dx_entry *entry2 = b;
-	struct ocfs2_dx_entry tmp;
 
 	BUG_ON(size != sizeof(*entry1));
 
-	tmp = *entry1;
-	*entry1 = *entry2;
-	*entry2 = tmp;
+	swap(*entry1, *entry2);
 }
 
 static int ocfs2_dx_leaf_same_major(struct ocfs2_dx_leaf *dx_leaf)
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-affs-inodec-remove-unneeded-initialization.patch
fs-affs-amigaffsc-remove-unneeded-initialization.patch
fs-affs-symlinkc-remove-unneeded-err-variable.patch
w1-masters-omap_hdq-add-support-for-1-wire-mode.patch
linux-next.patch

