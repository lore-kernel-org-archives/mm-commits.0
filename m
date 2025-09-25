Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84851DE3DC
	for <mm-commits@vger.kernel.org>; Thu, 25 Sep 2025 17:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758823134; cv=none; b=nfsk6tvsm3dmMQ3pdEeCQf2AFlgBhfKppIpvZ4F/Olhm2S1P4MF4gpnhVeZnMw8fJBLQybTJUB6885Io9Klb0MMoc1YZzIjBxjwIHtKAb3i8OCtpo+Jn5QFZvgxjFKt4SIhr6jAyM4qCZEi+Ud6Rf1D6Rkz1AApUf82QjKBSodY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758823134; c=relaxed/simple;
	bh=DgICMXOXnpB4qYkTdIESyVNktT8lk9G7Giexzx10JhM=;
	h=Date:To:From:Subject:Message-Id; b=KRAgG8G170Srzxa45a28LADKeLx8vz95FXRY5Zg43eBaD5a91w5yjUrP9Hff0tc6do4veqmEl4kI2OjpLZh9bTt9mQcf6uWv50UHmojKcNclUjS/EGepwn5xvnY3ytwuJFC4w2fHZPwmhBXLc3+rdvkxKl18XGf0ckUArn9ycJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2WsqtkxM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2WsqtkxM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ADB1C4CEF0;
	Thu, 25 Sep 2025 17:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758823133;
	bh=DgICMXOXnpB4qYkTdIESyVNktT8lk9G7Giexzx10JhM=;
	h=Date:To:From:Subject:From;
	b=2WsqtkxMMvV5sFcZcY9uB0uLDX/lv6EEaxCkWbHvRYBDAAKh01lE32qOXexQjFaX0
	 tVcrpPxpBrdtdJWIQm8nPsP3Fyct+dwJdlx5r9bee+Zi5FoAe9mn865KxPwDwi2eN/
	 xkvCrPlF9M2Z79vBNTnGwlI8HGOh0dOhM5d9WbnQ=
Date: Thu, 25 Sep 2025 10:58:52 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,jgg@nvidia.com,graf@amazon.com,chrisl@kernel.org,changyuanl@google.com,bhe@redhat.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-add-support-for-preserving-vmalloc-allocations-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20250925175853.5ADB1C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho-add-support-for-preserving-vmalloc-allocations-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-add-support-for-preserving-vmalloc-allocations-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-add-support-for-preserving-vmalloc-allocations-fix.patch

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
Subject: kho-add-support-for-preserving-vmalloc-allocations-fix
Date: Thu, 25 Sep 2025 13:05:08 +0200

Chunks are allocated using get_zeroed_page() so they should be freed
using free_page() not kfree().

Link: https://lkml.kernel.org/r/mafs0a52idbeg.fsf@kernel.org
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_handover.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/kexec_handover.c~kho-add-support-for-preserving-vmalloc-allocations-fix
+++ a/kernel/kexec_handover.c
@@ -885,7 +885,7 @@ static void kho_vmalloc_free_chunks(stru
 		kho_vmalloc_unpreserve_chunk(chunk);
 
 		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
-		kfree(tmp);
+		free_page((unsigned long)tmp);
 	}
 }
 
_

Patches currently in -mm which might be from pratyush@kernel.org are

kho-add-support-for-preserving-vmalloc-allocations-fix.patch
kho-only-fill-kimage-if-kho-is-finalized.patch

