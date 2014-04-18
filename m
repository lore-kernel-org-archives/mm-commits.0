From: akpm@linux-foundation.org
Subject: +
 lib-xz-add-comments-for-the-intentionally-missing-break-statements.patch
 added to -mm tree
Date: Fri, 18 Apr 2014 12:58:10 -0700
Message-ID: <535183d2.sOJCyoyPHxGQxb9S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42197 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008AbaDRT6K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Apr 2014 15:58:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, lasse.collin@tukaani.org

Subject: + lib-xz-add-comments-for-the-intentionally-missing-break-statements.patch added to -mm tree
To: lasse.collin@tukaani.org
From: akpm@linux-foundation.org
Date: Fri, 18 Apr 2014 12:58:10 -0700


The patch titled
     Subject: lib/xz: add comments for the intentionally missing break statements
has been added to the -mm tree.  Its filename is
     lib-xz-add-comments-for-the-intentionally-missing-break-statements.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-xz-add-comments-for-the-intentionally-missing-break-statements.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-xz-add-comments-for-the-intentionally-missing-break-statements.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

lib-xz-add-comments-for-the-intentionally-missing-break-statements.patch
lib-xz-enable-all-filters-by-default-in-kconfig.patch

