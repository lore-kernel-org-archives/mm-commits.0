From: akpm@linux-foundation.org
Subject: [obsolete]
 random-simplify-api-for-random-address-requests-v2.patch removed from -mm
 tree
Date: Mon, 15 Aug 2016 16:09:02 -0700
Message-ID: <57b24b8e.9NlyaSyDgCdgTo4a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39785 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201AbcHOXJE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Aug 2016 19:09:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jason@lakedaemon.net, mm-commits@vger.kernel.org


The patch titled
     Subject: random-simplify-api-for-random-address-requests-v2
has been removed from the -mm tree.  Its filename was
     random-simplify-api-for-random-address-requests-v2.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Jason Cooper <jason@lakedaemon.net>
Subject: random-simplify-api-for-random-address-requests-v2

s/randomize_page/randomize_addr/

Link: http://lkml.kernel.org/r/20160728204730.27453-2-jason@lakedaemon.net
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c  |   23 ++++++++---------------
 include/linux/random.h |    2 +-
 2 files changed, 9 insertions(+), 16 deletions(-)

diff -puN drivers/char/random.c~random-simplify-api-for-random-address-requests-v2 drivers/char/random.c
--- a/drivers/char/random.c~random-simplify-api-for-random-address-requests-v2
+++ a/drivers/char/random.c
@@ -2120,36 +2120,29 @@ randomize_range(unsigned long start, uns
 }
 
 /**
- * randomize_page - Generate a random, page aligned address
+ * randomize_addr - Generate a random, page aligned address
  * @start:	The smallest acceptable address the caller will take.
  * @range:	The size of the area, starting at @start, within which the
  *		random address must fall.
  *
- * If @start + @range would overflow, @range is capped.
+ * Before page alignment, the random address generated can be any value from
+ * @start, to @start + @range - 1 inclusive.
  *
- * NOTE: Historical use of randomize_range, which this replaces, presumed that
- * @start was already page aligned.  We now align it regardless.
+ * If @start + @range would overflow, @range is capped.
  *
  * Return: A page aligned address within [start, start + range).  On error,
  * @start is returned.
  */
 unsigned long
-randomize_page(unsigned long start, unsigned long range)
+randomize_addr(unsigned long start, unsigned long range)
 {
-	if (!PAGE_ALIGNED(start)) {
-		range -= PAGE_ALIGN(start) - start;
-		start = PAGE_ALIGN(start);
-	}
+	if (range == 0)
+		return start;
 
 	if (start > ULONG_MAX - range)
 		range = ULONG_MAX - start;
 
-	range >>= PAGE_SHIFT;
-
-	if (range == 0)
-		return start;
-
-	return start + (get_random_long() % range << PAGE_SHIFT);
+	return PAGE_ALIGN(get_random_long() % range + start);
 }
 
 /* Interface for in-kernel drivers of true hardware RNGs.
diff -puN include/linux/random.h~random-simplify-api-for-random-address-requests-v2 include/linux/random.h
--- a/include/linux/random.h~random-simplify-api-for-random-address-requests-v2
+++ a/include/linux/random.h
@@ -35,7 +35,7 @@ extern const struct file_operations rand
 unsigned int get_random_int(void);
 unsigned long get_random_long(void);
 unsigned long randomize_range(unsigned long start, unsigned long end, unsigned long len);
-unsigned long randomize_page(unsigned long start, unsigned long range);
+unsigned long randomize_addr(unsigned long start, unsigned long range);
 
 u32 prandom_u32(void);
 void prandom_bytes(void *buf, size_t nbytes);
_

Patches currently in -mm which might be from jason@lakedaemon.net are

random-simplify-api-for-random-address-requests.patch
x86-use-simpler-api-for-random-address-requests.patch
x86-use-simpler-api-for-random-address-requests-v2.patch
arm-use-simpler-api-for-random-address-requests.patch
arm-use-simpler-api-for-random-address-requests-v2.patch
arm64-use-simpler-api-for-random-address-requests.patch
arm64-use-simpler-api-for-random-address-requests-v2.patch
tile-use-simpler-api-for-random-address-requests.patch
tile-use-simpler-api-for-random-address-requests-v2.patch
unicore32-use-simpler-api-for-random-address-requests.patch
unicore32-use-simpler-api-for-random-address-requests-v2.patch
random-remove-unused-randomize_range.patch

