From: akpm@linux-foundation.org
Subject: + lru_cache-remove-use-of-seq_printf-return-value.patch added to
 -mm tree
Date: Mon, 23 Feb 2015 15:59:20 -0800
Message-ID: <54ebbed8.mPtQ42ygqzDDjt24%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48329 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbbBWX7V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 18:59:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, drbd-dev@lists.linbit.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lru_cache: remove use of seq_printf return value
has been added to the -mm tree.  Its filename is
     lru_cache-remove-use-of-seq_printf-return-value.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lru_cache-remove-use-of-seq_printf-return-value.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lru_cache-remove-use-of-seq_printf-return-value.patch

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
Subject: lru_cache: remove use of seq_printf return value

The seq_printf return value, because it's frequently misused,
will eventually be converted to void.

See: commit 1f33c41c03da ("seq_file: Rename seq_overflow() to
     seq_has_overflowed() and make public")

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/lru_cache.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN lib/lru_cache.c~lru_cache-remove-use-of-seq_printf-return-value lib/lru_cache.c
--- a/lib/lru_cache.c~lru_cache-remove-use-of-seq_printf-return-value
+++ a/lib/lru_cache.c
@@ -247,10 +247,11 @@ size_t lc_seq_printf_stats(struct seq_fi
 	 * progress) and "changed", when this in fact lead to an successful
 	 * update of the cache.
 	 */
-	return seq_printf(seq, "\t%s: used:%u/%u "
-		"hits:%lu misses:%lu starving:%lu locked:%lu changed:%lu\n",
-		lc->name, lc->used, lc->nr_elements,
-		lc->hits, lc->misses, lc->starving, lc->locked, lc->changed);
+	seq_printf(seq, "\t%s: used:%u/%u hits:%lu misses:%lu starving:%lu locked:%lu changed:%lu\n",
+		   lc->name, lc->used, lc->nr_elements,
+		   lc->hits, lc->misses, lc->starving, lc->locked, lc->changed);
+
+	return 0;
 }
 
 static struct hlist_head *lc_hash_slot(struct lru_cache *lc, unsigned int enr)
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

