Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591431428E8
	for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2024 20:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710274189; cv=none; b=QVTSANvxwMu++crS1LYge4wdkAf4CNRHbzHaU1z/lzUcK3g2BtNc0TVARK4yPtS5B49GFwslNs7IO/jyPy3VqVBiiq9ib65UReNYI+BtFsh/4tzWoFxTjxDn6kkCPZf+p95ut5cQVR9OGH2e7iKQsw/W+zmQxmu5sZzNEdkYy8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710274189; c=relaxed/simple;
	bh=wcNwugq2yyzJrDQLoJ/kwS4VeTuoCKEgHH4pGbN8jkg=;
	h=Date:To:From:Subject:Message-Id; b=a5NgC7qg9zhJKJ4QXK+jOy76xJ++2/ZZwdLvTjuMU8axq1cBdbJNzn7CRwXaEDCjPIuqqnohO/0joWQudQCGUBYo4r4tpChYHAdmHOsCZAOghe1C4BO1ER+LK8FcOES8T9hU+LMrbzyjFTsJ1l3nuywOcDSIDf0CqSzuRJSvQiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TOCICpbw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TOCICpbw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8FABC43394;
	Tue, 12 Mar 2024 20:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710274189;
	bh=wcNwugq2yyzJrDQLoJ/kwS4VeTuoCKEgHH4pGbN8jkg=;
	h=Date:To:From:Subject:From;
	b=TOCICpbwhX95qLLdq/KCOaEj92PexiTBqAf3Ilsja2wv6n0nibPnkZGCWh93lqH0F
	 v1vgGELlixGk5mJ8p1134hlJDLjzCB1p/R22BISflwDypg/1WVSsWUSzXJ7Enb15E0
	 yXqcMgr6bVbN6+rVmo1WN1T4AclYnjfPVoIqMMK8=
Date: Tue, 12 Mar 2024 13:09:48 -0700
To: mm-commits@vger.kernel.org,s.shtylyov@omp.ru,r.smirnov@omp.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] assoc_array-fix-the-return-value-in-assoc_array_insert_mid_shortcut.patch removed from -mm tree
Message-Id: <20240312200948.E8FABC43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: assoc_array: fix the return value in assoc_array_insert_mid_shortcut()
has been removed from the -mm tree.  Its filename was
     assoc_array-fix-the-return-value-in-assoc_array_insert_mid_shortcut.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Roman Smirnov <r.smirnov@omp.ru>
Subject: assoc_array: fix the return value in assoc_array_insert_mid_shortcut()
Date: Thu, 7 Mar 2024 10:17:17 +0300

Returning the edit variable is redundant because it is dereferenced right
before it is returned.  It would be better to return true.

Found by Linux Verification Center (linuxtesting.org) with Svace.

Link: https://lkml.kernel.org/r/20240307071717.5318-1-r.smirnov@omp.ru
Signed-off-by: Roman Smirnov <r.smirnov@omp.ru>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/assoc_array.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/assoc_array.c~assoc_array-fix-the-return-value-in-assoc_array_insert_mid_shortcut
+++ a/lib/assoc_array.c
@@ -938,7 +938,7 @@ static bool assoc_array_insert_mid_short
 		edit->leaf_p = &new_n0->slots[0];
 
 	pr_devel("<--%s() = ok [split shortcut]\n", __func__);
-	return edit;
+	return true;
 }
 
 /**
_

Patches currently in -mm which might be from r.smirnov@omp.ru are


