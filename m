Return-Path: <SRS0=U74d=BZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3991EC433DF
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 00:13:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16DE1207DA
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 00:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597450387;
	bh=LRtkVYC0a1oEAPNeoy27l6dq+xaSk5mmfKstbzH/y3c=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=VsRyqCwWcgYmT9y8ACbozbo/DMY/buQiD15VLCIt1s/V6HRy/vUjDFETi/o+2t/a8
	 4UtCzlzL8nsfzW+9X5EFyWFBjnOVTcyxT3psM09+joXGIVckQe+50lUUwP2jPzjlmr
	 C79zDdUssAV088wdAeGuV7WimJbq2Jy2VSe8HSkQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgHOANG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Aug 2020 20:13:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726213AbgHOANG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 Aug 2020 20:13:06 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44E6920781;
        Sat, 15 Aug 2020 00:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597450385;
        bh=LRtkVYC0a1oEAPNeoy27l6dq+xaSk5mmfKstbzH/y3c=;
        h=Date:From:To:Subject:From;
        b=WCmk4qoGhPSF3Io51LEHPuVW+qCijE+rlbz6S7QTfteDYdRCnUsbXlzp4SLLqRteq
         0GNcEDRCFTpvLl/pXSnIhrfv3JT85EQlcIjejGUf+4+RizkacaBwG6mV6ySiM5iL+A
         pdgq91EknnkQCd9JTtHt9dj1Yygtzj5NWVGJsMZE=
Date:   Fri, 14 Aug 2020 17:13:04 -0700
From:   akpm@linux-foundation.org
To:     heiko.carstens@de.ibm.com, lkp@intel.com,
        mm-commits@vger.kernel.org, nixiaoming@huawei.com
Subject:  [folded-merged]
 all-arch-remove-system-call-sys_sysctl-fix.patch removed from -mm tree
Message-ID: <20200815001304.jbgV4IfjY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: s390: fix build error for sys_call_table_emu
has been removed from the -mm tree.  Its filename was
     all-arch-remove-system-call-sys_sysctl-fix.patch

This patch was dropped because it was folded into all-arch-remove-system-call-sys_sysctl.patch

------------------------------------------------------
From: Xiaoming Ni <nixiaoming@huawei.com>
Subject: s390: fix build error for sys_call_table_emu

Build error on s390:
	arch/s390/kernel/entry.o: in function `sys_call_table_emu':
	>> (.rodata+0x1288): undefined reference to `__s390_'

In commit ("All arch: remove system call sys_sysctl")
 148  common	fdatasync		sys_fdatasync			sys_fdatasync
-149  common	_sysctl			sys_sysctl			compat_sys_sysctl
+149  common	_sysctl			sys_ni_syscall
 150  common	mlock			sys_mlock			sys_mlock

After the patch is integrated, there is a format error in the generated
arch/s390/include/generated/asm/syscall_table.h:
	SYSCALL(sys_fdatasync, sys_fdatasync)
	SYSCALL(sys_ni_syscall,) /* cause build error */
	SYSCALL(sys_mlock,sys_mlock)

According to the guidance of Heiko Carstens, use "-" to fill the empty
system call Similarly, modify
tools/perf/arch/s390/entry/syscalls/syscall.tbl.

Link: http://lkml.kernel.org/r/20200618141426.16884-1-nixiaoming@huawei.com
Fixes: ("All arch: remove system call sys_sysctl")
Fixes: https://lore.kernel.org/linuxppc-dev/20200616030734.87257-1-nixiaoming@huawei.com/
Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/syscalls/syscall.tbl           |    2 +-
 tools/perf/arch/s390/entry/syscalls/syscall.tbl |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/s390/kernel/syscalls/syscall.tbl~all-arch-remove-system-call-sys_sysctl-fix
+++ a/arch/s390/kernel/syscalls/syscall.tbl
@@ -138,7 +138,7 @@
 146  common	writev			sys_writev			compat_sys_writev
 147  common	getsid			sys_getsid			sys_getsid
 148  common	fdatasync		sys_fdatasync			sys_fdatasync
-149  common	_sysctl			sys_ni_syscall
+149  common	_sysctl			-				-
 150  common	mlock			sys_mlock			sys_mlock
 151  common	munlock			sys_munlock			sys_munlock
 152  common	mlockall		sys_mlockall			sys_mlockall
--- a/tools/perf/arch/s390/entry/syscalls/syscall.tbl~all-arch-remove-system-call-sys_sysctl-fix
+++ a/tools/perf/arch/s390/entry/syscalls/syscall.tbl
@@ -138,7 +138,7 @@
 146  common	writev			sys_writev			compat_sys_writev
 147  common	getsid			sys_getsid			sys_getsid
 148  common	fdatasync		sys_fdatasync			sys_fdatasync
-149  common	_sysctl			sys_ni_syscall
+149  common	_sysctl			-				-
 150  common	mlock			sys_mlock			compat_sys_mlock
 151  common	munlock			sys_munlock			compat_sys_munlock
 152  common	mlockall		sys_mlockall			sys_mlockall
_

Patches currently in -mm which might be from nixiaoming@huawei.com are

all-arch-remove-system-call-sys_sysctl.patch

