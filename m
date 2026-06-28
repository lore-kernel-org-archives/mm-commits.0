Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B564149620;
	Sun, 28 Jun 2026 04:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782622103; cv=none; b=bnreiePS0GlawLaOyLpzliLOPs1BxpXuSgr2seGfZE0SQaBd9ZVTxKWhTKDSGcJR0MJ7T3HLR0Qx40bvRpuccKkTw1mPwowWCx4rOPSCg3G8Fnjc+AvxH3p4hz4EdEnf5L+qtPHMY33IGYUm+pNVyATb781zVZvjIoaLHPW6Dko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782622103; c=relaxed/simple;
	bh=h3tFK2sbs61DxXpCwpvURsRrQOyh+mHidU0sV4EWToA=;
	h=Date:To:From:Subject:Message-Id; b=T5SJ6Pa6nky/yaacJyTbg+DLoIuOvy2putDw12RreNPzozCh/pyLGQeCVNo69F3IEuji+MJQOln7kVOt+4jBuNZnwADFqhGFOuYNnWNFaejIBnowOcJRBxtCrRqocpuHi9EA3E+1PBToyFCt3larw8pTxsfyqr16qUSwqtwEynE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uwrcRDFA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uwrcRDFA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 282601F000E9;
	Sun, 28 Jun 2026 04:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782622102;
	bh=b0oA15E2s8/df0k7f0vCFdyXzUu287GovqPnGOvfPew=;
	h=Date:To:From:Subject;
	b=uwrcRDFAvRgl5oQwfHMNVIx1vjEYeTGiK9egtbM5/NvEJtr1GwT8MLetK3ZFkDgpv
	 uo6DdAXWLBheCILlKMx9y/qSABYh9Ho4xJPRGXMasTxN/Q0r3FWK43T/GBS6i21/Fu
	 /MyEtBiawPIHhAvFO2jMkq2ZN18Cjc1+Ff2wEXoo=
Date: Sat, 27 Jun 2026 21:48:21 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xu.xin16@zte.com.cn,willy@infradead.org,wangkefeng.wang@huawei.com,svetly.todorov@memverge.com,sunnanyong@huawei.com,stable@vger.kernel.org,luizcap@redhat.com,linmiaohe@huawei.com,david@kernel.org,chengming.zhou@linux.dev,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-fix-kpf_ksm-reported-for-all-anonymous-pages.patch added to mm-hotfixes-unstable branch
Message-Id: <20260628044822.282601F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc: fix KPF_KSM reported for all anonymous pages
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fs-proc-fix-kpf_ksm-reported-for-all-anonymous-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-fix-kpf_ksm-reported-for-all-anonymous-pages.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: fs/proc: fix KPF_KSM reported for all anonymous pages
Date: Fri, 26 Jun 2026 09:32:52 +0800

Reading /proc/kpageflags for any anonymous page returns KPF_KSM set, even
when KSM is not in use.  As a result, tools misclassify all anonymous
pages as KSM merged.

In stable_page_flags(), if the page is anonymous, then use (mapping &
FOLIO_MAPPING_KSM) check to identify if the anonymous page is KSM page. 
However, FOLIO_MAPPING_KSM is FOLIO_MAPPING_ANON | FOLIO_MAPPING_ANON_KSM,
(mapping & FOLIO_MAPPING_KSM) check returns true for all anonymous pages.

To fix it, use FOLIO_MAPPING_ANON_KSM instead.

Link: https://lore.kernel.org/20260626013252.2846774-1-tujinjiang@huawei.com
Fixes: dee3d0bef2b0 ("proc: rewrite stable_page_flags()")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Luiz Capitulino <luizcap@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Svetly Todorov <svetly.todorov@memverge.com>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/page.c~fs-proc-fix-kpf_ksm-reported-for-all-anonymous-pages
+++ a/fs/proc/page.c
@@ -173,7 +173,7 @@ u64 stable_page_flags(const struct page
 		u |= 1 << KPF_MMAP;
 	if (is_anon) {
 		u |= 1 << KPF_ANON;
-		if (mapping & FOLIO_MAPPING_KSM)
+		if ((mapping & FOLIO_MAPPING_FLAGS) == FOLIO_MAPPING_KSM)
 			u |= 1 << KPF_KSM;
 	}
 
_

Patches currently in -mm which might be from tujinjiang@huawei.com are

fs-proc-fix-kpf_ksm-reported-for-all-anonymous-pages.patch

