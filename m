From: akpm@linux-foundation.org
Subject: [folded-merged] debugging-keep-track-of-page-owners-fix-2.patch
 removed from -mm tree
Date: Fri, 15 Nov 2013 14:24:02 -0800
Message-ID: <52869f02.y+FY3Otl8JUGjl93%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36348 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab3KOWYD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 17:24:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rdunlap@infradead.org, mina86@mina86.com, dave@linux.vnet.ibm.com, minchan@kernel.org

Subject: [folded-merged] debugging-keep-track-of-page-owners-fix-2.patch removed from -mm tree
To: minchan@kernel.org,dave@linux.vnet.ibm.com,mina86@mina86.com,rdunlap@infradead.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 14:24:02 -0800


The patch titled
     Subject: Fix wrong EOF compare
has been removed from the -mm tree.  Its filename was
     debugging-keep-track-of-page-owners-fix-2.patch

This patch was dropped because it was folded into debugging-keep-track-of-page-owners.patch

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: Fix wrong EOF compare

The C standards allows the character type char to be singed or unsinged,
depending on the platform and compiler. Most of systems uses signed char,
but those based on PowerPC and ARM processors typically use unsigned char.
This can lead to unexpected results when the variable is used to compare
with EOF(-1). It happens my ARM system and this patch fixes it.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/page_owner.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN Documentation/page_owner.c~debugging-keep-track-of-page-owners-fix-2 Documentation/page_owner.c
--- a/Documentation/page_owner.c~debugging-keep-track-of-page-owners-fix-2
+++ a/Documentation/page_owner.c
@@ -32,12 +32,13 @@ int read_block(char *buf, FILE *fin)
 {
 	int ret = 0;
 	int hit = 0;
+	int val;
 	char *curr = buf;
 
 	for (;;) {
-		*curr = getc(fin);
-		if (*curr == EOF) return -1;
