From: akpm@linux-foundation.org
Subject: + memcg-relax-memcg-iter-caching-checkpatch-fixes.patch added to -mm tree
Date: Wed, 13 Mar 2013 15:22:32 -0700
Message-ID: <20130313222233.261215A41D7@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:40839 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933282Ab3CMWWe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Mar 2013 18:22:34 -0400
Received: by mail-ve0-f202.google.com with SMTP id m1so160792ves.5
        for <mm-commits@vger.kernel.org>; Wed, 13 Mar 2013 15:22:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mhocko@suse.cz


The patch titled
     Subject: memcg-relax-memcg-iter-caching-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     memcg-relax-memcg-iter-caching-checkpatch-fixes.patch

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
Subject: memcg-relax-memcg-iter-caching-checkpatch-fixes

ERROR: code indent should use tabs where possible
#135: FILE: mm/memcontrol.c:1135:
+                         * If the dead_count mismatches, a destruction$

ERROR: code indent should use tabs where possible
#136: FILE: mm/memcontrol.c:1136:
+                         * has happened or is happening concurrently.$

ERROR: code indent should use tabs where possible
#137: FILE: mm/memcontrol.c:1137:
+                         * If the dead_count matches, a destruction$

ERROR: code indent should use tabs where possible
#138: FILE: mm/memcontrol.c:1138:
+                         * might still happen concurrently, but since$

ERROR: code indent should use tabs where possible
#139: FILE: mm/memcontrol.c:1139:
+                         * we checked under RCU, that destruction$

ERROR: code indent should use tabs where possible
#140: FILE: mm/memcontrol.c:1140:
+                         * won't free the object until we release the$

ERROR: code indent should use tabs where possible
#141: FILE: mm/memcontrol.c:1141:
+                         * RCU reader lock.  Thus, the dead_count$

ERROR: code indent should use tabs where possible
#142: FILE: mm/memcontrol.c:1142:
+                         * check verifies the pointer is still valid,$

ERROR: code indent should use tabs where possible
#143: FILE: mm/memcontrol.c:1143:
+                         * css_tryget() verifies the cgroup pointed to$

ERROR: code indent should use tabs where possible
#144: FILE: mm/memcontrol.c:1144:
+                         * is alive.$

total: 10 errors, 0 warnings, 130 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/memcg-relax-memcg-iter-caching.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN mm/memcontrol.c~memcg-relax-memcg-iter-caching-checkpatch-fixes mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-relax-memcg-iter-caching-checkpatch-fixes
+++ a/mm/memcontrol.c
@@ -1132,16 +1132,16 @@ struct mem_cgroup *mem_cgroup_iter(struc
 			}
 
 			/*
-                         * If the dead_count mismatches, a destruction
-                         * has happened or is happening concurrently.
-                         * If the dead_count matches, a destruction
-                         * might still happen concurrently, but since
-                         * we checked under RCU, that destruction
-                         * won't free the object until we release the
-                         * RCU reader lock.  Thus, the dead_count
-                         * check verifies the pointer is still valid,
-                         * css_tryget() verifies the cgroup pointed to
-                         * is alive.
+			 * If the dead_count mismatches, a destruction
+			 * has happened or is happening concurrently.
+			 * If the dead_count matches, a destruction
+			 * might still happen concurrently, but since
+			 * we checked under RCU, that destruction
+			 * won't free the object until we release the
+			 * RCU reader lock.  Thus, the dead_count
+			 * check verifies the pointer is still valid,
+			 * css_tryget() verifies the cgroup pointed to
+			 * is alive.
 			 */
 			dead_count = atomic_read(&root->dead_count);
 			smp_rmb();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
include-linux-res_counterh-needs-errnoh.patch
signal-always-clear-sa_restorer-on-execve.patch
kernel-signalc-use-__arch_has_sa_restorer-instead-of-sa_restorer.patch
mm-fremapc-fix-oops-on-error-path.patch
linux-next.patch
linux-next-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3-fix.patch
mm.patch
mm-shmemc-remove-an-ifdef.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module-fix.patch
memcg-relax-memcg-iter-caching-checkpatch-fixes.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
kernel-smpc-cleanups.patch
get_maintainer-use-filename-only-regex-match-for-tegra-fix.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix.patch
pid_namespacec-h-simplify-defines-fix.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
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

