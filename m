Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B2117F39B
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 19:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719345269; cv=none; b=dJ4x0FRS+oD9YytSmGg8QTGMbkP9wrLp9dHpy3CcCtZ0V7kai24QPEluiQ5jKnGZ4rohWWabxqIxsHjcTNeT/5qwI6A1fDeIjyX/8kTWNEx2NoxO2whoFghQLJr3d84oZpELW+ZdpQg80XPzkzMtalGrnkvXDDHpdz9nUpX/4cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719345269; c=relaxed/simple;
	bh=hozZ8Hc8FcEVx6LDVJzdeM5driYR9X/OKts1i8emZFg=;
	h=Date:To:From:Subject:Message-Id; b=OYeJx/85C69/yFQX+6HTortaBcDY/ylISSAVagY70NIDGtMARpZ+XwcKjrRo/XvLk08nzwoo0+o+V9EWDJqvepvb5JYgnbZZFvbfvDW7U0goPoajkWl4GDSniw2nGxbs64rkXI94hJYKs3QT7qCHKIy56codzBj33fAdVW9Ma8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hHDy/kUv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hHDy/kUv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65DE4C4DDF7;
	Tue, 25 Jun 2024 19:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719345268;
	bh=hozZ8Hc8FcEVx6LDVJzdeM5driYR9X/OKts1i8emZFg=;
	h=Date:To:From:Subject:From;
	b=hHDy/kUvmy8w5PFuFTG9rEBIW650XjWlwxc9FzdAS5ZLvVV79TrTHeE7amPt3/yDu
	 XENCmH5Gh8vAMpxdnO/YGcEdB/nRkiw8+UuT5/K14zBSXRCXMR7xBJjoZfmhpvEONV
	 nmFgcAhvpyol5hKPFMC0amEzttZihLYSjthA8768=
Date: Tue, 25 Jun 2024 12:54:27 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,lizhenneng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] migrate_pages-modify-max-number-of-pages-to-migrate-in-batch.patch removed from -mm tree
Message-Id: <20240625195428.65DE4C4DDF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: migrate_pages: modify max number of pages to migrate in batch
has been removed from the -mm tree.  Its filename was
     migrate_pages-modify-max-number-of-pages-to-migrate-in-batch.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Zhenneng Li <lizhenneng@kylinos.cn>
Subject: migrate_pages: modify max number of pages to migrate in batch
Date: Mon, 24 Jun 2024 12:51:20 +0800

We restrict the number of pages to be migrated to no more than
HPAGE_PMD_NR or NR_MAX_BATCHED_MIGRATION, but in fact, the number of pages
to be migrated may reach 2*HPAGE_PMD_NR-1 or 2
*NR_MAX_BATCHED_MIGRATION-1, it's not in inconsistent with the context.

Please refer to commit 42012e0436d4 ("migrate_pages: restrict number of
pages to migrate in batch").

Link: https://lkml.kernel.org/r/20240624045120.121261-1-lizhenneng@kylinos.cn
Signed-off-by: Zhenneng Li <lizhenneng@kylinos.cn>
Cc: "Huang, Ying" <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~migrate_pages-modify-max-number-of-pages-to-migrate-in-batch
+++ a/mm/migrate.c
@@ -1961,7 +1961,7 @@ again:
 			break;
 	}
 	if (nr_pages >= NR_MAX_BATCHED_MIGRATION)
-		list_cut_before(&folios, from, &folio2->lru);
+		list_cut_before(&folios, from, &folio->lru);
 	else
 		list_splice_init(from, &folios);
 	if (mode == MIGRATE_ASYNC)
_

Patches currently in -mm which might be from lizhenneng@kylinos.cn are


