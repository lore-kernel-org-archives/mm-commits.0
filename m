From: akpm@linux-foundation.org
Subject: + crc32-optimize-loop-counter-for-x86.patch added to -mm tree
Date: Wed, 18 Jan 2012 15:01:53 -0800
Message-ID: <20120118230154.3784D1E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:45966 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab2ARXBz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2012 18:01:55 -0500
Received: by ggnv2 with SMTP id v2so381033ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2012 15:01:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpearson@systemfabricworks.com, djwong@us.ibm.com


The patch titled
     Subject: crc32: optimize loop counter for x86
has been added to the -mm tree.  Its filename is
     crc32-optimize-loop-counter-for-x86.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bob Pearson <rpearson@systemfabricworks.com>
Subject: crc32: optimize loop counter for x86

Add two changes that improve the performance of x86 systems

1. replace main loop with incrementing counter this change improves
   the performance of the selftest by about 5-6% on Nehalem CPUs.  The
   apparent reason is that the compiler can use the loop index to perform
   an indexed memory access.  This is reported to make the performance of
   PowerPC CPUs to get worse.

2. replace the rem_len loop with incrementing counter this change
   improves the performance of the selftest, which has more than the usual
   number of occurances, by about 1-2% on x86 CPUs.  In actual work loads
   the length is most often a multiple of 4 bytes and this code does not
   get executed as often if at all.  Again this change is reported to make
   the performance of PowerPC get worse.

[djwong@us.ibm.com: Minor changelog tweaks]
Signed-off-by: Bob Pearson <rpearson@systemfabricworks.com>
Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/crc32.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN lib/crc32.c~crc32-optimize-loop-counter-for-x86 lib/crc32.c
--- a/lib/crc32.c~crc32-optimize-loop-counter-for-x86
+++ a/lib/crc32.c
@@ -66,6 +66,9 @@ crc32_body(u32 crc, unsigned char const 
 # endif
 	const u32 *b;
 	size_t    rem_len;
+# ifdef CONFIG_X86
+	size_t i;
+# endif
 	const u32 *t0=tab[0], *t1=tab[1], *t2=tab[2], *t3=tab[3];
 	const u32 *t4 = tab[4], *t5 = tab[5], *t6 = tab[6], *t7 = tab[7];
 	u32 q;
@@ -86,7 +89,12 @@ crc32_body(u32 crc, unsigned char const 
 # endif
 
 	b = (const u32 *)buf;
+# ifdef CONFIG_X86
+	--b;
+	for (i = 0; i < len; i++) {
+# else
 	for (--b; len; --len) {
+# endif
 		q = crc ^ *++b; /* use pre increment for speed */
 # if CRC_LE_BITS == 32
 		crc = DO_CRC4;
@@ -100,9 +108,14 @@ crc32_body(u32 crc, unsigned char const 
 	/* And the last few bytes */
 	if (len) {
 		u8 *p = (u8 *)(b + 1) - 1;
+# ifdef CONFIG_X86
+		for (i = 0; i < len; i++)
+			DO_CRC(*++p); /* use pre increment for speed */
+# else
 		do {
 			DO_CRC(*++p); /* use pre increment for speed */
 		} while (--len);
+# endif
 	}
 	return crc;
 #undef DO_CRC
_
Subject: Subject: crc32: optimize loop counter for x86

Patches currently in -mm which might be from rpearson@systemfabricworks.com are

origin.patch
crc32-removed-two-instances-of-trailing-whitespaces.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation.patch
crc32-simplify-unit-test-code.patch
crc32-miscellaneous-cleanups.patch
crc32-fix-mixing-of-endian-specific-types.patch
crc32-make-crc__bits-definition-correspond-to-actual-bit-counts.patch
crc32-add-slice-by-8-algorithm-to-existing-code.patch
crc32-optimize-loop-counter-for-x86.patch
crc32-add-note-about-this-patchset-to-crc32c.patch
crc32-bolt-on-crc32c.patch
crypto-crc32c-should-use-library-implementation.patch
crc32-add-self-test-code-for-crc32c.patch
crc32-select-an-algorithm-via-kconfig.patch

