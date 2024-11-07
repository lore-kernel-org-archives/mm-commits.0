Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B91217F51
	for <mm-commits@vger.kernel.org>; Thu,  7 Nov 2024 20:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731012497; cv=none; b=dGZWcwGOBTox8flpTj9FCGSMDADr3GzlZYe+ITry7YnUY0lnUeS/AVHyEOTiH+Hc5h+x7/S6gl29nVrb4xijrCVtLkAhLebvFPDl+PUbIRK+9PhcWFO/hzfJcpneLg6aPSawNo2IohB8CRz1Wr9c9aepFTWs0JQM65c/oXt3PIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731012497; c=relaxed/simple;
	bh=t+ALScSOnGxmXqgRMUrVh4wtr5v7M5nLFNFrqTPcWlA=;
	h=Date:To:From:Subject:Message-Id; b=TV9xuUKC97zBndS70o4aghkfnbggX6SXhpM7SSe/adWSqVYmCEoPaYNd6ILColOUkw1OTfj7Mgjn0P3P6B/k9QvsarqrncLmJwmKfjD5Q8BqY/WINzQuceT7qfV7cv0qmHMe2MAi7XUi5m8upJhOIIYRVlLWDu3y51edvCeIoxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YleF0sJm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YleF0sJm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78905C4CECC;
	Thu,  7 Nov 2024 20:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731012496;
	bh=t+ALScSOnGxmXqgRMUrVh4wtr5v7M5nLFNFrqTPcWlA=;
	h=Date:To:From:Subject:From;
	b=YleF0sJm/HT9+0bxKETM7MOvMluIE2Q3OZ1w+buYVoilqCDpusuGSWxbhkKeB+edG
	 eKGTXU58KXqopzdt6RX6ggI/szgk4TTVk0p25wrzzMIAA+gKkVasdLJlLxaLJgsmnH
	 8npaalF6lTTdDyQfZkDTZd/Hw8WPpNdB9QjWIUSY=
Date: Thu, 07 Nov 2024 12:48:15 -0800
To: mm-commits@vger.kernel.org,Yibo.Cai@arm.com,slp@redhat.com,lina@asahilina.net,kirill.shutemov@linux.intel.com,justin.he@arm.com,catalin.marinas@arm.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-fix-__wp_page_copy_user-fallback-path-for-remote-mm-fix.patch removed from -mm tree
Message-Id: <20241107204816.78905C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-fix-__wp_page_copy_user-fallback-path-for-remote-mm-fix
has been removed from the -mm tree.  Its filename was
     mm-fix-__wp_page_copy_user-fallback-path-for-remote-mm-fix.patch

This patch was dropped because it was folded into mm-fix-__wp_page_copy_user-fallback-path-for-remote-mm.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-fix-__wp_page_copy_user-fallback-path-for-remote-mm-fix
Date: Fri Nov  1 12:03:22 PM PDT 2024

coding style tweaks

Cc: Asahi Lina <lina@asahilina.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jia He <justin.he@arm.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Sergio Lopez Pascual <slp@redhat.com>
Cc: Yibo Cai <Yibo.Cai@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/mm/memory.c~mm-fix-__wp_page_copy_user-fallback-path-for-remote-mm-fix
+++ a/mm/memory.c
@@ -3081,18 +3081,20 @@ static inline int __wp_page_copy_user(st
 			update_mmu_cache_range(vmf, vma, addr, vmf->pte, 1);
 	}
 
-	/* If the mm is a remote mm, copy in the page using access_remote_vm() */
-	if (current->mm != mm) {
-		if (access_remote_vm(mm, (unsigned long)uaddr, kaddr, PAGE_SIZE, 0) != PAGE_SIZE)
-			goto warn;
-	}
 	/*
-	 * This really shouldn't fail, because the page is there
-	 * in the page tables. But it might just be unreadable,
-	 * in which case we just give up and fill the result with
-	 * zeroes.
+	 * If the mm is a remote mm, copy in the page using access_remote_vm()
 	 */
-	else if (__copy_from_user_inatomic(kaddr, uaddr, PAGE_SIZE)) {
+	if (current->mm != mm) {
+		if (access_remote_vm(mm, (unsigned long)uaddr, kaddr,
+				     PAGE_SIZE, 0) != PAGE_SIZE)
+			goto warn;
+	} else if (__copy_from_user_inatomic(kaddr, uaddr, PAGE_SIZE)) {
+		/*
+		 * This really shouldn't fail, because the page is there
+		 * in the page tables. But it might just be unreadable,
+		 * in which case we just give up and fill the result with
+		 * zeroes.
+		 */
 		if (vmf->pte)
 			goto warn;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-keep-track-of-free-highatomic-fix.patch
mm-fix-__wp_page_copy_user-fallback-path-for-remote-mm.patch
bootmem-stop-using-page-index-fix.patch
vma-detect-infinite-loop-in-vma-tree-fix.patch
maple_tree-add-a-test-checking-storing-null-fix.patch

