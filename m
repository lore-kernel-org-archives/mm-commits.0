From: akpm@linux-foundation.org
Subject: - type-cast-clean-up-for-find_next_zero_bit.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:38:05 -0700
Message-ID: <200703292338.l2TNc5Ee015191@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43030 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945930AbXC2XiJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:38:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kenchen@google.com, mm-commits@vger.kernel.org


The patch titled
     type cast clean up for find_next_zero_bit
has been removed from the -mm tree.  Its filename was
     type-cast-clean-up-for-find_next_zero_bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: type cast clean up for find_next_zero_bit
From: "Ken Chen" <kenchen@google.com>

clean up unneeded type cast by properly declare data type.

Signed-off-by: Ken Chen <kenchen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/lib/bitops.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/i386/lib/bitops.c~type-cast-clean-up-for-find_next_zero_bit arch/i386/lib/bitops.c
--- a/arch/i386/lib/bitops.c~type-cast-clean-up-for-find_next_zero_bit
+++ a/arch/i386/lib/bitops.c
@@ -43,7 +43,7 @@ EXPORT_SYMBOL(find_next_bit);
  */
 int find_next_zero_bit(const unsigned long *addr, int size, int offset)
 {
-	unsigned long * p = ((unsigned long *) addr) + (offset >> 5);
+	const unsigned long *p = addr + (offset >> 5);
 	int set = 0, bit = offset & 31, res;
 
 	if (bit) {
@@ -64,7 +64,7 @@ int find_next_zero_bit(const unsigned lo
 	/*
 	 * No zero yet, search remaining full bytes for a zero
 	 */
-	res = find_first_zero_bit (p, size - 32 * (p - (unsigned long *) addr));
+	res = find_first_zero_bit(p, size - 32 * (p - addr));
 	return (offset + set + res);
 }
 EXPORT_SYMBOL(find_next_zero_bit);
_

Patches currently in -mm which might be from kenchen@google.com are

cache-pipe-buf-page-address-for-non-highmem-arch.patch
cache-pipe-buf-page-address-for-non-highmem-arch-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch-fix-tidy.patch
