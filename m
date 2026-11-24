Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795484339;
	b=F8CQEIMStn86GvAyuR9i9X1mTd5rlFbYN6VXtXaXwuT2SYTPBo0+HDXkIqysFlft9WBK
	 BofbkFUEuDGST0ww+GqgmuuRFEfKwpN19Nx2nP4lml0Fb0E4U2R49QvdlNVZcyLcbhsWC
	 cHuXc27AWLJ15nQh310hBWCRsRiCAlGiJhTU9NTzfiVJx9FaiKSEahVi/iLy7hMhVOxoX
	 8f72Xp3eIxldvr7Avng5KANayM1ak0wTP/uLi2OWx8FWuWELgi2eLfOGjBWaBxF/i/JqE
	 9mr7UNwH74uTcUf/fJ8sZvkW/5IYoi11vhI12j8jigrRq/iXjDNwHfAOdryLy7NTmIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795484339;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=23xCIX2IZxqn29htKF9pCDTnvJRTLGEXqip3u9VMkuQ=;
	b=JYie2Zfl/v4WTAflFAKmrbx4NoXyg559DeOL3wqodc+m0+nJbFpf4Byt5GNNE9nQaJrU
	 B5N0CQaIG3NG/KSsoQv7tV10ECiheOD1Gb2m+snM0UeAH3xZxTFKkYk1A5oZxhkKnDYb1
	 58+JSq4TdkzMLPMWRlrcpqK0jq76S27n0YbHqcP/wtSF+dPndokF+RhXPB4BzGzaYM2De
	 2ZVc4jJcuz9P00Ubex0sshciDLMUDwpsX/Ro8HPe1+u7PkfZbBr9y2N8yStqnWoaQ7gGA
	 LEjixFdS+IoBKVCwrLw0DysVXm+S0RlTUjdL9GN5RwjXjEkU7O9yRectwvd8qcdd4VQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=HdnFDzHd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE711606A322
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 01:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=HdnFDzHd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2291F000D0;
	Tue, 24 Nov 2026 01:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795484339;
	bh=23xCIX2IZxqn29htKF9pCDTnvJRTLGEXqip3u9VMkuQ=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=HdnFDzHd79zT8v6dhxhMc0fhFvI5am7aHaj22CvN5PDaEGl3inm5CwC4SG6dGfo3u
	 jd0nBKSH9ajy4UIBkvXmrkA4K15jZoNUxg6ZLFzqLjJlSKVJ9H5ng4UpWBhUCxOiAO
	 mdPEbytvY4bmJAM3kBbfZX5juYbUeoDBsm8MZunc=
Date: Mon, 23 Nov 2026 17:38:58 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vivek.kasireddy@intel.com,
	syzbot+7666ed2c3d42196bf7e3@syzkaller.appspotmail.com,skhawaja@google.com,
	robin.murphy@arm.com,peterx@redhat.com,kevin.tian@intel.com,joro@8bytes.org,
	jhubbard@nvidia.com,jgg@ziepe.ca,david@kernel.org,
	xujiahao@cmss.chinamobile.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261119163531.315791-1-xujiahao@cmss.chinamobile.com>
References: <20261119163531.315791-1-xujiahao@cmss.chinamobile.com>
Subject: + iommufd-only-hold-references-to-files-memfd_pin_folios-can-pin.patch added to mm-new branch
Message-Id: <20261124013858.EB2291F000D0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: iommufd: only hold references to files memfd_pin_folios() can pin
has been added to the -mm mm-new branch.  Its filename is
     iommufd-only-hold-references-to-files-memfd_pin_folios-can-pin.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/iommufd-only-hold-references-to-files-memfd_pin_folios-can-pin.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Jiahao Xu <xujiahao@cmss.chinamobile.com>
Subject: iommufd: only hold references to files memfd_pin_folios() can pin
Date: Thu, 19 Nov 2026 16:35:31 +0800

iopt_map_file_pages() stores a reference to the file passed to
IOMMU_IOAS_MAP_FILE in the iopt_pages of the new mapping:

	iopt_map_file_pages()
	  iopt_alloc_file_pages()
	    pages->file = get_file(file)

iopt_release_pages() drops that reference only when the iopt_pages is
destroyed, which for a file mapping happens while the iommufd file is
being torn down.  Nothing restricts which file can be passed, so userspace
can map the iommufd file itself, or a vfio device fd bound to the same
iommufd, both of which own an iommufd_ctx reference.  The reference graph
then contains a cycle and the file, the iopt_pages, the IOAS and the
iommufd_ctx are all leaked; kmemleak reports it as "memory leak in
path_openat" with the holder taken through iopt_map_file_pages().

Reverse the test instead of trying to enumerate the files that own an
iommufd_ctx: accept only the files that memfd_pin_folios() is able to pin,
which is exactly the set of files the mapping can be built from. 
file_is_memfd_compatible() reports that set, so the same test can run here
before the reference is handed to iopt_pages.  dma-bufs are unaffected:
they are taken by the dma_buf_get() branch above and never reach the file
branch, and iopt_pages holds the dma_buf there, not a struct file.

Link: https://patch.msgid.link/20261119163531.315791-1-xujiahao@cmss.chinamobile.com
Fixes: f4986a72d6e4 ("iommufd: Add IOMMU_IOAS_MAP_FILE")
Signed-off-by: Jiahao Xu <xujiahao@cmss.chinamobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: <syzbot+7666ed2c3d42196bf7e3@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=7666ed2c3d42196bf7e3
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: David Hildenbrand <david@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jörg Rödel <joro@8bytes.org>
Cc: Will Deacon <will@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>

 drivers/iommu/iommufd/io_pagetable.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/iommu/iommufd/io_pagetable.c~iommufd-only-hold-references-to-files-memfd_pin_folios-can-pin
+++ a/drivers/iommu/iommufd/io_pagetable.c
@@ -515,6 +515,18 @@ int iopt_map_file_pages(struct iommufd_c
 		if (!file)
 			return -EBADF;
 
+		/*
+		 * iopt_pages keeps a reference to the file until the mapping is
+		 * destroyed, so only accept the files memfd_pin_folios() is able
+		 * to pin.  Any other fd, in particular one that itself owns an
+		 * iommufd_ctx (iommufd, vfio, ...), would put the file into a
+		 * reference cycle with this iommufd and never be released.
+		 */
+		if (!file_is_memfd_compatible(file)) {
+			fput(file);
+			return -EINVAL;
+		}
+
 		pages = iopt_alloc_file_pages(file, start_byte, start, length,
 					      iommu_prot & IOMMU_WRITE);
 		fput(file);
_

Patches currently in -mm which might be from xujiahao@cmss.chinamobile.com are

mm-gup-add-file_is_memfd_compatible-helper.patch
iommufd-only-hold-references-to-files-memfd_pin_folios-can-pin.patch

