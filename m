From: akpm@linux-foundation.org
Subject: [merged] hexdump-remove-the-trailing-space.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:37:36 -0700
Message-ID: <200906171837.n5HIba5Z003627@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760354AbZFQSiZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:38:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     hexdump: remove the trailing space
has been removed from the -mm tree.  Its filename was
     hexdump-remove-the-trailing-space.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hexdump: remove the trailing space
From: Li Zefan <lizf@cn.fujitsu.com>

For example:
        hex_dump_to_buffer("AB", 2, 16, 1, buf, 100, 0);
        pr_info("[%s]\n", buf);

I'd expect the output to be "[41 42]", but actually it's "[41 42 ]"

This patch also makes the required buf to be minimum.  To print the hex
format of "AB", a buf with size 6 should be sufficient, but
hex_dump_to_buffer() required at least 8.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/hexdump.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN lib/hexdump.c~hexdump-remove-the-trailing-space lib/hexdump.c
--- a/lib/hexdump.c~hexdump-remove-the-trailing-space
+++ a/lib/hexdump.c
@@ -65,7 +65,8 @@ void hex_dump_to_buffer(const void *buf,
 
 		for (j = 0; j < ngroups; j++)
 			lx += scnprintf(linebuf + lx, linebuflen - lx,
-				"%16.16llx ", (unsigned long long)*(ptr8 + j));
+				"%s%16.16llx", j ? " " : "",
+				(unsigned long long)*(ptr8 + j));
 		ascii_column = 17 * ngroups + 2;
 		break;
 	}
@@ -76,7 +77,7 @@ void hex_dump_to_buffer(const void *buf,
 
 		for (j = 0; j < ngroups; j++)
 			lx += scnprintf(linebuf + lx, linebuflen - lx,
-				"%8.8x ", *(ptr4 + j));
+				"%s%8.8x", j ? " " : "", *(ptr4 + j));
 		ascii_column = 9 * ngroups + 2;
 		break;
 	}
@@ -87,19 +88,21 @@ void hex_dump_to_buffer(const void *buf,
 
 		for (j = 0; j < ngroups; j++)
 			lx += scnprintf(linebuf + lx, linebuflen - lx,
-				"%4.4x ", *(ptr2 + j));
+				"%s%4.4x", j ? " " : "", *(ptr2 + j));
 		ascii_column = 5 * ngroups + 2;
 		break;
 	}
 
 	default:
-		for (j = 0; (j < rowsize) && (j < len) && (lx + 4) < linebuflen;
-		     j++) {
+		for (j = 0; (j < len) && (lx + 3) <= linebuflen; j++) {
 			ch = ptr[j];
 			linebuf[lx++] = hex_asc_hi(ch);
 			linebuf[lx++] = hex_asc_lo(ch);
 			linebuf[lx++] = ' ';
 		}
+		if (j)
+			lx--;
+
 		ascii_column = 3 * rowsize + 2;
 		break;
 	}
@@ -108,7 +111,7 @@ void hex_dump_to_buffer(const void *buf,
 
 	while (lx < (linebuflen - 1) && lx < (ascii_column - 1))
 		linebuf[lx++] = ' ';
-	for (j = 0; (j < rowsize) && (j < len) && (lx + 2) < linebuflen; j++)
+	for (j = 0; (j < len) && (lx + 2) < linebuflen; j++)
 		linebuf[lx++] = (isascii(ptr[j]) && isprint(ptr[j])) ? ptr[j]
 				: '.';
 nil:
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch
cgroups-make-messages-more-readable.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix2.patch
devcgroup-skip-superfluous-checks-when-found-the-dev_all-elem.patch
memcg-remove-some-redundant-checks.patch
memcg-remove-unneeded-forward-declaration-from-schedh.patch
memcg-fix-swap-accounting.patch
memcg-fix-swap-accounting-update.patch
memcg-fix-behavior-under-memorylimit-equals-to-memswlimit.patch
memcg-add-interface-to-reset-limits.patch

