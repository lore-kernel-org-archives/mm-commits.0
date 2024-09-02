Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F2514A627
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248794; cv=none; b=JavOiVfc+aeNdUudtPn6mEaSUV0A+7mhrEX/1AFQcE3OD2HpTeEQj5C5cSxvpH0ikwHRIY9i1BZv61Pl1+7AeWyqcFe64BHGFn8/Lw1Uk+lf8Jtd2rhXZWur1DTT+y0V8gOgwhi91uP2c1jXlPZ+sYz6RhMh+Bi4sTDVrrkEO1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248794; c=relaxed/simple;
	bh=Q1wL2iC1FwAaEysVrjZC46wX7sWXynoxTx4DoI8HlAI=;
	h=Date:To:From:Subject:Message-Id; b=GXMB/naGR+LRU3A+7DEoHR++7XrkT7X8d5sqvKrWwCmOeeLnsWj3qSHSVRVxS2GmSL9HuRVOTEmzVVlcrprMoHUOownw0uCfnsd3PuUaKt1nxN77h85f/IDuUDKcjHp3C49SfcjH1dqtz32L3Trt1S2A9+taopKg9PXEQH77XUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KEv9k0sV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KEv9k0sV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF57C4CEC2;
	Mon,  2 Sep 2024 03:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248794;
	bh=Q1wL2iC1FwAaEysVrjZC46wX7sWXynoxTx4DoI8HlAI=;
	h=Date:To:From:Subject:From;
	b=KEv9k0sVDtPo0gybQLVtar8TXYQBoZ/6pm6cpz+1nUe0Y11zwoF1flBr0BG44mJSk
	 W8mqT/vHGwT1vIGcNQtHrN0Y3qaRy0EtVXYYUPXDxAbK1RpY9VhUXxCPB1DeOzT+Mp
	 DZ/aiPBdBooKPuPmWWNvkbmHIfjG2jzqo6OhghO4=
Date: Sun, 01 Sep 2024 20:46:33 -0700
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,rppt@kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,dyoung@redhat.com,bhe@redhat.com,aou@eecs.berkeley.edu,ruanjinjie@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] crash-fix-crash-memory-reserve-exceed-system-memory-bug.patch removed from -mm tree
Message-Id: <20240902034634.2FF57C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: crash: fix crash memory reserve exceed system memory bug
has been removed from the -mm tree.  Its filename was
     crash-fix-crash-memory-reserve-exceed-system-memory-bug.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

user_namespace-use-kmemdup_array-instead-of-kmemdup-for-multiple-allocation.patch

