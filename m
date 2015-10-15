From: akpm@linux-foundation.org
Subject: +
 nilfs2-fix-gcc-uninitialized-variable-warnings-in-powerpc-build.patch added to -mm tree
Date: Thu, 15 Oct 2015 13:57:51 -0700
Message-ID: <5620134f.pkceMRS4GTdCjM0S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59085 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbbJOU5w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Oct 2015 16:57:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: fix gcc uninitialized-variable warnings in powerpc build
has been added to the -mm tree.  Its filename is
     nilfs2-fix-gcc-uninitialized-variable-warnings-in-powerpc-build.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-fix-gcc-uninitialized-variable-warnings-in-powerpc-build.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-fix-gcc-uninitialized-variable-warnings-in-powerpc-build.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: fix gcc uninitialized-variable warnings in powerpc build

Some false positive warnings are reported for powerpc build.

The following warnings are reported in
 http://kisskb.ellerman.id.au/kisskb/buildresult/12519703/

   CC      fs/nilfs2/super.o
 fs/nilfs2/super.c: In function 'nilfs_resize_fs':
 fs/nilfs2/super.c:376:2: warning: 'blocknr' may be used uninitialized in this function [-Wuninitialized]
 fs/nilfs2/super.c:362:11: note: 'blocknr' was declared here
   CC      fs/nilfs2/recovery.o
 fs/nilfs2/recovery.c: In function 'nilfs_salvage_orphan_logs':
 fs/nilfs2/recovery.c:631:21: warning: 'sum' may be used uninitialized in this function [-Wuninitialized]
 fs/nilfs2/recovery.c:585:32: note: 'sum' was declared here
 fs/nilfs2/recovery.c: In function 'nilfs_search_super_root':
 fs/nilfs2/recovery.c:873:11: warning: 'sum' may be used uninitialized in this function [-Wuninitialized]

Another similar warning is reported in
 http://kisskb.ellerman.id.au/kisskb/buildresult/12520079/

   CC      fs/nilfs2/btree.o
 fs/nilfs2/btree.c: In function 'nilfs_btree_convert_and_insert':
 include/asm-generic/bitops/non-atomic.h:105:20: warning: 'bh' may be used uninitialized in this function [-Wuninitialized]
 fs/nilfs2/btree.c:1859:22: note: 'bh' was declared here

This cleans out these warnings by forcing the variables to be initialized.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/btree.c    |    2 +-
 fs/nilfs2/recovery.c |    4 ++--
 fs/nilfs2/super.c    |    5 ++++-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff -puN fs/nilfs2/btree.c~nilfs2-fix-gcc-uninitialized-variable-warnings-in-powerpc-build fs/nilfs2/btree.c
--- a/fs/nilfs2/btree.c~nilfs2-fix-gcc-uninitialized-variable-warnings-in-powerpc-build
+++ a/fs/nilfs2/btree.c
@@ -1851,7 +1851,7 @@ int nilfs_btree_convert_and_insert(struc
 				   __u64 key, __u64 ptr,
 				   const __u64 *keys, const __u64 *ptrs, int n)
 {
-	struct buffer_head *bh;
+	struct buffer_head *bh = NULL;
 	union nilfs_bmap_ptr_req dreq, nreq, *di, *ni;
 	struct nilfs_bmap_stats stats;
 	int ret;
diff -puN fs/nilfs2/recovery.c~nilfs2-fix-gcc-uninitialized-variable-warnings-in-powerpc-build fs/nilfs2/recovery.c
--- a/fs/nilfs2/recovery.c~nilfs2-fix-gcc-uninitialized-variable-warnings-in-powerpc-build
+++ a/fs/nilfs2/recovery.c
@@ -582,7 +582,7 @@ static int nilfs_do_roll_forward(struct
 				 struct nilfs_recovery_info *ri)
 {
 	struct buffer_head *bh_sum = NULL;
-	struct nilfs_segment_summary *sum;
+	struct nilfs_segment_summary *sum = NULL;
 	sector_t pseg_start;
 	sector_t seg_start, seg_end;  /* Starting/ending DBN of full segment */
 	unsigned long nsalvaged_blocks = 0;
@@ -814,7 +814,7 @@ int nilfs_search_super_root(struct the_n
 			    struct nilfs_recovery_info *ri)
 {
 	struct buffer_head *bh_sum = NULL;
-	struct nilfs_segment_summary *sum;
+	struct nilfs_segment_summary *sum = NULL;
 	sector_t pseg_start, pseg_end, sr_pseg_start = 0;
 	sector_t seg_start, seg_end; /* range of full segment (block number) */
 	sector_t b, end;
diff -puN fs/nilfs2/super.c~nilfs2-fix-gcc-uninitialized-variable-warnings-in-powerpc-build fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~nilfs2-fix-gcc-uninitialized-variable-warnings-in-powerpc-build
+++ a/fs/nilfs2/super.c
@@ -361,7 +361,7 @@ static int nilfs_move_2nd_super(struct s
 	struct nilfs_super_block *nsbp;
 	sector_t blocknr, newblocknr;
 	unsigned long offset;
-	int sb2i = -1;  /* array index of the secondary superblock */
+	int sb2i;  /* array index of the secondary superblock */
 	int ret = 0;
 
 	/* nilfs->ns_sem must be locked by the caller. */
@@ -372,6 +372,9 @@ static int nilfs_move_2nd_super(struct s
 	} else if (nilfs->ns_sbh[0]->b_blocknr > nilfs->ns_first_data_block) {
 		sb2i = 0;
 		blocknr = nilfs->ns_sbh[0]->b_blocknr;
+	} else {
+		sb2i = -1;
+		blocknr = 0;
 	}
 	if (sb2i >= 0 && (u64)blocknr << nilfs->ns_blocksize_bits == sb2off)
 		goto out;  /* super block location is unchanged */
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-use-nilfs_warning-in-allocator-implementation.patch
nilfs2-do-not-call-nilfs_mdt_bgl_lock-needlessly.patch
nilfs2-refactor-nilfs_palloc_find_available_slot.patch
nilfs2-get-rid-of-nilfs_palloc_group_is_in.patch
nilfs2-add-helper-functions-to-delete-blocks-from-dat-file.patch
nilfs2-free-unused-dat-file-blocks-during-garbage-collection.patch
maintainers-nilfs2-add-header-file-for-tracing.patch
nilfs2-fix-gcc-unused-but-set-variable-warnings.patch
nilfs2-fix-gcc-uninitialized-variable-warnings-in-powerpc-build.patch

