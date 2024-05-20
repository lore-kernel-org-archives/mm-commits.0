Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D27632
	for <mm-commits@vger.kernel.org>; Mon, 20 May 2024 00:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716164070; cv=none; b=aTr5yzqUGyEo2qNwNnn+L8lUA0ZYdrbVulEdwsDdtNn6+aNmA7IZ0EWHFxLPY2ZixR75ZbW0uIgNl3UEZ8r0UNXV5L9jUmeXk90cKEg22f4OFIqPq2ce1CMEKdCL3QilGE2pOpb5KZx/mn4Zs6jHbkNEwcpthYQy8ddvZWtDwBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716164070; c=relaxed/simple;
	bh=WW8cnfxH3zdJBWEiffBC/Eby2rOA9gbSL8GYYW5eKmo=;
	h=Date:To:From:Subject:Message-Id; b=Y00C2ydb1pEizaBWJUO3kmkF1UjU2ZAB5kYBKC6whOdhb5mH/mzdE4Ed4x4eZXcFRjG/5qq2Xfx2loUhO09snzBNDD0+uX8ACUCXMGA4faQEGnyl/3iTodzn4EV5CVys7nheJRbSH/+32sQIWh6u6AY0mrAMg7teRhLTTppFilo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nhjNuIrz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nhjNuIrz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99587C32781;
	Mon, 20 May 2024 00:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716164069;
	bh=WW8cnfxH3zdJBWEiffBC/Eby2rOA9gbSL8GYYW5eKmo=;
	h=Date:To:From:Subject:From;
	b=nhjNuIrz9hcrSQPrPgaIc13jTArMU8AvEZk9182dc8V9K1LDQKYWhv5kQcnQzLs5c
	 TXxsxhbQc2NydUtMB9Joe9hvkq/l5Pa6rGoCJ8GEOMkaLXrbDnmaEshEJZ3WUtrfqU
	 jcyWqeV6J4p8UE1dks2Cgk51Ov75WrKF+GvgIYMw=
Date: Sun, 19 May 2024 17:14:29 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yang.yang29@zte.com.cn,xu.xin16@zte.com.cn,willy@infradead.org,shy828301@gmail.com,lu.zhongjun@zte.com.cn,david@redhat.com,ran.xiaokai@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-mark-racy-access-onhuge_anon_orders_always.patch added to mm-unstable branch
Message-Id: <20240520001429.99587C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: mark racy access onhuge_anon_orders_always
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-mark-racy-access-onhuge_anon_orders_always.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-mark-racy-access-onhuge_anon_orders_always.patch

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
Subject: mm/huge_memory: mark racy access onhuge_anon_orders_always
Date: Wed, 15 May 2024 10:47:54 +0800 (CST)

huge_anon_orders_always is accessed lockless, it is better to use the
READ_ONCE() wrapper.  This is not fixing any visible bug, hopefully this
can cease some KCSAN complains in the future.  Also do that for
huge_anon_orders_madvise.

Link: https://lkml.kernel.org/r/20240515104754889HqrahFPePOIE1UlANHVAh@zte.com.cn
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lu Zhongjun <lu.zhongjun@zte.com.cn>
Reviewed-by: xu xin <xu.xin16@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/huge_mm.h~mm-huge_memory-mark-racy-access-onhuge_anon_orders_always
+++ a/include/linux/huge_mm.h
@@ -134,8 +134,8 @@ static inline bool hugepage_flags_enable
 	 * So we don't need to look at huge_anon_orders_inherit.
 	 */
 	return hugepage_global_enabled() ||
-	       huge_anon_orders_always ||
-	       huge_anon_orders_madvise;
+	       READ_ONCE(huge_anon_orders_always) ||
+	       READ_ONCE(huge_anon_orders_madvise);
 }
 
 static inline int highest_order(unsigned long orders)
_

Patches currently in -mm which might be from ran.xiaokai@zte.com.cn are

mm-huge_memory-mark-racy-access-onhuge_anon_orders_always.patch

