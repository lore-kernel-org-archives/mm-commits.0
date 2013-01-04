From: akpm@linux-foundation.org
Subject: + generic-dynamic-per-cpu-refcounting-fix.patch added to -mm tree
Date: Fri, 04 Jan 2013 14:32:24 -0800
Message-ID: <20130104223224.A6C4C100049@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:33723 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023Ab3ADWcl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jan 2013 17:32:41 -0500
Received: by mail-vc0-f201.google.com with SMTP id p1so1810539vcq.4
        for <mm-commits@vger.kernel.org>; Fri, 04 Jan 2013 14:32:41 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, koverstreet@google.com


The patch titled
     Subject: generic-dynamic-per-cpu-refcounting-fix
has been added to the -mm tree.  Its filename is
     generic-dynamic-per-cpu-refcounting-fix.patch

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
Subject: generic-dynamic-per-cpu-refcounting-fix

lib/percpu-refcount.c: In function 'percpu_ref_init':
lib/percpu-refcount.c:22: error: 'jiffies' undeclared (first use in this function)
lib/percpu-refcount.c:22: error: (Each undeclared identifier is reported only once
lib/percpu-refcount.c:22: error: for each function it appears in.)
lib/percpu-refcount.c: In function 'percpu_ref_alloc':
lib/percpu-refcount.c:36: error: 'jiffies' undeclared (first use in this function)
lib/percpu-refcount.c:41: error: 'HZ' undeclared (first use in this function)

Cc: Kent Overstreet <koverstreet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/percpu-refcount.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/percpu-refcount.c~generic-dynamic-per-cpu-refcounting-fix lib/percpu-refcount.c
--- a/lib/percpu-refcount.c~generic-dynamic-per-cpu-refcounting-fix
+++ a/lib/percpu-refcount.c
@@ -1,6 +1,7 @@
 #define pr_fmt(fmt) "%s: " fmt "\n", __func__
 
 #include <linux/kernel.h>
+#include <linux/jiffies.h>
 #include <linux/percpu-refcount.h>
 #include <linux/rcupdate.h>
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ipc-add-sysctl-to-specify-desired-next-object-id.patch
ipc-message-queue-receive-cleanup.patch
ipc-convert-prepare_copy-from-macro-to-function.patch
rtc-add-rtc-driver-for-tps6586x-fix.patch
rtc-add-rtc-driver-for-tps6586x-fix2.patch
linux-next.patch
make-my-i386-build-work.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
i-need-old-gcc.patch
lib-cpu_rmap-avoid-flushing-all-workqueues-fix.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
kernel-auditc-avoid-negative-sleep-durations.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2.patch
mm.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
cma-make-putback_lru_pages-call-conditional-fix.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
rtc-max77686-add-maxim-77686-driver-fix.patch
rtc-pcf8523-add-low-battery-voltage-support-fix.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
aio-dont-include-aioh-in-schedh-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
aio-smoosh-struct-kiocb-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

