From: akpm@linux-foundation.org
Subject: + rapidio-rio_cm-avoid-gfp_kernel-in-atomic-context-fix.patch
 added to -mm tree
Date: Fri, 16 Sep 2016 15:08:09 -0700
Message-ID: <57dc6d49.TIlh8iQcii3bW/7T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58592 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756794AbcIPWIL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Sep 2016 18:08:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alexandre.bounine@idt.com, khoroshilov@ispras.ru, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio-rio_cm-avoid-gfp_kernel-in-atomic-context-fix
has been added to the -mm tree.  Its filename is
     rapidio-rio_cm-avoid-gfp_kernel-in-atomic-context-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-rio_cm-avoid-gfp_kernel-in-atomic-context-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-rio_cm-avoid-gfp_kernel-in-atomic-context-fix.patch

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
Subject: rapidio-rio_cm-avoid-gfp_kernel-in-atomic-context-fix

remove unneeded `if (!list_empty())'

Cc: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio_cm.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/rapidio/rio_cm.c~rapidio-rio_cm-avoid-gfp_kernel-in-atomic-context-fix drivers/rapidio/rio_cm.c
--- a/drivers/rapidio/rio_cm.c~rapidio-rio_cm-avoid-gfp_kernel-in-atomic-context-fix
+++ a/drivers/rapidio/rio_cm.c
@@ -2268,9 +2268,8 @@ static int rio_cm_shutdown(struct notifi
 	}
 	spin_unlock_bh(&idr_lock);
 
-	if (!list_empty(&list))
-		list_for_each_entry(ch, &list, ch_node)
-			riocm_send_close(ch);
+	list_for_each_entry(ch, &list, ch_node)
+		riocm_send_close(ch);
 
 	return NOTIFY_DONE;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
rapidio-rio_cm-avoid-gfp_kernel-in-atomic-context-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-vmalloc-fix-align-value-calculation-error-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix.patch
mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions-checkpatch-fixes.patch
mm-swap-add-swap_cluster_list-checkpatch-fixes.patch
mm-mlock-check-against-vma-for-actual-mlock-size-fix.patch
mm-page_ioc-replace-some-bug_ons-with-vm_bug_on_page.patch
fs-use-mapping_set_error-instead-of-opencoded-set_bit-fix.patch
mm-memcontrol-consolidate-cgroup-socket-tracking-fix.patch
mm-memcontrol-consolidate-cgroup-socket-tracking-checkpatch-fixes.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch
lib-bitmapc-enhance-bitmap-syntax-fix.patch
relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup-checkpatch-fixes.patch
ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-mlx5-deviceh-kill-build_bug_ons.patch
hung_task-allow-hung_task_panic-when-hung_task_warnings-is-0-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

