From: akpm@linux-foundation.org
Subject: + kfifo-api-type-safety-checkpatch-fixes.patch added to -mm tree
Date: Fri, 01 Nov 2013 15:58:50 -0700
Message-ID: <5274322a.HFMM9Rsk41743UFp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56039 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab3KAW6v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Nov 2013 18:58:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stefani@seibold.net, akpm@linux-foundation.org

Subject: + kfifo-api-type-safety-checkpatch-fixes.patch added to -mm tree
To: akpm@linux-foundation.org,stefani@seibold.net
From: akpm@linux-foundation.org
Date: Fri, 01 Nov 2013 15:58:50 -0700


The patch titled
     Subject: kfifo-api-type-safety-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     kfifo-api-type-safety-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kfifo-api-type-safety-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kfifo-api-type-safety-checkpatch-fixes.patch

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
Subject: kfifo-api-type-safety-checkpatch-fixes

ERROR: code indent should use tabs where possible
#201: FILE: include/linux/kfifo.h:504:
+ ^Itypeof(__tmp->ptr_const) __buf = (buf); \$

WARNING: please, no space before tabs
#201: FILE: include/linux/kfifo.h:504:
+ ^Itypeof(__tmp->ptr_const) __buf = (buf); \$

WARNING: please, no spaces at the start of a line
#201: FILE: include/linux/kfifo.h:504:
+ ^Itypeof(__tmp->ptr_const) __buf = (buf); \$

total: 1 errors, 2 warnings, 221 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/kfifo-api-type-safety.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kfifo.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/kfifo.h~kfifo-api-type-safety-checkpatch-fixes include/linux/kfifo.h
--- a/include/linux/kfifo.h~kfifo-api-type-safety-checkpatch-fixes
+++ a/include/linux/kfifo.h
@@ -501,7 +501,7 @@ __kfifo_uint_must_check_helper( \
 #define	kfifo_in(fifo, buf, n) \
 ({ \
 	typeof((fifo) + 1) __tmp = (fifo); \
- 	typeof(__tmp->ptr_const) __buf = (buf); \
+	typeof(__tmp->ptr_const) __buf = (buf); \
 	unsigned long __n = (n); \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix-fix.patch
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
linux-next.patch
linux-next-rejects.patch
x86-mem-hotplug-support-initialize-page-tables-in-bottom-up-next-fix.patch
net-netfilter-ipset-ip_set_hash_netnetc-fix-build-with-older-gcc.patch
net-netfilter-ipset-ip_set_hash_netportnetc-fix-build-with-older-gccs.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch
x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes.patch
mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page-fix-fix.patch
tree-wide-use-reinit_completion-instead-of-init_completion-fix.patch
llists-move-llist_reverse_order-from-raid5-to-llistc-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

