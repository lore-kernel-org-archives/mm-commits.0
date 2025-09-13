Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CFB2BE034
	for <mm-commits@vger.kernel.org>; Sat, 13 Sep 2025 22:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757802237; cv=none; b=hZtsZAF4KS6LjATz1R5Of5aLqo/UaS54eOGTajvn4VKBCUn3SN3brjBQwmjWKukj8Ar0jGIBU+93bscDuRN0EGgFdFuSlBhpZgV2U/HrRU4nFRZShKJJcSAxxqMfP3Tv4H8itFeL5G+Nc+DTDY5qeHTQb10EDln+L4jA3cxwQ94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757802237; c=relaxed/simple;
	bh=dbHx/1x1TsU3OQ2mfHBSuPzCjSXS4rxVScLD/9hB2fY=;
	h=Date:To:From:Subject:Message-Id; b=DSmCNAfbMlLiVSICl8ObZxe4uGTqPm2ahKZJ5s9z34mebWq/JzPGUSkLXMlsK/7fLAmo4uzxAmM8ukICxxuMo3QmNCTZ0XIhDYzdNoN69Q4RsCmf03GitSpxvbSAE8vEyuY3eSfGLnSRw8GPwoGG7ZfIEQERwvnO1SfHIrQbhBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cr1G/R0W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cr1G/R0W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5125C4CEEB;
	Sat, 13 Sep 2025 22:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757802236;
	bh=dbHx/1x1TsU3OQ2mfHBSuPzCjSXS4rxVScLD/9hB2fY=;
	h=Date:To:From:Subject:From;
	b=cr1G/R0WGWYTYUejb8lft9pl4R2JmijBmS9llqS65QWHPHT7et/3OI+riYg/d4Ybi
	 JM//8KWE6b/KsRixDNYUTFLg1uycHI8Y4Ytbx6Y5v9pp1g41lms2jQn36dZNSKA2O0
	 kVAI+Lt3+4CoUP4SBGKRCYwASQdjuzveYqeM+n1c=
Date: Sat, 13 Sep 2025 15:23:56 -0700
To: mm-commits@vger.kernel.org,wqu@suse.com,willy@infradead.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,boris@bur.io,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-filemap-add-as_kernel_file-fix.patch removed from -mm tree
Message-Id: <20250913222356.C5125C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix CONFIG_MEMCG build for AS_KERNEL_FILE
has been removed from the -mm tree.  Its filename was
     mm-filemap-add-as_kernel_file-fix.patch

This patch was dropped because it was folded into mm-filemap-add-as_kernel_file.patch

------------------------------------------------------
From: Boris Burkov <boris@bur.io>
Subject: mm: fix CONFIG_MEMCG build for AS_KERNEL_FILE
Date: Thu, 21 Aug 2025 15:51:22 -0700

this needs to be folded into

mm/filemap: add AS_KERNEL_FILE

for it to build with CONFIG_MEMCG unset. Apologies for the churn.

Link: https://lkml.kernel.org/r/6de59ddeec81b5c294d337c001ba0061631d4ec6.1755816635.git.boris@bur.io
Signed-off-by: Boris Burkov <boris@bur.io>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qu Wenruo <wqu@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/memcontrol.h~mm-filemap-add-as_kernel_file-fix
+++ a/include/linux/memcontrol.h
@@ -1059,6 +1059,8 @@ extern int mem_cgroup_init(void);
 
 #define MEM_CGROUP_ID_SHIFT	0
 
+#define root_mem_cgroup		(NULL)
+
 static inline struct mem_cgroup *folio_memcg(struct folio *folio)
 {
 	return NULL;
_

Patches currently in -mm which might be from boris@bur.io are

mm-filemap-add-as_kernel_file.patch
mm-add-vmstat-for-kernel_file-pages.patch
btrfs-set-as_kernel_file-on-the-btree_inode.patch

