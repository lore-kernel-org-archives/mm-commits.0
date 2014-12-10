From: akpm@linux-foundation.org
Subject: + rtc-ds1374-add-watchdog-support-fix.patch added to -mm tree
Date: Tue, 09 Dec 2014 16:10:41 -0800
Message-ID: <54878f81.3D+xHRu7VsGDHeNI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43948 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbaLJAKm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Dec 2014 19:10:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, dan.carpenter@oracle.com, san@rosetechnology.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-ds1374-add-watchdog-support-fix
has been added to the -mm tree.  Its filename is
     rtc-ds1374-add-watchdog-support-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-ds1374-add-watchdog-su=
pport-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-ds1374-add-watchdog-su=
pport-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Andrew Morton <akpm@linux-foundation.org>
Subject: rtc-ds1374-add-watchdog-support-fix

don't forget mutex_unlock() in ds1374_wdt_open() error path

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Soeren Andersen <san@rosetechnology.dk>
Cc: S=F8ren Andersen <san@rosetechnology.dk>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1374.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/Kconfig~rtc-ds1374-add-watchdog-support-fix drive=
rs/rtc/Kconfig
diff -puN drivers/rtc/rtc-ds1374.c~rtc-ds1374-add-watchdog-support-fix =
drivers/rtc/rtc-ds1374.c
--- a/drivers/rtc/rtc-ds1374.c~rtc-ds1374-add-watchdog-support-fix
+++ a/drivers/rtc/rtc-ds1374.c
@@ -458,8 +458,10 @@ static int ds1374_wdt_open(struct inode
=20
 	if (MINOR(inode->i_rdev) =3D=3D WATCHDOG_MINOR) {
 		mutex_lock(&ds1374->mutex);
-		if (test_and_set_bit(0, &wdt_is_open))
+		if (test_and_set_bit(0, &wdt_is_open)) {
+			mutex_unlock(&ds1374->mutex);
 			return -EBUSY;
+		}
 		/*
 		 *      Activate
 		 */
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-cma-fix-boot-regression-due-to-physical-address-of-high_memory-fix.p=
atch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkp=
atch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix.patch
mm.patch
slab-improve-checking-for-invalid-gfp_flags.patch
mm-memcontrol-lockless-page-counters-fix.patch
mm-memcontrol-lockless-page-counters-fix-fix.patch
kernel-res_counter-remove-the-unused-api-fix.patch
mm-compaction-simplify-deferred-compaction-fix.patch
mm-compaction-always-update-cached-scanner-positions-fix-checkpatch-fix=
es.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix.=
patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch
mm-fix-huge-zero-page-accounting-in-smaps-report-fix-2-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-mincore-add-hwpoison-page-handle-checkpatch-fixes.patch
include-linux-kmemleakh-needs-slabh.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-page_owner-keep-track-of-page-owners.patch
fs-seq_file-fallback-to-vmalloc-instead-of-oom-kill-processes-fix.patch
oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2-fix.patch
mm-memcontrol-fix-defined-but-not-used-compiler-warning-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix-2.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix.patch
mm-zsmalloc-support-allocating-obj-with-size-of-zs_max_alloc_size-fix.p=
atch
mm-zsmalloc-avoid-duplicate-assignment-of-prev_class-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
fs-proc-use-a-rb-tree-for-the-directory-entries-fix.patch
fs-binfmt_miscc-use-gfp_kernel-instead-of-gfp_user.patch
init-allow-config_init_fallback=3Dn-to-disable-defaults-if-init=3D-fail=
s-checkpatch-fixes.patch
rtc-omap-add-support-for-pmic_power_en-v3-fix.patch
drivers-rtc-rtc-sirfsocc-add-alarm_irq_enable-support-fix.patch
rtc-ds1374-add-watchdog-support-fix.patch
rtc-ds1374-add-watchdog-support-checkpatch-fixes.patch
exit-wait-cleanup-the-ptrace_reparented-checks-fix.patch
sysctl-terminate-strings-also-on-r-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch
ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-cma-make-kmemleak-ignore-cma-regions.patch
lib-show_mem-this-patch-adds-cma-reserved-infromation-fix.patch
tools-testing-selftests-makefile-alphasort-the-targets-list.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
