Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27AC14A96
	for <mm-commits@vger.kernel.org>; Tue, 11 Jun 2024 17:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718126876; cv=none; b=kOy6tcwIAOp6iNVWfBzafY1aBZlhDe+qHlqYHpZBZF0x5u5ba41jMrGQXrXmfXqZsAlh+AqGQPZn431qUc4H0M8UZxTtZWV35jNVEB7s8NNe1krQu9oYdxgujfwWsbD2SI1TBX12t+2X3Gk27+Ukz0K0P+ldoQxbdMcqm/vsXZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718126876; c=relaxed/simple;
	bh=xvaVjIFevCPTBr21D6REtWU+GIFJgbCI/xBYhsu0k+E=;
	h=Date:To:From:Subject:Message-Id; b=aUcG7zYzbd2EYdmriOWrajKP5sD/N/y2qagIvF4JylSwStlQBRf2j4JibAwTlG2oFz5co2hkLbzSlPiOt5bzoUd/TsxoO0DL4f+cCx0oLa0gD6DrrSNIbXKCG+YuCipDVuv68J2rutpe+HT62J+h0QAtb3i5HQb3u5kq2qpjUBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uppcIL0w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uppcIL0w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39AC6C2BD10;
	Tue, 11 Jun 2024 17:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718126876;
	bh=xvaVjIFevCPTBr21D6REtWU+GIFJgbCI/xBYhsu0k+E=;
	h=Date:To:From:Subject:From;
	b=uppcIL0wj2v9/ccB/bWOhm10hBLWjbAeV6AwocTyN/tIJyYvy/F3rY//n7X9V8241
	 IvoXlN2Q2UhX889Os0E8mRWBepipYSclHYNL8sEThBeDYBVOU3NbQXONbvisfyEwnQ
	 XIba0t80MXrYsHGcxbVU2xfe1AGcKygqPSdOpQ/Q=
Date: Tue, 11 Jun 2024 10:27:55 -0700
To: mm-commits@vger.kernel.org,vivek.kasireddy@intel.com,sumit.semwal@linaro.org,kraxel@redhat.com,david@redhat.com,christian.koenig@amd.com,airlied@redhat.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] udmabuf-use-vmf_insert_pfn-and-vm_pfnmap-for-handling-mmap-fix.patch removed from -mm tree
Message-Id: <20240611172756.39AC6C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: udmabuf: add CONFIG_MMU dependency
has been removed from the -mm tree.  Its filename was
     udmabuf-use-vmf_insert_pfn-and-vm_pfnmap-for-handling-mmap-fix.patch

This patch was dropped because it was folded into udmabuf-use-vmf_insert_pfn-and-vm_pfnmap-for-handling-mmap.patch

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

udmabuf-use-vmf_insert_pfn-and-vm_pfnmap-for-handling-mmap.patch

