From: akpm@linux-foundation.org
Subject: + fs-compatc-remove-unnecessary-test-on-unsigned-value.patch
 added to -mm tree
Date: Wed, 11 Jun 2014 15:43:13 -0700
Message-ID: <5398db81.YgBF4Oxc4g2qvfjM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52482 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbaFKWnN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jun 2014 18:43:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be

Subject: + fs-compatc-remove-unnecessary-test-on-unsigned-value.patch added to -mm tree
To: fabf@skynet.be
From: akpm@linux-foundation.org
Date: Wed, 11 Jun 2014 15:43:13 -0700


The patch titled
     Subject: fs/compat.c: remove unnecessary test on unsigned value
has been added to the -mm tree.  Its filename is
     fs-compatc-remove-unnecessary-test-on-unsigned-value.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-compatc-remove-unnecessary-test-on-unsigned-value.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-compatc-remove-unnecessary-test-on-unsigned-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/compat.c: remove unnecessary test on unsigned value

unsigned long value is never < 0

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/compat.c~fs-compatc-remove-unnecessary-test-on-unsigned-value fs/compat.c
--- a/fs/compat.c~fs-compatc-remove-unnecessary-test-on-unsigned-value
+++ a/fs/compat.c
@@ -562,7 +562,7 @@ ssize_t compat_rw_copy_check_uvector(int
 		goto out;
 
 	ret = -EINVAL;
-	if (nr_segs > UIO_MAXIOV || nr_segs < 0)
+	if (nr_segs > UIO_MAXIOV)
 		goto out;
 	if (nr_segs > fast_segs) {
 		ret = -ENOMEM;
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
kernel-auditfilterc-replace-countsize-kmalloc-by-kcalloc.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
mm-slabc-add-__init-to-init_lock_keys.patch
mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
mm-memory_hotplugc-add-__meminit-to-grow_zone_span-grow_pgdat_span.patch
mm-page_alloc-add-__meminit-to-alloc_pages_exact_nid.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
include-linux-memblockh-add-__init-to-memblock_set_bottom_up.patch
mm-zswapc-add-__init-to-zswap_entry_cache_destroy.patch
fs-compatc-remove-unnecessary-test-on-unsigned-value.patch
kernel-test_kprobesc-use-current-logging-functions.patch
fs-isofs-logging-clean-up.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
fs-cachefiles-daemonc-remove-unnecessary-tests-on-unsigned-values.patch
linux-next.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch

