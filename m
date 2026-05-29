Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BA136F8EF
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027607; cv=none; b=rXSgaeUgAT2LKfMo9gqpdKzM0Ok7m0xu0BzE2mhLqchVkofu/XNgy5UJ9CMix0Fmst/iS0uR/tg1+hcQXFpnDrrgYbw1f/SFUQjfZFN4M5FrQo4uH5lTt/tB6GbFxzeMUOM9+Wu4Hoc5eeu5KZg0PNIfCsPJ9QTlqmN4MTBPAqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027607; c=relaxed/simple;
	bh=k25e73GYTiR9LQRjfGYv64rF9E3QiWgOfqCm8iDUPq8=;
	h=Date:To:From:Subject:Message-Id; b=bJmY+npoVcD63RP7uVdo1vcz7tkPJGnuBct1NkX1s3ZifmOA3jmKwlQSOYd4YyD5fGnWVn9nGuhNET/a7GRbHx6OxXDXBCnXLgcn3IRGYtZr4h41HDlvV/BrA4wQOgEVUMoSfGW1rhVpqdfDls1yz1OZSHM27dti+9Sag/vi0Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jBcP7r+p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jBcP7r+p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3AB1F00893;
	Fri, 29 May 2026 04:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027605;
	bh=DWdip5E59QKZ4W+qXbHUb00hiQpkrlNktrlNtDjtjao=;
	h=Date:To:From:Subject;
	b=jBcP7r+pqgEtpoEld66821O2zphfB2S1Jxju/Nb0DFQi/cmWmVLFL/5Ns2u6Lm/DM
	 svJsCiSGbu3oTGWmCbIPiSyvNncbhYsQeBGKUNjdrMW4/LN3MoBZCvjIJb+UV5LWYj
	 wd6zeCTQq4UzVzuiqD/DNvQDnUp0ueIJZ0CrUeUs=
Date: Thu, 28 May 2026 21:06:45 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,zhen.ni@easystack.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_owner-fix-%pgp-format-specifier-argument-type.patch removed from -mm tree
Message-Id: <20260529040645.CC3AB1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_owner: fix %pGp format specifier argument type
has been removed from the -mm tree.  Its filename was
     mm-page_owner-fix-%pgp-format-specifier-argument-type.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhen Ni <zhen.ni@easystack.cn>
Subject: mm/page_owner: fix %pGp format specifier argument type
Date: Tue, 14 Apr 2026 15:58:13 +0800

The %pGp format specifier expects an argument of type 'unsigned long *',
but page->flags is now of type 'memdesc_flags_t' (a struct containing an
unsigned long member 'f') after the introduction of memdesc_flags_t.

Fix the type mismatch by passing &page->flags.f instead of &page->flags,
which matches the expected type.

Link: https://lore.kernel.org/20260414075813.3425968-1-zhen.ni@easystack.cn
Fixes: 53fbef56e07d ("mm: introduce memdesc_flags_t")
Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_owner.c~mm-page_owner-fix-%pgp-format-specifier-argument-type
+++ a/mm/page_owner.c
@@ -573,7 +573,7 @@ print_page_owner(char __user *buf, size_
 			migratetype_names[page_mt],
 			pfn >> pageblock_order,
 			migratetype_names[pageblock_mt],
-			&page->flags);
+			&page->flags.f);
 
 	ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
 	if (ret >= count)
_

Patches currently in -mm which might be from zhen.ni@easystack.cn are


