From: akpm@linux-foundation.org
Subject: [merged] sh-off-by-one-bug_on-in-setup_bootmem_node.patch removed from -mm tree
Date: Thu, 11 Dec 2014 10:55:04 -0800
Message-ID: <5489e888.PCQDzRr4DfnsBVAt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44945 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756095AbaLKSzF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:55:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, geert+renesas@glider.be, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sh: off by one BUG_ON() in setup_bootmem_node()
has been removed from the -mm tree.  Its filename was
     sh-off-by-one-bug_on-in-setup_bootmem_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: sh: off by one BUG_ON() in setup_bootmem_node()

This off by one bug is harmless but it upsets the static checkers and the
code is obvious so it doesn't hurt to fix it.  The Smatch warning is:

	arch/sh/mm/numa.c:47 setup_bootmem_node()
	error: buffer overflow 'node_data' 1024 <= 1024

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/mm/numa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/sh/mm/numa.c~sh-off-by-one-bug_on-in-setup_bootmem_node arch/sh/mm/numa.c
--- a/arch/sh/mm/numa.c~sh-off-by-one-bug_on-in-setup_bootmem_node
+++ a/arch/sh/mm/numa.c
@@ -31,7 +31,7 @@ void __init setup_bootmem_node(int nid,
 	unsigned long bootmem_paddr;
 
 	/* Don't allow bogus node assignment */
-	BUG_ON(nid > MAX_NUMNODES || nid <= 0);
+	BUG_ON(nid >= MAX_NUMNODES || nid <= 0);
 
 	start_pfn = start >> PAGE_SHIFT;
 	end_pfn = end >> PAGE_SHIFT;
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
decompress_bunzip2-off-by-one-in-get_next_block.patch
linux-next.patch

