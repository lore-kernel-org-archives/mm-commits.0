From: akpm@linux-foundation.org
Subject: + build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it.patch added to -mm tree
Date: Wed, 19 Aug 2009 14:49:08 -0700
Message-ID: <200908192149.n7JLn8Hr015645@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753271AbZHSVtc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Aug 2009 17:49:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: JBeulich@novell.com, andi@firstfloor.org, catalin.marinas@arm.com, davem@davemloft.net, jbeulich@novell.com, rusty@rustcorp.com.au


The patch titled
     BUILD_BUG_ON(): fix it and a couple of bogus uses of it
has been added to the -mm tree.  Its filename is
     build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: BUILD_BUG_ON(): fix it and a couple of bogus uses of it
From: "Jan Beulich" <JBeulich@novell.com>

gcc permitting variable length arrays makes the current construct used for
BUILD_BUG_ON() useless, as that doesn't produce any diagnostic if the
controlling expression isn't really constant.  Instead, this patch makes
it so that a bit field gets used here.  Consequently, those uses where the
condition isn't really constant now also need fixing.

Note that in the gfp.h, kmemcheck.h, and virtio_config.h cases
MAYBE_BUILD_BUG_ON() really just serves documentation purposes - even if
the expression is compile time constant (__builtin_constant_p() yields
true), the array is still deemed of variable length by gcc, and hence the
whole expression doesn't have the intended effect.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm.c        |    2 --
 drivers/net/niu.c             |    2 +-
 include/linux/gfp.h           |    2 +-
 include/linux/kernel.h        |    8 ++++++--
 include/linux/kmemcheck.h     |    2 +-
 include/linux/virtio_config.h |    3 +--
 6 files changed, 10 insertions(+), 9 deletions(-)

diff -puN drivers/char/tpm/tpm.c~build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it drivers/char/tpm/tpm.c
--- a/drivers/char/tpm/tpm.c~build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it
+++ a/drivers/char/tpm/tpm.c
@@ -696,7 +696,6 @@ int __tpm_pcr_read(struct tpm_chip *chip
 
 	cmd.header.in = pcrread_header;
 	cmd.params.pcrread_in.pcr_idx = cpu_to_be32(pcr_idx);
-	BUILD_BUG_ON(cmd.header.in.length > READ_PCR_RESULT_SIZE);
 	rc = transmit_cmd(chip, &cmd, cmd.header.in.length,
 			  "attempting to read a pcr value");
 
@@ -760,7 +759,6 @@ int tpm_pcr_extend(u32 chip_num, int pcr
 		return -ENODEV;
 
 	cmd.header.in = pcrextend_header;
-	BUILD_BUG_ON(be32_to_cpu(cmd.header.in.length) > EXTEND_PCR_SIZE);
 	cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(pcr_idx);
 	memcpy(cmd.params.pcrextend_in.hash, hash, TPM_DIGEST_SIZE);
 	rc = transmit_cmd(chip, &cmd, cmd.header.in.length,
diff -puN drivers/net/niu.c~build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it drivers/net/niu.c
--- a/drivers/net/niu.c~build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it
+++ a/drivers/net/niu.c
@@ -5615,7 +5615,7 @@ static void niu_init_tx_mac(struct niu *
 	/* The XMAC_MIN register only accepts values for TX min which
 	 * have the low 3 bits cleared.
 	 */
-	BUILD_BUG_ON(min & 0x7);
+	BUG_ON(min & 0x7);
 
 	if (np->flags & NIU_FLAGS_XMAC)
 		niu_init_tx_xmac(np, min, max);
diff -puN include/linux/gfp.h~build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it include/linux/gfp.h
--- a/include/linux/gfp.h~build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it
+++ a/include/linux/gfp.h
@@ -220,7 +220,7 @@ static inline enum zone_type gfp_zone(gf
 					 ((1 << ZONES_SHIFT) - 1);
 
 	if (__builtin_constant_p(bit))
-		BUILD_BUG_ON((GFP_ZONE_BAD >> bit) & 1);
+		MAYBE_BUILD_BUG_ON((GFP_ZONE_BAD >> bit) & 1);
 	else {
 #ifdef CONFIG_DEBUG_VM
 		BUG_ON((GFP_ZONE_BAD >> bit) & 1);
diff -puN include/linux/kernel.h~build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it include/linux/kernel.h
--- a/include/linux/kernel.h~build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it
+++ a/include/linux/kernel.h
@@ -678,13 +678,17 @@ struct sysinfo {
 };
 
 /* Force a compilation error if condition is true */
-#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
+#define BUILD_BUG_ON(condition) ((void)BUILD_BUG_ON_ZERO(condition))
+
+/* Force a compilation error if condition is constant and true */
+#define MAYBE_BUILD_BUG_ON(cond) ((void)sizeof(char[1 - 2 * !!(cond)]))
 
 /* Force a compilation error if condition is true, but also produce a
    result (of value 0 and type size_t), so the expression can be used
    e.g. in a structure initializer (or where-ever else comma expressions
    aren't permitted). */
-#define BUILD_BUG_ON_ZERO(e) (sizeof(char[1 - 2 * !!(e)]) - 1)
+#define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
+#define BUILD_BUG_ON_NULL(e) ((void *)sizeof(struct { int:-!!(e); }))
 
 /* Trap pasters of __FUNCTION__ at compile-time */
 #define __FUNCTION__ (__func__)
diff -puN include/linux/kmemcheck.h~build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it include/linux/kmemcheck.h
--- a/include/linux/kmemcheck.h~build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it
+++ a/include/linux/kmemcheck.h
@@ -140,7 +140,7 @@ static inline void kmemcheck_mark_initia
 	do if (ptr) {							\
 		int _n = (long) &((ptr)->name##_end)			\
 			- (long) &((ptr)->name##_begin);		\
-		BUILD_BUG_ON(_n < 0);					\
+		MAYBE_BUILD_BUG_ON(_n < 0);				\
 									\
 		kmemcheck_mark_initialized(&((ptr)->name##_begin), _n);	\
 	} while (0)
diff -puN include/linux/virtio_config.h~build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it include/linux/virtio_config.h
--- a/include/linux/virtio_config.h~build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it
+++ a/include/linux/virtio_config.h
@@ -109,8 +109,7 @@ static inline bool virtio_has_feature(co
 				      unsigned int fbit)
 {
 	/* Did you forget to fix assumptions on max features? */
-	if (__builtin_constant_p(fbit))
-		BUILD_BUG_ON(fbit >= 32);
+	MAYBE_BUILD_BUG_ON(fbit >= 32);
 
 	if (fbit < VIRTIO_TRANSPORT_F_START)
 		virtio_check_driver_offered_feature(vdev, fbit);
_

Patches currently in -mm which might be from JBeulich@novell.com are

linux-next.patch
memory-hotplug-fix-updating-of-num_physpages-for-hot-plugged-memory.patch
mm-replace-various-uses-of-num_physpages-by-totalram_pages.patch
mm-dont-use-alloc_bootmem_low-where-not-strictly-needed.patch
mm-also-use-alloc_large_system_hash-for-the-pid-hash-table.patch
build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it.patch

