From: akpm@linux-foundation.org
Subject: [wrecked] cciss-fix-botched-tag-masking-for-scsi-tape-commands.patch removed from -mm tree
Date: Tue, 11 Jan 2011 12:19:21 -0800
Message-ID: <201101112021.p0BKLkc6004899@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753413Ab1AKUWE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Jan 2011 15:22:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: scameron@beardog.cce.hp.com, axboe@kernel.dk, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     cciss: fix botched tag masking for scsi tape commands
has been removed from the -mm tree.  Its filename was
     cciss-fix-botched-tag-masking-for-scsi-tape-commands.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cciss: fix botched tag masking for scsi tape commands
From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

In process_non_indexed_cmd() we were only masking off the low two bits
when comparing tags vs.  busaddr, and not taking into account the fact
that in "performant" mode, three bits of block fetch table indexes were
stuffed into the tag, and needed to be masked out for the comparison to
work.

This resulted in spurious "bad tag" messages, and command completions
getting ignored for any scsi tape i/o and any i/o coming through
CCISS_BIG_PASSTHRU which required more than one scatter gather entry
(fewer than two worked because in such cases the 3 bits we failed to mask
off happened to be zero anyway.)

I also noticed we were repeatedly masking the bits off the tag in a loop
when doing it once at the top of the loop would have sufficed, so I fixed
that as well.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN drivers/block/cciss.c~cciss-fix-botched-tag-masking-for-scsi-tape-commands drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-fix-botched-tag-masking-for-scsi-tape-commands
+++ a/drivers/block/cciss.c
@@ -3136,10 +3136,13 @@ static inline u32 cciss_tag_to_index(u32
 	return tag >> DIRECT_LOOKUP_SHIFT;
 }
 
-static inline u32 cciss_tag_discard_error_bits(u32 tag)
+static inline u32 cciss_tag_discard_error_bits(ctlr_info_t *h, u32 tag)
 {
-#define CCISS_ERROR_BITS 0x03
-	return tag & ~CCISS_ERROR_BITS;
+#define CCISS_PERF_ERROR_BITS ((1 << DIRECT_LOOKUP_SHIFT) - 1)
+#define CCISS_SIMPLE_ERROR_BITS 0x03
+	if (likely(h->transMethod == CFGTBL_Trans_Performant))
+		return tag & ~CCISS_PERF_ERROR_BITS;
+	return tag & ~CCISS_SIMPLE_ERROR_BITS;
 }
 
 static inline void cciss_mark_tag_indexed(u32 *tag)
@@ -3400,15 +3403,13 @@ static inline u32 process_indexed_cmd(ct
 /* process completion of a non-indexed command */
 static inline u32 process_nonindexed_cmd(ctlr_info_t *h, u32 raw_tag)
 {
-	u32 tag;
 	CommandList_struct *c = NULL;
 	struct hlist_node *tmp;
 	__u32 busaddr_masked, tag_masked;
 
-	tag = cciss_tag_discard_error_bits(raw_tag);
+	tag_masked = cciss_tag_discard_error_bits(h, raw_tag);
 	hlist_for_each_entry(c, tmp, &h->cmpQ, list) {
-		busaddr_masked = cciss_tag_discard_error_bits(c->busaddr);
-		tag_masked = cciss_tag_discard_error_bits(tag);
+		busaddr_masked = cciss_tag_discard_error_bits(h, c->busaddr);
 		if (busaddr_masked == tag_masked) {
 			finish_cmd(h, c, raw_tag);
 			return next_command(h);
_

Patches currently in -mm which might be from scameron@beardog.cce.hp.com are

origin.patch
cciss-make-cciss_revalidate-not-loop-through-ciss_max_luns-volumes-unnecessarily.patch

