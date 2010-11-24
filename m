From: akpm@linux-foundation.org
Subject: + decompressors-validate-match-distance-in-decompress_unlzmac.patch added to -mm tree
Date: Wed, 24 Nov 2010 14:42:04 -0800
Message-ID: <201011242242.oAOMg4LX008336@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57017 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755726Ab0KXWmg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Nov 2010 17:42:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lasse.collin@tukaani.org, alain@knaff.lu, albin.tonnerre@free-electrons.com, hpa@zytor.com, phillip@lougher.demon.co.uk


The patch titled
     Decompressors: validate match distance in decompress_unlzma.c
has been added to the -mm tree.  Its filename is
     decompressors-validate-match-distance-in-decompress_unlzmac.patch

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
Subject: Decompressors: validate match distance in decompress_unlzma.c
From: Lasse Collin <lasse.collin@tukaani.org>

Validate the newly decoded distance (rep0) in process_bit1().  This is to
detect corrupt LZMA data quickly.  The old code can run for long time
producing garbage until it hits the end of the input.

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alain Knaff <alain@knaff.lu>
Cc: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_unlzma.c      |    3 +
 lib/decompress_unlzma.c.orig |   53 +++++++++++++++++++--------------
 2 files changed, 35 insertions(+), 21 deletions(-)

diff -puN lib/decompress_unlzma.c~decompressors-validate-match-distance-in-decompress_unlzmac lib/decompress_unlzma.c
--- a/lib/decompress_unlzma.c~decompressors-validate-match-distance-in-decompress_unlzmac
+++ a/lib/decompress_unlzma.c
@@ -522,6 +522,9 @@ static inline int INIT process_bit1(stru
 			cst->rep0 = pos_slot;
 		if (++(cst->rep0) == 0)
 			return 0;
+		if (cst->rep0 > wr->header->dict_size
+				|| cst->rep0 > get_pos(wr))
+			return -1;
 	}
 
 	len += LZMA_MATCH_MIN_LEN;
diff -puN lib/decompress_unlzma.c.orig~decompressors-validate-match-distance-in-decompress_unlzmac lib/decompress_unlzma.c.orig
--- a/lib/decompress_unlzma.c.orig~decompressors-validate-match-distance-in-decompress_unlzmac
+++ a/lib/decompress_unlzma.c.orig
@@ -313,32 +313,38 @@ static inline uint8_t INIT peek_old_byte
 
 }
 
-static inline void INIT write_byte(struct writer *wr, uint8_t byte)
+static inline int INIT write_byte(struct writer *wr, uint8_t byte)
 {
 	wr->buffer[wr->buffer_pos++] = wr->previous_byte = byte;
 	if (wr->flush && wr->buffer_pos == wr->header->dict_size) {
 		wr->buffer_pos = 0;
 		wr->global_pos += wr->header->dict_size;
-		wr->flush((char *)wr->buffer, wr->header->dict_size);
+		if (wr->flush((char *)wr->buffer, wr->header->dict_size)
+				!= wr->header->dict_size)
+			return -1;
 	}
+	return 0;
 }
 
 
-static inline void INIT copy_byte(struct writer *wr, uint32_t offs)
+static inline int INIT copy_byte(struct writer *wr, uint32_t offs)
 {
-	write_byte(wr, peek_old_byte(wr, offs));
+	return write_byte(wr, peek_old_byte(wr, offs));
 }
 
