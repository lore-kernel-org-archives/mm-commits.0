Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF38D2D97AF
	for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2025 22:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756333580; cv=none; b=Y1glD4js8a5PU6uDnh1vnFBKCoVFIwqcFh7BlgxtWf8cLWG92SDsrS0VvukhbvLYl2CXJ1ejK96tIHKjQhUYqoVFzKyq54nmkZNOAVvjvOoDnqN/VKe6Jat0mnR8zrsBOMSsWyOV1iTMzu4iDjpDn8rzDY4dIK5uzq3b3q1FsEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756333580; c=relaxed/simple;
	bh=pm6WQoMJpZoPrnGVJf3lxqhkp9ElAJiOCFdV8MPhdf8=;
	h=Date:To:From:Subject:Message-Id; b=tPrD7niXbDa1S3lX7DxQrb13PSkPA1mzOhQTEHsnPS4EtgYJQvy/U56KjGgLDg3KR52J3mOj6XOwpZasupJyelo1Cf5qMJO4/eRdHC3hNXS6X5AwylIB2fF1RffvIxNeOweHhZ9TNgJDZRsk+5vD68Z3zA2RvP6WuM7Nqh/vTEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FvNeLtjJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FvNeLtjJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BE77C4CEEB;
	Wed, 27 Aug 2025 22:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756333579;
	bh=pm6WQoMJpZoPrnGVJf3lxqhkp9ElAJiOCFdV8MPhdf8=;
	h=Date:To:From:Subject:From;
	b=FvNeLtjJPWvNtddRxrdFtMPz75eVI3CxpvF30y+72GGA76QwszoWBSC/gxTLr+mHn
	 f+MEY22rhf0NEktbW5h1f0JBkNXmM5k9Af6/RPYr11n9Bk0qLSzNYqAY7B8xlYJ1oG
	 OVfsf+DE+ZU+bN0nNAUvmU7VKigWbNc09ja7MbtU=
Date: Wed, 27 Aug 2025 15:26:18 -0700
To: mm-commits@vger.kernel.org,wqu@suse.com,willy@infradead.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,boris@bur.io,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-add-as_kernel_file-fix.patch added to mm-new branch
Message-Id: <20250827222619.4BE77C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix CONFIG_MEMCG build for AS_KERNEL_FILE
has been added to the -mm mm-new branch.  Its filename is
     mm-filemap-add-as_kernel_file-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-add-as_kernel_file-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
mm-filemap-add-as_kernel_file-fix.patch
mm-add-vmstat-for-kernel_file-pages.patch
btrfs-set-as_kernel_file-on-the-btree_inode.patch

