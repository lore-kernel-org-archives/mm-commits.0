Return-Path: <SRS0=Fe7N=DY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2508C433DF
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:04:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90C4220878
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602975857;
	bh=w82I/VMBB/A0CFOHkFymGwIgtPyn9NpE/u9hcPFM3Rg=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=aabBN6CUItB6O8tgAexRu4A1vbQp7qB/WoKH+/MjM1+B+PN3rgl/+q6PmKUbDQVEx
	 16r3J4qNvK6lVkaENib/gclf+MjvScV+CffUZt9cHyZhlv23E4LPUT3C2pAP/Wck8W
	 CG7zqNnN4H7Ym1Xec66nRuJEIGbAVMJnMRMhisSg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439838AbgJQXER (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 17 Oct 2020 19:04:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:45622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438235AbgJQXER (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 17 Oct 2020 19:04:17 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DADC208B6;
        Sat, 17 Oct 2020 23:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602975856;
        bh=w82I/VMBB/A0CFOHkFymGwIgtPyn9NpE/u9hcPFM3Rg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=2qg7OosZ5cckosL+7d4UL2h4miwVrYHAy1/6hpXA8Kr87/FPNbEMunlh7qLK9Mymt
         PV6GAMwC4oGEt2C7IZ/sO/IDgfyY9VPDz1maVlXMjCceolNCArK9jUA/g/h13XMrNB
         MX+Dpyi2/AYE3dPxLcxHFs8tJmMrKnA1YgP+ST5Y=
Date:   Sat, 17 Oct 2020 16:04:16 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     lkp@intel.com, minchan@kernel.org, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-madvise-introduce-process=5Fmadvise-syscall-an-external-?=
 =?US-ASCII?Q?memory-hinting-api-fix-fix-fix-fix-fix.patch?= removed from
 -mm tree
Message-ID: <20201017230416.1OTuE9AfJ%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix.patch

This patch was dropped because it was folded into mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api.patch

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix

fix mips build

warning: #warning syscall process_madvise not implemented [-Wcpp]
warning: #warning syscall process_madvise not implemented [-Wcpp]

Link: https://lkml.kernel.org/r/20200909173655.GC2435453@google.com
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/syscalls/syscall_n64.tbl |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/mips/kernel/syscalls/syscall_n64.tbl~mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix
+++ a/arch/mips/kernel/syscalls/syscall_n64.tbl
@@ -354,3 +354,4 @@
 437	n64	openat2				sys_openat2
 438	n64	pidfd_getfd			sys_pidfd_getfd
 439	n64	faccessat2			sys_faccessat2
+440	n64	process_madvise			sys_process_madvise
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-madvise-pass-mm-to-do_madvise.patch
pid-move-pidfd_get_pid-to-pidc.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix.patch

