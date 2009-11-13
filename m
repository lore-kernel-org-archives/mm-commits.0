From: akpm@linux-foundation.org
Subject: [to-be-updated] zlib-optimize-inffast-when-copying-direct-from-output.patch removed from -mm tree
Date: Fri, 13 Nov 2009 14:45:40 -0800
Message-ID: <200911132245.nADMjetn012107@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45583 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932176AbZKMWqL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Nov 2009 17:46:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Joakim.Tjernlund@transmode.se, alain@knaff.lu, dwmw2@infradead.org, hpa@zytor.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     zlib: optimize inffast when copying direct from output
has been removed from the -mm tree.  Its filename was
     zlib-optimize-inffast-when-copying-direct-from-output.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: zlib: optimize inffast when copying direct from output
From: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>

JFFS2 uses lesser compression ratio and inflate always ends up in "copy
direct from output" case.

This patch tries to optimize the copy procedure for arch's that have
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS defined.  On my MPC8321 this is
about 14% faster on my JFFS2 root FS than the original.

Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Cc: Alain Knaff <alain@knaff.lu>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN lib/zlib_inflate/inffast.c~zlib-optimize-inffast-when-copying-direct-from-output lib/zlib_inflate/inffast.c
--- a/lib/zlib_inflate/inffast.c~zlib-optimize-inffast-when-copying-direct-from-output
+++ a/lib/zlib_inflate/inffast.c
@@ -240,6 +240,40 @@ void inflate_fast(z_streamp strm, unsign
                 }
                 else {
                     from = out - dist;          /* copy direct from output */
+#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+                    /* minimum length is three */
+		    if (dist > 2 ) {
+			unsigned short *sout = (unsigned short *)(out - OFF);
+			unsigned short *sfrom = (unsigned short *)(from - OFF);
+			unsigned long loops = len >> 1;
+
+			do
+			    PUP(sout) = PUP(sfrom);
+			while (--loops);
+			out = (unsigned char *)sout + OFF;
+			from = (unsigned char *)sfrom + OFF;
+			if (len & 1)
+			    PUP(out) = PUP(from);
+		    } else if (dist == 2) {
+			unsigned short *sout = (unsigned short *)(out - OFF);
+			unsigned short pat16;
+			unsigned long loops = len >> 1;
+
+			pat16 = *(sout-2+2*OFF);
+			do
+			    PUP(sout) = pat16;
+			while (--loops);
+			out = (unsigned char *)sout + OFF;
+			if (len & 1)
+			    PUP(out) = PUP(from);
+		    } else {
+			unsigned char pat8 = *(out - 1 + OFF);
+
+			do {
+			    PUP(out) = pat8;
+			} while (--len);
+		    }
+#else
                     do {                        /* minimum length is three */
                         PUP(out) = PUP(from);
                         PUP(out) = PUP(from);
@@ -251,6 +285,7 @@ void inflate_fast(z_streamp strm, unsign
                         if (len > 1)
                             PUP(out) = PUP(from);
                     }
+#endif
                 }
             }
             else if ((op & 64) == 0) {          /* 2nd level distance code */
_

Patches currently in -mm which might be from Joakim.Tjernlund@transmode.se are

crc32-minor-optimizations-and-cleanup.patch
crc32-minor-optimizations-and-cleanup-checkpatch-fixes.patch
zlib-optimize-inffast-when-copying-direct-from-output.patch
zlib-optimize-inffast-even-more.patch

