Return-Path: <SRS0=iiPm=C7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B4E1C2D0E2
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 20:56:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0B632065D
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 20:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600808195;
	bh=qVey/dBPOeGEaYX5B+biwu4cGvrfN3qRyeRjUXA9GRY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=hqs/gGmy7t/HNChqrobxKlJ5TfuPKEZugUYpxLxhURIN3/wzUihtKAztokLDrI/5q
	 hrOcSClbEUieu2sEWjY6JAP9upgsCLJAjIm6fQmM43UIPethpoEkrVV6EfyJKo14t+
	 xr5oH6g1vyCBR2DyYLWoL02NLFpNR8NwJIFALQps=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbgIVU4f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Sep 2020 16:56:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726448AbgIVU4d (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Sep 2020 16:56:33 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F0922065D;
        Tue, 22 Sep 2020 20:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600808192;
        bh=qVey/dBPOeGEaYX5B+biwu4cGvrfN3qRyeRjUXA9GRY=;
        h=Date:From:To:Subject:From;
        b=E8kVFowXmaR31aIDq6DhB4kS/FZApvCTyw3ZtjTA6fc3vkx0UxN/xb1UnM6ND2YOl
         tYUEkb2eUADHbTkPZJM3fcPHgpHZpSYhiowKtsh4BAF/LUI10BUwkoDYnRCDnIwmC7
         fuVRpbcusHSOzhuAqU8t4yqOhPtjC4unWvpzErMM=
Date:   Tue, 22 Sep 2020 13:56:32 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, minchan@kernel.org,
        mm-commits@vger.kernel.org
Subject:  +
 =?US-ASCII?Q?mm-madvise-introduce-process=5Fmadvise-syscall-an-external-?=
 =?US-ASCII?Q?memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix.patch?=
 added to -mm tree
Message-ID: <20200922205632.9eG2_Jwh9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix
has been added to the -mm tree.  Its filename is
     mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix.patch

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
Subject: mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix

pidfd_get_pid() gained an argument

Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/madvise.c~mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix
+++ a/mm/madvise.c
@@ -1182,6 +1182,7 @@ SYSCALL_DEFINE5(process_madvise, int, pi
 	struct task_struct *task;
 	struct mm_struct *mm;
 	size_t total_len;
+	unsigned int f_flags;
 
 	if (flags != 0) {
 		ret = -EINVAL;
@@ -1200,7 +1201,7 @@ SYSCALL_DEFINE5(process_madvise, int, pi
 	if (ret < 0)
 		goto out;
 
-	pid = pidfd_get_pid(pidfd);
+	pid = pidfd_get_pid(pidfd, &f_flags);
 	if (IS_ERR(pid)) {
 		ret = PTR_ERR(pid);
 		goto free_iov;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-memory_hotplug-introduce-default-phys_to_target_node-implementation-fix.patch
device-dax-make-pgmap-optional-for-instance-creation-fix.patch
mm-memremap_pages-support-multiple-ranges-per-invocation-fix.patch
device-dax-make-align-a-per-device-property-fix.patch
powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte-fix.patch
mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix.patch
mm-page_allocc-clean-code-by-removing-unnecessary-initialization-fix.patch
memblock-make-memblock_debug-and-related-functionality-private-fix.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix.patch
xarray-add-xa_get_order-fix.patch
xarray-add-xas_split-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-memory_hotplug-simplify-page-offlining-fix.patch
checkpatch-warn-on-self-assignments-checkpatch-fixes.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
linux-next-rejects.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix.patch

