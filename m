From: akpm@linux-foundation.org
Subject: - hexdump-dont-print-bytes-with-bit-7-set.patch removed from -mm tree
Date: Fri, 30 Nov 2007 16:22:17 -0800
Message-ID: <200712010022.lB10MHC1031881@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55939 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757642AbXLAA1w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 19:27:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, herbert@gondor.apana.org.au, mm-commits@vger.kernel.org


The patch titled
     hexdump: don't print bytes with bit 7 set
has been removed from the -mm tree.  Its filename was
     hexdump-dont-print-bytes-with-bit-7-set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hexdump: don't print bytes with bit 7 set
From: Randy Dunlap <randy.dunlap@oracle.com>

As Herbert Xu pointed out, bytes (chars) with bit 7 (0x80) set are true
with isprint() but they may not be isascii() but be Unicode instead, so
don't try to print them in hex dumps.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/hexdump.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN lib/hexdump.c~hexdump-dont-print-bytes-with-bit-7-set lib/hexdump.c
--- a/lib/hexdump.c~hexdump-dont-print-bytes-with-bit-7-set
+++ a/lib/hexdump.c
@@ -106,7 +106,8 @@ void hex_dump_to_buffer(const void *buf,
 	while (lx < (linebuflen - 1) && lx < (ascii_column - 1))
 		linebuf[lx++] = ' ';
 	for (j = 0; (j < rowsize) && (j < len) && (lx + 2) < linebuflen; j++)
-		linebuf[lx++] = isprint(ptr[j]) ? ptr[j] : '.';
+		linebuf[lx++] = (isascii(ptr[j]) && isprint(ptr[j])) ? ptr[j]
+				: '.';
 nil:
 	linebuf[lx++] = '\0';
 }
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-dvb.patch
git-scsi-misc.patch
advansys-fix-section-mismatch-warning.patch
aic94-fix-section-mismatches.patch
sym2-fix-section-mismatch-warning.patch
git-unionfs.patch
git-ipwireless_cs.patch
git-x86.patch
register_cpu-__devinit-or-__cpuinit.patch
cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch
move-kprobes-examples-to-samples-resend.patch
move-kprobes-examples-to-samples-resend-checkpatch-fixes.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch
