From: akpm@linux-foundation.org
Subject: [merged] alpha-bad-macro-expansion-parameter-is-member.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:36:50 -0700
Message-ID: <200906171836.n5HIaoTP002881@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758188AbZFQSqD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:46:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha: bad macro expansion, parameter is member
has been removed from the -mm tree.  Its filename was
     alpha-bad-macro-expansion-parameter-is-member.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
serial-fix-off-by-one-errors.patch
usb-mutually-exclusive-port_status.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
spi_bfin5xx-limit-reaches-1.patch
platinumfb-misplaced-parenthesis.patch
ufs-sector_t-cannot-be-negative.patch
dtlk-off-by-one-in-readwrite_tts.patch

