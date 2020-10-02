Return-Path: <SRS0=hqm6=DJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E03FC35257
	for <mm-commits@archiver.kernel.org>; Fri,  2 Oct 2020 22:18:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE78020796
	for <mm-commits@archiver.kernel.org>; Fri,  2 Oct 2020 22:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601677138;
	bh=u7vAqRrctadXNjxVce0exiwonYQLcHdCuru/TlokOVc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=I3n6a91hXCkqiloasCzzcsFGkDcGlT+DhzRG/2Afgr9zgajfr01X37tOdq1MyrMH5
	 TWQxWrPV+Y/ldfuOqPRHWbYvP7BkoAxIRtoSRAlt0mtSW/wxVwqhTVJpqe9YRLHSOg
	 20k6IS6jCAqedXDfL12n8CZRBShK+btsGoJdlrPU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725710AbgJBWS6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Oct 2020 18:18:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:46552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbgJBWS6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 2 Oct 2020 18:18:58 -0400
Received: from X1 (c-76-21-107-111.hsd1.ca.comcast.net [76.21.107.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A5D520738;
        Fri,  2 Oct 2020 22:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601677137;
        bh=u7vAqRrctadXNjxVce0exiwonYQLcHdCuru/TlokOVc=;
        h=Date:From:To:Subject:From;
        b=wTzE0ZXXjSdhrAHfmyHO+MRWdYoJ1+DKUKn/Ave0PLbd80Q5KNFaIW7BmpKb9ttHj
         CrV2VNDXSahtEqMUc0WEcufrXtJWh2V9uLyLtQGQONVm7B90buZXQrAJgDidVzpLLr
         w+mbeGegDFjwq1MTlEh8i+WzbGHYMkwxtzsZkD3g=
Date:   Fri, 02 Oct 2020 15:18:57 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, joe@perches.com,
        akpm@linux-foundation.org
Subject:  + checkpatch-emit-a-warning-on-embedded-filenames-fix.patch
 added to -mm tree
Message-ID: <20201002221857.ZVs0r%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch-emit-a-warning-on-embedded-filenames-fix
has been added to the -mm tree.  Its filename is
     checkpatch-emit-a-warning-on-embedded-filenames-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-emit-a-warning-on-embedded-filenames-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-emit-a-warning-on-embedded-filenames-fix.patch

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
Subject: checkpatch-emit-a-warning-on-embedded-filenames-fix

remove stray " di"

Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-emit-a-warning-on-embedded-filenames-fix
+++ a/scripts/checkpatch.pl
@@ -3274,7 +3274,7 @@ sub process {
 		}
 
 # check for embedded filenames
-		if ($rawline =~ /^\+.*\Q$realfile\E/) { di
+		if ($rawline =~ /^\+.*\Q$realfile\E/) {
 			WARN("EMBEDDED_FILENAME",
 			     "It's generally not useful to have the filename in the file\n" . $herecurr);
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-memory_hotplug-introduce-default-phys_to_target_node-implementation-fix.patch
powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte-fix.patch
mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix.patch
mm-page_allocc-clean-code-by-removing-unnecessary-initialization-fix.patch
mm-mempool-add-else-to-split-mutually-exclusive-case-fix.patch
memblock-make-memblock_debug-and-related-functionality-private-fix.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix.patch
xarray-add-xa_get_order-fix.patch
xarray-add-xas_split-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-memory_hotplug-simplify-page-offlining-fix.patch
checkpatch-warn-on-self-assignments-checkpatch-fixes.patch
checkpatch-emit-a-warning-on-embedded-filenames-fix.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
linux-next-rejects.patch
fs-fuse-virtio_fsc-fix-for-mm-memremap_pages-convert-to-struct-range.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

