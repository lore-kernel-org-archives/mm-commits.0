From: akpm@linux-foundation.org
Subject: + init-mainc-dont-use-pr_debug.patch added to -mm tree
Date: Thu, 10 Apr 2014 15:02:28 -0700
Message-ID: <534714f4.TpfiwyhaF4/QfhMv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49309 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845AbaDJWC3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Apr 2014 18:02:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, rmk@arm.linux.org.uk, joe@perches.com, akpm@linux-foundation.org

Subject: + init-mainc-dont-use-pr_debug.patch added to -mm tree
To: akpm@linux-foundation.org,joe@perches.com,rmk@arm.linux.org.uk,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 10 Apr 2014 15:02:28 -0700


The patch titled
     Subject: init/main.c: don't use pr_debug()
has been added to the -mm tree.  Its filename is
     init-mainc-dont-use-pr_debug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/init-mainc-dont-use-pr_debug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/init-mainc-dont-use-pr_debug.patch

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
Subject: init/main.c: don't use pr_debug()

Pertially revert ea676e846a8171b8 ("init/main.c: convert to pr_foo()").

Unbeknownst to me, pr_debug() is different from the other pr_foo() levels:
pr_debug() is a no-op when DEBUG is not defined.  Consequently
initcall_debug does not work when init/main.c was compiled without
-DDEBUG.

Reported-by: Russell King <rmk@arm.linux.org.uk>
Cc: Joe Perches <joe@perches.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN init/main.c~init-mainc-dont-use-pr_debug init/main.c
--- a/init/main.c~init-mainc-dont-use-pr_debug
+++ a/init/main.c
@@ -672,13 +672,13 @@ static int __init_or_module do_one_initc
 	unsigned long long duration;
 	int ret;
 
-	pr_debug("calling  %pF @ %i\n", fn, task_pid_nr(current));
+	printk(KERN_DEBUG "calling  %pF @ %i\n", fn, task_pid_nr(current));
 	calltime = ktime_get();
 	ret = fn();
 	rettime = ktime_get();
 	delta = ktime_sub(rettime, calltime);
 	duration = (unsigned long long) ktime_to_ns(delta) >> 10;
-	pr_debug("initcall %pF returned %d after %lld usecs\n",
+	printk(KERN_DEBUG "initcall %pF returned %d after %lld usecs\n",
 		 fn, ret, duration);
 
 	return ret;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
init-mainc-dont-use-pr_debug.patch
wait-explain-the-shadowing-and-type-inconsistencies.patch
mips-export-flush_icache_range-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
ufs-sb-mutex-merge-mutex_destroy.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

