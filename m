Return-Path: <SRS0=2RlJ=CN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D88E3C43461
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 21:08:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C1F6208C7
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 21:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599253690;
	bh=6BZKQt5BwAToOXFJ8o1X8c/fHfKdhVRxtWVSPVglACs=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Eti7WA9EXk5blPx06X9AXR4B/aGWaxMSo1nNkWDFGYoBBWdNBcaPW1MHY3cyEg9TR
	 K8Gi0sMja4rdnxfXXxAxZtl9RhzZ595yvXtALKfz7ucS6QQ93vNQd8czP7C8amSk9t
	 jkNw6NImq4DKufPfh62iWxOH0F32Jxj0sb7Oq22c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbgIDVIJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Sep 2020 17:08:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726842AbgIDVII (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Sep 2020 17:08:08 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E192120709;
        Fri,  4 Sep 2020 21:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599253688;
        bh=6BZKQt5BwAToOXFJ8o1X8c/fHfKdhVRxtWVSPVglACs=;
        h=Date:From:To:Subject:From;
        b=OwCIYk7cBUKciQIf6SvikYG5OXoj/8sIp1ddQgVc1F2oxoIWrbHOmPNv7HxZupRgv
         rZoNs8jACKqOVu4AvYKcGR+lg28b1t2SQdlb35GQKY1vurMHiCQ9bZvLqYraiWzaX4
         s5M1U2NumeNAQKRe6iQAArnuojg6wA1AVc07N4cU=
Date:   Fri, 04 Sep 2020 14:08:07 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, minchan@kernel.org, fw@deneb.enyo.de,
        akpm@linux-foundation.org
Subject:  +
 =?us-ascii?Q?mm-madvise-introduce-process=5Fmadvise-syscall-an-external-?=
 =?us-ascii?Q?memory-hinting-api-fix-fix.patch?= added to -mm tree
Message-ID: <20200904210807.xBvQd%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix
has been added to the -mm tree.  Its filename is
     mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix.patch

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
Subject: mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix

fix i386 build

mm/madvise.c: In function process_madvise_vec:
mm/madvise.c:1168:15: error: storage size of iovec isnt known
  struct iovec iovec;

Cc: Florian Weimer <fw@deneb.enyo.de>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/madvise.c~mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix
+++ a/mm/madvise.c
@@ -18,6 +18,7 @@
 #include <linux/fadvise.h>
 #include <linux/sched.h>
 #include <linux/sched/mm.h>
+#include <linux/uio.h>
 #include <linux/ksm.h>
 #include <linux/fs.h>
 #include <linux/file.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-slub-re-initialize-randomized-freelist-sequence-in-calculate_sizes-fix.patch
mm.patch
mm-memory_hotplug-introduce-default-phys_to_target_node-implementation-fix.patch
device-dax-make-align-a-per-device-property-fix.patch
powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte-fix.patch
mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix.patch
mm-page_allocc-clean-code-by-removing-unnecessary-initialization-fix.patch
memblock-make-memblock_debug-and-related-functionality-private-fix.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix.patch
xarray-add-xa_get_order-fix.patch
xarray-add-xas_split-fix.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix.patch
mmhwpoison-drop-unneeded-pcplist-draining-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-memory_hotplug-simplify-page-offlining-fix.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
arch-x86-makefile-use-config_shell.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

