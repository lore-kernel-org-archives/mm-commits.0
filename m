From: akpm@linux-foundation.org
Subject: + drivers-char-random-add-get_random_long.patch added to -mm tree
Date: Thu, 04 Feb 2016 15:20:16 -0800
Message-ID: <56b3dcb0.CfqKpt929nGNifar%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35859 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbcBDXUS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2016 18:20:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcashman@android.com, arnd@arndb.de, benh@kernel.crashing.org, catalin.marinas@arm.com, davem@davemloft.net, gregkh@linuxfoundation.org, hpa@zytor.com, jeffv@google.com, keescook@chromium.org, mingo@redhat.com, mpe@ellerman.id.au, nnk@google.com, paulus@samba.org, ralf@linux-mips.org, salyzyn@android.com, tglx@linutronix.de, tytso@mit.edu, viro@zeniv.linux.org.uk, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers: char: random: add get_random_long()
has been added to the -mm tree.  Its filename is
     drivers-char-random-add-get_random_long.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-char-random-add-get_random_long.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-char-random-add-get_random_long.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daniel Cashman <dcashman@android.com>
Subject: drivers: char: random: add get_random_long()

d07e22597d1d355 ("mm: mmap: add new /proc tunable for mmap_base ASLR")
added the ability to choose from a range of values to use for entropy
count in generating the random offset to the mmap_base address.  The
maximum value on this range was set to 32 bits for 64-bit x86 systems, but
this value could be increased further, requiring more than the 32 bits of
randomness provided by get_random_int(), as is already possible for arm64.
Add a new function: get_random_long() which more naturally fits with the
mmap usage of get_random_int() but operates exactly the same as
get_random_int().

Also, fix the shifting constant in mmap_rnd() to be an unsigned long so
that values greater than 31 bits generate an appropriate mask without
overflow.  This is especially important on x86, as its shift instruction
uses a 5-bit mask for the shift operand, which meant that any value for
mmap_rnd_bits over 31 acts as a no-op and effectively disables mmap_base
randomization.

Finally, replace calls to get_random_int() with get_random_long() where
appropriate.


This patch (of 2):

Add get_random_long().

Signed-off-by: Daniel Cashman <dcashman@android.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Nick Kralevich <nnk@google.com>
Cc: Jeff Vander Stoep <jeffv@google.com>
Cc: Mark Salyzyn <salyzyn@android.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c  |   22 ++++++++++++++++++++++
 include/linux/random.h |    1 +
 2 files changed, 23 insertions(+)

diff -puN drivers/char/random.c~drivers-char-random-add-get_random_long drivers/char/random.c
--- a/drivers/char/random.c~drivers-char-random-add-get_random_long
+++ a/drivers/char/random.c
@@ -1819,6 +1819,28 @@ unsigned int get_random_int(void)
 EXPORT_SYMBOL(get_random_int);
 
 /*
+ * Same as get_random_int(), but returns unsigned long.
+ */
+unsigned long get_random_long(void)
+{
+	__u32 *hash;
+	unsigned long ret;
+
+	if (arch_get_random_long(&ret))
+		return ret;
+
+	hash = get_cpu_var(get_random_int_hash);
+
+	hash[0] += current->pid + jiffies + random_get_entropy();
+	md5_transform(hash, random_int_secret);
+	ret = *(unsigned long *)hash;
+	put_cpu_var(get_random_int_hash);
+
+	return ret;
+}
+EXPORT_SYMBOL(get_random_long);
+
+/*
  * randomize_range() returns a start address such that
  *
  *    [...... <range> .....]
diff -puN include/linux/random.h~drivers-char-random-add-get_random_long include/linux/random.h
--- a/include/linux/random.h~drivers-char-random-add-get_random_long
+++ a/include/linux/random.h
@@ -34,6 +34,7 @@ extern const struct file_operations rand
 #endif
 
 unsigned int get_random_int(void);
+unsigned long get_random_long(void);
 unsigned long randomize_range(unsigned long start, unsigned long end, unsigned long len);
 
 u32 prandom_u32(void);
_

Patches currently in -mm which might be from dcashman@android.com are

drivers-char-random-add-get_random_long.patch
use-get_random_long.patch

