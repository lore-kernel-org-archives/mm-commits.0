Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6FC521832F
	for <mm-commits@vger.kernel.org>; Thu,  7 Nov 2024 22:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731019115; cv=none; b=DnQwnX/K1AqketSGT/Q1UMnomQ7D/kfEeyahL1z4cD6m/93JcGfqcR44sonGt7QC0PjPmJoNXdWXWrekZ3a82zT8RFbGK2Uzu3GlziUFrMGZupHHB5HZ1uezlJLzeAptNZEskG8lfH0CZ2wkNiMD3jkQyCuGpycIxZo+blS4abc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731019115; c=relaxed/simple;
	bh=bauiFZ0pf9s30BlG49MFB37WLZW+P/MDktelxQ4HCt4=;
	h=Date:To:From:Subject:Message-Id; b=p6td43SAet3t7zgVRcg2v/NbGQ1tPIRe7+S+3gH1wKbondtFUr2ZY38qtqv/Qm7JWVhe3ZtgtfxcFp9Sn6/rnfttqQFiKuk4Av6W8Dr0qrc260dNvlDFB3X27GmGCZy42G8CIclfjDzOATjf/IlDhk+IjqQr0kYruwrGkWK1Aa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gb8AeKtF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gb8AeKtF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51DA0C4CECC;
	Thu,  7 Nov 2024 22:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731019115;
	bh=bauiFZ0pf9s30BlG49MFB37WLZW+P/MDktelxQ4HCt4=;
	h=Date:To:From:Subject:From;
	b=gb8AeKtF105JUhm65q3gnieunGTm8YOzQicKmREaXgpQ5CgzdWwF4apZc/23Xz4eU
	 iaRIk5rvAaDlhyBvsPkC7tagCv2cUuETdoHxAAxrGOSQSQisYLdW5tS/kV3oAwneOr
	 PywloQQFFNOQ545WGdi2K2JsR+5aKeDv19qB5dq0=
Date: Thu, 07 Nov 2024 14:38:34 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,skhan@linuxfoundation.org,senozhatsky@chromium.org,pintu.ping@gmail.com,minchan@kernel.org,joe@perches.com,quic_pintu@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zsmalloc-use-memcpy_from-to_page-whereever-possible.patch removed from -mm tree
Message-Id: <20241107223835.51DA0C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zsmalloc: use memcpy_from/to_page whereever possible
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-use-memcpy_from-to_page-whereever-possible.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pintu Kumar <quic_pintu@quicinc.com>
Subject: mm/zsmalloc: use memcpy_from/to_page whereever possible
Date: Thu, 10 Oct 2024 23:21:43 +0530

As part of "zsmalloc: replace kmap_atomic with kmap_local_page" [1] we
replaced kmap/kunmap_atomic() with kmap_local_page()/kunmap_local().

But later it was found that some of the code could be replaced with
already available apis in highmem.h, such as
memcpy_from_page()/memcpy_to_page().

Also, update the comments with correct api naming.

[1] https://lkml.kernel.org/r/20241001175358.12970-1-quic_pintu@quicinc.com

Link: https://lkml.kernel.org/r/20241010175143.27262-1-quic_pintu@quicinc.com
Signed-off-by: Pintu Kumar <quic_pintu@quicinc.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Suggested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Joe Perches <joe@perches.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pintu Agarwal <pintu.ping@gmail.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   36 +++++++++++++-----------------------
 1 file changed, 13 insertions(+), 23 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-use-memcpy_from-to_page-whereever-possible
+++ a/mm/zsmalloc.c
@@ -263,7 +263,7 @@ struct zspage {
 struct mapping_area {
 	local_lock_t lock;
 	char *vm_buf; /* copy buffer for objects that span pages */
-	char *vm_addr; /* address of kmap_atomic()'ed pages */
+	char *vm_addr; /* address of kmap_local_page()'ed pages */
 	enum zs_mapmode vm_mm; /* mapping mode */
 };
 
@@ -1046,11 +1046,10 @@ static inline void __zs_cpu_down(struct
 static void *__zs_map_object(struct mapping_area *area,
 			struct page *pages[2], int off, int size)
 {
-	int sizes[2];
-	void *addr;
+	size_t sizes[2];
 	char *buf = area->vm_buf;
 
-	/* disable page faults to match kmap_atomic() return conditions */
+	/* disable page faults to match kmap_local_page() return conditions */
 	pagefault_disable();
 
 	/* no read fastpath */
@@ -1061,12 +1060,8 @@ static void *__zs_map_object(struct mapp
 	sizes[1] = size - sizes[0];
 
 	/* copy object to per-cpu buffer */
-	addr = kmap_local_page(pages[0]);
-	memcpy(buf, addr + off, sizes[0]);
-	kunmap_local(addr);
-	addr = kmap_local_page(pages[1]);
-	memcpy(buf + sizes[0], addr, sizes[1]);
-	kunmap_local(addr);
+	memcpy_from_page(buf, pages[0], off, sizes[0]);
+	memcpy_from_page(buf + sizes[0], pages[1], 0, sizes[1]);
 out:
 	return area->vm_buf;
 }
@@ -1074,8 +1069,7 @@ out:
 static void __zs_unmap_object(struct mapping_area *area,
 			struct page *pages[2], int off, int size)
 {
-	int sizes[2];
-	void *addr;
+	size_t sizes[2];
 	char *buf;
 
 	/* no write fastpath */
@@ -1091,15 +1085,11 @@ static void __zs_unmap_object(struct map
 	sizes[1] = size - sizes[0];
 
 	/* copy per-cpu buffer to object */
-	addr = kmap_local_page(pages[0]);
-	memcpy(addr + off, buf, sizes[0]);
-	kunmap_local(addr);
-	addr = kmap_local_page(pages[1]);
-	memcpy(addr, buf + sizes[0], sizes[1]);
-	kunmap_local(addr);
+	memcpy_to_page(pages[0], off, buf, sizes[0]);
+	memcpy_to_page(pages[1], 0, buf + sizes[0], sizes[1]);
 
 out:
-	/* enable page faults to match kunmap_atomic() return conditions */
+	/* enable page faults to match kunmap_local() return conditions */
 	pagefault_enable();
 }
 
@@ -1511,10 +1501,10 @@ static void zs_object_copy(struct size_c
 		d_size -= size;
 
 		/*
-		 * Calling kunmap_atomic(d_addr) is necessary. kunmap_atomic()
-		 * calls must occurs in reverse order of calls to kmap_atomic().
-		 * So, to call kunmap_atomic(s_addr) we should first call
-		 * kunmap_atomic(d_addr). For more details see
+		 * Calling kunmap_local(d_addr) is necessary. kunmap_local()
+		 * calls must occurs in reverse order of calls to kmap_local_page().
+		 * So, to call kunmap_local(s_addr) we should first call
+		 * kunmap_local(d_addr). For more details see
 		 * Documentation/mm/highmem.rst.
 		 */
 		if (s_off >= PAGE_SIZE) {
_

Patches currently in -mm which might be from quic_pintu@quicinc.com are


