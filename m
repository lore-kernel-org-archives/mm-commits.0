Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795495616;
	b=AT2BQ+mWAhnbQEA/Cd0WiOqFmVhduns328IxIjJULbNMv6WLDTTRKb8kxSa1sEsbVDCY
	 Gyaf+vlKcYRxACjoksBH8rsByjjeKmH0GtaP9hF9WINALQTOi7d9VEYqkoabqeR33eS0o
	 4n/NBw+IkMUldHfalG0VKXNFWfpJujAoJBUAywpyFbTxoqcJqYo3VQF0Pt9j1t0X1iMva
	 L7niDEPt9lKLDI6nJfvyCJ4YOxeEfbQLCkgr8+X73LLlNZk7wH1gyD7pKedZ93dyNO/p2
	 66+Zpm5nEriszSY+iZ5pRVoxHovt0oqv7/vTQ1GiQ3TyT2cDjukgAyNYNZwSsgkVw6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795495616;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=jRjOrAvwXoKIGMft86qdM5AtBhhKEJKUEuhqeEbemkE=;
	b=MaqqBbWquZlJF5mBocasL3M1M5HlMcZMGz33WZ1itZT8xHSkLnJ++K2Kiy2lCOhnvJiA
	 384WVkbNsqhs0UIfZ/uEF2ViZcRRjqVlt+EjcpK4ywSTXkPR6DgtN9cWvzWYY5r+h7p0F
	 6ObULjPVZFKNG8Zt2MLGUrfvrD24ZJs+TEQ/DC1C/+dTiNfwo4V5OKRA6glYF5kVBT7Ra
	 Dv/VDkewnWVVL35rNEcSYWTBPoy3y0izwI+ghzCKO/1tQxbxBSQmMB5cZr99ZnOd4Vii+
	 8jqrc+Hso48MjPuEZC0AePJ5JRHJygoYKdqOdCazD4419Qt0i3MQZaBeuSv5Wki+WWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Nw+meKzI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301F1606A31E
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 04:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Nw+meKzI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF4D1F000C6;
	Tue, 24 Nov 2026 04:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795495615;
	bh=jRjOrAvwXoKIGMft86qdM5AtBhhKEJKUEuhqeEbemkE=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=Nw+meKzIhqbiH0E6wYBGPFqMjcYfas9zdNhNjQXqfmJyD+XNeRmrAGkacVL0acVUm
	 puy2+B7IDoqIhH58Rdn5sNc/Qn8W+eK34U5rri785C41aM5pW9N1i4kIxAjYwEchxj
	 Zv0irWgK/sQkXjn46vTiPtaZfp5ysqkQR43fpqTI=
Date: Mon, 23 Nov 2026 20:46:55 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vivek.kasireddy@intel.com,
	syzbot+7666ed2c3d42196bf7e3@syzkaller.appspotmail.com,skhawaja@google.com,
	robin.murphy@arm.com,peterx@redhat.com,kevin.tian@intel.com,joro@8bytes.org,
	jhubbard@nvidia.com,jgg@ziepe.ca,david@kernel.org,
	xujiahao@cmss.chinamobile.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261119163531.315791-1-xujiahao@cmss.chinamobile.com>
References: <20261119163531.315791-1-xujiahao@cmss.chinamobile.com>
Subject: [merged] iommufd-only-hold-references-to-files-memfd_pin_folios-can-pin.patch removed from -mm tree
Message-Id: <20261124044655.CAF4D1F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: iommufd: only hold references to files memfd_pin_folios() can pin
has been removed from the -mm tree.  Its filename was
     iommufd-only-hold-references-to-files-memfd_pin_folios-can-pin.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


