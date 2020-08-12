Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C783C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:35:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AC87207DA
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196104;
	bh=wQKWqrd1pON3WTNBy0y07AFYCQCCJOUHRbJrM9F/p6Q=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=BCVt26yua1fHi70E+s6NTEqQmkzk/2mGhXH2wztxSnPJIoMt2UAIVpRQ9D2AA4MY3
	 RyaVnYytM86zAwcPaRY+bzaoBO/5ULL3fF12orzzL4tL5vlDi7ewLywBShLoj19WWw
	 wxGRwCgqMZGoaNwcfUhUOzILKHB/gcblQ6HAixvo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgHLBfD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:35:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:35886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgHLBfC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:35:02 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D46C82080C;
        Wed, 12 Aug 2020 01:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196101;
        bh=wQKWqrd1pON3WTNBy0y07AFYCQCCJOUHRbJrM9F/p6Q=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=l22fQVJZpFumL+SSevljmdF2e+Z6VrIR9ta4dy4gOKnP9QHXhhV0P3djx0QQEbisb
         jQq3EUbAKoKnf0z6eEwWBUcjrY02rM6fzQ9PZhmj4pM7SPMFEmNOo0t1fcLKVjc0tK
         S2bBeSAB2sfdsrKtVoM4Anf1Ji0JQY20x+ulRMdE=
Date:   Tue, 11 Aug 2020 18:35:00 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     4sschmid@informatik.uni-hamburg.de, akpm@linux-foundation.org,
        gaoxiang25@huawei.com, gregkh@linuxfoundation.org,
        linux-mm@kvack.org, mingo@kernel.org, mm-commits@vger.kernel.org,
        nivedita@alum.mit.edu, terrelln@fb.com,
        torvalds@linux-foundation.org, yann.collet.73@gmail.com
Subject:  [patch 090/165] lz4: fix kernel decompression speed
Message-ID: <20200812013500.TPqi6kXv2%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Nick Terrell <terrelln@fb.com>
Subject: lz4: fix kernel decompression speed

This patch replaces all memcpy() calls with LZ4_memcpy() which calls
__builtin_memcpy() so the compiler can inline it.

LZ4 relies heavily on memcpy() with a constant size being inlined.  In x86
and i386 pre-boot environments memcpy() cannot be inlined because memcpy()
doesn't get defined as __builtin_memcpy().

An equivalent patch has been applied upstream so that the next import
won't lose this change [1].

I've measured the kernel decompression speed using QEMU before and after
this patch for the x86_64 and i386 architectures.  The speed-up is about
10x as shown below.

Code	Arch	Kernel Size	Time	Speed
v5.8	x86_64	11504832 B	148 ms	 79 MB/s
patch	x86_64	11503872 B	 13 ms	885 MB/s
v5.8	i386	 9621216 B	 91 ms	106 MB/s
patch	i386	 9620224 B	 10 ms	962 MB/s

I also measured the time to decompress the initramfs on x86_64, i386, and
arm.  All three show the same decompression speed before and after, as
expected.

[1] https://github.com/lz4/lz4/pull/890

Link: http://lkml.kernel.org/r/20200803194022.2966806-1-nickrterrell@gmail.com
Signed-off-by: Nick Terrell <terrelln@fb.com>
Cc: Yann Collet <yann.collet.73@gmail.com>
Cc: Gao Xiang <gaoxiang25@huawei.com>
Cc: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Arvind Sankar <nivedita@alum.mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/lz4/lz4_compress.c   |    4 ++--
 lib/lz4/lz4_decompress.c |   18 +++++++++---------
 lib/lz4/lz4defs.h        |   10 ++++++++++
 lib/lz4/lz4hc_compress.c |    2 +-
 4 files changed, 22 insertions(+), 12 deletions(-)

--- a/lib/lz4/lz4_compress.c~lz4-fix-kernel-decompression-speed
+++ a/lib/lz4/lz4_compress.c
@@ -446,7 +446,7 @@ _last_literals:
 			*op++ = (BYTE)(lastRun << ML_BITS);
 		}
 
-		memcpy(op, anchor, lastRun);
+		LZ4_memcpy(op, anchor, lastRun);
 
 		op += lastRun;
 	}
@@ -708,7 +708,7 @@ _last_literals:
 		} else {
 			*op++ = (BYTE)(lastRunSize<<ML_BITS);
 		}
-		memcpy(op, anchor, lastRunSize);
+		LZ4_memcpy(op, anchor, lastRunSize);
 		op += lastRunSize;
 	}
 
