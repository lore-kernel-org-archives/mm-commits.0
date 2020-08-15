Return-Path: <SRS0=U74d=BZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D1BAC433E1
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 00:12:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3FF120781
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 00:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597450359;
	bh=y9/vbH+pDqqLrKQx3zJVR6NRMapDK2Umj8ZqlS4BcDs=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=YW+i/EECVvuSTYCpP/PGXIJ6mIWo8Umg2NCqcYIEjWkuaozlhY2CS16JjqHKApZ7f
	 PEJ7OHMXExaNbhyLl3lWV5aXaFmReDgPHYctYKoPZQ3uW83zOcVONi150uvjHZaCLw
	 8ykmrJ21awTpG7Ff8xSb0l0ovTy4P5XDjVuYlVnU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgHOAMj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Aug 2020 20:12:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726213AbgHOAMj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 Aug 2020 20:12:39 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAB4420781;
        Sat, 15 Aug 2020 00:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597450359;
        bh=y9/vbH+pDqqLrKQx3zJVR6NRMapDK2Umj8ZqlS4BcDs=;
        h=Date:From:To:Subject:From;
        b=TqiGi94Q9aDHQZy6rmIIQaUVRRfpq2lp0eUWrr+CmjbUW/FSc2urNWk1NayBRHe4V
         e19RFF7gGXPRBcYwaZSDPu3IQBQ3NqBLmffYYbDrdam08W0RdccUxZvEdwclwrdgBs
         sgMut/mRhwxNHcT5RhrISeY3Y2Hn4K6vX63reMVY=
Date:   Fri, 14 Aug 2020 17:12:38 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, minchan@kernel.org,
        mm-commits@vger.kernel.org
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-madvise-introduce-process=5Fmadvise-syscall-an-external-?=
 =?US-ASCII?Q?memory-hinting-api-fix.patch?= removed from -mm tree
Message-ID: <20200815001238.fK6HXokGa%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix
has been removed from the -mm tree.  Its filename was
     mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch

This patch was dropped because it was folded into mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix

fix arm64 whoops

Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/unistd32.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/include/asm/unistd32.h~mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix
+++ a/arch/arm64/include/asm/unistd32.h
@@ -887,7 +887,7 @@ __SYSCALL(__NR_openat2, sys_openat2)
 __SYSCALL(__NR_pidfd_getfd, sys_pidfd_getfd)
 #define __NR_faccessat2 439
 __SYSCALL(__NR_faccessat2, sys_faccessat2)
-#define __NR_fsinfo 440
+#define __NR_process_madvise 440
 __SYSCALL(__NR_process_madvise, compat_sys_process_madvise)
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api.patch
iomap-constify-ioreadx-iomem-argument-as-in-generic-implementation-fix-fix.patch
mm.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