-static inline void INIT copy_bytes(struct writer *wr,
+static inline int INIT copy_bytes(struct writer *wr,
 					 uint32_t rep0, int len)
 {
 	do {
-		copy_byte(wr, rep0);
+		if (copy_byte(wr, rep0))
+			return -1;
 		len--;
 	} while (len != 0 && wr->buffer_pos < wr->header->dst_size);
+
+	return len;
 }
 
-static inline void INIT process_bit0(struct writer *wr, struct rc *rc,
+static inline int INIT process_bit0(struct writer *wr, struct rc *rc,
 				     struct cstate *cst, uint16_t *p,
 				     int pos_state, uint16_t *prob,
 				     int lc, uint32_t literal_pos_mask) {
@@ -372,16 +378,17 @@ static inline void INIT process_bit0(str
 		uint16_t *prob_lit = prob + mi;
 		rc_get_bit(rc, prob_lit, &mi);
 	}
-	write_byte(wr, mi);
 	if (cst->state < 4)
 		cst->state = 0;
 	else if (cst->state < 10)
 		cst->state -= 3;
 	else
 		cst->state -= 6;
+
+	return write_byte(wr, mi);
 }
 
-static inline void INIT process_bit1(struct writer *wr, struct rc *rc,
+static inline int INIT process_bit1(struct writer *wr, struct rc *rc,
 					    struct cstate *cst, uint16_t *p,
 					    int pos_state, uint16_t *prob) {
   int offset;
@@ -412,8 +419,7 @@ static inline void INIT process_bit1(str
 
 				cst->state = cst->state < LZMA_NUM_LIT_STATES ?
 					9 : 11;
-				copy_byte(wr, cst->rep0);
-				return;
+				return copy_byte(wr, cst->rep0);
 			} else {
 				rc_update_bit_1(rc, prob);
 			}
@@ -515,12 +521,12 @@ static inline void INIT process_bit1(str
 		} else
 			cst->rep0 = pos_slot;
 		if (++(cst->rep0) == 0)
-			return;
+			return 0;
 	}
 
 	len += LZMA_MATCH_MIN_LEN;
 
-	copy_bytes(wr, cst->rep0, len);
+	return copy_bytes(wr, cst->rep0, len);
 }
 
 
@@ -623,11 +629,17 @@ STATIC inline int INIT unlzma(unsigned c
 		int pos_state =	get_pos(&wr) & pos_state_mask;
 		uint16_t *prob = p + LZMA_IS_MATCH +
 			(cst.state << LZMA_NUM_POS_BITS_MAX) + pos_state;
-		if (rc_is_bit_0(&rc, prob))
-			process_bit0(&wr, &rc, &cst, p, pos_state, prob,
-				     lc, literal_pos_mask);
-		else {
-			process_bit1(&wr, &rc, &cst, p, pos_state, prob);
+		if (rc_is_bit_0(&rc, prob)) {
+			if (process_bit0(&wr, &rc, &cst, p, pos_state, prob,
+					lc, literal_pos_mask)) {
+				error("LZMA data is corrupt");
+				goto exit_3;
+			}
+		} else {
+			if (process_bit1(&wr, &rc, &cst, p, pos_state, prob)) {
+				error("LZMA data is corrupt");
+				goto exit_3;
+			}
 			if (cst.rep0 == 0)
 				break;
 		}
@@ -637,9 +649,8 @@ STATIC inline int INIT unlzma(unsigned c
 
 	if (posp)
 		*posp = rc.ptr-rc.buffer;
-	if (wr.flush)
-		wr.flush(wr.buffer, wr.buffer_pos);
-	ret = 0;
+	if (!wr.flush || wr.flush(wr.buffer, wr.buffer_pos) == wr.buffer_pos)
+		ret = 0;
 exit_3:
 	large_free(p);
 exit_2:
_

Patches currently in -mm which might be from lasse.collin@tukaani.org are

decompressors-add-missing-init-ie-__init.patch
decompressors-get-rid-of-set_error_fn-macro.patch
decompressors-include-linux-slabh-in-linux-decompress-mmh.patch
decompressors-remove-unused-function-from-lib-decompress_unlzmac.patch
decompressors-fix-header-validation-in-decompress_unlzmac.patch
decompressors-check-for-read-errors-in-decompress_unlzmac.patch
decompressors-check-for-write-errors-in-decompress_unlzmac.patch
decompressors-validate-match-distance-in-decompress_unlzmac.patch
decompressors-check-for-write-errors-in-decompress_unlzoc.patch
decompressors-check-input-size-in-decompress_unlzoc.patch
decompressors-fix-callback-to-callback-mode-in-decompress_unlzoc.patch

