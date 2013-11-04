From: akpm@linux-foundation.org
Subject: + ipc-msg-fix-message-length-check-for-negative-values-fix.patch added to -mm tree
Date: Mon, 04 Nov 2013 15:06:44 -0800
Message-ID: <20131105000511.212B431C226@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f201.google.com ([209.85.223.201]:48953 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab3KEAbp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Nov 2013 19:31:45 -0500
Received: by mail-ie0-f201.google.com with SMTP id u16so1604696iet.0
        for <mm-commits@vger.kernel.org>; Mon, 04 Nov 2013 16:31:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, davidlohr@hp.com, manfred@colorfullife.com, minipli@googlemail.com, pageexec@freemail.hu, spender@grsecurity.net, torvalds@linux-foundation.org


The patch titled
     Subject: ipc-msg-fix-message-length-check-for-negative-values-fix
has been added to the -mm tree.  Its filename is
     ipc-msg-fix-message-length-check-for-negative-values-fix.patch

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
Subject: ipc-msg-fix-message-length-check-for-negative-values-fix

fix i386 min() warnings

ipc/msgutil.c: In function 'alloc_msg':
ipc/msgutil.c:54: warning: comparison of distinct pointer types lacks a cast
ipc/msgutil.c:66: warning: comparison of distinct pointer types lacks a cast
ipc/msgutil.c: In function 'load_msg':
ipc/msgutil.c:94: warning: comparison of distinct pointer types lacks a cast
ipc/msgutil.c:101: warning: comparison of distinct pointer types lacks a cast
ipc/msgutil.c: In function 'copy_msg':
ipc/msgutil.c:127: warning: comparison of distinct pointer types lacks a cast
ipc/msgutil.c:135: warning: comparison of distinct pointer types lacks a cast
ipc/msgutil.c: In function 'store_msg':
ipc/msgutil.c:155: warning: comparison of distinct pointer types lacks a cast
ipc/msgutil.c:162: warning: comparison of distinct pointer types lacks a cast

Cc: Brad Spengler <spender@grsecurity.net>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Mathias Krause <minipli@googlemail.com>
Cc: Pax Team <pageexec@freemail.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msgutil.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN ipc/msgutil.c~ipc-msg-fix-message-length-check-for-negative-values-fix ipc/msgutil.c
--- a/ipc/msgutil.c~ipc-msg-fix-message-length-check-for-negative-values-fix
+++ a/ipc/msgutil.c
@@ -41,8 +41,8 @@ struct msg_msgseg {
 	/* the next part of the message follows immediately */
 };
 
-#define DATALEN_MSG	(PAGE_SIZE-sizeof(struct msg_msg))
-#define DATALEN_SEG	(PAGE_SIZE-sizeof(struct msg_msgseg))
+#define DATALEN_MSG	((size_t)PAGE_SIZE-sizeof(struct msg_msg))
+#define DATALEN_SEG	((size_t)PAGE_SIZE-sizeof(struct msg_msgseg))
 
 
 static struct msg_msg *alloc_msg(size_t len)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
posix_acl-uninlining.patch
mm.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
kernel-printk-printkc-convert-to-pr_foo.patch
maintainers-remove-richard-purdie-as-backlight-maintainer-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
kfifo-api-type-safety-checkpatch-fixes.patch
ipc-msg-fix-message-length-check-for-negative-values-fix.patch
linux-next.patch
linux-next-git-rejects.patch
linux-next-rejects.patch
x86-mem-hotplug-support-initialize-page-tables-in-bottom-up-next-fix.patch
net-netfilter-ipset-ip_set_hash_netnetc-fix-build-with-older-gcc.patch
net-netfilter-ipset-ip_set_hash_netportnetc-fix-build-with-older-gccs.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch
x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes.patch
mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page-fix-fix.patch
tree-wide-use-reinit_completion-instead-of-init_completion-fix.patch
kernel-provide-a-__smp_call_function_single-stub-for-config_smp-fix.patch
llists-move-llist_reverse_order-from-raid5-to-llistc-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

