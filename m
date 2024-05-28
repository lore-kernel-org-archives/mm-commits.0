Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D283171E59
	for <mm-commits@vger.kernel.org>; Tue, 28 May 2024 19:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716923406; cv=none; b=HReRuoXQ4qI3a0BY7elwG/NjHowoXyV72Pxt1QqIZOA5LTbr+vOncRj7NiKyTDBb/0JofzeVfR3bUluNTsNqk9pyRCwfYgJd18rz3TNJvUZb9eWqwKt2yuJ9D3jzO3YG3QnzGtST9yyqjnccIkZQR/y6otK5DK2T4mAGsKmIpfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716923406; c=relaxed/simple;
	bh=6Q7lrGNnO+L98LPU422ZztQSTu6T/nRdo9oT0gGYbGo=;
	h=Date:To:From:Subject:Message-Id; b=DsT79bpZoobSkgN7MKr2Vd6hJOqjjxrQtdWnH8I+AFuUZ3WEhAXv8UxmPDlD98vGz8UHQhGBvClL8gF5Ik/vAsqa2eXwWbBu2+o4g2M0hXdO9RagChfMa0Z1WD1maKnXmt4jLGBW3/C7aZXcxw5Z1OhXQRaEKSg669CwSK/YDew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LPhlhF32; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LPhlhF32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77CBC32781;
	Tue, 28 May 2024 19:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716923405;
	bh=6Q7lrGNnO+L98LPU422ZztQSTu6T/nRdo9oT0gGYbGo=;
	h=Date:To:From:Subject:From;
	b=LPhlhF32/1eBM5j8cgJJ3Pm1lc4ez6+oBzq9rWFFNSIuVqp+GKr5ZUqaBFsllU53M
	 T7IUFwnhK1N48pzl7eUt4BIQbT+6fP5Z0IgHgTE3sOtzPZRdovqKOZukzIEi7SbcUS
	 PXaYnhONVq1EbauafEbNM1iTUkvWTu2ifKiiQcRE=
Date: Tue, 28 May 2024 12:10:05 -0700
To: mm-commits@vger.kernel.org,vivek.kasireddy@intel.com,sumit.semwal@linaro.org,kraxel@redhat.com,david@redhat.com,christian.koenig@amd.com,airlied@redhat.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + udmabuf-use-vmf_insert_pfn-and-vm_pfnmap-for-handling-mmap-fix.patch added to mm-unstable branch
Message-Id: <20240528191005.D77CBC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: udmabuf: add CONFIG_MMU dependency
has been added to the -mm mm-unstable branch.  Its filename is
     udmabuf-use-vmf_insert_pfn-and-vm_pfnmap-for-handling-mmap-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/udmabuf-use-vmf_insert_pfn-and-vm_pfnmap-for-handling-mmap-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Arnd Bergmann <arnd@arndb.de>
Subject: udmabuf: add CONFIG_MMU dependency
Date: Tue, 28 May 2024 15:31:31 +0200

There is no !CONFIG_MMU version of vmf_insert_pfn():

arm-linux-gnueabi-ld: drivers/dma-buf/udmabuf.o: in function `udmabuf_vm_fault':
udmabuf.c:(.text+0xaa): undefined reference to `vmf_insert_pfn'

Link: https://lkml.kernel.org/r/20240528133138.2237237-1-arnd@kernel.org
Fixes: f7254e043ff1 ("udmabuf: use vmf_insert_pfn and VM_PFNMAP for handling mmap")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma-buf/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/dma-buf/Kconfig~udmabuf-use-vmf_insert_pfn-and-vm_pfnmap-for-handling-mmap-fix
+++ a/drivers/dma-buf/Kconfig
@@ -35,6 +35,7 @@ config UDMABUF
 	default n
 	depends on DMA_SHARED_BUFFER
 	depends on MEMFD_CREATE || COMPILE_TEST
+	depends on MMU
 	help
 	  A driver to let userspace turn memfd regions into dma-bufs.
 	  Qemu can use this to create host dmabufs for guest framebuffers.
_

Patches currently in -mm which might be from arnd@arndb.de are

udmabuf-use-vmf_insert_pfn-and-vm_pfnmap-for-handling-mmap-fix.patch

