Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E111225757
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957079; cv=none; b=T6oQQK+KKeQ4HQiOjOMv0X/vnKETSpbPgg9Yu2EoZNRXfhmNI2lKizCIJTgb4/wGRGboiWCqQT+OQosV86FjXTUojAje56L2vmAmCCN942TNEIUgFWsyBH+58wxS/qL2I3MzYKKYoZo63drB5QMDllEQdHJ3z/pKKKSfZQ+TZGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957079; c=relaxed/simple;
	bh=7tbo/O7SH3Xz8UbvapPIyO/tw2HIg1TwqNCnrz659zg=;
	h=Date:To:From:Subject:Message-Id; b=KhSH9mhZT6k+y/JTNqLl9QdqkJzBMPDkO2KZLxNemJPiTQpk32h8Mcl042oujzo5CbMJRlJ8Kk93/Yyus/dIHX5bWZ6JW7QZSxz51k7I+LFBLM/l1eKrsNmJNrysaoyjZDkDfciQdIfA3/jICybukKL8Qt4jNZ/dP5tmczcrr4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LiXfu13U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LiXfu13U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B80C0C113CC;
	Mon,  6 May 2024 00:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957078;
	bh=7tbo/O7SH3Xz8UbvapPIyO/tw2HIg1TwqNCnrz659zg=;
	h=Date:To:From:Subject:From;
	b=LiXfu13UIdY1653VLtcU7aRH0RUWHVIIKfbGgxtdumsadzlJlXLHcrf1LqJ9urOvr
	 rMnhCapRr/XueSDRiWTn50fn/vCgc8qw2V/aBTyvfT3Rt38pMcgXu1+81sMv2SCJbw
	 3MDDl5sQbsvhXj54Svtydlc2krMT0U/haPKO+AfY=
Date: Sun, 05 May 2024 17:57:58 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,lrh2000@pku.edu.cn,josef@toxicpanda.com,david@redhat.com,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page-flags-make-pageuptodate-return-bool.patch removed from -mm tree
Message-Id: <20240506005758.B80C0C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page-flags: make PageUptodate return bool
has been removed from the -mm tree.  Its filename was
     mm-page-flags-make-pageuptodate-return-bool.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hao Ge <gehao@kylinos.cn>
Subject: mm/page-flags: make PageUptodate return bool
Date: Mon, 22 Apr 2024 11:27:25 +0800

Make PageUptodate return bool to align the return values of
folio_test_uptodate function

Link: https://lkml.kernel.org/r/20240422032725.41452-1-gehao@kylinos.cn
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Cc: David Hildenbrand <david@redhat.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ruihan Li <lrh2000@pku.edu.cn>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/page-flags.h~mm-page-flags-make-pageuptodate-return-bool
+++ a/include/linux/page-flags.h
@@ -789,7 +789,7 @@ static inline bool folio_test_uptodate(c
 	return ret;
 }
 
-static inline int PageUptodate(const struct page *page)
+static inline bool PageUptodate(const struct page *page)
 {
 	return folio_test_uptodate(page_folio(page));
 }
_

Patches currently in -mm which might be from gehao@kylinos.cn are


