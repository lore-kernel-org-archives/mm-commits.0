From: akpm@linux-foundation.org
Subject: [merged] ocfs2-fix-the-end-cluster-offset-of-fiemap.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:41:55 -0700
Message-ID: <52321903.YoPTW+T4SymndbdP%akpm__6855.3167781376$1379014932$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57924 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab3ILTl4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:41:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wb@munzinger.de, sunil.mushran@gmail.com, stable@vger.kernel.org, mfasheh@suse.de, jlbec@evilplan.org, jeff.liu@oracle.com

Subject: [merged] ocfs2-fix-the-end-cluster-offset-of-fiemap.patch removed from -mm tree
To: jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.de,stable@vger.kernel.org,sunil.mushran@gmail.com,wb@munzinger.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:41:55 -0700


The patch titled
     Subject: ocfs2: fix the end cluster offset of FIEMAP
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-the-end-cluster-offset-of-fiemap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jie Liu <jeff.liu@oracle.com>
Subject: ocfs2: fix the end cluster offset of FIEMAP

Call fiemap ioctl(2) with given start offset as well as an desired mapping
range should show extents if possible.  However, we somehow figure out the
end offset of mapping via 'mapping_end -= cpos' before iterating the
extent records which would cause problems if the given fiemap length is
too small to a cluster size, e.g,

Cluster size 4096:
debugfs.ocfs2 1.6.3
        Block Size Bits: 12   Cluster Size Bits: 12

The extended fiemap test utility From David:
https://gist.github.com/anonymous/6172331

# dd if=/dev/urandom of=/ocfs2/test_file bs=1M count=1000
# ./fiemap /ocfs2/test_file 4096 10
start: 4096, length: 10
File /ocfs2/test_file has 0 extents:
#	Logical          Physical         Length           Flags
	^^^^^ <-- No extent is shown

In this case, at ocfs2_fiemap(): cpos == mapping_end == 1. Hence the
loop of searching extent records was not executed at all.

This patch remove the in question 'mapping_end -= cpos', and loops
until the cpos is larger than the mapping_end as usual.

# ./fiemap /ocfs2/test_file 4096 10
start: 4096, length: 10
File /ocfs2/test_file has 1 extents:
#	Logical          Physical         Length           Flags
0:	0000000000000000 0000000056a01000 0000000006a00000 0000

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Reported-by: David Weber <wb@munzinger.de>
Tested-by: David Weber <wb@munzinger.de>
Cc: Sunil Mushran <sunil.mushran@gmail.com>
Cc: Mark Fashen <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/extent_map.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/ocfs2/extent_map.c~ocfs2-fix-the-end-cluster-offset-of-fiemap fs/ocfs2/extent_map.c
--- a/fs/ocfs2/extent_map.c~ocfs2-fix-the-end-cluster-offset-of-fiemap
+++ a/fs/ocfs2/extent_map.c
@@ -781,7 +781,6 @@ int ocfs2_fiemap(struct inode *inode, st
 	cpos = map_start >> osb->s_clustersize_bits;
 	mapping_end = ocfs2_clusters_for_bytes(inode->i_sb,
 					       map_start + map_len);
-	mapping_end -= cpos;
 	is_last = 0;
 	while (cpos < mapping_end && !is_last) {
 		u32 fe_flags;
_

Patches currently in -mm which might be from jeff.liu@oracle.com are

origin.patch
ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch
ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
memcg-correct-resource_max-to-ullong_max.patch
memcg-rename-resource_max-to-res_counter_max.patch
memcg-avoid-overflow-caused-by-page_align.patch
memcg-reduce-function-dereference.patch

