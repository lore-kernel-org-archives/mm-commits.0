From: akpm@linux-foundation.org
Subject: + kernel-signalc-use-__arch_has_sa_restorer-instead-of-sa_restorer.patch added to -mm tree
Date: Mon, 11 Mar 2013 14:19:46 -0700
Message-ID: <20130311211946.DBF4D31C1E1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:41012 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101Ab3CKVTs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Mar 2013 17:19:48 -0400
Received: by mail-vb0-f74.google.com with SMTP id r6so358411vbi.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Mar 2013 14:19:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ebiederm@xmission.com, jln@google.com, oleg@redhat.com, pageexec@freemail.hu, re.emese@gmail.com, serge.hallyn@canonical.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: kernel/signal.c: use __ARCH_HAS_SA_RESTORER instead of SA_RESTORER
has been added to the -mm tree.  Its filename is
     kernel-signalc-use-__arch_has_sa_restorer-instead-of-sa_restorer.patch

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
Subject: kernel/signal.c: use __ARCH_HAS_SA_RESTORER instead of SA_RESTORER

__ARCH_HAS_SA_RESTORER is the preferred conditional for use in 3.9 and
later kernels, per Kees.

Cc: Emese Revfy <re.emese@gmail.com>
Cc: Emese Revfy <re.emese@gmail.com>
Cc: PaX Team <pageexec@freemail.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Julien Tinnes <jln@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/signal.c~kernel-signalc-use-__arch_has_sa_restorer-instead-of-sa_restorer kernel/signal.c
--- a/kernel/signal.c~kernel-signalc-use-__arch_has_sa_restorer-instead-of-sa_restorer
+++ a/kernel/signal.c
@@ -485,7 +485,7 @@ flush_signal_handlers(struct task_struct
 		if (force_default || ka->sa.sa_handler != SIG_IGN)
 			ka->sa.sa_handler = SIG_DFL;
 		ka->sa.sa_flags = 0;
-#ifdef SA_RESTORER
+#ifdef __ARCH_HAS_SA_RESTORER
 		ka->sa.sa_restorer = NULL;
 #endif
 		sigemptyset(&ka->sa.sa_mask);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
include-linux-res_counterh-needs-errnoh.patch
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
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch
signal-always-clear-sa_restorer-on-execve-fix.patch
kernel-signalc-use-__arch_has_sa_restorer-instead-of-sa_restorer.patch
kexec-use-min_t-to-simplify-logic-fix.patch
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

