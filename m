Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92FF437031D
	for <mm-commits@vger.kernel.org>; Tue, 18 Nov 2025 22:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763504137; cv=none; b=dUEgFYRTKM2eLIbjJ9havy9KhSaApxLsEnfxyJNP2kE0DEy9s6BrPni5QS3/HRseDKNFJUZ/2owRKM+9c0seD8xJN3oGNGm08l8QHPhUYkJXsjFqmmiObv9c6PiWNQAqmSA0Thx6lHXzVfqpmBxC7RxpRWqykdANDJKEg9J9dg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763504137; c=relaxed/simple;
	bh=I3wTwL88wNYnRR22kBc6yOdRDtLsJlkSWr2qFeKNxc4=;
	h=Date:To:From:Subject:Message-Id; b=Qf7MEQyhhEuYCoBUv8jacC01C7s8LGIuWvxxkpBP5jEfzLKtqa2z2ib/W6/gIhYTzlZOeXMYXzKgg96sIHzfKv7XajCb9ScD1KKO/Rs/pFW6FLkuWYUkB7Fe+gxhWMGmkfBR8w03dvjXRL8g9moGSi4hLjBbkd8X12xktIKf4Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J3eujxU+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J3eujxU+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ADF3C4CEF1;
	Tue, 18 Nov 2025 22:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763504136;
	bh=I3wTwL88wNYnRR22kBc6yOdRDtLsJlkSWr2qFeKNxc4=;
	h=Date:To:From:Subject:From;
	b=J3eujxU+Z1uijBRmVwAosJNr29SWd7V8ZXkfWtpKWCv/5SJoriowUr5HPqaS2+yV6
	 2UmluZROsNdfoNp6jT5mAL0fAh9/3wIgalUm02+XNy6ysmNtPJvXCoMEe2jSOKvB6F
	 V0Ss7Isve/hxwuTQ+ihSM3NrWw9AhSWdKWEVD18E=
Date: Tue, 18 Nov 2025 14:15:34 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,dmatlack@google.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-free-chunks-using-free_page-instead-of-kfree.patch added to mm-nonmm-unstable branch
Message-Id: <20251118221536.0ADF3C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: free chunks using free_page() instead of kfree()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-free-chunks-using-free_page-instead-of-kfree.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-free-chunks-using-free_page-instead-of-kfree.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Cc: Alexander Graf <graf@amazon.com>
Cc: David Matlack <dmatlack@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
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

maintainers-add-test_kho-to-khos-entry.patch
maintainers-add-myself-as-a-reviewer-for-kho.patch
liveupdate-luo_file-add-private-argument-to-store-runtime-state.patch
kho-free-chunks-using-free_page-instead-of-kfree.patch

