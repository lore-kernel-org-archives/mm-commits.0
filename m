Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF72836EA84
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027645; cv=none; b=DhMpVgQSb3OGlMO9XrSkVVgdKsZz5D4q51iHKA+Wrhreblqobby4b5d8OGo9ypdH4JuB1eZPDVMP43k/CXLB1kSANORm6UtmpfmTM0+scGUqyXu8lohLTso/rLVwFxxO3GuZEEV3zoaTUF1M+uEhh4mHJC7ECkshCSe9V2s+6/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027645; c=relaxed/simple;
	bh=gL4yG+pgmUkg/fM+c2BlTYuFtNs21zwyogVWnEiutZ8=;
	h=Date:To:From:Subject:Message-Id; b=YyDoeIW5henvUhA9j54xWRxfbt+onNv7QeNRJ9b2Ers9nMgsXRIZm91nap2ty/XKCN+Xf85A8iRMwkd8a6D9hAnlA651aFt8No7tzTGnbxhnTEObVpb/JbPmin8sy6yX6DI4QO0oRSXIcwR2ZtFdO9haT+iHlzxD8RrQVNYSAjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u3eb25eO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u3eb25eO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C451E1F00898;
	Fri, 29 May 2026 04:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027643;
	bh=ZzjoCjubEgd6tyDruOxPqZEMvu13RYJNQCESaFLvhk8=;
	h=Date:To:From:Subject;
	b=u3eb25eOlPtyKZSTjJ87XR+/IE7/ErIHTAkrV/ayEjT87J/7mRLRYmPfm1cI1TR4e
	 318WJOMB/Iq49zJFBbNkCk7hOqGAdf/m1H64YQXml93GSXeO88tOe1JOWqQTu9VIqS
	 TYrJ41PDsKsFoMuooD/Y0U/+86RULcqpTf9+CO3c=
Date: Thu, 28 May 2026 21:07:23 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,gutierrez.asier@huawei-partners.com,david@kernel.org,corbet@lwn.net,aethernet65535@gmail.com,hank20010209@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-fix-parametrs-typo.patch removed from -mm tree
Message-Id: <20260529040723.C451E1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon: fix 'parametrs' typo
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-fix-parametrs-typo.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Cheng-Han Wu <hank20010209@gmail.com>
Subject: Docs/admin-guide/mm/damon: fix 'parametrs' typo
Date: Sun, 26 Apr 2026 16:16:15 -0700

Fix the misspelling of "parametrs" as "parameters" in reclaim.rst and
lru_sort.rst.

Link: https://lore.kernel.org/20260426231619.107231-3-sj@kernel.org
Signed-off-by: Cheng-Han Wu <hank20010209@gmail.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/lru_sort.rst |    2 +-
 Documentation/admin-guide/mm/damon/reclaim.rst  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/mm/damon/lru_sort.rst~docs-admin-guide-mm-damon-fix-parametrs-typo
+++ a/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -75,7 +75,7 @@ Make DAMON_LRU_SORT reads the input para
 
 Input parameters that updated while DAMON_LRU_SORT is running are not applied
 by default.  Once this parameter is set as ``Y``, DAMON_LRU_SORT reads values
-of parametrs except ``enabled`` again.  Once the re-reading is done, this
+of parameters except ``enabled`` again.  Once the re-reading is done, this
 parameter is set as ``N``.  If invalid parameters are found while the
 re-reading, DAMON_LRU_SORT will be disabled.
 
--- a/Documentation/admin-guide/mm/damon/reclaim.rst~docs-admin-guide-mm-damon-fix-parametrs-typo
+++ a/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -67,7 +67,7 @@ Make DAMON_RECLAIM reads the input param
 
 Input parameters that updated while DAMON_RECLAIM is running are not applied
 by default.  Once this parameter is set as ``Y``, DAMON_RECLAIM reads values
-of parametrs except ``enabled`` again.  Once the re-reading is done, this
+of parameters except ``enabled`` again.  Once the re-reading is done, this
 parameter is set as ``N``.  If invalid parameters are found while the
 re-reading, DAMON_RECLAIM will be disabled.
 
_

Patches currently in -mm which might be from hank20010209@gmail.com are


