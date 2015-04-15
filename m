From: akpm@linux-foundation.org
Subject: [merged] ocfs2-fix-typo-in-ocfs2_reserve_local_alloc_bits.patch
 removed from -mm tree
Date: Wed, 15 Apr 2015 12:08:14 -0700
Message-ID: <552eb71e.0ZsM7Vd4AWspZ3Ri%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47833 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932192AbbDOTIO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:08:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix typo in ocfs2_reserve_local_alloc_bits
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-typo-in-ocfs2_reserve_local_alloc_bits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: fix typo in ocfs2_reserve_local_alloc_bits

In ocfs2_reserve_local_alloc_bits, it calls ocfs2_error if local alloc
inode bitmap used bits mismatch, but the log mistakes it as free bits.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/localalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/localalloc.c~ocfs2-fix-typo-in-ocfs2_reserve_local_alloc_bits fs/ocfs2/localalloc.c
--- a/fs/ocfs2/localalloc.c~ocfs2-fix-typo-in-ocfs2_reserve_local_alloc_bits
+++ a/fs/ocfs2/localalloc.c
@@ -666,7 +666,7 @@ int ocfs2_reserve_local_alloc_bits(struc
 	if (le32_to_cpu(alloc->id1.bitmap1.i_used) !=
 	    ocfs2_local_alloc_count_bits(alloc)) {
 		ocfs2_error(osb->sb, "local alloc inode %llu says it has "
-			    "%u free bits, but a count shows %u",
+			    "%u used bits, but a count shows %u",
 			    (unsigned long long)le64_to_cpu(alloc->i_blkno),
 			    le32_to_cpu(alloc->id1.bitmap1.i_used),
 			    ocfs2_local_alloc_count_bits(alloc));
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

origin.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch

