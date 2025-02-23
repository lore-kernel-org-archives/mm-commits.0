Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C60728691
	for <mm-commits@vger.kernel.org>; Sun, 23 Feb 2025 03:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740279634; cv=none; b=hC9OBQpRToa/W5cvoQH2a/U5u+5ZyorUys+/ZPc/qpzPB3sookpVD3NZxQam8oa7VltPGZakp8Puw5wvlbA8RshtMany3jPBpLkmsLLTl1FZ2o3xjRXsUliSg+oVfo0xZsIQFvRvBb/Dx35aZo0P4onLw0UK1y7gfj8iOaqzbzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740279634; c=relaxed/simple;
	bh=Gl5OFJkyd1vWaf8kVlr5oMv+5hZBUSbJZYiMGoSmF00=;
	h=Date:To:From:Subject:Message-Id; b=iq302fSaCFAOqYPT1yB58FjqHTJZSVn42Q5FeBqgNInOa51oR6CgvxyQfq59iAtNDZCS4YgSKUTzWOReSB56FzYUi1M0rmP1f3x0rq3Vh1XJO04uJ/UzjuvGYq2x4JpZ1nw6KB9LShfxFSFn4BWJsRrnYT9n7Bb6wFKgPEZEDAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iBkjwjhz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iBkjwjhz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 401D0C4CEE4;
	Sun, 23 Feb 2025 03:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740279634;
	bh=Gl5OFJkyd1vWaf8kVlr5oMv+5hZBUSbJZYiMGoSmF00=;
	h=Date:To:From:Subject:From;
	b=iBkjwjhz6zfZau9YjkiSjexA4hf0CzuxnhU4gNCMKNYmfutD42evNmr0mAx7BFjRl
	 ghN1XZBxyJLXfCsX4EWWS+8L6IvGr8VkofytJ0kkCAZKfvo0NoKZM0d5r+4O36TGM3
	 Vrqv70sfS87fb7zB9Ry1vQUYArh6vhAFidCDfUPk=
Date: Sat, 22 Feb 2025 19:00:33 -0800
To: mm-commits@vger.kernel.org,quic_zijuhu@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmu_gather-remove-needless-return-in-void-api-tlb_remove_page.patch added to mm-nonmm-unstable branch
Message-Id: <20250223030034.401D0C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mmu_gather: remove needless return in void API tlb_remove_page()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mm-mmu_gather-remove-needless-return-in-void-api-tlb_remove_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmu_gather-remove-needless-return-in-void-api-tlb_remove_page.patch

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
From: Zijun Hu <quic_zijuhu@quicinc.com>
Subject: mm/mmu_gather: remove needless return in void API tlb_remove_page()
Date: Fri, 21 Feb 2025 05:02:06 -0800

Remove needless 'return' in void API tlb_remove_page() since both the API
and tlb_remove_page_size() are void functions.

Link: https://lkml.kernel.org/r/20250221-rmv_return-v1-1-cc8dff275827@quicinc.com
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/tlb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/asm-generic/tlb.h~mm-mmu_gather-remove-needless-return-in-void-api-tlb_remove_page
+++ a/include/asm-generic/tlb.h
@@ -503,7 +503,7 @@ static inline void tlb_remove_page_size(
 
 static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
 {
-	return tlb_remove_page_size(tlb, page, PAGE_SIZE);
+	tlb_remove_page_size(tlb, page, PAGE_SIZE);
 }
 
 static inline void tlb_remove_ptdesc(struct mmu_gather *tlb, void *pt)
_

Patches currently in -mm which might be from quic_zijuhu@quicinc.com are

rhashtable-remove-needless-return-in-three-void-apis.patch
cpu-remove-needless-return-in-void-api-suspend_enable_secondary_cpus.patch
mm-mmu_gather-remove-needless-return-in-void-api-tlb_remove_page.patch

