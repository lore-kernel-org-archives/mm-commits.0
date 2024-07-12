Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D426CDB3
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824493; cv=none; b=k99hvFxdFslrx4loibrOdhV1U4ookPeBC+A3/umpgEfIeCKTuZywJG+gV94HE8NiYJyuWvztNvhnWIu2rui/YXzISYHiM9zcP0fW/+Se+Uzz2HcMRLxoY2mrG3Kd2BbvK13psuwhSkFFM26Uoef+EiHXgAolKocgTqSaLEvWD8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824493; c=relaxed/simple;
	bh=9J16cLsd0uz32o9cN60jpyG8DIy8qG9mkVGvXGirxEY=;
	h=Date:To:From:Subject:Message-Id; b=OzAvbEgfU7BoRrYyenA0FSeIwcrftme9vKvDat57wEx9ay4Yh3Tr5kpUZL6CxWp937mKRkZO4XezKwlviCxeLLPMVRfBmYMv+l6xGYPmJ25TPA5fPxo32zO/EXibPcan4LBkGO426h4yqps855l3bmaFWa+td7fZzIIcJQhi9oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V7sm6cSw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V7sm6cSw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8773CC32782;
	Fri, 12 Jul 2024 22:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824492;
	bh=9J16cLsd0uz32o9cN60jpyG8DIy8qG9mkVGvXGirxEY=;
	h=Date:To:From:Subject:From;
	b=V7sm6cSwn2sy1NfACYu9CmejIwr8x0YI2Voc3hVqxyS5pC0cZkCP0odBjuiI4kEsK
	 97Unn6Zmjj0qDn4QMXJduDgPMU9UI8jQtX6ALbr4jDdQ09l4n3WYtuJXJjz2bGp378
	 Llr5oeK73bLiwKFStN/XMBwOhKGh7/HoNd5D95KE=
Date: Fri, 12 Jul 2024 15:48:12 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,usama.anjum@collabora.com,svetly.todorov@memverge.com,ryan.roberts@arm.com,david@redhat.com,corbet@lwn.net,avagin@google.com,ran.xiaokai@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kpageflags-detect-isolated-kpf_thp-folios-v2.patch removed from -mm tree
Message-Id: <20240712224812.8773CC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kpageflags: detect isolated KPF_THP folios
has been removed from the -mm tree.  Its filename was
     kpageflags-detect-isolated-kpf_thp-folios-v2.patch

This patch was dropped because it was folded into kpageflags-detect-isolated-kpf_thp-folios.patch

------------------------------------------------------
From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Subject: kpageflags: detect isolated KPF_THP folios
Date: Mon, 8 Jul 2024 06:26:01 +0000

directly use is_zero_folio(), per David

Link: https://lkml.kernel.org/r/20240708062601.165215-1-ranxiaokai627@163.com
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andrei Vagin <avagin@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Svetly Todorov <svetly.todorov@memverge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/page.c~kpageflags-detect-isolated-kpf_thp-folios-v2
+++ a/fs/proc/page.c
@@ -154,7 +154,7 @@ u64 stable_page_flags(const struct page
 	} else if (is_huge_zero_folio(folio)) {
 		u |= 1 << KPF_ZERO_PAGE;
 		u |= 1 << KPF_THP;
-	} else if (is_zero_pfn(page_to_pfn(page))) {
+	} else if (is_zero_folio(folio)) {
 		u |= 1 << KPF_ZERO_PAGE;
 	}
 
_

Patches currently in -mm which might be from ran.xiaokai@zte.com.cn are

kpageflags-detect-isolated-kpf_thp-folios.patch

