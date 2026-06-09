Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F8A3019A9
	for <mm-commits@vger.kernel.org>; Tue,  9 Jun 2026 01:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780968172; cv=none; b=szjSLDi0r+QUTzvY1T7joCTP1a7wyo+qYFlDmxKhut2Brp3K56ssDiaiHiVunUR33YcbOfpjR0Eu1YfA3I+re4ExilkMWKs47Lnv1LcG7bPr5d9hjnluUkgVwMIPl5EZDe0pT1E/+vp2DuXs6DoIzBspzAWdZw76Q3BpuscoZG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780968172; c=relaxed/simple;
	bh=J2Uyalc1/hawAx1HfMnkX351gTB5EZOeKq+Q4ixmP20=;
	h=Date:To:From:Subject:Message-Id; b=A4VzyCQvY7187XMD5MygChDo3vyluH3GxDBUxKuKmDRVViDDzitlz4qJGDB3HiLGVoy39mYfwFDZmD8u6Dk2IKU/Y1DyHlsyOaHlPlUnG0f7bNPlE3n8ZPRSQkvcPMTldiOYbInuSS8jAjgPqj3jv2UmaoRalf1e+/k1q8ISYGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=muNSBet6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="muNSBet6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28241F00898;
	Tue,  9 Jun 2026 01:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780968170;
	bh=iN8TIesq9k6JM13EbR54LiF8Zd8KOauKvk8XaZLJ8oM=;
	h=Date:To:From:Subject;
	b=muNSBet6goVa6PS78I7L6hW4KPbJHH24+on09qIlIFYEcBRgGNg7bv3rVT/S66smr
	 E6u+wR+lQvuJqUB0ohznvSeGcVl0yceCJpE9enqJ0uHSX0MRNT+2UUJJgn/baiguMY
	 tLyzxIWsCDsgv8ry5Htae6YOEZteM0f4dK0QTb4E=
Date: Mon, 08 Jun 2026 18:22:50 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,npiggin@gmail.com,dev.jain@arm.com,zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] vmalloc-fix-null-pointer-dereference-in-is_vm_area_hugepages.patch removed from -mm tree
Message-Id: <20260609012250.A28241F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: vmalloc: fix NULL pointer dereference in is_vm_area_hugepages()
has been removed from the -mm tree.  Its filename was
     vmalloc-fix-null-pointer-dereference-in-is_vm_area_hugepages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hui Zhu <zhuhui@kylinos.cn>
Subject: vmalloc: fix NULL pointer dereference in is_vm_area_hugepages()
Date: Fri, 29 May 2026 09:41:30 +0800

find_vm_area() can return NULL if the given address is not a valid vmalloc
area.  Check the return value before dereferencing it to avoid a kernel
crash.

Link: https://lore.kernel.org/20260529014130.671291-1-hui.zhu@linux.dev
Fixes: 121e6f3258fe ("mm/vmalloc: hugepage vmalloc mappings")
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/include/linux/vmalloc.h~vmalloc-fix-null-pointer-dereference-in-is_vm_area_hugepages
+++ a/include/linux/vmalloc.h
@@ -265,7 +265,9 @@ static inline bool is_vm_area_hugepages(
 	 * allocated in the vmalloc layer.
 	 */
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMALLOC
-	return find_vm_area(addr)->page_order > 0;
+	struct vm_struct *area = find_vm_area(addr);
+
+	return area && area->page_order > 0;
 #else
 	return false;
 #endif
_

Patches currently in -mm which might be from zhuhui@kylinos.cn are


