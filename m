From: akpm@linux-foundation.org
Subject: [merged] ihex-fix-unused-return-value-compiler-warning.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:04:04 -0800
Message-ID: <201101132006.p0DK6jHZ029772@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757381Ab1AMUNm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:13:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cmruffin@gmail.com, broonie@opensource.wolfsonmicro.com, mm-commits@vger.kernel.org


The patch titled
     ihex: fix unused return value compiler warning
has been removed from the -mm tree.  Its filename was
     ihex-fix-unused-return-value-compiler-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ihex: fix unused return value compiler warning
From: Chris Ruffin <cmruffin@gmail.com>

Fix unusued return value compiler warnings due to unchecked write() calls.

[akpm@linux-foundation.org: correctly handle short writes]
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
+			return 1;
 		p = p->next;
 	}
 	/* EOF record is zero length, since we don't bother to represent
 	   the type field in the binary version */
-	write(outfd, zeroes, 6);
+	if (write(outfd, zeroes, 6) != 6)
+		return 1;
 	return 0;
 }
_

Patches currently in -mm which might be from cmruffin@gmail.com are

origin.patch

