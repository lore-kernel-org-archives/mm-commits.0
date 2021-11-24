Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00E7CC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 23:47:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236249AbhKXXvF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Nov 2021 18:51:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:45300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235851AbhKXXvF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Nov 2021 18:51:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAA2D61039;
        Wed, 24 Nov 2021 23:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637797674;
        bh=H8Vl9UgaH8EivK/pkK3BmTeNlfAWUZ5WToFlluW7Aio=;
        h=Date:From:To:Subject:From;
        b=M1we8Izb2lJAVHW6rPwLjdvueYmO0GIcpAFDUeM242P4SkV0aG63pcKJZPn0RWRGL
         XTKdqOtPm7hYp0ylK3F+GCOz8yHuRElD3n4hZ0s33Rghqcmzzs75CktnFpX1tmhwQN
         Jn/GJ3RrhizJmR/irrdtAlxKYPk20Radoem+K9KY=
Date:   Wed, 24 Nov 2021 15:47:54 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        pasha.tatashin@soleen.com
Subject:  + mm-page-table-check-fix.patch added to -mm tree
Message-ID: <20211124234754.l5co34dUK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page-table-check-fix
has been added to the -mm tree.  Its filename is
     mm-page-table-check-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page-table-check-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page-table-check-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page-table-check-fix

export page_table_check_disabled and __page_table_check_pte_set to modules

ERROR: modpost: "page_table_check_disabled" [drivers/gpu/drm/i915/i915.ko] undefined!
ERROR: modpost: "__page_table_check_pte_set" [drivers/gpu/drm/i915/i915.ko] undefined!

Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_table_check.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/page_table_check.c~mm-page-table-check-fix
+++ a/mm/page_table_check.c
@@ -19,6 +19,7 @@ static bool __page_table_check_enabled _
 				IS_ENABLED(CONFIG_PAGE_TABLE_CHECK_ENFORCED);
 
 DEFINE_STATIC_KEY_TRUE_RO(page_table_check_disabled);
+EXPORT_SYMBOL(page_table_check_disabled);
 
 static int __init early_page_table_check_param(char *buf)
 {
@@ -217,6 +218,7 @@ void __page_table_check_pte_set(struct m
 				     pte_write(pte));
 	}
 }
+EXPORT_SYMBOL(__page_table_check_pte_set);
 
 void __page_table_check_pmd_set(struct mm_struct *mm, unsigned long addr,
 				pmd_t *pmdp, pmd_t pmd)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
kthread-add-the-helper-function-kthread_run_on_cpu-fix.patch
mm.patch
mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix.patch
panic-use-error_report_end-tracepoint-on-warnings-fix.patch
linux-next-git-rejects.patch
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mm-page-table-check-fix.patch

