From: akpm@linux-foundation.org
Subject: [merged] crc32-optimize-loop-counter-for-x86.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:30:50 -0700
Message-ID: <20120326193050.6115AA00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:52960 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558Ab2CZTav (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:30:51 -0400
Received: by mail-fa0-f74.google.com with SMTP id a19so298455faa.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:30:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpearson@systemfabricworks.com, djwong@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: crc32: optimize loop counter for x86
has been removed from the -mm tree.  Its filename was
     crc32-optimize-loop-counter-for-x86.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from rpearson@systemfabricworks.com are

origin.patch

