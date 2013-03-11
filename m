From: akpm@linux-foundation.org
Subject: + mm-fremapc-fix-oops-on-error-path.patch added to -mm tree
Date: Mon, 11 Mar 2013 16:03:32 -0700
Message-ID: <20130311230332.6F84731C174@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:50252 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab3CKXDd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Mar 2013 19:03:33 -0400
Received: by mail-gg0-f202.google.com with SMTP id l4so441098ggi.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Mar 2013 16:03:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, tt.rantala@gmail.com, walken@google.com


The patch titled
     Subject: mm/fremap.c: fix oops on error path
has been added to the -mm tree.  Its filename is
     mm-fremapc-fix-oops-on-error-path.patch

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
Subject: mm/fremap.c: fix oops on error path

If find_vma() fails, sys_remap_file_pages() will dereference `vma', which
contains NULL.  Fix it by checking the pointer.

(We could alternatively check for err==0, but this seems more direct)

(The vm_flags change is to squish a bogus used-uninitialised warning
without adding extra code).

Reported-by: Tommi Rantala <tt.rantala@gmail.com>
Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fremap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/fremap.c~mm-fremapc-fix-oops-on-error-path mm/fremap.c
--- a/mm/fremap.c~mm-fremapc-fix-oops-on-error-path
+++ a/mm/fremap.c
@@ -163,7 +163,8 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 	 * and that the remapped range is valid and fully within
 	 * the single existing vma.
 	 */
-	if (!vma || !(vma->vm_flags & VM_SHARED))
+	vm_flags = vma->vm_flags;
+	if (!vma || !(vm_flags & VM_SHARED))
 		goto out;
 
 	if (!vma->vm_ops || !vma->vm_ops->remap_pages)
@@ -254,7 +255,8 @@ get_write_lock:
 	 */
 
 out:
-	vm_flags = vma->vm_flags;
+	if (vma)
+		vm_flags = vma->vm_flags;
 	if (likely(!has_write_lock))
 		up_read(&mm->mmap_sem);
 	else
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
include-linux-res_counterh-needs-errnoh.patch
signal-always-clear-sa_restorer-on-execve-fix.patch
kernel-signalc-use-__arch_has_sa_restorer-instead-of-sa_restorer.patch
mm-fremapc-fix-oops-on-error-path.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3-fix.patch
drivers-usb-dwc3-ep0c-fix-sparc64-build.patch
mm.patch
mm-shmemc-remove-an-ifdef.patch
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

