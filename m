From: akpm@linux-foundation.org
Subject: [merged] ocfs2-use-memweight.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:51:10 -0700
Message-ID: <20120731185111.1A365200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:50337 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756254Ab2GaSvN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:51:13 -0400
Received: by eaao12 with SMTP id o12so241482eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:51:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: use memweight()
has been removed from the -mm tree.  Its filename was
     ocfs2-use-memweight.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: ocfs2: use memweight()

Use memweight to count the total number of bits set in memory area.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/localalloc.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/localalloc.c~ocfs2-use-memweight fs/ocfs2/localalloc.c
--- a/fs/ocfs2/localalloc.c~ocfs2-use-memweight
+++ a/fs/ocfs2/localalloc.c
@@ -784,14 +784,10 @@ bail:
 
 static u32 ocfs2_local_alloc_count_bits(struct ocfs2_dinode *alloc)
 {
-	int i;
-	u8 *buffer;
-	u32 count = 0;
+	u32 count;
 	struct ocfs2_local_alloc *la = OCFS2_LOCAL_ALLOC(alloc);
 
-	buffer = la->la_bitmap;
-	for (i = 0; i < le16_to_cpu(la->la_size); i++)
-		count += hweight8(buffer[i]);
+	count = memweight(la->la_bitmap, le16_to_cpu(la->la_size));
 
 	trace_ocfs2_local_alloc_count_bits(count);
 	return count;
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
fault-injection-fix-failcmdsh-warning.patch
linux-next.patch
ocfs2-use-find_last_bit.patch
ocfs2-use-bitmap_weight.patch

