Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F332D12FB37
	for <mm-commits@vger.kernel.org>; Mon, 29 Jul 2024 21:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722290297; cv=none; b=BAy/Dbp98nsdQNAqTnQZGhXGxZFhBiDJElHzUiOfnNQkqe48PjVq2nAXMuc6GuAtSygvx1AvJwvQePNI17EYnKJiGIrIol3exNEZZiaC92y/X/UpE6dkt9JjPRIeYkmkcMzE171woStO4/zwxU16EtOw8yZ5qOqDr5erKpM9kng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722290297; c=relaxed/simple;
	bh=heJpt50AGMWNVZQOLFFkwYAg8INm6I5yn7GIyDWzSHY=;
	h=Date:To:From:Subject:Message-Id; b=ksqv9u5PZgbmQq3Dp8e/MyG72q3QiEc6fxwEcgn/KjkILpR0YvYUHWtNIslgE8Yba+4SeWnvBINOrkJNGFoHiwA50lDTaqigrZ1SFh1AcEshx2t0bb14Ifv+ZlzCdMr8XbkDcjChTk0Whihgj9QPjgYYcq+I+2Df3b+UeTml3d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wkUCDJDe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wkUCDJDe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81DCCC32786;
	Mon, 29 Jul 2024 21:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722290296;
	bh=heJpt50AGMWNVZQOLFFkwYAg8INm6I5yn7GIyDWzSHY=;
	h=Date:To:From:Subject:From;
	b=wkUCDJDe9tW3rdqGGsgLKsknyM6UL42MGeRamleHyKMy9lwPI1MHG2ApF1QsliSco
	 0GnaNkCh31NSbWFSsBLXPonS+Sas+c9fBQUx3SjHwJF4ETNwQC3ii1X8Y/9fDww4+M
	 9w33VI67AkKH4pQyV9jrebG/seYpoGaQehPwMRpg=
Date: Mon, 29 Jul 2024 14:58:15 -0700
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,rppt@kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,dyoung@redhat.com,bhe@redhat.com,aou@eecs.berkeley.edu,ruanjinjie@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crash-fix-crash-memory-reserve-exceed-system-memory-bug.patch added to mm-nonmm-unstable branch
Message-Id: <20240729215816.81DCCC32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crash: fix crash memory reserve exceed system memory bug
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     crash-fix-crash-memory-reserve-exceed-system-memory-bug.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash-fix-crash-memory-reserve-exceed-system-memory-bug.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Jinjie Ruan <ruanjinjie@huawei.com>
Subject: crash: fix crash memory reserve exceed system memory bug
Date: Mon, 29 Jul 2024 19:52:52 +0800

On x86_32 Qemu machine with 1GB memory, the cmdline "crashkernel=4G" is ok
as below:
	crashkernel reserved: 0x0000000020000000 - 0x0000000120000000 (4096 MB)

It's similar on other architectures, such as ARM32 and RISCV32.

The cause is that the crash_size is parsed and printed with "unsigned long
long" data type which is 8 bytes but allocated used with "phys_addr_t"
which is 4 bytes in memblock_phys_alloc_range().

Fix it by checking if crash_size is greater than system RAM size and
return error if so.

After this patch, there is no above confusing reserve success info.

Link: https://lkml.kernel.org/r/20240729115252.1659112-1-ruanjinjie@huawei.com
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Suggested-by: Mike Rapoport <rppt@kernel.org>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Dave Young <dyoung@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_reserve.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/crash_reserve.c~crash-fix-crash-memory-reserve-exceed-system-memory-bug
+++ a/kernel/crash_reserve.c
@@ -335,6 +335,9 @@ int __init parse_crashkernel(char *cmdli
 	if (!*crash_size)
 		ret = -EINVAL;
 
+	if (*crash_size >= system_ram)
+		ret = -EINVAL;
+
 	return ret;
 }
 
_

Patches currently in -mm which might be from ruanjinjie@huawei.com are

crash-fix-x86_32-crash-memory-reserve-dead-loop-bug.patch
crash-fix-x86_32-crash-memory-reserve-dead-loop.patch
arm-use-generic-interface-to-simplify-crashkernel-reservation.patch
crash-fix-crash-memory-reserve-exceed-system-memory-bug.patch

