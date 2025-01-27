Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA34453BE
	for <mm-commits@vger.kernel.org>; Mon, 27 Jan 2025 20:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738008572; cv=none; b=Mfhmu0GgEU5HxIelSYfY6oIrxePDeRE5UYMH68uRAhXUlZxPQGkkncGjrdc6UUi28hOUTNKfB1riMszmHJcrVpuO5IKJYgiyDSE4IOViC0kNViW6wuWMNrA1GOa4rgL4+alDwwztaFWdxykySuedLAdDiPjwvwB2S96WyDIQoxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738008572; c=relaxed/simple;
	bh=/aUH3GNazQcuCaW0/WZXVxW8Yl0qnmUAeYQe/9NnnKY=;
	h=Date:To:From:Subject:Message-Id; b=QzlE1mlmsWCfdajwMBNxQ195xyGCtjStowsOqOMXVdyB5QibPJgAm//cnEGw9uTPCUdL+mQVlnJRyk2MHxYiUl6zFj1oakqUd7o4X7Le8BpLT5W1pdnOp2/rvAGlWZajivWoq50aR0VgxJoJhZZsnpiKM5ZuH/VzHuQEA0cvndE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ogIi3Hvm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ogIi3Hvm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37153C4CED2;
	Mon, 27 Jan 2025 20:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738008571;
	bh=/aUH3GNazQcuCaW0/WZXVxW8Yl0qnmUAeYQe/9NnnKY=;
	h=Date:To:From:Subject:From;
	b=ogIi3HvmpYA5szO30a4YZlS8aXL0wpNQiXKsQlw2rCJ2C6Uu8pjtkCiLwgI0jZHbM
	 8KCUSojsg3MvRCXTGOgBqeL7CQFG5n2zMqoifhgEdzhkyDPocIzPAJOWfas01zsxm4
	 e+ZXutc7bxpJrCLFZiXUdLW/yK5EGH3Ni/RzGWqg=
Date: Mon, 27 Jan 2025 12:09:30 -0800
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,lkp@intel.com,alexs@kernel.org,42.hyeyoo@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-add-__maybe_unused-attribute-for-is_first_zpdesc.patch added to mm-hotfixes-unstable branch
Message-Id: <20250127200931.37153C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zsmalloc: add __maybe_unused attribute for is_first_zpdesc()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-zsmalloc-add-__maybe_unused-attribute-for-is_first_zpdesc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-add-__maybe_unused-attribute-for-is_first_zpdesc.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Subject: mm/zsmalloc: add __maybe_unused attribute for is_first_zpdesc()
Date: Tue, 28 Jan 2025 08:16:31 +0900

Commit c1b3bb73d55e ("mm/zsmalloc: use zpdesc in
trylock_zspage()/lock_zspage()") introduces is_first_zpdesc() function. 
However, the function is only used when CONFIG_DEBUG_VM=y.

When building with LLVM=1 and W=1 option, the following warning is
generated:
  $ make -j12 W=1 LLVM=1 mm/zsmalloc.o
  mm/zsmalloc.c:455:20: error: function 'is_first_zpdesc' is not needed and will not be emitted [-Werror,-Wunneeded-internal-declaration]
    455 | static inline bool is_first_zpdesc(struct zpdesc *zpdesc)
        |                    ^~~~~~~~~~~~~~~
  1 error generated.

Fix the warning by adding __maybe_unused attribute to the function.
No functional change intended.

Link: https://lkml.kernel.org/r/20250127231631.4363-1-42.hyeyoo@gmail.com
Fixes: c1b3bb73d55e ("mm/zsmalloc: use zpdesc in trylock_zspage()/lock_zspage()")
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202501240958.4ILzuBrH-lkp@intel.com/
Cc: Alex Shi <alexs@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-add-__maybe_unused-attribute-for-is_first_zpdesc
+++ a/mm/zsmalloc.c
@@ -452,7 +452,7 @@ static DEFINE_PER_CPU(struct mapping_are
 	.lock	= INIT_LOCAL_LOCK(lock),
 };
 
-static inline bool is_first_zpdesc(struct zpdesc *zpdesc)
+static inline bool __maybe_unused is_first_zpdesc(struct zpdesc *zpdesc)
 {
 	return PagePrivate(zpdesc_page(zpdesc));
 }
_

Patches currently in -mm which might be from 42.hyeyoo@gmail.com are

mm-zsmalloc-add-__maybe_unused-attribute-for-is_first_zpdesc.patch

