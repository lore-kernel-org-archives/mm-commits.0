Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530EE40D598
	for <mm-commits@vger.kernel.org>; Sun, 28 Jun 2026 04:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782622002; cv=none; b=U+EfytBLQNgGnFuyA7VN582kdsAHlTHtQMvcWngYPhIeInCmkQjVcVynVfW+7QAJHh74zuwDkdmySviOiNdvvGDmz6HWEiXtU8Y/IceMgtQNKLi8c0k9lphM6Efm+IHYzpFA0XPrpm8Ew5DflyttN2MJyUKsraLCjvyU5r50Xbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782622002; c=relaxed/simple;
	bh=iW/0IhHX41dVJnWSRrybf9MTqx7MRT+UzzECgEeVuxE=;
	h=Date:To:From:Subject:Message-Id; b=e7NTmvXLBr57ikfAPtqOGCoo6oR6JN34cHOVhLkrmD/A2BkBSqdXFKhUfoECoOP0Y9FdM+d7IwJ4B2VVnvcgiXpLCvhXc4atT+KnSa2GAddx7obfNHFbsmj+QNYAUf2Y4m4L2I41aUtfIsIWVcSa68IB/cxo3THish0HxO7TBxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dz/DbDrJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dz/DbDrJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32101F000E9;
	Sun, 28 Jun 2026 04:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782622000;
	bh=WqkfzR4XFwTPayV/5gvPGNQfInzWbTLXT7k7VTkgmZI=;
	h=Date:To:From:Subject;
	b=dz/DbDrJuuw7EPHzNYBVEvtVkyLrCyxgTQQVZSoNgpRtwR0qoDOoKhBLnNXbG/Vyh
	 HZibANXIZpw9fM5FSYI5d1bem2QrUZaTy/X0Uufw8za6t/a186Ix3a8s0j2hBh7x37
	 mu0CS2faNDf0WaRxWBwfoFejAnxccG+nOO3Tsv+M=
Date: Sat, 27 Jun 2026 21:46:40 -0700
To: mm-commits@vger.kernel.org,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] fs-proc-fix-kpf_ksm-reported-for-all-anonymous-pages.patch removed from -mm tree
Message-Id: <20260628044640.B32101F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc: fix KPF_KSM reported for all anonymous pages
has been removed from the -mm tree.  Its filename was
     fs-proc-fix-kpf_ksm-reported-for-all-anonymous-pages.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: fs/proc: fix KPF_KSM reported for all anonymous pages
Date: Mon, 22 Jun 2026 17:15:39 +0800

Reading /proc/kpageflags for any anonymous page returns KPF_KSM set, even
when KSM is not in use.  As a result, tools which use /proc/kpageflags
(and hwpoison inject on a weird testing interface) misclassify all
anonymous pages as KSM merged.

In stable_page_flags(), if the page is anonymous, then use (mapping &
FOLIO_MAPPING_KSM) check to identify if the anonymous page is KSM page. 
However, FOLIO_MAPPING_KSM is FOLIO_MAPPING_ANON | FOLIO_MAPPING_ANON_KSM,
(mapping & FOLIO_MAPPING_KSM) check returns true for all anonymous pages.

To fix it, use FOLIO_MAPPING_ANON_KSM instead.

Link: https://lore.kernel.org/20260622091539.836531-1-tujinjiang@huawei.com
Fixes: dee3d0bef2b0 ("proc: rewrite stable_page_flags()")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Luiz Capitulino <luizcap@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Svetly Todorov <svetly.todorov@memverge.com>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Zi Yan <ziy@nvidia.com>
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
+		if (mapping & FOLIO_MAPPING_ANON_KSM)
 			u |= 1 << KPF_KSM;
 	}
 
_

Patches currently in -mm which might be from tujinjiang@huawei.com are


