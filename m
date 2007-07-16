From: akpm@linux-foundation.org
Subject: - hfs-refactor-ascii-to-unicode-conversion-routine.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:57:49 -0700
Message-ID: <200707162057.l6GKvnMc002230@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38063 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762344AbXGPVPa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:15:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: duaneg@dghda.com, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     HFS+: refactor ASCII to unicode conversion routine for later reuse
has been removed from the -mm tree.  Its filename was
     hfs-refactor-ascii-to-unicode-conversion-routine.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: HFS+: refactor ASCII to unicode conversion routine for later reuse
From: Duane Griffin <duaneg@dghda.com>

The HFS+ filesystem is case-insensitive and does automatic unicode
decomposition by default, but does not provide custom dentry operations.  This
can lead to multiple dentries being cached for lookups on a filename with
varying case and/or character (de)composition.

These patches add custom dentry hash and comparison operations for
case-sensitive and/or automatically decomposing HFS+ filesystems.  Unicode
decomposition and case-folding are performed as required to ensure equivalent
filenames are hashed to the same values and compare as equal.


This patch:

Refactor existing HFS+ ASCII to unicode string conversion routine to split out
character conversion functionality.  This will be reused by the custom dentry
hash and comparison routines.  This approach avoids unnecessary memory
allocation compared to using the string conversion routine directly in the new
functions.

[akpm@linux-foundation.org: avoid use-of-uninitialised]
Signed-off-by: Duane Griffin <duaneg@dghda.com>
Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/unicode.c |  107 +++++++++++++++++++++++------------------
 1 file changed, 62 insertions(+), 45 deletions(-)

diff -puN fs/hfsplus/unicode.c~hfs-refactor-ascii-to-unicode-conversion-routine fs/hfsplus/unicode.c
--- a/fs/hfsplus/unicode.c~hfs-refactor-ascii-to-unicode-conversion-routine
+++ a/fs/hfsplus/unicode.c
@@ -239,58 +239,75 @@ out:
 	return res;
 }
 
-int hfsplus_asc2uni(struct super_block *sb, struct hfsplus_unistr *ustr, const char *astr, int len)
+/*
+ * Convert one or more ASCII characters into a single unicode character.
+ * Returns the number of ASCII characters corresponding to the unicode char.
+ */
+static inline int asc2unichar(struct super_block *sb, const char *astr, int len,
+			      wchar_t *uc)
 {
-	struct nls_table *nls = HFSPLUS_SB(sb).nls;
-	int size, off, decompose;
+	int size = HFSPLUS_SB(sb).nls->char2uni(astr, len, uc);
+	if (size <= 0) {
+		*uc = '?';
+		size = 1;
+	}
+	switch (*uc) {
+	case 0x2400:
+		*uc = 0;
+		break;
+	case ':':
+		*uc = '/';
+		break;
+	}
+	return size;
+}
+
+/* Decomposes a single unicode character. */
+static inline u16 *decompose_unichar(wchar_t uc, int *size)
+{
+	int off;
+
+	off = hfsplus_decompose_table[(uc >> 12) & 0xf];
+	if (off == 0 || off == 0xffff)
+		return NULL;
+
+	off = hfsplus_decompose_table[off + ((uc >> 8) & 0xf)];
+	if (!off)
+		return NULL;
+
+	off = hfsplus_decompose_table[off + ((uc >> 4) & 0xf)];
+	if (!off)
+		return NULL;
+
+	off = hfsplus_decompose_table[off + (uc & 0xf)];
+	*size = off & 3;
+	if (*size == 0)
+		return NULL;
+	return hfsplus_decompose_table + (off / 4);
+}
+
+int hfsplus_asc2uni(struct super_block *sb, struct hfsplus_unistr *ustr,
+		    const char *astr, int len)
+{
+	int size, dsize, decompose;
+	u16 *dstr, outlen = 0;
 	wchar_t c;
-	u16 outlen = 0;
 
 	decompose = !(HFSPLUS_SB(sb).flags & HFSPLUS_SB_NODECOMPOSE);
-
 	while (outlen < HFSPLUS_MAX_STRLEN && len > 0) {
-		size = nls->char2uni(astr, len, &c);
-		if (size <= 0) {
-			c = '?';
-			size = 1;
-		}
-		astr += size;
-		len -= size;
-		switch (c) {
-		case 0x2400:
-			c = 0;
-			break;
-		case ':':
-			c = '/';
-			break;
-		}
-		if (c >= 0xc0 && decompose) {
-			off = hfsplus_decompose_table[(c >> 12) & 0xf];
-			if (!off)
-				goto done;
-			if (off == 0xffff) {
-				goto done;
-			}
-			off = hfsplus_decompose_table[off + ((c >> 8) & 0xf)];
-			if (!off)
-				goto done;
-			off = hfsplus_decompose_table[off + ((c >> 4) & 0xf)];
-			if (!off)
-				goto done;
-			off = hfsplus_decompose_table[off + (c & 0xf)];
-			size = off & 3;
-			if (!size)
-				goto done;
-			off /= 4;
-			if (outlen + size > HFSPLUS_MAX_STRLEN)
+		size = asc2unichar(sb, astr, len, &c);
+
+		if (decompose && (dstr = decompose_unichar(c, &dsize))) {
+			if (outlen + dsize > HFSPLUS_MAX_STRLEN)
 				break;
 			do {
-				ustr->unicode[outlen++] = cpu_to_be16(hfsplus_decompose_table[off++]);
-			} while (--size > 0);
-			continue;
-		}
-	done:
-		ustr->unicode[outlen++] = cpu_to_be16(c);
+				ustr->unicode[outlen++] = cpu_to_be16(*dstr++);
+			} while (--dsize > 0);
+		} else
+			ustr->unicode[outlen++] = cpu_to_be16(c);
+
+		astr += size;
+		len -= size;
 	}
 	ustr->length = cpu_to_be16(outlen);
 	if (len > 0)
_

Patches currently in -mm which might be from duaneg@dghda.com are

origin.patch
