Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370913655D0
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067103; cv=none; b=pr+/VqDiig+89BBbZ0dImOWf4Y+UNuYAlm05AXJ1P6hZP0wkgRIcCF7nnAS+/Q0arz6y1sP1a49MpP93rautjWToXkFPwvhL5ZG+xOYeR+zaEVNEq0ZY1Z6/QbBosoCHqtqrzipnxsULGldddirDWbVUEOIOUPe9iEhNlvJ06rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067103; c=relaxed/simple;
	bh=qAOlW3BBhCoNtdzFt4Os86udH5I7xLCyzzG6aCqvjm8=;
	h=Date:To:From:Subject:Message-Id; b=Bq+gTZkvSFlfdqzY4PLB92zDS8PfMg6sutgaT4DT6x3UhwoQdsI1DCqwJKFiN470EGooRTx4DqXUsnc0jzndcTX5ilmZ2cRKHl2CsyI8aDs4MWMP2i4pDDl1cdJjE1HAimG41/VDrOGj+Yo+iRQzFUhN2eAxtDqRtAnwg1RGJjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NiwU7XQn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NiwU7XQn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8BC1F000E9;
	Sun, 21 Jun 2026 18:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067101;
	bh=Agnwy5WMZIKAYN2CyPVM2t51+GCtGcj2bb9A4CN2f7I=;
	h=Date:To:From:Subject;
	b=NiwU7XQnimTbAnfDll7n6TDRakJLqOmbi2rZeqcnbXa8IaxEy/G6DoaElV3SiKkzC
	 jVQl7hCiI7IL4kWrEuiZeAev5XNDJWQkJv1a0/HsYxQjH9n9M7VE5EyFcX2nZ8uXh6
	 +Hnu1c3nG+/v4ZSSCbWrqKwoMlfLWT/5F4kooUUw=
Date: Sun, 21 Jun 2026 11:38:21 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@kernel.org,surenb@google.com,songliubraving@fb.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jack@suse.cz,dsterba@suse.com,dev.jain@arm.com,david@kernel.org,clm@fb.com,brauner@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-read_only_thp_for_fs-kconfig-option.patch removed from -mm tree
Message-Id: <20260621183821.BB8BC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove READ_ONLY_THP_FOR_FS Kconfig option
has been removed from the -mm tree.  Its filename was
     mm-remove-read_only_thp_for_fs-kconfig-option.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm: remove READ_ONLY_THP_FOR_FS Kconfig option
Date: Sun, 17 May 2026 09:54:07 -0400

After removing READ_ONLY_THP_FOR_FS check in file_thp_enabled(),
khugepaged and MADV_COLLAPSE can run on FSes with PMD THP pagecache
support even without READ_ONLY_THP_FOR_FS enabled.  Remove the Kconfig
first so that no one can use READ_ONLY_THP_FOR_FS as upcoming commits
remove mapping->nr_thps, which its safe guard mechanism relies on.

Link: https://lore.kernel.org/20260517135416.1434539-6-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Nico Pache <npache@redhat.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
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

 mm/Kconfig |   11 -----------
 1 file changed, 11 deletions(-)

--- a/mm/Kconfig~mm-remove-read_only_thp_for_fs-kconfig-option
+++ a/mm/Kconfig
@@ -936,17 +936,6 @@ config THP_SWAP
 
 	  For selection by architectures with reasonable THP sizes.
 
-config READ_ONLY_THP_FOR_FS
-	bool "Read-only THP for filesystems (EXPERIMENTAL)"
-	depends on TRANSPARENT_HUGEPAGE
-
-	help
-	  Allow khugepaged to put read-only file-backed pages in THP.
-
-	  This is marked experimental because it is a new feature. Write
-	  support of file THPs will be developed in the next few release
-	  cycles.
-
 config NO_PAGE_MAPCOUNT
 	bool "No per-page mapcount (EXPERIMENTAL)"
 	help
_

Patches currently in -mm which might be from ziy@nvidia.com are


