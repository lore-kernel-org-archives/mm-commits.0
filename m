From: akpm@linux-foundation.org
Subject: + alpha-bad-macro-expansion-parameter-is-member.patch added to -mm tree
Date: Tue, 12 May 2009 15:24:19 -0700
Message-ID: <200905122224.n4CMOJeE028749@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55944 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751722AbZELW1K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 May 2009 18:27:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, ink@jurassic.park.msu.ru, rth@twiddle.net


The patch titled
     alpha: bad macro expansion, parameter is member
has been added to the -mm tree.  Its filename is
     alpha-bad-macro-expansion-parameter-is-member.patch

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
Subject: alpha: bad macro expansion, parameter is member
From: Roel Kluin <roel.kluin@gmail.com>

`for_each_mem_cluster(x, y, z)' will expand to
`for ((x) = (y)->x ...' but correct is `for ((x) = (y)->cluster ...'

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/setup.c |    6 +++---
 arch/alpha/mm/numa.c      |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/alpha/kernel/setup.c~alpha-bad-macro-expansion-parameter-is-member arch/alpha/kernel/setup.c
--- a/arch/alpha/kernel/setup.c~alpha-bad-macro-expansion-parameter-is-member
+++ a/arch/alpha/kernel/setup.c
@@ -252,9 +252,9 @@ reserve_std_resources(void)
 }
 
 #define PFN_MAX		PFN_DOWN(0x80000000)
-#define for_each_mem_cluster(memdesc, cluster, i)		\
-	for ((cluster) = (memdesc)->cluster, (i) = 0;		\
-	     (i) < (memdesc)->numclusters; (i)++, (cluster)++)
+#define for_each_mem_cluster(memdesc, _cluster, i)		\
+	for ((_cluster) = (memdesc)->cluster, (i) = 0;		\
+	     (i) < (memdesc)->numclusters; (i)++, (_cluster)++)
 
 static unsigned long __init
 get_mem_size_limit(char *s)
diff -puN arch/alpha/mm/numa.c~alpha-bad-macro-expansion-parameter-is-member arch/alpha/mm/numa.c
--- a/arch/alpha/mm/numa.c~alpha-bad-macro-expansion-parameter-is-member
+++ a/arch/alpha/mm/numa.c
@@ -28,9 +28,9 @@ EXPORT_SYMBOL(node_data);
 #define DBGDCONT(args...)
 #endif
 
-#define for_each_mem_cluster(memdesc, cluster, i)		\
-	for ((cluster) = (memdesc)->cluster, (i) = 0;		\
-	     (i) < (memdesc)->numclusters; (i)++, (cluster)++)
+#define for_each_mem_cluster(memdesc, _cluster, i)		\
+	for ((_cluster) = (memdesc)->cluster, (i) = 0;		\
+	     (i) < (memdesc)->numclusters; (i)++, (_cluster)++)
 
 static void __init show_mem_layout(void)
 {
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
asm-generic-fix-local_add_unless-macro.patch
linux-next.patch
i2c-pxac-timeouts-off-by-1.patch
drm-fix-lock_test_with_return-macro.patch
v4l-dvb-cimax2c-fix-typo.patch
zoran-fix-error.patch
uwb-event_size-should-be-signed.patch
isdn-get_free_devid-failure-ignored.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
wis-sony-tunerc-typo.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-bad-macro-expansion-parameter-is-member.patch
m68k-count-can-reach-51-not-50.patch
serial-z85c30-bcm1480-loops-reach-1.patch
spi_bfin5xx-limit-reaches-1.patch
ufs-sector_t-cannot-be-negative.patch

