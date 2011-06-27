From: akpm@linux-foundation.org
Subject: + ocfs2-avoid-unaligned-access-to-dqc_bitmap.patch added to -mm tree
Date: Mon, 27 Jun 2011 14:55:34 -0700
Message-ID: <201106272155.p5RLtYH8029627@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753875Ab1F0Vzo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Jun 2011 17:55:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, jlbec@evilplan.org, mfasheh@suse.com


The patch titled
     ocfs2: avoid unaligned access to dqc_bitmap
has been added to the -mm tree.  Its filename is
     ocfs2-avoid-unaligned-access-to-dqc_bitmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ocfs2: avoid unaligned access to dqc_bitmap
From: Akinobu Mita <akinobu.mita@gmail.com>

The dqc_bitmap field of struct ocfs2_local_disk_chunk is 32-bit aligned,
but not 64-bit aligned.  The dqc_bitmap is accessed by ocfs2_set_bit(),
ocfs2_clear_bit(), ocfs2_test_bit(), or ocfs2_find_next_zero_bit().  These
are wrapper macros for ext2_*_bit() which need to take an unsigned long
aligned address (though some architectures are able to handle unaligned
address correctly)

So some 64bit architectures may not be able to access the dqc_bitmap
correctly.

This avoids such unaligned access by using another wrapper functions for
ext2_*_bit().  The code is taken from fs/ext4/mballoc.c which also need to
handle unaligned bitmap access.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/ocfs2.h       |   47 +++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/quota_local.c |   10 ++++----
 2 files changed, 52 insertions(+), 5 deletions(-)

diff -puN fs/ocfs2/ocfs2.h~ocfs2-avoid-unaligned-access-to-dqc_bitmap fs/ocfs2/ocfs2.h
--- a/fs/ocfs2/ocfs2.h~ocfs2-avoid-unaligned-access-to-dqc_bitmap
+++ a/fs/ocfs2/ocfs2.h
@@ -849,5 +849,52 @@ static inline void _ocfs2_clear_bit(unsi
 #define ocfs2_test_bit test_bit_le
 #define ocfs2_find_next_zero_bit find_next_zero_bit_le
 #define ocfs2_find_next_bit find_next_bit_le
+
+static inline void *correct_addr_and_bit_unaligned(int *bit, void *addr)
+{
+#if BITS_PER_LONG == 64
+	*bit += ((unsigned long) addr & 7UL) << 3;
+	addr = (void *) ((unsigned long) addr & ~7UL);
+#elif BITS_PER_LONG == 32
+	*bit += ((unsigned long) addr & 3UL) << 3;
+	addr = (void *) ((unsigned long) addr & ~3UL);
+#else
+#error "how many bits you are?!"
+#endif
+	return addr;
+}
+
+static inline void ocfs2_set_bit_unaligned(int bit, void *bitmap)
+{
+	bitmap = correct_addr_and_bit_unaligned(&bit, bitmap);
+	ocfs2_set_bit(bit, bitmap);
+}
+
+static inline void ocfs2_clear_bit_unaligned(int bit, void *bitmap)
+{
+	bitmap = correct_addr_and_bit_unaligned(&bit, bitmap);
+	ocfs2_clear_bit(bit, bitmap);
+}
+
+static inline int ocfs2_test_bit_unaligned(int bit, void *bitmap)
+{
+	bitmap = correct_addr_and_bit_unaligned(&bit, bitmap);
+	return ocfs2_test_bit(bit, bitmap);
+}
+
+static inline int ocfs2_find_next_zero_bit_unaligned(void *bitmap, int max,
+							int start)
+{
+	int fix = 0, ret, tmpmax;
+	bitmap = correct_addr_and_bit_unaligned(&fix, bitmap);
+	tmpmax = max + fix;
+	start += fix;
+
+	ret = ocfs2_find_next_zero_bit(bitmap, tmpmax, start) - fix;
+	if (ret > max)
+		return max;
+	return ret;
+}
+
 #endif  /* OCFS2_H */
 
diff -puN fs/ocfs2/quota_local.c~ocfs2-avoid-unaligned-access-to-dqc_bitmap fs/ocfs2/quota_local.c
--- a/fs/ocfs2/quota_local.c~ocfs2-avoid-unaligned-access-to-dqc_bitmap
+++ a/fs/ocfs2/quota_local.c
@@ -549,8 +549,8 @@ static int ocfs2_recover_local_quota_fil
 				goto out_commit;
 			}
 			lock_buffer(qbh);
-			WARN_ON(!ocfs2_test_bit(bit, dchunk->dqc_bitmap));
-			ocfs2_clear_bit(bit, dchunk->dqc_bitmap);
+			WARN_ON(!ocfs2_test_bit_unaligned(bit, dchunk->dqc_bitmap));
+			ocfs2_clear_bit_unaligned(bit, dchunk->dqc_bitmap);
 			le32_add_cpu(&dchunk->dqc_free, 1);
 			unlock_buffer(qbh);
 			ocfs2_journal_dirty(handle, qbh);
@@ -944,7 +944,7 @@ static struct ocfs2_quota_chunk *ocfs2_f
 		      * ol_quota_entries_per_block(sb);
 	}
 
-	found = ocfs2_find_next_zero_bit(dchunk->dqc_bitmap, len, 0);
+	found = ocfs2_find_next_zero_bit_unaligned(dchunk->dqc_bitmap, len, 0);
 	/* We failed? */
 	if (found == len) {
 		mlog(ML_ERROR, "Did not find empty entry in chunk %d with %u"
@@ -1208,7 +1208,7 @@ static void olq_alloc_dquot(struct buffe
 	struct ocfs2_local_disk_chunk *dchunk;
 
 	dchunk = (struct ocfs2_local_disk_chunk *)bh->b_data;
-	ocfs2_set_bit(*offset, dchunk->dqc_bitmap);
+	ocfs2_set_bit_unaligned(*offset, dchunk->dqc_bitmap);
 	le32_add_cpu(&dchunk->dqc_free, -1);
 }
 
@@ -1289,7 +1289,7 @@ int ocfs2_local_release_dquot(handle_t *
 			(od->dq_chunk->qc_headerbh->b_data);
 	/* Mark structure as freed */
 	lock_buffer(od->dq_chunk->qc_headerbh);
-	ocfs2_clear_bit(offset, dchunk->dqc_bitmap);
+	ocfs2_clear_bit_unaligned(offset, dchunk->dqc_bitmap);
 	le32_add_cpu(&dchunk->dqc_free, 1);
 	unlock_buffer(od->dq_chunk->qc_headerbh);
 	ocfs2_journal_dirty(handle, od->dq_chunk->qc_headerbh);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
dm-use-use-proper-little-endian-bitops.patch
ext4-use-proper-little-endian-bitops.patch
ocfs2-avoid-unaligned-access-to-dqc_bitmap.patch
md-use-proper-little-endian-bitops.patch
reiserfs-use-proper-little-endian-bitops.patch
reiserfs-use-hweight_long.patch
asm-generic-add-another-generic-ext2-atomic-bitops.patch

