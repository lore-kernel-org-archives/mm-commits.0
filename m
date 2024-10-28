Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BBC563C
	for <mm-commits@vger.kernel.org>; Mon, 28 Oct 2024 01:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730077274; cv=none; b=QAlMlFkmWu2hmpK8P9oW4jD5Ki+/cxhF7dwZMFYyNKfHKZ8SuYBE7UzLJMAOpLrN+TI8G0M++tqoJ69W7q1e0XSe7/3HnY/elqHgW0rTdaPejURO1LPM6qwQszdfASB1YbgoHlRp4HDeUmW8HtPuyCdhcGPWcRwgvPkvivBZVjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730077274; c=relaxed/simple;
	bh=kVYcWosZ6MEk3CNltfk2xOQKTdkntllwPthrA4k/IW8=;
	h=Date:To:From:Subject:Message-Id; b=BhQ60P85q4M9BLMlN4YRYSNRmxrf2T3uz+bPC+EiVWqkpDl7nphL6vc31yHWZo5m9kLVjHOwOCqjZwOqa4yVJ0D0181ib0IdQSVFCJy0rdz6sGjp4msGwh0EomYeQ9z7VCdFCNn5s0jNrudN625UYRiUm+xbRkMdkQiaU5dr5Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kXa7BEB5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kXa7BEB5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B21C4CEC3;
	Mon, 28 Oct 2024 01:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730077273;
	bh=kVYcWosZ6MEk3CNltfk2xOQKTdkntllwPthrA4k/IW8=;
	h=Date:To:From:Subject:From;
	b=kXa7BEB52x+6LYH22N+4bfBCMcVDZ6E8sw8ycMJeqLfhbR9YkFsVEVIjO6497oRIm
	 zqaQP1thzktLyUll9WwqybHHXkK6YLCggqbSVWRJtfwSaArWctdMGn3I8pN9XDNCD4
	 fq+3xA6slcBjW3/adm2uYtLZT80UlCpF6U+Ocrmg=
Date: Sun, 27 Oct 2024 18:01:13 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosryahmed@google.com,songmuchun@bytedance.com,shakeel.butt@linux.dev,sfr@canb.auug.org.au,roman.gushchin@linux.dev,mhocko@suse.com,hughd@google.com,hannes@cmpxchg.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-workingset-remove-folio_memcg_rcu-usage-fix.patch added to mm-unstable branch
Message-Id: <20241028010113.C6B21C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg-workingset-remove-folio_memcg_rcu-usage-fix
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-workingset-remove-folio_memcg_rcu-usage-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-workingset-remove-folio_memcg_rcu-usage-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-workingset-remove-folio_memcg_rcu-usage-fix
Date: Sun Oct 27 05:59:41 PM PDT 2024

fix build: provide folio_memcg_charged stub for CONFIG_MEMCG=n

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/include/linux/memcontrol.h~memcg-workingset-remove-folio_memcg_rcu-usage-fix
+++ a/include/linux/memcontrol.h
@@ -1055,6 +1055,11 @@ static inline struct mem_cgroup *folio_m
 	return NULL;
 }
 
+static inline bool folio_memcg_charged(struct folio *folio)
+{
+	return false;
+}
+
 static inline struct mem_cgroup *folio_memcg_check(struct folio *folio)
 {
 	return NULL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-consolidate-common-checks-in-hugetlb_get_unmapped_area-fix.patch
mm-memoryc-remove-stray-newline-at-top-of-file.patch
bootmem-stop-using-page-index-fix.patch
mm-kasan-kmsan-copy_from-to_kernel_nofault-fix.patch
tools-mm-free-the-allocated-memory-fix.patch
memcg-v1-no-need-for-memcg-locking-for-mglru-fix.patch
mm-vma-the-pgoff-is-correct-if-can_merge_right-fix.patch
memcg-workingset-remove-folio_memcg_rcu-usage-fix.patch

