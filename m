From: akpm@linux-foundation.org
Subject: +
 relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup-checkpatch-fixes.patch added to -mm tree
Date: Thu, 08 Sep 2016 16:46:20 -0700
Message-ID: <57d1f84c./IZqUodx7zbzvy04%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47557 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751000AbcIHXqV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Sep 2016 19:46:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, akash.goel@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup-checkpatch-fixes

ERROR: Please use git commit description style 'commit <12+ chars of sha1> ("<title line>")' - ie: 'commit 0123456789ab ("commit description")'
#12: 
	commit 7c9cb38302e78d24e37f7d8a2ea7eed4ae5f2fa7

WARNING: line over 80 characters
#87: FILE: kernel/relay.c:337:
+	struct rchan_buf *buf = container_of(work, struct rchan_buf, wakeup_work);

WARNING: waitqueue_active without comment
#119: FILE: kernel/relay.c:772:
+		if (waitqueue_active(&buf->read_wait)) {

total: 1 errors, 2 warnings, 70 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Akash Goel <akash.goel@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/relay.c~relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup-checkpatch-fixes kernel/relay.c
--- a/kernel/relay.c~relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup-checkpatch-fixes
+++ a/kernel/relay.c
@@ -334,7 +334,9 @@ static struct rchan_callbacks default_ch
  */
 static void wakeup_readers(struct irq_work *work)
 {
-	struct rchan_buf *buf = container_of(work, struct rchan_buf, wakeup_work);
+	struct rchan_buf *buf;
+
+	buf = container_of(work, struct rchan_buf, wakeup_work);
 	wake_up_interruptible(&buf->read_wait);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-vmalloc-fix-align-value-calculation-error-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix.patch
mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions-checkpatch-fixes.patch
mm-swap-add-swap_cluster_list-checkpatch-fixes.patch
mm-check-that-we-havent-used-more-than-32-bits-in-address_spaceflags.patch
mm-mlock-check-against-vma-for-actual-mlock-size-fix.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch
relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup-checkpatch-fixes.patch
ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-mlx5-deviceh-kill-build_bug_ons.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

