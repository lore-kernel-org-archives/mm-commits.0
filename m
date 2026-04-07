Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF4B36998F
	for <mm-commits@vger.kernel.org>; Tue,  7 Apr 2026 20:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775595124; cv=none; b=uPOPQza0oNbLnlkuIzdslRWSJszULaa9L/2qt3QnEMoEziaJbmBINCSkMx5v/4Jo7x8ysf5GdXZn1IKxyUj1lmo9Rn0uKsi2hXY+/1l/BOvJha2JZ+MLFUSdZ/5Sn5b/5KNARLtXOtUOqgd63ik1gG6e0fWucjsFLhvDk66YLdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775595124; c=relaxed/simple;
	bh=TUNSn/vaRV7Ard97Ou60oEl/GtUzekziRnJNiKJaZgo=;
	h=Date:To:From:Subject:Message-Id; b=k4EMYe7cP/Z4wOwk84AygJhSy1sQeIOYJLavLlAAqs9daQjiEL6m/g/IR1TPV4oFuhavVhVc4n/0uIHfeXLc4K+Osa1nZGMSXErBQJiGA0ZVjutzz/crorJ/st9euiEPZRC1/NIXJMe7VfsztBsaY47arw6z43T+Nnu5KvVjSFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eeJG79L9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eeJG79L9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A153AC116C6;
	Tue,  7 Apr 2026 20:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775595123;
	bh=TUNSn/vaRV7Ard97Ou60oEl/GtUzekziRnJNiKJaZgo=;
	h=Date:To:From:Subject:From;
	b=eeJG79L99QpPWMDLa4QVpDJUIFC5VWxie5p89csmgJgJGOW3zKxtYywED895EzYzs
	 C8Lc+3lErhVXPy/JVI/dfu8gED29FKwm8TNNlv3RDtbpcemUGChowKo8bucBNBBLR7
	 LY4dM03QnJj7DOht27lNCA+kMzL446ScmOr+grw8=
Date: Tue, 07 Apr 2026 13:52:02 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,rakie.kim@sk.com,matthew.brost@intel.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-fix-weighted-interleave-auto-sysfs-name.patch added to mm-hotfixes-unstable branch
Message-Id: <20260407205203.A153AC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mempolicy: fix weighted interleave auto sysfs name
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mempolicy-fix-weighted-interleave-auto-sysfs-name.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-fix-weighted-interleave-auto-sysfs-name.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: mm/mempolicy: fix weighted interleave auto sysfs name
Date: Tue, 7 Apr 2026 07:14:14 -0700

The __ATTR macro is a utility that makes defining kobj_attributes easier
by stringfying the name, verifying the mode, and setting the show/store
fields in a single initializer.  It takes a raw token as the first value,
rather than a string, so that __ATTR family macros like __ATTR_RW can
token-paste it for inferring the _show / _store function names.

Commit e341f9c3c841 ("mm/mempolicy: Weighted Interleave Auto-tuning") used
the __ATTR macro to define the "auto" sysfs for weighted interleave.  A
few months later, commit 2fb6915fa22d ("compiler_types.h: add "auto" as a
macro for "__auto_type"") introduced a #define macro which expanded auto
into __auto_type.

This led to the "auto" token passed into __ATTR to be expanded out into
__auto_type, and the sysfs entry to be displayed as __auto_type as well.

Expand out the __ATTR macro and directly pass a string "auto" instead of
the raw token 'auto' to prevent it from being expanded out.  Also bypass
the VERIFY_OCTAL_PERMISSIONS check by triple checking that 0664 is indeed
the intended permissions for this sysfs file.

Before:
$ ls /sys/kernel/mm/mempolicy/weighted_interleave
__auto_type  node0

After:
$ ls /sys/kernel/mm/mempolicy/weighted_interleave/
auto  node0

Link: https://lkml.kernel.org/r/20260407141415.3080960-1-joshua.hahnjy@gmail.com
Fixes: 2fb6915fa22d ("compiler_types.h: add "auto" as a macro for "__auto_type"")
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-fix-weighted-interleave-auto-sysfs-name
+++ a/mm/mempolicy.c
@@ -3781,9 +3781,11 @@ static void wi_state_free(void)
 	}
 }
 
-static struct kobj_attribute wi_auto_attr =
-	__ATTR(auto, 0664, weighted_interleave_auto_show,
-			   weighted_interleave_auto_store);
+static struct kobj_attribute wi_auto_attr = {
+	.attr = { .name = "auto", .mode = 0664 },
+	.show = weighted_interleave_auto_show,
+	.store = weighted_interleave_auto_store,
+};
 
 static void wi_cleanup(void) {
 	sysfs_remove_file(&wi_group->wi_kobj, &wi_auto_attr.attr);
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are

mm-mempolicy-fix-weighted-interleave-auto-sysfs-name.patch

