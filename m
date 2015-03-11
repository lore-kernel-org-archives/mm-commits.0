From: akpm@linux-foundation.org
Subject: + ocfs2-fix-typo-in-ocfs2_reserve_local_alloc_bits.patch added to -mm tree
Date: Wed, 11 Mar 2015 14:10:44 -0700
Message-ID: <5500af54.SiV0vA9QXlx5BrjO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50184 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbbCKVKp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Mar 2015 17:10:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix typo in ocfs2_reserve_local_alloc_bits
has been added to the -mm tree.  Its filename is
     ocfs2-fix-typo-in-ocfs2_reserve_local_alloc_bits.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-typo-in-ocfs2_reserve_local_alloc_bits.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-typo-in-ocfs2_reserve_local_alloc_bits.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-make-append_dio-an-incompat-feature.patch
ocfs2-fix-a-typing-error-in-ocfs2_direct_io_write.patch
ocfs2-no-need-get-dinode-bh-when-zeroing-extend.patch
ocfs2-take-inode-lock-when-get-clusters.patch
ocfs2-do-not-use-ocfs2_zero_extend-during-direct-io.patch
ocfs2-fix-typo-in-ocfs2_reserve_local_alloc_bits.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages-v3.patch

