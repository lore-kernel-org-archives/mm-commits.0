Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795296047;
	b=0vBO0EIG5ItzgPf5OcDlcR6TMU+oddujLD1TcRpjZVq2dXeo93CQfONugPHh6hTi8hX6
	 7k8WyBlYx08MeBt7vuouJh0X4fEJUVWhN9Rc7E/jBj/fr8dH2z61rFkdNxK1UxOEjngyd
	 HHKiA+zp+mDCFTwPSNAcE6wtMc/0HBBj/5C3wgHMP+IKQnVCd9PXa/7gEjbrqJQgDbgTy
	 ry+M0SNMKk7WiLeJbq2HRebbREaCVirSnTyPEsImy7DyYDE2EC0HTSTm3eeHMVc//e9z7
	 Xv5Mea1Ncl0GcNwDqHdmhxyT4BY21tYV3bU1ELRpe1RafEFCKbX7VaEfN6ZYr5WC9sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795296047;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=2rhXo6UuM40kKP8j+lc9CvZmflmNneE9L4xcrFX6jfM=;
	b=YIW56wuPWWR/Q60fHDxlKD17JJnhz88aCaqd3xat/Na+GvLUAfUjpdbc+EnbpoHXNPTh
	 qbRtcTu24Lr5RJCt1Mp2R0dloREoCokxD09Lt94sxVm0QhjF/tzAcyQfD001iusseOpuE
	 w5dx4lVSpp1y2/5Fsqe9orA4eHj7Ez75qwb8YIRWiGgbYsNCWRddD/EU3syEjENitdohe
	 CfwL7yRXk7JDm0rPG82O1KQmed+ZI0Dm8UQn+JJywdN6id1UTcLT2dW01IU8TGhGNeicd
	 8y0OkWXnUxl0ad7Dnq2YLHA0NeGjuLmVseiD/Ev4n8j6o93+9mpVwNugIzeIcvd2ZcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=cjbgvnWY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C13606A320
	for <mm-commits@vger.kernel.org>; Sat, 21 Nov 2026 21:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=cjbgvnWY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC35A1F000C0;
	Sat, 21 Nov 2026 21:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795296047;
	bh=2rhXo6UuM40kKP8j+lc9CvZmflmNneE9L4xcrFX6jfM=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=cjbgvnWY1oJjy5+iRXObANtlbGJnDLRlg7RjHAthp9VSCfNi3yf+AYBqqMJ0n0mzS
	 mQ2CikNqIJwbaGbLpCQ4Wxr+tzvplDtiLkOnrUk6+i87VCPguhCX9P/0C+6AOqdZOi
	 AxyNqX2ssSt6rt8wBwz3ZS+7BQ6coLzfXFq8Xmxw=
Date: Sat, 21 Nov 2026 13:20:46 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,azpijr@gmail.com,
	liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261029-vmalloc_remap-v2-2-c4705cbf26c2@linux.dev>
References: <20261029-vmalloc_remap-v2-2-c4705cbf26c2@linux.dev>
Subject: + mm-vmalloc-reject-null-pages-in-remap_vmalloc_range_partial.patch added to mm-unstable branch
Message-Id: <20261121212046.DC35A1F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/vmalloc: reject NULL pages in remap_vmalloc_range_partial
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-reject-null-pages-in-remap_vmalloc_range_partial.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-reject-null-pages-in-remap_vmalloc_range_partial.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/vmalloc: reject NULL pages in remap_vmalloc_range_partial
Date: Thu, 29 Oct 2026 17:19:08 +0800

remap_vmalloc_range_partial() passes vmalloc_to_page()'s result to
vm_insert_page() unchecked, oopsing via page_folio() on a NULL page.
The NULL case cannot happen today because VM_USERMAP areas keep every
page mapped, but nothing enforces that invariant. Warn once and fail
the mapping with -EINVAL instead of oopsing if it is ever broken.

Link: https://patch.msgid.link/20261029-vmalloc_remap-v2-2-c4705cbf26c2@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>

 mm/vmalloc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/vmalloc.c~mm-vmalloc-reject-null-pages-in-remap_vmalloc_range_partial
+++ a/mm/vmalloc.c
@@ -5064,6 +5064,9 @@ int remap_vmalloc_range_partial(struct v
 		struct page *page = vmalloc_to_page(kaddr);
 		int ret;
 
+		if (WARN_ON_ONCE(!page))
+			return -EINVAL;
+
 		ret = vm_insert_page(vma, uaddr, page);
 		if (ret)
 			return ret;
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-vmalloc-drop-vm_dma_coherent-from-remap_vmalloc_range_partial.patch
mm-vmalloc-reject-null-pages-in-remap_vmalloc_range_partial.patch

