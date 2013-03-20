From: akpm@linux-foundation.org
Subject: + crypto-add-lz4-cryptographic-api-fix.patch added to -mm tree
Date: Wed, 20 Mar 2013 16:31:39 -0700
Message-ID: <20130320233139.D85755A400F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:61034 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab3CTXbl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Mar 2013 19:31:41 -0400
Received: by mail-vc0-f202.google.com with SMTP id gf12so211839vcb.1
        for <mm-commits@vger.kernel.org>; Wed, 20 Mar 2013 16:31:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, chanho.min@lge.com, djwong@us.ibm.com, fengguang.wu@intel.com, herbert@gondor.hengli.com.au, kyungsik.lee@lge.com, richard@nod.at, rpearson@systemfabricworks.com, yann.collet.73@gmail.com


The patch titled
     Subject: crypto-add-lz4-cryptographic-api-fix
has been added to the -mm tree.  Its filename is
     crypto-add-lz4-cryptographic-api-fix.patch

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
Subject: crypto-add-lz4-cryptographic-api-fix

fix warnings

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Bob Pearson <rpearson@systemfabricworks.com>
Cc: Chanho Min <chanho.min@lge.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Kyungsik Lee <kyungsik.lee@lge.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Yann Collet <yann.collet.73@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 crypto/lz4.c   |    3 ++-
 crypto/lz4hc.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN crypto/lz4.c~crypto-add-lz4-cryptographic-api-fix crypto/lz4.c
--- a/crypto/lz4.c~crypto-add-lz4-cryptographic-api-fix
+++ a/crypto/lz4.c
@@ -66,8 +66,9 @@ static int lz4_decompress_crypto(struct
 {
 	int err;
 	size_t tmp_len = *dlen;
+	size_t __slen = slen;
 
-	err = lz4_decompress(src, &slen, dst, tmp_len);
+	err = lz4_decompress(src, &__slen, dst, tmp_len);
 	if (err < 0)
 		return -EINVAL;
 
diff -puN crypto/lz4hc.c~crypto-add-lz4-cryptographic-api-fix crypto/lz4hc.c
--- a/crypto/lz4hc.c~crypto-add-lz4-cryptographic-api-fix
+++ a/crypto/lz4hc.c
@@ -66,8 +66,9 @@ static int lz4hc_decompress_crypto(struc
 {
 	int err;
 	size_t tmp_len = *dlen;
+	size_t __slen = slen;
 
-	err = lz4_decompress(src, &slen, dst, tmp_len);
+	err = lz4_decompress(src, &__slen, dst, tmp_len);
 	if (err < 0)
 		return -EINVAL;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
printk-provide-a-wake_up_klogd-off-case-fix.patch
mm-hugetlb-fix-total-hugetlbfs-pages-count-when-memory-overcommit-accouting-fix.patch
dma-debug-fix-locking-bug-in-check_unmap-fix.patch
mips-define-kvm_user_mem_slots.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3-fix.patch
kernel-sched-schedh-fix-warning.patch
loop-cleanup-partitions-when-detaching-loop-device-checkpatch-fixes.patch
loop-cleanup-partitions-when-detaching-loop-device-fix.patch
loop-cleanup-partitions-when-detaching-loop-device-fix-fix.patch
mm.patch
mm-shmemc-remove-an-ifdef.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module-fix.patch
memcg-relax-memcg-iter-caching-checkpatch-fixes.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix-fix.patch
kexec-vmalloc-export-additional-vmalloc-layer-information-fix.patch
mm-hugetlb-include-hugepages-in-meminfo-checkpatch-fixes.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
kernel-smpc-cleanups.patch
early_printk-consolidate-random-copies-of-identical-code-v3-fix.patch
include-linux-printkh-include-stdargh.patch
get_maintainer-use-filename-only-regex-match-for-tegra-fix.patch
argv_split-teach-it-to-handle-mutable-strings-fix.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix.patch
pid_namespacec-h-simplify-defines-fix.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
aio-kiocb_cancel.patch
wait-add-wait_event_hrtimeout.patch
aio-use-cancellation-list-lazily.patch
aio-give-shared-kioctx-fields-their-own-cachelines.patch
generic-dynamic-per-cpu-refcounting.patch
aio-dont-include-aioh-in-schedh.patch
aio-kill-ki_retry.patch
block-aio-batch-completion-for-bios-kiocbs.patch
crypto-add-lz4-cryptographic-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

