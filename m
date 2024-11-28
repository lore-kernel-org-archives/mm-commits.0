Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30CD1D554;
	Thu, 28 Nov 2024 00:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732755579; cv=none; b=gqpg6HQaCcZGJzuZXPbVeUtptbJXtin958QllQpDwhaQ/aUkkweSZHdMGV8ou/jsvIaWULm+nGavB5rSTO2rgHjcyVPI10GXsV9wRSM4d3lJaOx5WAXhn16qWDcInv6YvN/OQr769rpkWSIGa2FsTTPnJimiVGmdBvn6U2qBhI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732755579; c=relaxed/simple;
	bh=O68VrLMfK/muz5lE4IiM1vnuC+7/pnHzlNc2ezBIDIc=;
	h=Date:To:From:Subject:Message-Id; b=NzO4HRt3AKgQprjLhgusSsLri8OPLGlybVEOBU2c0K0vRaQ56o5FHPTkjgjKRUyt8x6yC6gDpRSGrtAaO3aXhfRbzbxngGbwSGs2dIp826RTGy8t4ETFNqfJWcJ1+bNlKBcoGMoECZDpGxCuPR9mllAhU6hW0ZfF71M7tIESq4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rXGpGVnL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rXGpGVnL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F023C4CECC;
	Thu, 28 Nov 2024 00:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732755578;
	bh=O68VrLMfK/muz5lE4IiM1vnuC+7/pnHzlNc2ezBIDIc=;
	h=Date:To:From:Subject:From;
	b=rXGpGVnLMxiK0qU9y4c1QkTVO/i+rkdYF5DyM0Ov+qhJHF/ty0pDeRlW85kpBFEX/
	 d9jQp14wLoYthHv3ZnoHV7wLeJc5tNmwItQfN/4xStUj8G+okoAwDqJI5QNs8b2O2d
	 Zx/g5b75I+XLxWEhAazOpS+4jStv2Yjr24alOZPo=
Date: Wed, 27 Nov 2024 16:59:37 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,urezki@gmail.com,stable@vger.kernel.org,mhocko@suse.com,hch@infradead.org,ast@kernel.org,andrii@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-vreallocs-kasan-poisoning-logic.patch added to mm-hotfixes-unstable branch
Message-Id: <20241128005938.4F023C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix vrealloc()'s KASAN poisoning logic
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-vreallocs-kasan-poisoning-logic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-vreallocs-kasan-poisoning-logic.patch

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
From: Andrii Nakryiko <andrii@kernel.org>
Subject: mm: fix vrealloc()'s KASAN poisoning logic
Date: Mon, 25 Nov 2024 16:52:06 -0800

When vrealloc() reuses already allocated vmap_area, we need to re-annotate
poisoned and unpoisoned portions of underlying memory according to the new
size.

Note, hard-coding KASAN_VMALLOC_PROT_NORMAL might not be exactly correct,
but KASAN flag logic is pretty involved and spread out throughout
__vmalloc_node_range_noprof(), so I'm using the bare minimum flag here and
leaving the rest to mm people to refactor this logic and reuse it here.

Link: https://lkml.kernel.org/r/20241126005206.3457974-1-andrii@kernel.org
Fixes: 3ddc2fefe6f3 ("mm: vmalloc: implement vrealloc()")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-fix-vreallocs-kasan-poisoning-logic
+++ a/mm/vmalloc.c
@@ -4093,7 +4093,8 @@ void *vrealloc_noprof(const void *p, siz
 		/* Zero out spare memory. */
 		if (want_init_on_alloc(flags))
 			memset((void *)p + size, 0, old_size - size);
-
+		kasan_poison_vmalloc(p + size, old_size - size);
+		kasan_unpoison_vmalloc(p, size, KASAN_VMALLOC_PROT_NORMAL);
 		return (void *)p;
 	}
 
_

Patches currently in -mm which might be from andrii@kernel.org are

mm-fix-vreallocs-kasan-poisoning-logic.patch

