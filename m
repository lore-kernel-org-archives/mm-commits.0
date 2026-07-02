Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED4B2773EC
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 02:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782957816; cv=none; b=S0qVloGvq90gNVxT8NyRHieqdiZVUnt3YeRRzQc84UYAlW+P3q/wmzuRv2GcFWIZoWbfv4dSsBmfBlAF5rIstMtQ+7OR/PJRMY3A8aL20fFTtzc1DGgAN4IUS0cGgZZuMXCbGCFkjL5LbcIsT2BT3irsBu+0fnpYmUjW9i9eWKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782957816; c=relaxed/simple;
	bh=1e78mf9hvtgjggbFSXGThIglXiNazzSztM5857lRZzM=;
	h=Date:To:From:Subject:Message-Id; b=ud51gvyY5VOfP0KoQf8jN5/0ja+jUkHAypinf3htyMXeSSCQltXOmaCHiMZ7/Jsl+vHQlu3irfIOjO4A/3LFBQVwQ9s1hIsNBmMsWkN3MMUts96PlnWexCFUgcXuu5Xp1hAjI0hNz9xBl4NlvxtxF1Vy+Ra4CCylj7rznWAeXeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Qpea83lS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Qpea83lS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC27D1F00A3A;
	Thu,  2 Jul 2026 02:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782957814;
	bh=wRUq3PRwbyZA8LR+7emViY3L0XQBk5/0jV+wrmuW7zE=;
	h=Date:To:From:Subject;
	b=Qpea83lSWv8Hox1ix5XP42c3mHt9mP39I1iqYfqD4vbhNEuWYJB8s+x3nWVT2OLZv
	 10PVSs/tAIFpch0/k1JuyHKBsIVKB6c77tHaY6QYAqPQsnL/N8YYlgKiEUIIK2kK68
	 l7KZ7KkpM6ZzRPCP5/ppAtAQIdn0jg6GvtnkLmPs=
Date: Wed, 01 Jul 2026 19:03:34 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,sj@kernel.org,riel@surriel.com,liam@infradead.org,lance.yang@linux.dev,jannh@google.com,harry@kernel.org,dev.jain@arm.com,david@kernel.org,baohua@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-lance-as-an-rmap-reviewer.patch removed from -mm tree
Message-Id: <20260702020334.CC27D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add Lance as an rmap reviewer
has been removed from the -mm tree.  Its filename was
     maintainers-add-lance-as-an-rmap-reviewer.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: MAINTAINERS: add Lance as an rmap reviewer
Date: Mon, 22 Jun 2026 16:59:13 +0100

Lance has been doing excellent work reviewing rmap series and has proven
himself to be a great member of the community in general, so add him as an
rmap reviewer.

Link: https://lore.kernel.org/20260622155913.280355-1-ljs@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: SeongJae Park <sj@kernel.org>
Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
Acked-by: Dev Jain <dev.jain@arm.com>
Acked-by: Barry Song <baohua@kernel.org>
Acked-by: Lance Yang <lance.yang@linux.dev>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-lance-as-an-rmap-reviewer
+++ a/MAINTAINERS
@@ -17205,6 +17205,7 @@ R:	Liam R. Howlett <liam@infradead.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Harry Yoo <harry@kernel.org>
 R:	Jann Horn <jannh@google.com>
+R:	Lance Yang <lance.yang@linux.dev>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	include/linux/rmap.h
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-move-alloc-tag-to-mm.patch

