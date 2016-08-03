From: akpm@linux-foundation.org
Subject: + random-simplify-api-for-random-address-requests.patch added to
 -mm tree
Date: Wed, 03 Aug 2016 16:57:01 -0700
Message-ID: <57a284cd.RH5JEfEKDiSClxQD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44312 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbcHCX6a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 19:58:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jason@lakedaemon.net, arnd@arndb.de, benh@kernel.crashing.org, catalin.marinas@arm.com, cmetcalf@mellanox.com, davem@davemloft.net, dcashman@android.com, gregkh@linuxfoundation.org, gxt@mprc.pku.edu.cn, hpa@zytor.com, jeffv@google.com, keescook@chromium.org, linux@arm.linux.org.uk, mingo@redhat.com, mpe@ellerman.id.au, nnk@google.com, paulus@samba.org, ralf@linux-mips.org, tglx@linutronix.de, tytso@mit.edu, will.deacon@arm.com, william.c.roberts@intel.com, ydroneaud@opteya.com, mm-commits@vger.kernel.org


The patch titled
     Subject: random: simplify API for random address requests
has been added to the -mm tree.  Its filename is
     random-simplify-api-for-random-address-requests.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/random-simplify-api-for-random-address-requests.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/random-simplify-api-for-random-address-requests.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jason Cooper <jason@lakedaemon.net>
Subject: random: simplify API for random address requests

To date, all callers of randomize_range() have set the length to 0, and
check for a zero return value.  For the current callers, the only way to
get zero returned is if end <= start.  Since they are all adding a
constant to the start address, this is unnecessary.

We can remove a bunch of needless checks by simplifying the API to do just
what everyone wants, return an address between [start, start + range).

While we're here, s/get_random_int/get_random_long/.  No current call site
is adversely affected by get_random_int(), since all current range
requests are < UINT_MAX.  However, we should match caller expectations to
avoid coming up short (ha!) in the future.

All current callers to randomize_range() chose to use the start address if
randomize_range() failed.  Therefore, we simplify things by just returning
the start address on error.

randomize_range() will be removed once all callers have been converted
over to randomize_addr().

Link: http://lkml.kernel.org/r/20160803233913.32511-2-jason@lakedaemon.net
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Roberts, William C" <william.c.roberts@intel.com>
Cc: Yann Droneaud <ydroneaud@opteya.com>
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H . Peter Anvin" <hpa@zytor.com>
Cc: Nick Kralevich <nnk@google.com>
Cc: Jeffrey Vander Stoep <jeffv@google.com>
Cc: Daniel Cashman <dcashman@android.com>
Cc: Chris Metcalf <cmetcalf@mellanox.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c  |   33 +++++++++++++++++++++++++++++++++
 include/linux/random.h |    1 +
 2 files changed, 34 insertions(+)

diff -puN drivers/char/random.c~random-simplify-api-for-random-address-requests drivers/char/random.c
--- a/drivers/char/random.c~random-simplify-api-for-random-address-requests
+++ a/drivers/char/random.c
@@ -2119,6 +2119,39 @@ randomize_range(unsigned long start, uns
 	return PAGE_ALIGN(get_random_int() % range + start);
 }
 
+/**
+ * randomize_page - Generate a random, page aligned address
+ * @start:	The smallest acceptable address the caller will take.
+ * @range:	The size of the area, starting at @start, within which the
+ *		random address must fall.
+ *
+ * If @start + @range would overflow, @range is capped.
+ *
+ * NOTE: Historical use of randomize_range, which this replaces, presumed that
+ * @start was already page aligned.  We now align it regardless.
+ *
+ * Return: A page aligned address within [start, start + range).  On error,
+ * @start is returned.
+ */
+unsigned long
+randomize_page(unsigned long start, unsigned long range)
+{
+	if (!PAGE_ALIGNED(start)) {
+		range -= PAGE_ALIGN(start) - start;
+		start = PAGE_ALIGN(start);
+	}
+
+	if (start > ULONG_MAX - range)
+		range = ULONG_MAX - start;
+
+	range >>= PAGE_SHIFT;
+
+	if (range == 0)
+		return start;
+
+	return start + (get_random_long() % range << PAGE_SHIFT);
+}
+
 /* Interface for in-kernel drivers of true hardware RNGs.
  * Those devices may produce endless random bits and will be throttled
  * when our pool is full.
diff -puN include/linux/random.h~random-simplify-api-for-random-address-requests include/linux/random.h
--- a/include/linux/random.h~random-simplify-api-for-random-address-requests
+++ a/include/linux/random.h
@@ -35,6 +35,7 @@ extern const struct file_operations rand
 unsigned int get_random_int(void);
 unsigned long get_random_long(void);
 unsigned long randomize_range(unsigned long start, unsigned long end, unsigned long len);
+unsigned long randomize_page(unsigned long start, unsigned long range);
 
 u32 prandom_u32(void);
 void prandom_bytes(void *buf, size_t nbytes);
_

Patches currently in -mm which might be from jason@lakedaemon.net are

random-simplify-api-for-random-address-requests.patch
x86-use-simpler-api-for-random-address-requests.patch
arm-use-simpler-api-for-random-address-requests.patch
arm64-use-simpler-api-for-random-address-requests.patch
tile-use-simpler-api-for-random-address-requests.patch
unicore32-use-simpler-api-for-random-address-requests.patch
random-remove-unused-randomize_range.patch

