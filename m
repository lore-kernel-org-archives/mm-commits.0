Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01457193061
	for <mm-commits@vger.kernel.org>; Wed, 26 Jun 2024 20:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719435204; cv=none; b=en3p2J+YQwihMOl+FEAjHrqbZmH45BEMXMMXmMGqA6i1ajxUia8gX9Ephq/qWXBBA99spcsoct+ZMJwY1tPB6fJjhQAKeMT/fU9XraDSHEqpfbj94oeY7+ZusiOfv8IZCf0u/vTK84gtaYJw4zXxt4IUHx2Bfj/gV7LcI2T2ilA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719435204; c=relaxed/simple;
	bh=me3ulHyMkGEwqZ1XVn3DvWk3J7wTaRD7OfpdXR+wj/g=;
	h=Date:To:From:Subject:Message-Id; b=lB8wijdt6UvH5NYTXh6+fSON+B3qL2JQs5LihPVsA9Mleu04NKsaE6x9eQTuit3J6WVlNdasNT/7zUDFvj4i1zQ0VlmNgmyDMkAEGtIibI1uWA0oB51k57vBCqE251OI7ndpq+gxbcRVLbe/ZAQ3sh/0fhWv4wUxC+/Nd2W2ctw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t+aWiCLX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t+aWiCLX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8612EC116B1;
	Wed, 26 Jun 2024 20:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719435203;
	bh=me3ulHyMkGEwqZ1XVn3DvWk3J7wTaRD7OfpdXR+wj/g=;
	h=Date:To:From:Subject:From;
	b=t+aWiCLXy6DnUeAfaDyutOiwBW8RvXoFIhZVcK4xixp5SpOkuGmpPuei4EhTZ0YRY
	 fMwL3gw8qDzQze4GjGBbk+z+STucEQSjO0WL5ppZ/N5xJBAwiWZPtiuJi3uNEnRDlE
	 wEV8UYqY3jG3VG4uLuQJnaKlYvQZxkjESSZWDcU0=
Date: Wed, 26 Jun 2024 13:53:22 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vivek.kasireddy@intel.com,shuah@kernel.org,peterx@redhat.com,osalvador@suse.de,mike.kravetz@oracle.com,kraxel@redhat.com,junxiao.chang@intel.com,jgg@nvidia.com,hughd@google.com,hch@lst.de,hch@infradead.org,dongwon.kim@intel.com,david@redhat.com,daniel.vetter@ffwll.ch,airlied@redhat.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + udmabuf-add-config_mmu-dependency.patch added to mm-unstable branch
Message-Id: <20240626205323.8612EC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: udmabuf: add CONFIG_MMU dependency
has been added to the -mm mm-unstable branch.  Its filename is
     udmabuf-add-config_mmu-dependency.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/udmabuf-add-config_mmu-dependency.patch

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
Date: Sun, 23 Jun 2024 23:36:12 -0700

There is no !CONFIG_MMU version of vmf_insert_pfn():

arm-linux-gnueabi-ld: drivers/dma-buf/udmabuf.o: in function `udmabuf_vm_fault':
udmabuf.c:(.text+0xaa): undefined reference to `vmf_insert_pfn'

Link: https://lkml.kernel.org/r/20240624063952.1572359-5-vivek.kasireddy@intel.com
Fixes: d1d00dd1fd2f ("udmabuf: use vmf_insert_pfn and VM_PFNMAP for handling mmap")
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

udmabuf-add-config_mmu-dependency.patch

