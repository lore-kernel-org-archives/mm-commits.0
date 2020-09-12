Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A69C5C433E2
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 19:20:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B3382078D
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 19:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599938432;
	bh=klJZq1gtZmAmAoQAMeuBLYpuAsYvAh45WhKRg0wfRKM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=mtIbeJB1d+YjEGkvD2O+/15IrR393P1YBmG9Qdymo5oAL5WOwLPC0tglhx7ks12Nd
	 70RSYgOBRYFFJlCohmL6GdywN3bVrVrCgWCBsZZ5Xf0R2THkuXMj9gYbAV73z+KhET
	 mbEhfWXHhndqpiEefwgqNuwDnUrWHFEoGSOGE53o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbgILTUb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 15:20:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgILTUa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 15:20:30 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B097E207C3;
        Sat, 12 Sep 2020 19:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599938429;
        bh=klJZq1gtZmAmAoQAMeuBLYpuAsYvAh45WhKRg0wfRKM=;
        h=Date:From:To:Subject:From;
        b=xQ/uMgy0+A6YSfGxqXEpl/QsI60hjrO4ygV/Jk6OcjlGpIDcSiduSedUapX5KJZZu
         rB83V9pVNSDBP0WdBO+8Z9N4Rj87YF7akTvJwcOUJG4IDTGS2gYy5JaoQtxcVdeFlf
         TwavqJ3acIJ38sRhGveDqh4BG6Wl50fGHde4k8K0=
Date:   Sat, 12 Sep 2020 12:20:29 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, lkp@intel.com, minchan@kernel.org
Subject:  +
 =?us-ascii?Q?mm-madvise-introduce-process=5Fmadvise-syscall-an-external-?=
 =?us-ascii?Q?memory-hinting-api-fix-fix-fix-fix-fix.patch?= added to -mm
 tree
Message-ID: <20200912192029.Oq09-%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix
has been added to the -mm tree.  Its filename is
     mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -355,3 +355,4 @@
 438	n64	pidfd_getfd			sys_pidfd_getfd
 439	n64	faccessat2			sys_faccessat2
 440	n64	watch_mount			sys_watch_mount
+441	n64	process_madvise			sys_process_madvise
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-madvise-pass-mm-to-do_madvise.patch
pid-move-pidfd_get_pid-to-pidc.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix.patch

