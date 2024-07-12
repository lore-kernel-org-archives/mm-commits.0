Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD341CF96
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824840; cv=none; b=TbRM8e3/xR4HWwHdDAcNCeC5DUdBVO6Mdf5pMfDpN8Jg/tg4FPrcoAbKYmBiOBrpPuqmyqx+SFGpzamRvTA9QhIxkQXWKQO5jzT2hSFmswq2FKRsywGS/g4kGaZ0xud1dWgaE5NogzmV9aNcDQ3lFrN23doNOk1UcgoHviDUNuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824840; c=relaxed/simple;
	bh=rVDMYcdQxALoW8ph9oCklBbCA6UC06xPu+lHZ7LHXkA=;
	h=Date:To:From:Subject:Message-Id; b=k8+DkQPFSjyvDl6gdhhDQ9FIVrJWcMB2I9WNC9/H07Ms7pGL+xGK00v5r+rmB0KucF4JtGIrrwVHUAV2QxpDU0HQJOL0z72C0balF0q/QavqBX/+JzD7xpZNJ2qCd6dEBCnbo/vdHKlM5eetk7a14bkXtFxfXkWPZFKI5aYp5t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EawFXvcX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EawFXvcX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0644C32782;
	Fri, 12 Jul 2024 22:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824840;
	bh=rVDMYcdQxALoW8ph9oCklBbCA6UC06xPu+lHZ7LHXkA=;
	h=Date:To:From:Subject:From;
	b=EawFXvcXYwE5Tvo6yGOze1kYwiEwvhJifdi4bmCAnSJ3aAnwRrRu3pNws2DrfjF3N
	 wY05MF/b/Xqc7URU51LBzDRp7fmTfvpaNvlipAtCN5Kq8qraDqdhRKIuee+/qnRHLP
	 EmufwjwWC24AHZ2L7eNdtxW4boJKC7DYWZd+qplM=
Date: Fri, 12 Jul 2024 15:53:59 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vivek.kasireddy@intel.com,shuah@kernel.org,peterx@redhat.com,osalvador@suse.de,mike.kravetz@oracle.com,kraxel@redhat.com,junxiao.chang@intel.com,jgg@nvidia.com,hughd@google.com,hch@lst.de,hch@infradead.org,dongwon.kim@intel.com,david@redhat.com,daniel.vetter@ffwll.ch,airlied@redhat.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] udmabuf-add-config_mmu-dependency.patch removed from -mm tree
Message-Id: <20240712225359.F0644C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: udmabuf: add CONFIG_MMU dependency
has been removed from the -mm tree.  Its filename was
     udmabuf-add-config_mmu-dependency.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: udmabuf: add CONFIG_MMU dependency
Date: Sun, 23 Jun 2024 23:36:12 -0700

There is no !CONFIG_MMU version of vmf_insert_pfn():

arm-linux-gnueabi-ld: drivers/dma-buf/udmabuf.o: in function `udmabuf_vm_fault':
udmabuf.c:(.text+0xaa): undefined reference to `vmf_insert_pfn'

Link: https://lkml.kernel.org/r/20240624063952.1572359-5-vivek.kasireddy@intel.com
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Dongwon Kim <dongwon.kim@intel.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Junxiao Chang <junxiao.chang@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma-buf/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/dma-buf/Kconfig~udmabuf-add-config_mmu-dependency
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


