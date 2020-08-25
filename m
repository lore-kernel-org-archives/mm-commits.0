Return-Path: <SRS0=wvGk=CD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42D97C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 25 Aug 2020 23:46:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2262020738
	for <mm-commits@archiver.kernel.org>; Tue, 25 Aug 2020 23:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598399179;
	bh=/2PJien3NiFyxmIM4APtzfr8YgoFrfF9oKL0sBcHWBE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=PradW3TcTkEaDRZl5d2gYJpQUWvXmSfRtsYuausUO4wrPkChvxS6zPw1S0lEFWmlP
	 YN81rQaLNjCQD/es/F2IR+1BHzpKjxqGP54lWz1LpPRY2UEupfDSp2dtkuU+OWagWA
	 bdy//vjURGzWX+C5lQmZ361hwvyYbF/6WhT4bVQ8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgHYXqS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Aug 2020 19:46:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726391AbgHYXqS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 25 Aug 2020 19:46:18 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1D1720706;
        Tue, 25 Aug 2020 23:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598399177;
        bh=/2PJien3NiFyxmIM4APtzfr8YgoFrfF9oKL0sBcHWBE=;
        h=Date:From:To:Subject:From;
        b=UOr9ZapTfnF/F3S7uNXr3F5SgkB9/Efz/55w8EvQgMGWlJFfz6WXlTK/p4AAUJKuA
         S5i7wJB8zaUibI1Em4D9bSZpsg1sjWALNAJUnroKesfKTVTEVGv5YvOqHCx0TYkkh+
         gUoVfw//QQMhAVTR1Hqx87JgoPPdvnqsFfFQ20S8=
Date:   Tue, 25 Aug 2020 16:46:17 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, lkp@intel.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        sfr@canb.auug.org.au
Subject:  +
 arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix.patch
 added to -mm tree
Message-ID: <20200825234617.-BKK_yfBA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix
has been added to the -mm tree.  Its filename is
     arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix.patch

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
Subject: arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix

fix arch/arm/mm/pmsa-v7.c build

Reported-by: kernel test robot <lkp@intel.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/pmsa-v7.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mm/pmsa-v7.c~arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix
+++ a/arch/arm/mm/pmsa-v7.c
@@ -273,7 +273,7 @@ void __init pmsav7_adjust_lowmem_bounds(
 				panic("First memory bank must be contiguous from PHYS_OFFSET");
 
 			mem_start = reg_start;
-			mem_end = reg_end
+			mem_end = reg_end;
 			specified_mem_size = mem_end - mem_start;
 		} else {
 			/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-slub-re-initialize-randomized-freelist-sequence-in-calculate_sizes-fix.patch
mm.patch
device-dax-make-align-a-per-device-property-fix.patch
mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix.patch
memblock-make-memblock_debug-and-related-functionality-private-fix.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
scripts-gdb-update-for-lockless-printk-ringbuffer-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch

