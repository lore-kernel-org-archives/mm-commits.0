Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2D225A321
	for <mm-commits@vger.kernel.org>; Sun, 28 Sep 2025 18:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759085549; cv=none; b=qcLAEhjrZLCrc8VmDoHwjSkg3p6zof1ooosFj+ZSqJdXExlW+KD1XUhulmvH5Y6MrvVwJFLGKp2jxtsbO5vm0KMck8pwo11Ju54Tvybb6TzKVXGwPSyPmykKTHu0ZBhlpJ8kYGpux2pNxoEmhcNlAt3L3SdjjJZtXwgvMzGJhn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759085549; c=relaxed/simple;
	bh=2JvHQ4Bz6GtxAzLV2AD8wCcs9WwYz4rQBW1NlwybAxs=;
	h=Date:To:From:Subject:Message-Id; b=fahcpPeMOy+YWi7zOp0/ctr/zprxnu7G9wUtsU+/rHq9VOWaqCY2nrSSGTzDIHS8wKgV6CBWqNIBfJTR7TmAOL95Y2CCQ8jQlxauWY+GvsJ0hUNDSA14iBlHfc+5xn4NEagL6Y29jJwRzaAOdoaLLsJCauWCmSGa7w1MrVvxUPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IQm+UUGg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IQm+UUGg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17029C4CEF0;
	Sun, 28 Sep 2025 18:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759085549;
	bh=2JvHQ4Bz6GtxAzLV2AD8wCcs9WwYz4rQBW1NlwybAxs=;
	h=Date:To:From:Subject:From;
	b=IQm+UUGgiAj6826TandQ/AFoIKq1vxPEZToKAJryHuV+TzVwdC45jqmwhYKf9qGrJ
	 1NleX+drJ17urGqzovXFdNxU7YWpUpEnvY2c/kHL5vW9/5zaKnfTNBXKQC5eMUMyRJ
	 dFM3H5Lfbqf3f+jjGjvUMJMM06Qw0RZ1vXlFSwoo=
Date: Sun, 28 Sep 2025 11:52:28 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,nao.horiguchi@gmail.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,liam.howlett@oracle.com,david@redhat.com,anshuman.khandual@arm.com,xieyuanbin1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-not-select-memory_isolation.patch removed from -mm tree
Message-Id: <20250928185229.17029C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: don't select MEMORY_ISOLATION
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-not-select-memory_isolation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xie Yuanbin <xieyuanbin1@huawei.com>
Subject: mm/memory-failure: don't select MEMORY_ISOLATION
Date: Mon, 22 Sep 2025 22:36:18 +0800

We added that "select MEMORY_ISOLATION" in commit ee6f509c3274 ("mm:
factor out memory isolate functions").  However, in commit add05cecef80
("mm: soft-offline: don't free target page in successful page migration")
we remove the need for it, where we removed the calls to
set_migratetype_isolate() etc.

What CONFIG_MEMORY_FAILURE soft-offline support wants is migrate_pages()
support.  But that comes with CONFIG_MIGRATION.  And
isolate_folio_to_list() has nothing to do with CONFIG_MEMORY_ISOLATION.

Therefore, we can remove "select MEMORY_ISOLATION" of MEMORY_FAILURE.

Link: https://lkml.kernel.org/r/20250922143618.48640-1-xieyuanbin1@huawei.com
Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/Kconfig~mm-memory-failure-not-select-memory_isolation
+++ a/mm/Kconfig
@@ -748,7 +748,6 @@ config MEMORY_FAILURE
 	depends on MMU
 	depends on ARCH_SUPPORTS_MEMORY_FAILURE
 	bool "Enable recovery from hardware memory errors"
-	select MEMORY_ISOLATION
 	select RAS
 	help
 	  Enables code to recover from some memory failures on systems
_

Patches currently in -mm which might be from xieyuanbin1@huawei.com are


