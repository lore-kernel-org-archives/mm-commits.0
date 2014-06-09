From: akpm@linux-foundation.org
Subject: [merged] doc-fix-important-typo-re-memory-barriers.patch removed
 from -mm tree
Date: Mon, 09 Jun 2014 12:33:22 -0700
Message-ID: <53960c02.yab8yFbpHOXqXo6X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53977 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaFITdX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:33:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dhowells@redhat.com, adobriyan@gmail.com

Subject: [merged] doc-fix-important-typo-re-memory-barriers.patch removed from -mm tree
To: adobriyan@gmail.com,dhowells@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:33:22 -0700


The patch titled
     Subject: Documentation/memory-barriers.txt: fix important typo re memory barriers
has been removed from the -mm tree.  Its filename was
     doc-fix-important-typo-re-memory-barriers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Documentation/memory-barriers.txt: fix important typo re memory barriers

Examples introducing neccesity of RMB+WMP pair reads as

	A=3	READ B
	www	rrrrrr
	B=4	READ A

Note the opposite order of reads vs writes.

But the first example without barriers reads as

	A=3	READ A
	B=4	READ B

There are 4 outcomes in the first example.
But if someone new to the concept tries to insert barriers like this:

	A=3	READ A
	www	rrrrrr
	B=4	READ B

he will still get all 4 possible outcomes, because "READ A" is first.

All this can be utterly confusing because barrier pair seems to be
superfluous.  In short, fixup first example to match latter examples with
barriers.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/memory-barriers.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/memory-barriers.txt~doc-fix-important-typo-re-memory-barriers Documentation/memory-barriers.txt
--- a/Documentation/memory-barriers.txt~doc-fix-important-typo-re-memory-barriers
+++ a/Documentation/memory-barriers.txt
@@ -115,8 +115,8 @@ For example, consider the following sequ
 	CPU 1		CPU 2
 	===============	===============
 	{ A == 1; B == 2 }
-	A = 3;		x = A;
-	B = 4;		y = B;
+	A = 3;		x = B;
+	B = 4;		y = A;
 
 The set of accesses as seen by the memory system in the middle can be arranged
 in 24 different combinations:
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch

