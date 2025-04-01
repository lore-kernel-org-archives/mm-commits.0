Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B375C20FAB2
	for <mm-commits@vger.kernel.org>; Tue,  1 Apr 2025 19:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743534478; cv=none; b=fMfRpE2uDUvCBVWx4Kjqz6zg61Tfn0/OaHvopU3kUFbkJipU8hm34AfeYeqo1QQNwDUlB5fDg/PmAmBXSpaAg0YlYA0lYQo7LOm+o++OByn/scdZuv54/c3aWsrKF0V4082X/iCPObt7PNVXGCnr+NOzNLN4DAEqWhxyuzVO8P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743534478; c=relaxed/simple;
	bh=eotBgKEIAdXT+X5NhVVgnWs6sBvaS4AvwWIZutUfSaM=;
	h=Date:To:From:Subject:Message-Id; b=WI5IPE6X7HOCoVjLRt4+VnPh9TQq9/0wFZUeO5CtW+DpeWVlGE5DXn5KlT9LP0aqYhb0g6OFCo91R86YWZB0XEdtCsZ6juk8de+msiEkDplF1C9hGSICgSfHjowfPK/UukxOMG2xED/3BzpWqvM9/jNv9p0ldqrXbQIUjWmoMkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t6BU2ifh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t6BU2ifh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22797C4CEE4;
	Tue,  1 Apr 2025 19:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743534478;
	bh=eotBgKEIAdXT+X5NhVVgnWs6sBvaS4AvwWIZutUfSaM=;
	h=Date:To:From:Subject:From;
	b=t6BU2ifhmEW6W0nuuYFMFV1nG3CgIR1frLN6x74opIqe/ioouGBTXtXru7dsheLtZ
	 9OZjB4c/MAb2ZLmsuev967HEvBOLNzWnVo0/XOwTyfM/MynA3vND9JJlW0D/Qiy5xL
	 9ngtR6RutQuWY0bW8ICW6vmmFTyxHJ2Q8NhG/UJw=
Date: Tue, 01 Apr 2025 12:07:57 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2-fix.patch removed from -mm tree
Message-Id: <20250401190758.22797C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2-fix
has been removed from the -mm tree.  Its filename was
     mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2-fix.patch

This patch was dropped because it was folded into mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2-fix
Date: Mon Mar  3 03:52:14 PM PST 2025

remove trailing semi in arch/loongarch/include/asm/pgalloc.h

Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/include/asm/pgalloc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/include/asm/pgalloc.h~mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2-fix
+++ a/arch/loongarch/include/asm/pgalloc.h
@@ -56,7 +56,7 @@ static inline pte_t *pte_alloc_one_kerne
 }
 
 #define __pte_free_tlb(tlb, pte, address)	\
-	tlb_remove_ptdesc((tlb), page_ptdesc(pte));
+	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
 
 #ifndef __PAGETABLE_PMD_FOLDED
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc.patch

