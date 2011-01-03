From: akpm@linux-foundation.org
Subject: + ihex-fix-unused-return-value-compiler-warning.patch added to -mm tree
Date: Mon, 03 Jan 2011 11:52:46 -0800
Message-ID: <201101031952.p03Jqkxr025454@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55195 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755607Ab1ACTxM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Jan 2011 14:53:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cmruffin@gmail.com, broonie@opensource.wolfsonmicro.com


The patch titled
     ihex: fix unused return value compiler warning
has been added to the -mm tree.  Its filename is
     ihex-fix-unused-return-value-compiler-warning.patch

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
Subject: ihex: fix unused return value compiler warning
From: Chris Ruffin <cmruffin@gmail.com>

Fix unusued return value compiler warnings due to unchecked write() calls.

Signed-off-by: Chris Ruffin <cmruffin@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 firmware/ihex2fw.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN firmware/ihex2fw.c~ihex-fix-unused-return-value-compiler-warning firmware/ihex2fw.c
--- a/firmware/ihex2fw.c~ihex-fix-unused-return-value-compiler-warning
+++ a/firmware/ihex2fw.c
@@ -124,8 +124,7 @@ int main(int argc, char **argv)
 	if (process_ihex(data, st.st_size))
 		return 1;
 
-	output_records(outfd);
-	return 0;
+	return output_records(outfd);
 }
 
 static int process_ihex(uint8_t *data, ssize_t size)
@@ -269,11 +268,13 @@ static int output_records(int outfd)
 
 		p->addr = htonl(p->addr);
 		p->len = htons(p->len);
-		write(outfd, &p->addr, writelen);
+		if (write(outfd, &p->addr, writelen) != writelen)
+			return errno;
 		p = p->next;
 	}
 	/* EOF record is zero length, since we don't bother to represent
 	   the type field in the binary version */
-	write(outfd, zeroes, 6);
+	if (write(outfd, zeroes, 6) != 6)
+		return errno;
 	return 0;
 }
_

Patches currently in -mm which might be from cmruffin@gmail.com are

ihex-fix-unused-return-value-compiler-warning.patch
ihex-fix-unused-return-value-compiler-warning-fix.patch

