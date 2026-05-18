Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00514399D0B
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 21:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779141577; cv=none; b=NZpLGHr8+bAyhzZOacwPH9PqukMyznUzXN4QpZmTgcwyoTJGvaij3qh+3HhJndcjFIdyk5iWVilsGeb5A2+YR2GzMDjjZRL0skEDwJW3gL7/7csmAJM30d3j0S26GK+ctrDUtOz/7RQA/iYhWYSZC9PYcMeJs2MWlagAH4BFpPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779141577; c=relaxed/simple;
	bh=Wcmqlf0MBlmeLkMgJ4lLdSuwKjfdDY0L4XS7mhgICtU=;
	h=Date:To:From:Subject:Message-Id; b=MY5UYW/F7NOzY5y4Xy9PegkldlPJuGfZtwMFL2HDH4bfxTm2P/Wp6bacMT0MfZQiaRYTwzONAa+0TxPawFjeTSLowu258JeS1ZyboiWHpPU7Z8vFedxmuLaYq4PS2dOpmFGsMZJkp6OfYlxfPUrPhOWcERR3clvzr8Z6We91A1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z3j1hJex; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z3j1hJex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB2FC2BCB7;
	Mon, 18 May 2026 21:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779141576;
	bh=Wcmqlf0MBlmeLkMgJ4lLdSuwKjfdDY0L4XS7mhgICtU=;
	h=Date:To:From:Subject:From;
	b=Z3j1hJexKcKzSIqzMbq2ff25v3Jms2SfVSqll78IkwZINIMeNJO+D4qyf1f/3A4TV
	 qSUQCaZkPIsazfEz4RcqPF9TUvmgflJF4ba/Jkz14YpCnSylbtXyb6K3KfLPvN0ZI0
	 vVOeNnfrE+iL5sTE6HrjskBNT3GfM6sPIn7mZQxE=
Date: Mon, 18 May 2026 14:59:36 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] fs-btrfs-remove-a-comment-referring-to-read_only_thp_for_fs.patch removed from -mm tree
Message-Id: <20260518215936.8EB2FC2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/btrfs: remove a comment referring to READ_ONLY_THP_FOR_FS
has been removed from the -mm tree.  Its filename was
     fs-btrfs-remove-a-comment-referring-to-read_only_thp_for_fs.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: fs/btrfs: remove a comment referring to READ_ONLY_THP_FOR_FS
Date: Wed, 29 Apr 2026 11:35:33 -0400

READ_ONLY_THP_FOR_FS is no longer present, remove related comment.

Link: https://lore.kernel.org/20260429153538.727855-6-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: David Sterba <dsterba@suse.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/defrag.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/fs/btrfs/defrag.c~fs-btrfs-remove-a-comment-referring-to-read_only_thp_for_fs
+++ a/fs/btrfs/defrag.c
@@ -860,9 +860,6 @@ again:
 		return folio;
 
 	/*
-	 * Since we can defragment files opened read-only, we can encounter
-	 * transparent huge pages here (see CONFIG_READ_ONLY_THP_FOR_FS).
-	 *
 	 * The IO for such large folios is not fully tested, thus return
 	 * an error to reject such folios unless it's an experimental build.
 	 *
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-remove-read_only_thp_for_fs-in-khugepaged.patch
selftests-mm-remove-read_only_thp_for_fs-in-khugepaged-fix.patch
selftests-mm-remove-read_only_thp_for_fs-in-khugepaged-fix-2.patch
selftests-mm-remove-read_only_thp_for_fs-code-from-guard-regions.patch
mm-khugepaged-enable-clean-pagecache-folio-collapse-for-writable-files.patch
selftests-mm-add-writable-file-collapse-tests-for-khugepaged.patch

