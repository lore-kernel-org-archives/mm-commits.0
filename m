Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28ABD2BE636;
	Tue, 21 Oct 2025 22:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761086820; cv=none; b=L9w0K/Q7WjBsoP39ejmUo2QIfywtv+DPjj/F5I342Tf4hxIDQtacbe1QVH//TGMaldi6HW+WtggQwCu6zJx64OioaKnleuI5RB6rb65vZnbg8ATBZrTVloEat7jNyR8zGJ3xaB3+Z1KVxLHMEX9fcikFE3UQEWZoZnn27Slkt5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761086820; c=relaxed/simple;
	bh=l2GkWEFTS3t8kI2a4r+Boo5pB5vyH1ikZd1lB18+zIs=;
	h=Date:To:From:Subject:Message-Id; b=BHJPSE3aCXLVtFtr7IWg0zclRjbx3hkG9UZC/hkM00Gtin2A5dE8ncI/NGV2YF4i3UtD9vRGEplBG8NmrU/wTOEXOpZX91COCRY9nRoOtaE6WhJabpaLR/MFdEElLC5RooibGKjkkfJfHGE4k6lJWUu6UhG3+5qz0qLkTNtQp6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uAjXibi+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uAjXibi+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A80AC4CEF1;
	Tue, 21 Oct 2025 22:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761086819;
	bh=l2GkWEFTS3t8kI2a4r+Boo5pB5vyH1ikZd1lB18+zIs=;
	h=Date:To:From:Subject:From;
	b=uAjXibi+brwR66NH0a+04xrFZnRk6kt5aJro4Qo4IE52HRyEfjWkJ9kRisbSBOtqB
	 ZmzD7ILAxKiV3NbR3k66JvL+I9X9pFI31F2ffDc2hgic2jQkApGOnVrpRaLGYSoP0N
	 Hx3S6fe003DnAtWv0mhI2CtA/aNLd4Lo9X4tg35c=
Date: Tue, 21 Oct 2025 15:46:58 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,lienze@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-core-fix-potential-memory-leak-by-cleaning-ops_filter-in-damon_destroy_scheme.patch removed from -mm tree
Message-Id: <20251021224659.8A80AC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: fix potential memory leak by cleaning ops_filter in damon_destroy_scheme
has been removed from the -mm tree.  Its filename was
     mm-damon-core-fix-potential-memory-leak-by-cleaning-ops_filter-in-damon_destroy_scheme.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Enze Li <lienze@kylinos.cn>
Subject: mm/damon/core: fix potential memory leak by cleaning ops_filter in damon_destroy_scheme
Date: Tue, 14 Oct 2025 16:42:25 +0800

Currently, damon_destroy_scheme() only cleans up the filter list but
leaves ops_filter untouched, which could lead to memory leaks when a
scheme is destroyed.

This patch ensures both filter and ops_filter are properly freed in
damon_destroy_scheme(), preventing potential memory leaks.

Link: https://lkml.kernel.org/r/20251014084225.313313-1-lienze@kylinos.cn
Fixes: ab82e57981d0 ("mm/damon/core: introduce damos->ops_filters")
Signed-off-by: Enze Li <lienze@kylinos.cn>
Reviewed-by: SeongJae Park <sj@kernel.org>
Tested-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-fix-potential-memory-leak-by-cleaning-ops_filter-in-damon_destroy_scheme
+++ a/mm/damon/core.c
@@ -452,6 +452,9 @@ void damon_destroy_scheme(struct damos *
 	damos_for_each_filter_safe(f, next, s)
 		damos_destroy_filter(f);
 
+	damos_for_each_ops_filter_safe(f, next, s)
+		damos_destroy_filter(f);
+
 	kfree(s->migrate_dests.node_id_arr);
 	kfree(s->migrate_dests.weight_arr);
 	damon_del_scheme(s);
_

Patches currently in -mm which might be from lienze@kylinos.cn are


