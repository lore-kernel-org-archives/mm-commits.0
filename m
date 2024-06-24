Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF73847A64
	for <mm-commits@vger.kernel.org>; Mon, 24 Jun 2024 22:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719269558; cv=none; b=uQ5+h8LkaLZDsm0zyU7etxbiene8pl1uIHT/neMtSGPW8bcr9SkB4FachPdoV9r3prmSs989wuERL4Y23a1pCjasAa4JfPuJf5oIpfP8d+2jYS/9lK2+y8UDDvfJ2FS4fcuelZ1m7qcSgVq4i40KbCtEmxXJw/QZQYqgBRoO7UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719269558; c=relaxed/simple;
	bh=G6BxaiYxTake+c30rzEXo+db0Oe7OQxLVYvotcqP904=;
	h=Date:To:From:Subject:Message-Id; b=Jz5Poo1gCGdS/5BdjF7Jx7e5XgFkYF1/ZKo5OZEuEKJ6K7nX7Mk72Ap/A3s8ef3LdFQI0IcPC3Z33MicfIvzkGhofwoDxZtjWQRQlVihxj6TNp5oPxnCr4rUmszwJNZKjFQVHflMn79vz0wVhNQPSvhXygaO6/3alyFWZTgb4mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yF7ShTah; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yF7ShTah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 343CDC2BBFC;
	Mon, 24 Jun 2024 22:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719269558;
	bh=G6BxaiYxTake+c30rzEXo+db0Oe7OQxLVYvotcqP904=;
	h=Date:To:From:Subject:From;
	b=yF7ShTahBVUmtFNqKsyrDPX5OBHCBy79r/9taGbmyp/2UgQjFt/G/5+XXnC2QeQK4
	 jTZWdZsH4mBpuBWvqoRJRu2rijHhbzS264z0hDrwFwtrvvUSgaoR3+G+e4vgmNKkU9
	 nXWuPhxw105S59pTRToxAxnUNms2Kdp+fsslsyRA=
Date: Mon, 24 Jun 2024 15:52:37 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,lizhenneng@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + migrate_pages-modify-max-number-of-pages-to-migrate-in-batch.patch added to mm-unstable branch
Message-Id: <20240624225238.343CDC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: migrate_pages: modify max number of pages to migrate in batch
has been added to the -mm mm-unstable branch.  Its filename is
     migrate_pages-modify-max-number-of-pages-to-migrate-in-batch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/migrate_pages-modify-max-number-of-pages-to-migrate-in-batch.patch

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

migrate_pages-modify-max-number-of-pages-to-migrate-in-batch.patch

