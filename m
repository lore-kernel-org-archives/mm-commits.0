From: akpm@linux-foundation.org
Subject: + kexec-use-min_t-to-simplify-logic-fix.patch added to -mm tree
Date: Wed, 27 Feb 2013 14:32:03 -0800
Message-ID: <20130227223203.A6F9531C231@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:39037 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab3B0WcG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 17:32:06 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so124987vch.2
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 14:32:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ebiederm@xmission.com, horms@verge.net.au, joe@perches.com, zhangyanfei@cn.fujitsu.com


The patch titled
     Subject: kexec-use-min_t-to-simplify-logic-fix
has been added to the -mm tree.  Its filename is
     kexec-use-min_t-to-simplify-logic-fix.patch

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
Subject: kexec-use-min_t-to-simplify-logic-fix

replace min_t with min, remove unneeded casts

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Joe Perches <joe@perches.com>
Cc: Simon Horman <horms@verge.net.au>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN kernel/kexec.c~kexec-use-min_t-to-simplify-logic-fix kernel/kexec.c
--- a/kernel/kexec.c~kexec-use-min_t-to-simplify-logic-fix
+++ a/kernel/kexec.c
@@ -820,8 +820,8 @@ static int kimage_load_normal_segment(st
 		clear_page(ptr);
 		ptr += maddr & ~PAGE_MASK;
 		mchunk = min_t(size_t, mbytes,
-			       (size_t)(PAGE_SIZE - (maddr & ~PAGE_MASK)));
-		uchunk = min_t(size_t, ubytes, mchunk);
+				PAGE_SIZE - (maddr & ~PAGE_MASK));
+		uchunk = min(ubytes, mchunk);
 
 		result = copy_from_user(ptr, buf, uchunk);
 		kunmap(page);
@@ -868,8 +868,8 @@ static int kimage_load_crash_segment(str
 		ptr = kmap(page);
 		ptr += maddr & ~PAGE_MASK;
 		mchunk = min_t(size_t, mbytes,
-			       (size_t)(PAGE_SIZE - (maddr & ~PAGE_MASK)));
-		uchunk = min_t(size_t, ubytes, mchunk);
+				PAGE_SIZE - (maddr & ~PAGE_MASK));
+		uchunk = min(ubytes, mchunk);
 		if (mchunk > uchunk) {
 			/* Zero the trailing part of the page */
 			memset(ptr + uchunk, 0, mchunk - uchunk);
@@ -1451,7 +1451,7 @@ void vmcoreinfo_append_str(const char *f
 	r = vsnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
 
-	r = min_t(size_t, r, vmcoreinfo_max_size - vmcoreinfo_size);
+	r = min(r, vmcoreinfo_max_size - vmcoreinfo_size);
 
 	memcpy(&vmcoreinfo_data[vmcoreinfo_size], buf, r);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-use-vm_unmapped_area-on-parisc-architecture-fix.patch
backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
mm.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
kernel-smpc-cleanups.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
signal-allow-to-send-any-siginfo-to-itself-fix.patch
fs-proc-clean-up-printks.patch
fs-proc-clean-up-printks-fix.patch
fs-proc-clean-up-printks-fix-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix-fix.patch
lockdep-check-that-no-locks-held-at-freeze-time-fix.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting-checkpatch-fixes.patch
kexec-use-min_t-to-simplify-logic-fix.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch
idr-remove-length-restriction-from-idr_layer-bitmap-checkpatch-fixes.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
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
selftests-add-tests-for-efivarfs-fix.patch
selftests-add-tests-for-efivarfs-fix-fix.patch
tools-testing-selftests-makefile-rearrange-targets.patch
selftests-add-a-simple-doc-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes.patch
hlist-drop-the-node-parameter-from-iterators-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