--- a/lib/lz4/lz4_decompress.c~lz4-fix-kernel-decompression-speed
+++ a/lib/lz4/lz4_decompress.c
@@ -153,7 +153,7 @@ static FORCE_INLINE int LZ4_decompress_g
 		   && likely((endOnInput ? ip < shortiend : 1) &
 			     (op <= shortoend))) {
 			/* Copy the literals */
-			memcpy(op, ip, endOnInput ? 16 : 8);
+			LZ4_memcpy(op, ip, endOnInput ? 16 : 8);
 			op += length; ip += length;
 
 			/*
@@ -172,9 +172,9 @@ static FORCE_INLINE int LZ4_decompress_g
 			    (offset >= 8) &&
 			    (dict == withPrefix64k || match >= lowPrefix)) {
 				/* Copy the match. */
-				memcpy(op + 0, match + 0, 8);
-				memcpy(op + 8, match + 8, 8);
-				memcpy(op + 16, match + 16, 2);
+				LZ4_memcpy(op + 0, match + 0, 8);
+				LZ4_memcpy(op + 8, match + 8, 8);
+				LZ4_memcpy(op + 16, match + 16, 2);
 				op += length + MINMATCH;
 				/* Both stages worked, load the next token. */
 				continue;
@@ -263,7 +263,7 @@ static FORCE_INLINE int LZ4_decompress_g
 				}
 			}
 
-			memcpy(op, ip, length);
+			LZ4_memcpy(op, ip, length);
 			ip += length;
 			op += length;
 
@@ -350,7 +350,7 @@ _copy_match:
 				size_t const copySize = (size_t)(lowPrefix - match);
 				size_t const restSize = length - copySize;
 
-				memcpy(op, dictEnd - copySize, copySize);
+				LZ4_memcpy(op, dictEnd - copySize, copySize);
 				op += copySize;
 				if (restSize > (size_t)(op - lowPrefix)) {
 					/* overlap copy */
@@ -360,7 +360,7 @@ _copy_match:
 					while (op < endOfMatch)
 						*op++ = *copyFrom++;
 				} else {
-					memcpy(op, lowPrefix, restSize);
+					LZ4_memcpy(op, lowPrefix, restSize);
 					op += restSize;
 				}
 			}
@@ -386,7 +386,7 @@ _copy_match:
 				while (op < copyEnd)
 					*op++ = *match++;
 			} else {
-				memcpy(op, match, mlen);
+				LZ4_memcpy(op, match, mlen);
 			}
 			op = copyEnd;
 			if (op == oend)
@@ -400,7 +400,7 @@ _copy_match:
 			op[2] = match[2];
 			op[3] = match[3];
 			match += inc32table[offset];
-			memcpy(op + 4, match, 4);
+			LZ4_memcpy(op + 4, match, 4);
 			match -= dec64table[offset];
 		} else {
 			LZ4_copy8(op, match);
--- a/lib/lz4/lz4defs.h~lz4-fix-kernel-decompression-speed
+++ a/lib/lz4/lz4defs.h
@@ -137,6 +137,16 @@ static FORCE_INLINE void LZ4_writeLE16(v
 	return put_unaligned_le16(value, memPtr);
 }
 
+/*
+ * LZ4 relies on memcpy with a constant size being inlined. In freestanding
+ * environments, the compiler can't assume the implementation of memcpy() is
+ * standard compliant, so apply its specialized memcpy() inlining logic. When
+ * possible, use __builtin_memcpy() to tell the compiler to analyze memcpy()
+ * as-if it were standard compliant, so it can inline it in freestanding
+ * environments. This is needed when decompressing the Linux Kernel, for example.
+ */
+#define LZ4_memcpy(dst, src, size) __builtin_memcpy(dst, src, size)
+
 static FORCE_INLINE void LZ4_copy8(void *dst, const void *src)
 {
 #if LZ4_ARCH64
--- a/lib/lz4/lz4hc_compress.c~lz4-fix-kernel-decompression-speed
+++ a/lib/lz4/lz4hc_compress.c
@@ -570,7 +570,7 @@ _Search3:
 			*op++ = (BYTE) lastRun;
 		} else
 			*op++ = (BYTE)(lastRun<<ML_BITS);
-		memcpy(op, anchor, iend - anchor);
+		LZ4_memcpy(op, anchor, iend - anchor);
 		op += iend - anchor;
 	}
 
_
