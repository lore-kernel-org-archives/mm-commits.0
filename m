From: akpm@linux-foundation.org
Subject: + pid_namespacec-h-simplify-defines-fix.patch added to -mm tree
Date: Thu, 07 Mar 2013 14:22:59 -0800
Message-ID: <20130307222259.BE2D55A42FE@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:58833 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab3CGWXB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Mar 2013 17:23:01 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so99400yhz.5
        for <mm-commits@vger.kernel.org>; Thu, 07 Mar 2013 14:23:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, raphael.scarv@gmail.com


The patch titled
     Subject: pid_namespacec-h-simplify-defines-fix
has been added to the -mm tree.  Its filename is
     pid_namespacec-h-simplify-defines-fix.patch

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
Subject: pid_namespacec-h-simplify-defines-fix

kernel/pid.c:54:1: warning: "BITS_PER_PAGE" redefined

Cc: Raphael S.Carvalho <raphael.scarv@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid_namespace.h |    1 +
 kernel/pid.c                  |    3 ---
 2 files changed, 1 insertion(+), 3 deletions(-)

diff -puN include/linux/pid_namespace.h~pid_namespacec-h-simplify-defines-fix include/linux/pid_namespace.h
--- a/include/linux/pid_namespace.h~pid_namespacec-h-simplify-defines-fix
+++ a/include/linux/pid_namespace.h
@@ -14,6 +14,7 @@ struct pidmap {
 };
 
 #define BITS_PER_PAGE		(PAGE_SIZE * 8)
+#define BITS_PER_PAGE_MASK	(BITS_PER_PAGE-1)
 #define PIDMAP_ENTRIES		((PID_MAX_LIMIT+BITS_PER_PAGE-1)/BITS_PER_PAGE)
 
 struct bsd_acct_struct;
diff -puN kernel/pid.c~pid_namespacec-h-simplify-defines-fix kernel/pid.c
--- a/kernel/pid.c~pid_namespacec-h-simplify-defines-fix
+++ a/kernel/pid.c
@@ -51,9 +51,6 @@ int pid_max = PID_MAX_DEFAULT;
 int pid_max_min = RESERVED_PIDS + 1;
 int pid_max_max = PID_MAX_LIMIT;
 
-#define BITS_PER_PAGE		(PAGE_SIZE*8)
-#define BITS_PER_PAGE_MASK	(BITS_PER_PAGE-1)
-
 static inline int mk_pid(struct pid_namespace *pid_ns,
 		struct pidmap *map, int off)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
dmi_scan-fix-missing-check-for-_dmi_-signature-in-smbios_present-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3-fix.patch
mm.patch
mm-shmemc-remove-an-ifdef.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
kernel-smpc-cleanups.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
pid_namespacec-h-simplify-defines-fix.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-use-cancellation-list-lazily-fix-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
generic-dynamic-per-cpu-refcounting-sparse-fixes-fix.patch
generic-dynamic-per-cpu-refcounting-doc-fix.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-dont-include-aioh-in-schedh-fix-3-fix.patch
aio-dont-include-aioh-in-schedh-fix-3-fix-fix.patch
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

