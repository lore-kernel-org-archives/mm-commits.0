Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79366311589
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282430; cv=none; b=fhckJjLSv4+Kta6+azisdnRzw9A70A10ZZAxUBoC2RrKBH7Sb4bQMjeIUTfVHIQ3oaJqJBnc4mi+Eiu8GL8x4R7rcpoPIUIBOeLPLPHretvnrPUokfTAsmh8g6TGfizD9P9Y5iXLmCtUYHAP8SBaMUrzNzOBniB2R3YdmiNf1CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282430; c=relaxed/simple;
	bh=9qbZPnqFGPYlqibFMqfzcMm+N59N9eq7rVrwZSIjpVQ=;
	h=Date:To:From:Subject:Message-Id; b=tJm5QOlyy/hyPJ+pXsWugNM1zYGMnD/1NB2LKIqXfJAM+UWYKVdDZvLO3KR5BRl25h4VfRySuA3OH8Ejs2txcoOju2F7SP0/Gmvxz573N+MWlsFYeHTynCZaudAtQr325b155m6FwXKQnj80hqEiNcE/MkKMqG4KdYR/UnMpybA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hnWdP4F6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hnWdP4F6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50ED5C4CEFB;
	Thu, 27 Nov 2025 22:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764282429;
	bh=9qbZPnqFGPYlqibFMqfzcMm+N59N9eq7rVrwZSIjpVQ=;
	h=Date:To:From:Subject:From;
	b=hnWdP4F6KyDSGVn2RyBdATrfnqxde/hH94WYtKuN359KRyKUgX0hyZ5QFVTEEKKKa
	 ER8IPAvDY9du0Fi56h451TjW8gXQF9Q5xbjxtLWXsgeG6qFryfYKGEhthPpNQe4u8x
	 nW9tGnjLxGa1qoaIgtIEff7z2F0AYS3ManQ58+IA=
Date: Thu, 27 Nov 2025 14:27:08 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,dmatlack@google.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kho-free-chunks-using-free_page-instead-of-kfree.patch removed from -mm tree
Message-Id: <20251127222709.50ED5C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: free chunks using free_page() instead of kfree()
has been removed from the -mm tree.  Its filename was
     kho-free-chunks-using-free_page-instead-of-kfree.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pratyush Yadav <pratyush@kernel.org>
Subject: kho: free chunks using free_page() instead of kfree()
Date: Tue, 18 Nov 2025 19:22:16 +0100

Before commit fa759cd75bce5 ("kho: allocate metadata directly from the
buddy allocator"), the chunks were allocated from the slab allocator using
kzalloc().  Those were rightly freed using kfree().

When the commit switched to using the buddy allocator directly, it missed
updating kho_mem_ser_free() to use free_page() instead of kfree().

Link: https://lkml.kernel.org/r/20251118182218.63044-1-pratyush@kernel.org
Fixes: fa759cd75bce5 ("kho: allocate metadata directly from the buddy allocator")
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: David Matlack <dmatlack@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-free-chunks-using-free_page-instead-of-kfree
+++ a/kernel/liveupdate/kexec_handover.c
@@ -360,7 +360,7 @@ static void kho_mem_ser_free(struct khos
 		struct khoser_mem_chunk *tmp = chunk;
 
 		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
-		kfree(tmp);
+		free_page((unsigned long)tmp);
 	}
 }
 
_

Patches currently in -mm which might be from pratyush@kernel.org are


