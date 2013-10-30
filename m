From: akpm@linux-foundation.org
Subject: + bitops-find-clarify-and-extend-documentation.patch added to -mm tree
Date: Wed, 30 Oct 2013 15:51:21 -0700
Message-ID: <52718d69.4P/kMoJtetZPkSRF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49687 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab3J3WvV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Oct 2013 18:51:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, arnd@arndb.de, cody@linux.vnet.ibm.com

Subject: + bitops-find-clarify-and-extend-documentation.patch added to -mm tree
To: cody@linux.vnet.ibm.com,arnd@arndb.de
From: akpm@linux-foundation.org
Date: Wed, 30 Oct 2013 15:51:21 -0700


The patch titled
     Subject: bitops/find: clarify and extend documentation
has been added to the -mm tree.  Its filename is
     bitops-find-clarify-and-extend-documentation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bitops-find-clarify-and-extend-documentation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bitops-find-clarify-and-extend-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: bitops/find: clarify and extend documentation

Add return value documentation and clarify the units of the @size
parameter.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Cody P Schafer <cody@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bitops/find.h |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN include/asm-generic/bitops/find.h~bitops-find-clarify-and-extend-documentation include/asm-generic/bitops/find.h
--- a/include/asm-generic/bitops/find.h~bitops-find-clarify-and-extend-documentation
+++ a/include/asm-generic/bitops/find.h
@@ -7,6 +7,9 @@
  * @addr: The address to base the search on
  * @offset: The bitnumber to start searching at
  * @size: The bitmap size in bits
+ *
+ * Returns the bit number for the next set bit
+ * If no bits are set, returns @size.
  */
 extern unsigned long find_next_bit(const unsigned long *addr, unsigned long
 		size, unsigned long offset);
@@ -18,6 +21,9 @@ extern unsigned long find_next_bit(const
  * @addr: The address to base the search on
  * @offset: The bitnumber to start searching at
  * @size: The bitmap size in bits
+ *
+ * Returns the bit number of the next zero bit
+ * If no bits are zero, returns @size.
  */
 extern unsigned long find_next_zero_bit(const unsigned long *addr, unsigned
 		long size, unsigned long offset);
@@ -28,9 +34,10 @@ extern unsigned long find_next_zero_bit(
 /**
  * find_first_bit - find the first set bit in a memory region
  * @addr: The address to start the search at
- * @size: The maximum size to search
+ * @size: The maximum number of bits to search
  *
  * Returns the bit number of the first set bit.
+ * If no bits are set, returns @size.
  */
 extern unsigned long find_first_bit(const unsigned long *addr,
 				    unsigned long size);
@@ -38,9 +45,10 @@ extern unsigned long find_first_bit(cons
 /**
  * find_first_zero_bit - find the first cleared bit in a memory region
  * @addr: The address to start the search at
- * @size: The maximum size to search
+ * @size: The maximum number of bits to search
  *
  * Returns the bit number of the first cleared bit.
+ * If no bits are zero, returns @size.
  */
 extern unsigned long find_first_zero_bit(const unsigned long *addr,
 					 unsigned long size);
_

Patches currently in -mm which might be from cody@linux.vnet.ibm.com are

bitops-find-clarify-and-extend-documentation.patch

