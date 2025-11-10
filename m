Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07902E7F08;
	Mon, 10 Nov 2025 05:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762752048; cv=none; b=EqZL8+51FB6g71mRINeJ5bLyUfZPLi0oXdQDepMUWcqJsniV10imvi0/oYIRu+ylWbZFd//T1T2j7nBEI/4gUPiHya+BG4Q9r6M7xacQInGZBv8qOUGSwMLAhydz+VHmnSu3mbmbJaerSyhDf7i8tON6yiGzHq9UPmT4GEnJpew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762752048; c=relaxed/simple;
	bh=6XR8+f2UAp4FOMFGDLGTkrf3wkJSUrEMA2/R0JuY09o=;
	h=Date:To:From:Subject:Message-Id; b=ZGwXH0tdiyWMlTVqnfs3QPumMo6wYbAIBxr39NmoW71Oo2BGya75kGHMCEDNCOJNA04hJp6nUx6aLtW8ZGP7tItEZNFmNflZ39zTCT4Id6YjBqEfPxgPOEdT1h+ckYmokdDk+F5guGHvqulqimJpRqfPl+2eyjYn8CYDsvQRxeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JEEggjXL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JEEggjXL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C127C4CEFB;
	Mon, 10 Nov 2025 05:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762752048;
	bh=6XR8+f2UAp4FOMFGDLGTkrf3wkJSUrEMA2/R0JuY09o=;
	h=Date:To:From:Subject:From;
	b=JEEggjXLoB2bB2hxxzHGgDESwkysXlNC0ntLApIzHpYDqo77G+UMMkk9RTimtwASk
	 n+I1+HFSc5YDcZvax1u9eDxM9+bNKbeI+1KxDgy8FCuUrHyk4lzpNMHFyUEvqA+jA5
	 /CoeOqfMvWdgdM1kArXvYriSivUCFMPktdzZwbag=
Date: Sun, 09 Nov 2025 21:20:47 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,bhe@redhat.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kho-warn-and-exit-when-unpreserved-page-wasnt-preserved.patch removed from -mm tree
Message-Id: <20251110052048.5C127C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: warn and exit when unpreserved page wasn't preserved
has been removed from the -mm tree.  Its filename was
     kho-warn-and-exit-when-unpreserved-page-wasnt-preserved.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pratyush Yadav <pratyush@kernel.org>
Subject: kho: warn and exit when unpreserved page wasn't preserved
Date: Mon, 3 Nov 2025 19:02:32 +0100

Calling __kho_unpreserve() on a pair of (pfn, end_pfn) that wasn't
preserved is a bug.  Currently, if that is done, the physxa or bits can be
NULL.  This results in a soft lockup since a NULL physxa or bits results
in redoing the loop without ever making any progress.

Return when physxa or bits are not found, but WARN first to loudly
indicate invalid behaviour.

Link: https://lkml.kernel.org/r/20251103180235.71409-3-pratyush@kernel.org
Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_handover.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/kexec_handover.c~kho-warn-and-exit-when-unpreserved-page-wasnt-preserved
+++ a/kernel/kexec_handover.c
@@ -171,12 +171,12 @@ static void __kho_unpreserve(struct kho_
 		const unsigned long pfn_high = pfn >> order;
 
 		physxa = xa_load(&track->orders, order);
-		if (!physxa)
-			continue;
+		if (WARN_ON_ONCE(!physxa))
+			return;
 
 		bits = xa_load(&physxa->phys_bits, pfn_high / PRESERVE_BITS);
-		if (!bits)
-			continue;
+		if (WARN_ON_ONCE(!bits))
+			return;
 
 		clear_bit(pfn_high % PRESERVE_BITS, bits->preserve);
 
_

Patches currently in -mm which might be from pratyush@kernel.org are

maintainers-add-myself-as-a-reviewer-for-kho.patch
liveupdate-luo_file-add-private-argument-to-store-runtime-state.patch

