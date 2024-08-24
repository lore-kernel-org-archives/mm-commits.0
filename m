Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F0F14B092
	for <mm-commits@vger.kernel.org>; Sat, 24 Aug 2024 05:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724477165; cv=none; b=oycZVGmVrmD+NEbZ7jQn+AYpN537FeRSPG1iimsxXBkDXtQ1K9OhiYJ9hGxS/fPwqGsgSu39WUhbBiFrtU3fEbURVuiRi/rCQ72hBgM3dn7qHr+B6A4UvXsXsUy2W0rsY/mUfoi4L0CJaQ6XZE8C4Ffmvz2y08G9yhKkw/rmJ/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724477165; c=relaxed/simple;
	bh=pznkRvam65tU/mkE4uva1o4qArDGyr84JRc3F1WeoYw=;
	h=Date:To:From:Subject:Message-Id; b=ANvjXyaNEPHOtc8IzcusvGrEzWyc7q7y7gFHhSsAcFM+20bsHS2GFp6mvyONXLxz189ZfrBvbBp47gLv2YjhWLfP8vMsqphmoNqoSVymCPgBEXKhxjhr/EJWbfAgfA2apLxsefULUnhKgfveFsg4jVs23/e4LEF9YHsyuqeQdbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Nu0K23Uj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Nu0K23Uj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 639ECC32781;
	Sat, 24 Aug 2024 05:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724477164;
	bh=pznkRvam65tU/mkE4uva1o4qArDGyr84JRc3F1WeoYw=;
	h=Date:To:From:Subject:From;
	b=Nu0K23UjdlLAX1UWRYUtP9/ZkRfdz1+no9RARs6I4YjgZunu1YpoXkQWkyaPAlOM7
	 LXqxRmdPjkZIsynwhhH4dbYGuaWr7TzQFNA0nEEfD/ki3COcKufJhXdo02nbZ1G6EC
	 ft4pq7VzAdU+tV8vUVaAC5Dy4BOA/LoXyP7C0pXA=
Date: Fri, 23 Aug 2024 22:26:03 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,me@yhndnzj.com,hannes@cmpxchg.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-test_zswap-add-test-for-hierarchical-zswapwriteback-fix.patch added to mm-unstable branch
Message-Id: <20240824052604.639ECC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests-test_zswap-add-test-for-hierarchical-zswapwriteback-fix
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-test_zswap-add-test-for-hierarchical-zswapwriteback-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-test_zswap-add-test-for-hierarchical-zswapwriteback-fix.patch

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
Subject: selftests-test_zswap-add-test-for-hierarchical-zswapwriteback-fix
Date: Fri Aug 23 10:25:10 PM PDT 2024

fix/simplify text

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Mike Yuan <me@yhndnzj.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/cgroup-v2.rst~selftests-test_zswap-add-test-for-hierarchical-zswapwriteback-fix
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1757,7 +1757,7 @@ The following nested keys are defined.
 	Note that this is subtly different from setting memory.swap.max to
 	0, as it still allows for pages to be written to the zswap pool.
 	This setting has no effect if zswap is disabled, and swapping
-	would be allowed unless memory.swap.max is set to 0.
+	is allowed unless memory.swap.max is set to 0.
 
   memory.pressure
 	A read-only nested-keyed file.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-mmzoneh-clean-up-watermark-accessors.patch
mm-remove-legacy-install_special_mapping-code-checkpatch-fixes.patch
mm-contig_alloc-support-__gfp_comp-fix.patch
mm-memory_hotplug-remove-head-variable-in-do_migrate_range-fix.patch
mm-memory-failure-add-unmap_posioned_folio-fix.patch
mm-memory_hotplug-check-hwpoisoned-page-firstly-in-do_migrate_range-fix.patch
selftests-mm-add-more-mseal-traversal-tests-fix.patch
mm-remove-pageactive-fix.patch
selftests-test_zswap-add-test-for-hierarchical-zswapwriteback-fix.patch
fault-inject-improve-build-for-config_fault_injection=n-fix.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-2.patch
fault-inject-improve-build-for-config_fault_injection=n-fix-3.patch

