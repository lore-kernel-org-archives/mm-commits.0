From: akpm@linux-foundation.org
Subject: + decompressors-add-missing-init-ie-__init.patch added to -mm tree
Date: Mon, 22 Nov 2010 12:01:20 -0800
Message-ID: <201011222001.oAMK1KBp006638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757448Ab0KVUB7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Nov 2010 15:01:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lasse.collin@tukaani.org, alain@knaff.lu, albin.tonnerre@free-electrons.com, hpa@zytor.com, phillip@lougher.demon.co.uk


The patch titled
     Decompressors: add missing INIT (i.e. __init)
has been added to the -mm tree.  Its filename is
     decompressors-add-missing-init-ie-__init.patch

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
Subject: Decompressors: add missing INIT (i.e. __init)
From: Lasse Collin <lasse.collin@tukaani.org>

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alain Knaff <alain@knaff.lu>
Cc: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_inflate.c |    2 +-
 lib/decompress_unlzma.c  |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/decompress_inflate.c~decompressors-add-missing-init-ie-__init lib/decompress_inflate.c
--- a/lib/decompress_inflate.c~decompressors-add-missing-init-ie-__init
+++ a/lib/decompress_inflate.c
@@ -27,7 +27,7 @@
 
 #define GZIP_IOBUF_SIZE (16*1024)
 
-static int nofill(void *buffer, unsigned int len)
+static int INIT nofill(void *buffer, unsigned int len)
 {
 	return -1;
 }
diff -puN lib/decompress_unlzma.c~decompressors-add-missing-init-ie-__init lib/decompress_unlzma.c
--- a/lib/decompress_unlzma.c~decompressors-add-missing-init-ie-__init
+++ a/lib/decompress_unlzma.c
@@ -82,7 +82,7 @@ struct rc {
 #define RC_MODEL_TOTAL_BITS 11
 
 
-static int nofill(void *buffer, unsigned int len)
+static int INIT nofill(void *buffer, unsigned int len)
 {
 	return -1;
 }
@@ -169,7 +169,7 @@ static inline void INIT rc_update_bit_0(
 	rc->range = rc->bound;
 	*p += ((1 << RC_MODEL_TOTAL_BITS) - *p) >> RC_MOVE_BITS;
 }
-static inline void rc_update_bit_1(struct rc *rc, uint16_t *p)
+static inline void INIT rc_update_bit_1(struct rc *rc, uint16_t *p)
 {
 	rc->range -= rc->bound;
 	rc->code -= rc->bound;
_

Patches currently in -mm which might be from lasse.collin@tukaani.org are

decompressors-add-missing-init-ie-__init.patch
decompressors-get-rid-of-set_error_fn-macro.patch
decompressors-include-linux-slabh-in-linux-decompress-mmh.patch
decompressors-remove-unused-function-from-lib-decompress_unlzmac.patch

