Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8C8274641;
	Thu,  2 Jul 2026 02:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782957820; cv=none; b=QYqLexPPjb2OPnbAHN1hV5wgZgcihxhI6Y/d3NnJvDSLyGMMLzrjLB5ZLJlPLTKvlp2T2DkgrLcF1J6GxBVI+AUqckFpQ5xIFq8uZpsN1xh3Ox80EM7mEY647kz+2I0p1kB/6x6pQ5gZ6+QeJDW2Mu3HWZfD68Tfu0APVgib/r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782957820; c=relaxed/simple;
	bh=3kW+2ihceWJW2fmN7qaPMOx5nAMe2Wnp6cj/gK241hE=;
	h=Date:To:From:Subject:Message-Id; b=kDctMRkZG02QrZcbEa3ISZYYamHKeGq3MU3yocH6yF32iMTEkm8k48TSaRyDKMRWojLQL2w9mqXxBa9dHWiEDLPUsH5A9YUCVoqKlJ1/q4Xg5hA4kQmWm+tnxXe4362YGXeoE5tOB70NfP3rEnZwPOGckt5ZpYXRidbgKCcSdeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2hahxo8W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2hahxo8W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B00021F000E9;
	Thu,  2 Jul 2026 02:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782957818;
	bh=tl9xL+txI7+dKr5OvkITpANXW0bgLdUpKQg4NbaD8kw=;
	h=Date:To:From:Subject;
	b=2hahxo8W9i6oD4PNRxKc8+2wy/EqYDMDLIYZPP+PmT5+qtOeoJbt3+XyF3FxLLshK
	 ANuNxtu9sA3ZqHwDeQAmacBO6UHA1jAhgW/XtteKngpcrQbk9aTmTt/J+/2zcqcat9
	 oEdUtnOUM7ggNypoVLPNE7nfIaN/5SxkToelrRRU=
Date: Wed, 01 Jul 2026 19:03:38 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xu.xin16@zte.com.cn,willy@infradead.org,wangkefeng.wang@huawei.com,svetly.todorov@memverge.com,sunnanyong@huawei.com,stable@vger.kernel.org,luizcap@redhat.com,linmiaohe@huawei.com,david@kernel.org,chengming.zhou@linux.dev,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] fs-proc-fix-kpf_ksm-reported-for-all-anonymous-pages.patch removed from -mm tree
Message-Id: <20260702020338.B00021F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc: fix KPF_KSM reported for all anonymous pages
has been removed from the -mm tree.  Its filename was
     fs-proc-fix-kpf_ksm-reported-for-all-anonymous-pages.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Link: https://lore.kernel.org/20260629033122.774318-1-tujinjiang@huawei.com
Link: https://lore.kernel.org/20260626013252.2846774-1-tujinjiang@huawei.com
Fixes: dee3d0bef2b0 ("proc: rewrite stable_page_flags()")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Xu Xin <xu.xin16@zte.com.cn>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Luiz Capitulino <luizcap@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Svetly Todorov <svetly.todorov@memverge.com>
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


