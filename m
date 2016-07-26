From: akpm@linux-foundation.org
Subject: [patch 081/126] mm/memblock.c:memblock_add_range(): if nr_new is
 0 just return
Date: Tue, 26 Jul 2016 15:24:56 -0700
Message-ID: <5797e338.wpIDF/p6VOQuY7Ch%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56945 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758488AbcGZWY5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:24:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, nimisolo@gmail.com, kuleshovmail@gmail.com, mgorman@techsingularity.net, penberg@kernel.org, tangchen@cn.fujitsu.com, tony.luck@intel.com, weiyang@linux.vnet.ibm.com

From: nimisolo <nimisolo@gmail.com>
Subject: mm/memblock.c:memblock_add_range(): if nr_new is 0 just return

If nr_new is 0 which means there's no region would be added, so just
return to the caller.

Signed-off-by: nimisolo <nimisolo@gmail.com>
Cc: Alexander Kuleshov <kuleshovmail@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Wei Yang <weiyang@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/memblock.c~mm-memblock-if-nr_new-is-0-just-return mm/memblock.c
--- a/mm/memblock.c~mm-memblock-if-nr_new-is-0-just-return
+++ a/mm/memblock.c
@@ -584,6 +584,9 @@ repeat:
 					       nid, flags);
 	}
 
+	if (!nr_new)
+		return 0;
+
 	/*
 	 * If this was the first round, resize array and repeat for actual
 	 * insertions; otherwise, merge and return.
_
