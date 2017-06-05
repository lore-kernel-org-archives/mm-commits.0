From: akpm@linux-foundation.org
Subject: +
 signal-avoid-undefined-behaviour-in-kill_something_info-fix.patch added to
 -mm tree
Date: Mon, 05 Jun 2017 14:57:01 -0700
Message-ID: <5935d3ad.XZrElndX/xqsnLLR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52640 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751189AbdFEV5C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jun 2017 17:57:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@kernel.org, oleg@redhat.com, qiuxishi@huawei.com, vbabka@suse.cz, zhongjiang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: signal-avoid-undefined-behaviour-in-kill_something_info-fix
has been added to the -mm tree.  Its filename is
     signal-avoid-undefined-behaviour-in-kill_something_info-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/signal-avoid-undefined-behaviour-in-kill_something_info-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/signal-avoid-undefined-behaviour-in-kill_something_info-fix.patch

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
Subject: signal-avoid-undefined-behaviour-in-kill_something_info-fix

tweak comment

Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: zhongjiang <zhongjiang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN kernel/signal.c~signal-avoid-undefined-behaviour-in-kill_something_info-fix kernel/signal.c
--- a/kernel/signal.c~signal-avoid-undefined-behaviour-in-kill_something_info-fix
+++ a/kernel/signal.c
@@ -1393,10 +1393,7 @@ static int kill_something_info(int sig,
 		return ret;
 	}
 
-	/*
-	 * -INT_MIN is undefined, it need to exclude following case to
-	 * avoid the UBSAN detection.
-	 */
+	/* -INT_MIN is undefined.  Exclude this case to avoid a UBSAN warning */
 	if (pid == INT_MIN)
 		return -ESRCH;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix.patch
swap-add-block-io-poll-in-swapin-path-checkpatch-fixes.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix-fix.patch
mm-swap-sort-swap-entries-before-free-fix.patch
mm-vmscan-avoid-thrashing-anon-lru-when-free-file-is-low-fix.patch
mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error-fix.patch
signal-avoid-undefined-behaviour-in-kill_something_info-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

