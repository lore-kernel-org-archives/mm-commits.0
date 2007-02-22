From: akpm@linux-foundation.org
Subject: + type-cast-clean-up-for-find_next_zero_bit.patch added to -mm tree
Date: Wed, 21 Feb 2007 16:49:35 -0800
Message-ID: <200702220049.l1M0nZOa031903@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60170 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbXBVAtj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 19:49:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kenchen@google.com


The patch titled
     type cast clean up for find_next_zero_bit
has been added to the -mm tree.  Its filename is
     type-cast-clean-up-for-find_next_zero_bit.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: type cast clean up for find_next_zero_bit
From: "Ken Chen" <kenchen@google.com>

clean up unneeded type cast by properly declare data type.

Signed-off-by: Ken Chen <kenchen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/lib/bitops.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

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

type-cast-clean-up-for-find_next_zero_bit.patch
