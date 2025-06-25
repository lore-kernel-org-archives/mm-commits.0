Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350BE20E031
	for <mm-commits@vger.kernel.org>; Wed, 25 Jun 2025 20:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750884006; cv=none; b=AYsIM0dfNXTkMZXsnD27wh7U5ZjkUBh9HG3wkTaG2QeXkamR9kAaXNbCNBTyWTewxij+BN9XfnPnBsNhQFhu0xjqC3vH4xR+FFms0TMmaHAJ4Ky/zMB+r8yVyHOBAMypgZZeHM56Fm4ytTy89TRXv0QVTwN2lxL0EfGLIyA9/BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750884006; c=relaxed/simple;
	bh=N40436RAhTEOAl4LUcHkUn9gztZLZIIuMNbpmakm2ZA=;
	h=Date:To:From:Subject:Message-Id; b=IL158vaa0tJXE6v768gjM4NvrzI2x02hHuwhUqqCqNe9v5cmx9BdxXbvfLVzv3rJysV5PRwvtIjBfbms+dxCb2j94451Wcj18qt1dvxmdNhKQDWJQXiQYm9zl6dbPKovkVhTXOTmnqnyb3KBb4P7wRiCFWkAggGfimO6VyLymMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZBfKmniF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZBfKmniF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E239DC4CEEA;
	Wed, 25 Jun 2025 20:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750884006;
	bh=N40436RAhTEOAl4LUcHkUn9gztZLZIIuMNbpmakm2ZA=;
	h=Date:To:From:Subject:From;
	b=ZBfKmniFT2g6pZyvvhRGltvk1qMQuB5ONRzI53wyDD0bhxxm5BzKQ74yrnt4EqPHV
	 PM5IWUIDigUqQLhtU0oYdFl7hS39VtnrC1bozvlA5OQXz7xioOaEiTT8L2LqbrXwjI
	 BQXYfqriouFX1RNDxHYyjud1aEATKKsdmTKx0gwQ=
Date: Wed, 25 Jun 2025 13:40:05 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,rakie.kim@sk.com,myon@debian.org,matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,david@redhat.com,byungchul@sk.com,bertranddrouvot.pg@gmail.com,apopple@nvidia.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fix-do_pages_stat-to-use-compat_uptr_t-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20250625204005.E239DC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fix-do_pages_stat-to-use-compat_uptr_t-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fix-do_pages_stat-to-use-compat_uptr_t-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fix-do_pages_stat-to-use-compat_uptr_t-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: fix-do_pages_stat-to-use-compat_uptr_t-fix
Date: Wed Jun 25 01:37:57 PM PDT 2025

fix coding style

Cc: Alistair Popple <apopple@nvidia.com>
Cc: Bertrand Drouvot <bertranddrouvot.pg@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Christoph Berg <myon@debian.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/migrate.c~fix-do_pages_stat-to-use-compat_uptr_t-fix
+++ a/mm/migrate.c
@@ -2449,8 +2449,9 @@ static int do_pages_stat(struct mm_struc
 
 			pages32 += chunk_nr;
 			pages = (const void __user * __user *) pages32;
-		} else
+		} else {
 			pages += chunk_nr;
+		}
 		status += chunk_nr;
 		nr_pages -= chunk_nr;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-add-oom-killer-maintainer-structure-fix.patch
mm-add-oom-killer-maintainer-structure-fix-checkpatch-fixes.patch
fix-do_pages_stat-to-use-compat_uptr_t-fix.patch
mmslub-use-node-notifier-instead-of-memory-notifier-fix.patch
maple-tree-use-goto-label-to-simplify-code-fix.patch
mm-memcg-make-memoryreclaim-interface-generic-fix.patch
maintainers-add-lib-raid6-to-software-raid.patch

