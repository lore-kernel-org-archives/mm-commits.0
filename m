Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA427345B
	for <mm-commits@vger.kernel.org>; Mon,  8 Jul 2024 21:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720475105; cv=none; b=ao+R0mHHwYY4x5f597H58UwltF/RhTBvwsDF+iEzrY8fKbrniRIZiEFBOIERzlux1/w+oqD/P2aHFhiqlWsIO8km/YRUG/jjc9FMXCZHaIWDrMa1Y3pxPsMzENfi7rmq9CcW67l2oIbfjAoTwb2H+VU3gAZl34uanOdLG4k8la0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720475105; c=relaxed/simple;
	bh=U5qiB5IaOE4ZO/e0/jvi6iYl+jTTtd6ZopIFQcaRZ/s=;
	h=Date:To:From:Subject:Message-Id; b=a7l67CgNt6CM5iXKt8L5tfQTKVpZkJbWhLEXQmLteucNz7Ue7nP4hnpJgiY2ZHz9G38xQZXqu0fjorCDide/m9tzNw9AzBsFlsTlXmYhKoQA/ngh3ObngiJRSzrDDsitDlnV3ShDe+QVkXg+sxoJt1pkEBkLOOts3PI+bUnyt/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TAIpZsGb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TAIpZsGb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD91C116B1;
	Mon,  8 Jul 2024 21:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720475105;
	bh=U5qiB5IaOE4ZO/e0/jvi6iYl+jTTtd6ZopIFQcaRZ/s=;
	h=Date:To:From:Subject:From;
	b=TAIpZsGbM5aJuLiV6tBeqjxzJKMW5lN6FHe5wofpS0IaAFGlPyvs728ipB3rOu6El
	 eEGcUyO7tbrduoGcdr02vGujYT5r5+cGwINDCCeLUv6xTdO0LaFZzY4kOH72pd9nnT
	 h0rpAvZ3DbFLV1HK/RjfYKPa8RAow9yTlGLHqdjQ=
Date: Mon, 08 Jul 2024 14:45:04 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,usama.anjum@collabora.com,svetly.todorov@memverge.com,ryan.roberts@arm.com,david@redhat.com,corbet@lwn.net,avagin@google.com,ran.xiaokai@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kpageflags-detect-isolated-kpf_thp-folios-v2.patch added to mm-unstable branch
Message-Id: <20240708214505.2AD91C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kpageflags: detect isolated KPF_THP folios
has been added to the -mm mm-unstable branch.  Its filename is
     kpageflags-detect-isolated-kpf_thp-folios-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kpageflags-detect-isolated-kpf_thp-folios-v2.patch

This patch will later appear in the mm-unstable branch at
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
kpageflags-detect-isolated-kpf_thp-folios-v2.patch

