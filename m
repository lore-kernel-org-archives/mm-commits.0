Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61AF257849
	for <mm-commits@vger.kernel.org>; Sun, 19 Apr 2026 06:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776579919; cv=none; b=LnurgmLHzWvyQhoFECZIEH2ZUpsZFaztrCaCcM0jereVAZSgNT2onYIAPJP3biqGLR6kl1YsQKFVz+KUtGGJfbfSj67rfOodJtmN5dgDRGyZZiRo8OiRt1Ca73EtkpX+nKf+FgJKG2GzNqQWh+WRlTvyBUmx7df3SpZjqT/rNzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776579919; c=relaxed/simple;
	bh=liqnj5cWBkJL/O3BJaKV9sSLTC0gZbIs3YlPkM77L6U=;
	h=Date:To:From:Subject:Message-Id; b=h3KHMAFUY/5i68Y7gpRNMdwr+PuhCZnC8TSETTh/yCBM8cC+0SaRbsr5cjHCP1wp3KL1jAaWMHphA1vga2ib1UYv/jhLAsYJsbwFiV23mcWJ/ot/YR8xAXqTY47Imq71CavGhyFAOHang1QF+i9jfSBm83+mxl05EhlT328D0pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rfu0P26g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rfu0P26g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B35FC2BCAF;
	Sun, 19 Apr 2026 06:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776579919;
	bh=liqnj5cWBkJL/O3BJaKV9sSLTC0gZbIs3YlPkM77L6U=;
	h=Date:To:From:Subject:From;
	b=rfu0P26gYxzQrEK/qS6EDa2SwKpHZ29pmYIQ8aEeCobjEA8iZZSm6PJDxoYOrv0Hx
	 LMVjWNANjmAxp5xqODQQQmLovjjXIn6BJvNBoCnjyr5ltl82grFEKfHZ8HnTY3EkNs
	 h6b8MS64mnmq9ONujbkEWeaVlOcyID83AbkKprhI=
Date: Sat, 18 Apr 2026 23:25:10 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,rakie.kim@sk.com,matthew.brost@intel.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mempolicy-fix-weighted-interleave-auto-sysfs-name.patch removed from -mm tree
Message-Id: <20260419062519.0B35FC2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mempolicy: fix weighted interleave auto sysfs name
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-fix-weighted-interleave-auto-sysfs-name.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Link: https://lore.kernel.org/20260407141415.3080960-1-joshua.hahnjy@gmail.com
Fixes: 2fb6915fa22d ("compiler_types.h: add "auto" as a macro for "__auto_type"")
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Rakie Kim <rakie.kim@sk.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
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


