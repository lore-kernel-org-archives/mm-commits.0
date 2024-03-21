Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF4213340E
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 22:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711059519; cv=none; b=ds4MYvtjk4SAbKA6oSQb1g/fy8rdr0PjbCFp8VMkAzQfLNfLjb90OnU0svuMTj372IcWb2xw+ciBeSXyaSudebucr4NF8yy2557QeZfnHEZlUmJMS17Xlki2LwPll4o6XhuCx1OMuA8dDG5zUEYWjO2bCgLoeF1MWVyUGkL9+4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711059519; c=relaxed/simple;
	bh=NF9orme0sjgkgEeLjUBX8OSN9Y1OL6LQeXoRNxeYk3o=;
	h=Date:To:From:Subject:Message-Id; b=ILydpT2sqPPrWGQcl9yEbsacXHAeLFIp7RzS6c3veUlPqsJtWyY1kV2wFPmeRjvsty6bguFWzs5MvxgEnAz01/Sv4GwD18+/wv8rv8jYXIu4KKC00A0Vj72gfFQzVKiiL+A3oho6/LcAffKJ1mErulX/M3/B23yquIbDa6CAmUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O17tZi9b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O17tZi9b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 542EEC433F1;
	Thu, 21 Mar 2024 22:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711059519;
	bh=NF9orme0sjgkgEeLjUBX8OSN9Y1OL6LQeXoRNxeYk3o=;
	h=Date:To:From:Subject:From;
	b=O17tZi9bKgXs80jwqM8W/YdYAoivvgF4oU+jAL0imT0xRmVat3b953Lh5WP3/LqG1
	 yYQkNbYnwYrFyA9JqjB9ggFqd/TJuRHTZNGa5N2CY6lke5B9z1LoMHQ8h/gKpbU/HC
	 ML/6r6+jTvauMuaMVVEHXglpyQrHLauctLUTx7qs=
Date: Thu, 21 Mar 2024 15:18:38 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page-flags-make-pagemappingflags-return-bool.patch added to mm-unstable branch
Message-Id: <20240321221839.542EEC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page-flags: make PageMappingFlags return bool
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page-flags-make-pagemappingflags-return-bool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page-flags-make-pagemappingflags-return-bool.patch

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
From: Hao Ge <gehao@kylinos.cn>
Subject: mm/page-flags: make PageMappingFlags return bool
Date: Thu, 21 Mar 2024 11:07:12 +0800

Make PageMappingFlags() return bool like folio_mapping_flags().

Link: https://lkml.kernel.org/r/20240321030712.80618-1-gehao@kylinos.cn
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/page-flags.h~mm-page-flags-make-pagemappingflags-return-bool
+++ a/include/linux/page-flags.h
@@ -686,7 +686,7 @@ static __always_inline bool folio_mappin
 	return ((unsigned long)folio->mapping & PAGE_MAPPING_FLAGS) != 0;
 }
 
-static __always_inline int PageMappingFlags(const struct page *page)
+static __always_inline bool PageMappingFlags(const struct page *page)
 {
 	return ((unsigned long)page->mapping & PAGE_MAPPING_FLAGS) != 0;
 }
_

Patches currently in -mm which might be from gehao@kylinos.cn are

mm-page-flags-make-__pagemovable-return-bool.patch
mm-page-flags-make-pagemappingflags-return-bool.patch

