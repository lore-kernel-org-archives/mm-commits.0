From: akpm@linux-foundation.org
Subject: + fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
 added to -mm tree
Date: Wed, 11 Jun 2014 14:25:57 -0700
Message-ID: <5398c965.b+/nVEHJx4cmMx/e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51291 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbaFKVZ6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jun 2014 17:25:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, qiuxishi@huawei.com, fabf@skynet.be

Subject: + fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch added to -mm tree
To: fabf@skynet.be,qiuxishi@huawei.com,rientjes@google.com
From: akpm@linux-foundation.org
Date: Wed, 11 Jun 2014 14:25:57 -0700


The patch titled
     Subject: fs/proc/kcore.c: use PAGE_ALIGN instead of ALIGN(PAGE_SIZE)
has been added to the -mm tree.  Its filename is
     fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch

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
Subject: fs/proc/kcore.c: use PAGE_ALIGN instead of ALIGN(PAGE_SIZE)

Use mm.h definition.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/kcore.c~fs-proc-kcorec-use-page_align-instead-of-alignpage_size fs/proc/kcore.c
--- a/fs/proc/kcore.c~fs-proc-kcorec-use-page_align-instead-of-alignpage_size
+++ a/fs/proc/kcore.c
@@ -172,7 +172,7 @@ get_sparsemem_vmemmap_info(struct kcore_
 
 	start = ((unsigned long)pfn_to_page(pfn)) & PAGE_MASK;
 	end = ((unsigned long)pfn_to_page(pfn + nr_pages)) - 1;
-	end = ALIGN(end, PAGE_SIZE);
+	end = PAGE_ALIGN(end);
 	/* overlap check (because we have to align page */
 	list_for_each_entry(tmp, head, list) {
 		if (tmp->type != KCORE_VMEMMAP)
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
mm-memory_hotplugc-add-__meminit-to-grow_zone_span-grow_pgdat_span.patch
mm-page_alloc-add-__meminit-to-alloc_pages_exact_nid.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
fs-isofs-logging-clean-up.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
fs-cachefiles-daemonc-remove-unnecessary-tests-on-unsigned-values.patch
linux-next.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch

