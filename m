From: akpm@linux-foundation.org
Subject: - mm-sparsec-check-the-return-value-of-sparse_index_alloc.patch removed from -mm tree
Date: Thu, 20 Dec 2007 15:36:11 -0800
Message-ID: <200712202336.lBKNaB9T018786@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53171 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753913AbXLTXgu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 18:36:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, clameter@sgi.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm/sparse.c: check the return value of sparse_index_alloc()
has been removed from the -mm tree.  Its filename was
     mm-sparsec-check-the-return-value-of-sparse_index_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm/sparse.c: check the return value of sparse_index_alloc()
From: WANG Cong <xiyou.wangcong@gmail.com>

Since sparse_index_alloc() can return NULL on memory allocation failure,
we must deal with the failure condition when calling it.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/sparse.c~mm-sparsec-check-the-return-value-of-sparse_index_alloc mm/sparse.c
--- a/mm/sparse.c~mm-sparsec-check-the-return-value-of-sparse_index_alloc
+++ a/mm/sparse.c
@@ -83,6 +83,8 @@ static int __meminit sparse_index_init(u
 		return -EEXIST;
 
 	section = sparse_index_alloc(nid);
+	if (!section)
+		return -ENOMEM;
 	/*
 	 * This lock keeps two different sections from
 	 * reallocating for the same index
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch
uml-code-tidying-under-arch-um-os-linux.patch
uml-const-and-other-tidying.patch
time-fix-sysfs_show_availablecurrent_clocksources-buffer-overflow-problem.patch
