From: akpm@linux-foundation.org
Subject: + staging-lustre-convert-seq_-hash-functions-to-return-void.patch added to -mm tree
Date: Mon, 23 Feb 2015 15:58:36 -0800
Message-ID: <54ebbeac.6tHS/IrDeY/DxmId%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48248 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbbBWX6h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 18:58:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, andreas.dilger@intel.com, gregkh@linuxfoundation.org, oleg.drokin@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: staging: lustre: convert seq_ hash functions to return void
has been added to the -mm tree.  Its filename is
     staging-lustre-convert-seq_-hash-functions-to-return-void.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/staging-lustre-convert-seq_-hash-functions-to-return-void.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/staging-lustre-convert-seq_-hash-functions-to-return-void.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: staging: lustre: convert seq_ hash functions to return void

These functions don't need to return anything.
No caller uses the return value.

Miscellanea:

Integrate the individual strings to reduce object size ~100 bytes.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Oleg Drokin <oleg.drokin@intel.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/lustre/include/linux/libcfs/libcfs_hash.h |    4 +-
 drivers/staging/lustre/lustre/libcfs/hash.c               |   14 ++--------
 2 files changed, 6 insertions(+), 12 deletions(-)

diff -puN drivers/staging/lustre/include/linux/libcfs/libcfs_hash.h~staging-lustre-convert-seq_-hash-functions-to-return-void drivers/staging/lustre/include/linux/libcfs/libcfs_hash.h
--- a/drivers/staging/lustre/include/linux/libcfs/libcfs_hash.h~staging-lustre-convert-seq_-hash-functions-to-return-void
+++ a/drivers/staging/lustre/include/linux/libcfs/libcfs_hash.h
@@ -785,8 +785,8 @@ static inline void __cfs_hash_set_theta(
 
 /* Generic debug formatting routines mainly for proc handler */
 struct seq_file;
-int cfs_hash_debug_header(struct seq_file *m);
-int cfs_hash_debug_str(struct cfs_hash *hs, struct seq_file *m);
+void cfs_hash_debug_header(struct seq_file *m);
+void cfs_hash_debug_str(struct cfs_hash *hs, struct seq_file *m);
 
 /*
  * Generic djb2 hash algorithm for character arrays.
diff -puN drivers/staging/lustre/lustre/libcfs/hash.c~staging-lustre-convert-seq_-hash-functions-to-return-void drivers/staging/lustre/lustre/libcfs/hash.c
--- a/drivers/staging/lustre/lustre/libcfs/hash.c~staging-lustre-convert-seq_-hash-functions-to-return-void
+++ a/drivers/staging/lustre/lustre/libcfs/hash.c
@@ -2008,14 +2008,10 @@ void cfs_hash_rehash_key(struct cfs_hash
 }
 EXPORT_SYMBOL(cfs_hash_rehash_key);
 
-int cfs_hash_debug_header(struct seq_file *m)
+void cfs_hash_debug_header(struct seq_file *m)
 {
-	seq_printf(m, "%-*s%6s%6s%6s%6s%6s%6s%6s%7s%8s%8s%8s%s\n",
-		   CFS_HASH_BIGNAME_LEN,
-		   "name", "cur", "min", "max", "theta", "t-min", "t-max",
-		   "flags", "rehash", "count", "maxdep", "maxdepb",
-		   " distribution");
-	return 0;
+	seq_printf(m, "%-*s   cur   min   max theta t-min t-max flags rehash   count  maxdep maxdepb distribution\n",
+		   CFS_HASH_BIGNAME_LEN, "name");
 }
 EXPORT_SYMBOL(cfs_hash_debug_header);
 
@@ -2043,7 +2039,7 @@ cfs_hash_full_nbkt(struct cfs_hash *hs)
 	       CFS_HASH_RH_NBKT(hs) : CFS_HASH_NBKT(hs);
 }
 
-int cfs_hash_debug_str(struct cfs_hash *hs, struct seq_file *m)
+void cfs_hash_debug_str(struct cfs_hash *hs, struct seq_file *m)
 {
 	int		    dist[8] = { 0, };
 	int		    maxdep  = -1;
@@ -2098,7 +2094,5 @@ int cfs_hash_debug_str(struct cfs_hash *
 		seq_printf(m, "%d%c",  dist[i], (i == 7) ? '\n' : '/');
 
 	cfs_hash_unlock(hs, 0);
-
-	return 0;
 }
 EXPORT_SYMBOL(cfs_hash_debug_str);
_

Patches currently in -mm which might be from joe@perches.com are

staging-lustre-convert-return-seq_printf-uses.patch
staging-lustre-convert-seq_-hash-functions-to-return-void.patch
staging-lustre-convert-uses-of-int-rc-=-seq_printf.patch
staging-lustre-convert-remaining-uses-of-=-seq_printf.patch
x86-mtrr-if-remove-use-of-seq_printf-return-value.patch
power-wakeup-remove-use-of-seq_printf-return-value.patch
rtc-remove-use-of-seq_printf-return-value.patch
ipc-remove-use-of-seq_printf-return-value.patch
pxa27x_udc-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value.patch
nios2-cpuinfo-remove-use-of-seq_printf-return-value.patch
arm-plat-pxa-remove-use-of-seq_printf-return-value.patch
openrisc-remove-use-of-seq_printf-return-value.patch
cris-remove-use-of-seq_printf-return-value.patch
mfd-ab8500-debugfs-remove-use-of-seq_printf-return-value.patch
staging-i2o-remove-use-of-seq_printf-return-value.patch
staging-rtl8192x-remove-use-of-seq_printf-return-value.patch
s390-remove-use-of-seq_printf-return-value.patch
i8k-remove-use-of-seq_printf-return-value.patch
watchdog-bcm281xx-remove-use-of-seq_printf-return-value.patch
proc-remove-use-of-seq_printf-return-value.patch
cgroup-remove-use-of-seq_printf-return-value.patch
tracing-remove-use-of-seq_printf-return-value.patch
lru_cache-remove-use-of-seq_printf-return-value.patch
parisc-remove-use-of-seq_printf-return-value.patch
regulator-dbx500-remove-use-of-seq_puts-seq_printf-return-value.patch
mm-utilc-add-kstrimdup.patch
checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch
linux-next.patch

