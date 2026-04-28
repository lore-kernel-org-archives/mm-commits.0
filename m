Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC9642314A
	for <mm-commits@vger.kernel.org>; Tue, 28 Apr 2026 14:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777385371; cv=none; b=VdCzzwOsna9XXTtJGt+c3PgUpczQ5LSQo3LOMzg1fIsBTELj6giT7iHjzscTXyZTo6Ev699orGAA7rxVqnCnM99hiVUYzIXCUbL9RJZIGgNnNWv43E74bk9hc3vYwujpIq+sMFcQ9MKXemVg6lQEQZmrlbc1Qd61OCa+Wq2QYHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777385371; c=relaxed/simple;
	bh=SyD7Rjcw6kVud7FIGBmYAefY4BsZ3vry/dSoHbdain8=;
	h=Date:To:From:Subject:Message-Id; b=S+9OwIsIZWa7qRaLw7sDiJyXzB+uLx7cSizTvXxZ9/XuVPY5utJmXwPrkiciZmUvF6O/7ttt8DhTM59wPB5CKHUyyXs2rmCSo9MRt6AvRst0mIh8lAz+RxK795yYimNhPYTDHeNz1GFFtvC8Ewa+oWezy0ED3TZoBe1OnW5PZUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IYArrE6J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IYArrE6J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2F0C2BCAF;
	Tue, 28 Apr 2026 14:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777385371;
	bh=SyD7Rjcw6kVud7FIGBmYAefY4BsZ3vry/dSoHbdain8=;
	h=Date:To:From:Subject:From;
	b=IYArrE6Ja+wT9iEGToVGe8EfsrnbyLxnEPqDsYdHccGPbN5tb86kuZt+moOEYOIQy
	 mtA7UjLyO1MI+E7sub6ZKRHl6gBGRt4xaA8fFKFR3zFFRLsmoZ/0fhfvL3Csmckfw+
	 U8SyVKDZSUGA8f+4lUnJV4QVJ+j7X/fy3ZWJVMCI=
Date: Tue, 28 Apr 2026 07:09:31 -0700
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_owner-add-numa-node-filter-with-nodelist-support-fix.patch removed from -mm tree
Message-Id: <20260428140931.9C2F0C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-page_owner-add-numa-node-filter-with-nodelist-support-fix
has been removed from the -mm tree.  Its filename was
     mm-page_owner-add-numa-node-filter-with-nodelist-support-fix.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_owner-add-numa-node-filter-with-nodelist-support-fix
Date: Fri Apr 24 01:08:46 PM PDT 2026

remove READ_ONCE/WRITE_ONCE of nodemask_t

It triggers compile-time assertions.

Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zhen Ni <zhen.ni@easystack.cn>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-add-numa-node-filter-with-nodelist-support-fix
+++ a/mm/page_owner.c
@@ -732,7 +732,7 @@ read_page_owner(struct file *file, char
 			continue;
 
 		/* NUMA node filter using bitmask */
-		mask = READ_ONCE(owner_filter.nid_mask);
+		mask = owner_filter.nid_mask;
 		if (!nodes_empty(mask)) {
 			int nid = page_to_nid(page);
 
@@ -1049,7 +1049,7 @@ static ssize_t nid_filter_write(struct f
 		goto out_free;
 	}
 
-	WRITE_ONCE(owner_filter.nid_mask, mask);
+	owner_filter.nid_mask = mask;
 	ret = count;
 
 out_free:
@@ -1059,7 +1059,7 @@ out_free:
 
 static int nid_filter_show(struct seq_file *m, void *v)
 {
-	nodemask_t mask = READ_ONCE(owner_filter.nid_mask);
+	nodemask_t mask = owner_filter.nid_mask;
 
 	if (nodes_empty(mask))
 		seq_puts(m, "-1\n");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free-fix.patch
include-asm-generic-fixmaph-reimplement-nasty-macros-in-c.patch
include-asm-generic-fixmaph-reimplement-nasty-macros-in-c-fix.patch
include-asm-generic-fixmaph-reimplement-nasty-macros-in-c-fix-fix.patch
proc-rewrite-next_tgid-fix.patch

