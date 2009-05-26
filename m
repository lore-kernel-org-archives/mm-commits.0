From: akpm@linux-foundation.org
Subject: + hexdump-remove-the-trailing-space.patch added to -mm tree
Date: Tue, 26 May 2009 16:37:22 -0700
Message-ID: <200905262337.n4QNbMPW013478@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44927 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760142AbZEZXhr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 19:37:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, randy.dunlap@oracle.com


The patch titled
     hexdump: remove the trailing space
has been added to the -mm tree.  Its filename is
     hexdump-remove-the-trailing-space.patch

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

linux-next.patch
cls_cgroup-read-classid-atomically-in-classifier.patch
hexdump-remove-the-trailing-space.patch
cgroups-make-messages-more-readable.patch
devcgroup-skip-superfluous-checks-when-found-the-dev_all-elem.patch
memcg-remove-some-redundant-checks.patch
memcg-remove-unneeded-forward-declaration-from-schedh.patch

