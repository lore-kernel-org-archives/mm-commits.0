Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2382AD0C
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 00:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783299535; cv=none; b=jnrFBkOY5xnlAM6dYG4RqW+ihCUb4SM7JXt5axN4TZJJRPMHEtAU2TdbzkV5r9ASmCHPjzXQjf/XZabuMtILRAKQDi/5oPwEJap/QH46OVkbqktsUuz6WtGinWIk5bDW/RAsQOqoK9KRoJxo1O8JCCKiNZPTx38p5S8/BTWPgSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783299535; c=relaxed/simple;
	bh=WrSXwLAu97x26t/ke85NrxPrWBrTqe9xWkbVtQrA3WU=;
	h=Date:To:From:Subject:Message-Id; b=Xd9kzAQC1CnyX2GafCStocLHIjGl1+g1zVLoP3yphtw4bX62xBwYSxlgt4HfR+ItwVveivkq6mU8yztbEwisjL20cUJM56mXBLzfgS5W1wih3KeY+6v8FxEnOaBG47vP3OxYAlPy9Dz2L+feSxMlVoqoIOI/kDZcrNP0keIgNnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rmNV/ym+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rmNV/ym+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764C31F000E9;
	Mon,  6 Jul 2026 00:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783299533;
	bh=3gK47HFfYPjFhKwgtRsA7OZLievS5nlMjcseN9xF8PE=;
	h=Date:To:From:Subject;
	b=rmNV/ym+VE2pfikiGMbXphjOP0j2nLV66/qCkf0A4rPEf/I7DnMYfIvOczOFjYbKn
	 JN9zQFTHpxE9Bi1S/3Swvsk9AIJoCnuf/FERj+vIiympczskt14JAuBXJtEETUF8w6
	 Yssj+vbMRLsRqgU6ovgfZE4oZWCw95Rxe5zm9rVY=
Date: Sun, 05 Jul 2026 17:58:53 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,liam@infradead.org,andrewjballance@gmail.com,aliceryhl@google.com,enelsonmoore@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-remove-undocumented-config_maple_rcu_disabled-macro.patch added to mm-new branch
Message-Id: <20260706005853.764C31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: remove undocumented CONFIG_MAPLE_RCU_DISABLED macro
has been added to the -mm mm-new branch.  Its filename is
     maple_tree-remove-undocumented-config_maple_rcu_disabled-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-remove-undocumented-config_maple_rcu_disabled-macro.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Subject: maple_tree: remove undocumented CONFIG_MAPLE_RCU_DISABLED macro
Date: Wed, 10 Jun 2026 15:09:04 -0700

<linux/maple_tree.h> consults the macro CONFIG_MAPLE_RCU_DISABLED to
determine whether to disable the mt_in_rcu() function (by making it always
return false).  This macro is not reachable via Kconfig, despite its name,
and is not documented anywhere.  Remove it to avoid polluting the CONFIG_*
namespace.

Discovered while searching for CONFIG_* symbols referenced in code but not
defined in any Kconfig file.

Link: https://lore.kernel.org/20260610220905.99860-1-enelsonmoore@gmail.com
Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Acked-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Liam Howlett <liam@infradead.org>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |    4 ----
 1 file changed, 4 deletions(-)

--- a/include/linux/maple_tree.h~maple_tree-remove-undocumented-config_maple_rcu_disabled-macro
+++ a/include/linux/maple_tree.h
@@ -11,7 +11,6 @@
 #include <linux/kernel.h>
 #include <linux/rcupdate.h>
 #include <linux/spinlock.h>
-/* #define CONFIG_MAPLE_RCU_DISABLED */
 
 /*
  * Allocated nodes are mutable until they have been inserted into the tree,
@@ -868,9 +867,6 @@ static inline void mt_init(struct maple_
 
 static inline bool mt_in_rcu(struct maple_tree *mt)
 {
-#ifdef CONFIG_MAPLE_RCU_DISABLED
-	return false;
-#endif
 	return mt->ma_flags & MT_FLAGS_USE_RCU;
 }
 
_

Patches currently in -mm which might be from enelsonmoore@gmail.com are

mm-hugetlb-correct-config_cgroup_hugetlb-macro-name-in-comment.patch
mm-fix-config_stack_growsup-typo-in-tools-testing-vma-include-duph.patch
maple_tree-remove-undocumented-config_maple_rcu_disabled-macro.patch

