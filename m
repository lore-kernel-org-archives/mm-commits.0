From: akpm@linux-foundation.org
Subject: [merged]
 lib-xz-add-comments-for-the-intentionally-missing-break-statements.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 13:05:07 -0700
Message-ID: <5390cd73.AxyE1BSZTNL3cRZY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56796 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaFEUFH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 16:05:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, lasse.collin@tukaani.org

Subject: [merged] lib-xz-add-comments-for-the-intentionally-missing-break-statements.patch removed from -mm tree
To: lasse.collin@tukaani.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 13:05:07 -0700


The patch titled
     Subject: lib/xz: add comments for the intentionally missing break statements
has been removed from the -mm tree.  Its filename was
     lib-xz-add-comments-for-the-intentionally-missing-break-statements.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lasse Collin <lasse.collin@tukaani.org>
Subject: lib/xz: add comments for the intentionally missing break statements

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xz/xz_dec_lzma2.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN lib/xz/xz_dec_lzma2.c~lib-xz-add-comments-for-the-intentionally-missing-break-statements lib/xz/xz_dec_lzma2.c
--- a/lib/xz/xz_dec_lzma2.c~lib-xz-add-comments-for-the-intentionally-missing-break-statements
+++ a/lib/xz/xz_dec_lzma2.c
@@ -1043,6 +1043,8 @@ XZ_EXTERN enum xz_ret xz_dec_lzma2_run(s
 
 			s->lzma2.sequence = SEQ_LZMA_PREPARE;
 
+		/* Fall through */
+
 		case SEQ_LZMA_PREPARE:
 			if (s->lzma2.compressed < RC_INIT_BYTES)
 				return XZ_DATA_ERROR;
@@ -1053,6 +1055,8 @@ XZ_EXTERN enum xz_ret xz_dec_lzma2_run(s
 			s->lzma2.compressed -= RC_INIT_BYTES;
 			s->lzma2.sequence = SEQ_LZMA_RUN;
 
+		/* Fall through */
+
 		case SEQ_LZMA_RUN:
 			/*
 			 * Set dictionary limit to indicate how much we want
_

Patches currently in -mm which might be from lasse.collin@tukaani.org are

origin.patch
linux-next.patch

