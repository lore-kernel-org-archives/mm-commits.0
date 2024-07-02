Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA007BA37
	for <mm-commits@vger.kernel.org>; Tue,  2 Jul 2024 06:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719903187; cv=none; b=GcHl/FgtdDReONfYr/izwBxB6t90CvyhTYqTfEJuWap6vvZaxDFIYBRfNSLUHv8oxeufxtrn9D8OL7Ul1poxq2Y3AGNU2ad7SRdg8EtQvoue0csbe8lIt2KMzQzxyRHD8MG/TaOeWxXEEYsZ0QqRzGi/0tzFl+8PsXQLhGUozwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719903187; c=relaxed/simple;
	bh=t+q1TS81uEQedB1nLRp1EkZa6yqq6ADCch72TYyuaMU=;
	h=Date:To:From:Subject:Message-Id; b=bZEcBbD9sz+GkmYWHD/ofbhB7h1qaXPG4CO5WE2btOPRp38LEpVwx727EhJYht17pc1xWomyqAwR/hTJZ4alfkXt+NHetMusMOhHKWKI92y5cnePCzfQMPrYxIKL6Xhu5ch70oKcwG8T7uJNumo7rsHq/qk7yz5kcXdCo4Zhh7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bTgqaqi2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bTgqaqi2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E45C116B1;
	Tue,  2 Jul 2024 06:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719903187;
	bh=t+q1TS81uEQedB1nLRp1EkZa6yqq6ADCch72TYyuaMU=;
	h=Date:To:From:Subject:From;
	b=bTgqaqi20Dj9Vx7B0LUsPxSzEmYvBITcmvalbfH0YyInNz9h1GjcOymDCFAbcn3G4
	 qYrut5yFd46JBH6Pr5ePBZeP3wc+i0mz5uwYkgxXeluBon9lA6kmuG4y+KHLXmkuYu
	 iwAGgvO7q6jIdrLpbx8jxGuQS7jGuMpKjOY+gziA=
Date: Mon, 01 Jul 2024 23:53:06 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,willy@infradead.org,nphamcs@gmail.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,chengming.zhou@linux.dev,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-fix-zswap_never_enabled-for-config_zswap==n.patch added to mm-unstable branch
Message-Id: <20240702065307.34E45C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: fix zswap_never_enabled() for CONFIG_ZSWAP==N
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-fix-zswap_never_enabled-for-config_zswap==n.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-fix-zswap_never_enabled-for-config_zswap==n.patch

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
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: zswap: fix zswap_never_enabled() for CONFIG_ZSWAP==N
Date: Sun, 30 Jun 2024 11:22:31 +1200

If CONFIG_ZSWAP is set to N, it means zswap cannot be enabled. 
zswap_never_enabled() should return true.

Link: https://lkml.kernel.org/r/20240629232231.42394-1-21cnbao@gmail.com
Fixes: 0300e17d67c3 ("mm: zswap: add zswap_never_enabled()")
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zswap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/zswap.h~mm-zswap-fix-zswap_never_enabled-for-config_zswap==n
+++ a/include/linux/zswap.h
@@ -68,7 +68,7 @@ static inline bool zswap_is_enabled(void
 
 static inline bool zswap_never_enabled(void)
 {
-	return false;
+	return true;
 }
 
 #endif
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout.patch
mm-vmscan-drop-checking-if-_deferred_list-is-empty-before-using-ttu_sync.patch
mm-zswap-fix-zswap_never_enabled-for-config_zswap==n.patch

