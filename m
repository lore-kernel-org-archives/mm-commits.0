Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89331EDA04
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119240; cv=none; b=s3Dsr1u+gbZmTrHKShupod56n8bSupJxKm+anKPtRN2uO9u2MFpAqJrSOZByUWZnVbltaybdDiFhKGo4/N/3+WA8Xbh4bkQme1gw4i1547Ap0g2/vHem8+YkrytwIOVKxOemfmi1oOjVDplop4qGqkCo5x+C2WNScXFFAcWuA9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119240; c=relaxed/simple;
	bh=b47x5l8xqU3Dtk4fHwrT8tX87eT5eXZjo9b+mhxE9hA=;
	h=Date:To:From:Subject:Message-Id; b=oaOpv8BvVrnRARm+cNiCbGNFLeO8+/IV/YiVAt/EPl0x1/eHs/V6yRSSyYgSuWp6x4SbVRk8nt1Yv34accBTna5mHI7WXumIhKjnz0gYq74PAN2C+abryyTY116w2U8eU21eU0FWFN+8jC+Jna7OSyH5CFSkUNYdQE32MzDb99A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RnN8L6bk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RnN8L6bk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11AADC4CEE4;
	Tue, 13 May 2025 06:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119240;
	bh=b47x5l8xqU3Dtk4fHwrT8tX87eT5eXZjo9b+mhxE9hA=;
	h=Date:To:From:Subject:From;
	b=RnN8L6bkSP0p5AjwKljSTYWIvtRoj8jWg8esN+tlWBde6WxMCDo0Q+HmaGWRiy3sa
	 8r1AtXbcALWuRUT2frNrNc3ws4AowXffTFfN/p162+zY+0IsL+0/s7Fr2PgPOaa/cw
	 1yK/1GFdBrqxKBqGuFI79eB5ircrxZEiXG1sPfHg=
Date: Mon, 12 May 2025 23:53:59 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,riel@surriel.com,nao.horiguchi@gmail.com,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,liam.howlett@oracle.com,harry.yoo@oracle.com,david@redhat.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-fix-typo-in-comment-in-page_address_in_vma.patch removed from -mm tree
Message-Id: <20250513065400.11AADC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: fix typo in comment in page_address_in_vma
has been removed from the -mm tree.  Its filename was
     mm-rmap-fix-typo-in-comment-in-page_address_in_vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/rmap: fix typo in comment in page_address_in_vma
Date: Mon, 21 Apr 2025 16:57:29 +0800

Fix a minor typo in the comment above page_address_in_vma():
"responsibililty" → "responsibility"

Link: https://lkml.kernel.org/r/20250421085729.127845-3-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/rmap.c~mm-rmap-fix-typo-in-comment-in-page_address_in_vma
+++ a/mm/rmap.c
@@ -774,7 +774,7 @@ static bool should_defer_flush(struct mm
  * @vma: The VMA we need to know the address in.
  *
  * Calculates the user virtual address of this page in the specified VMA.
- * It is the caller's responsibililty to check the page is actually
+ * It is the caller's responsibility to check the page is actually
  * within the VMA.  There may not currently be a PTE pointing at this
  * page, but if a page fault occurs at this address, this is the page
  * which will be accessed.
_

Patches currently in -mm which might be from liuye@kylinos.cn are


