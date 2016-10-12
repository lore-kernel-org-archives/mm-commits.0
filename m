From: akpm@linux-foundation.org
Subject: [merged] tile-use-simpler-api-for-random-address-requests.patch
 removed from -mm tree
Date: Wed, 12 Oct 2016 12:24:59 -0700
Message-ID: <57fe8e0b.PRvDMwkJlc7RbnE3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33191 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755880AbcJLTZA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:25:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jason@lakedaemon.net, cmetcalf@mellanox.com, keescook@chromium.org, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: tile: use simpler API for random address requests
has been removed from the -mm tree.  Its filename was
     tile-use-simpler-api-for-random-address-requests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jason Cooper <jason@lakedaemon.net>
Subject: tile: use simpler API for random address requests

Currently, all callers to randomize_range() set the length to 0 and
calculate end by adding a constant to the start address.  We can simplify
the API to remove a bunch of needless checks and variables.

Use the new randomize_addr(start, range) call to set the requested
address.

Link: http://lkml.kernel.org/r/20160803233913.32511-6-jason@lakedaemon.net
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Chris Metcalf <cmetcalf@mellanox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/mm/mmap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/tile/mm/mmap.c~tile-use-simpler-api-for-random-address-requests arch/tile/mm/mmap.c
--- a/arch/tile/mm/mmap.c~tile-use-simpler-api-for-random-address-requests
+++ a/arch/tile/mm/mmap.c
@@ -88,6 +88,5 @@ void arch_pick_mmap_layout(struct mm_str
 
 unsigned long arch_randomize_brk(struct mm_struct *mm)
 {
-	unsigned long range_end = mm->brk + 0x02000000;
-	return randomize_range(mm->brk, range_end, 0) ? : mm->brk;
+	return randomize_page(mm->brk, 0x02000000);
 }
_

Patches currently in -mm which might be from jason@lakedaemon.net are


