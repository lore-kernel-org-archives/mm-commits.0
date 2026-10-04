Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8CAC47F78B
	for <mm-commits@vger.kernel.org>; Sun,  4 Oct 2026 20:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791144710; cv=none; b=L0hXBYYC7IYXOV3rjuqKTJNmG6XL+SSXRloJT6IQzOfyX0dUOJ3J24TG7UBNzsqJW/vWumlRKEKsVDfQb1ob866Q+HEl8X7/9z+G4q54xfJS80i9dCtWSxhnbvRi1js6glJb2Z8v5JeRjwftk4t5eBD+nNFUPoesBpOa+zmxvaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791144710; c=relaxed/simple;
	bh=VFGa/s6tE2TPZVY/65beASnvSwCwvPI8S4qd/3oheXo=;
	h=Date:To:From:Subject:Message-Id; b=uGbYRpTkvakf0TQ6UmEEohXi658oVlhMA66U3Q4WqBzzHuL7ggyC6fzk9nzbBlhigTlM9FZ5hHmSojAbasqv7CcYZ2JFxXaQeEdmWM1ymWsT+xg1MCmXMG0GYYHxvGBGPlXHYXBLbwN1Fce8LDEs/48s+H2DWTWDfHJRnuFKrUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hx78P7Yq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hx78P7Yq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC4B1F000FF;
	Sun,  4 Oct 2026 20:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791144708;
	bh=q0LxiUXPKpnpKgtIcmfOju9MPK+NbIq/xOdtau5jBa8=;
	h=Date:To:From:Subject;
	b=hx78P7YqMcavWyU4JnHVNyED91B/ZmQtAo6crYetLRbw4VxQTGUzoAJmYHRiKl04P
	 s5WjB0kU0C2Eq/kbUYoNPeUEEIw88D7fZR7g9/eqSUdUNg+S13bVEMVlT8bAPlsAZC
	 9q1HkeSzV5d85IT0ppolABArYrIcdmgkuYp6zpvo=
Date: Sun, 04 Oct 2026 13:11:47 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,lienze@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_cgroup-add-trailing-endif-comment-for-include-guard.patch added to mm-unstable branch
Message-Id: <20261004201148.5BC4B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb_cgroup: add trailing #endif comment for include guard
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_cgroup-add-trailing-endif-comment-for-include-guard.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_cgroup-add-trailing-endif-comment-for-include-guard.patch

This patch will later appear in the mm-unstable branch at
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
From: Enze Li <lienze@kylinos.cn>
Subject: mm/hugetlb_cgroup: add trailing #endif comment for include guard
Date: Sat,  3 Oct 2026 14:00:29 +0800

The final #endif that closes the _LINUX_HUGETLB_CGROUP_H include guard
is left without a comment.  Add the macro name to the comment for
consistency and easier navigation.

Link: https://lore.kernel.org/20261003060029.2152489-2-lienze@kylinos.cn
Signed-off-by: Enze Li <lienze@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
---

 include/linux/hugetlb_cgroup.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/hugetlb_cgroup.h~mm-hugetlb_cgroup-add-trailing-endif-comment-for-include-guard
+++ a/include/linux/hugetlb_cgroup.h
@@ -268,4 +268,4 @@ static inline void hugetlb_cgroup_migrat
 }
 
 #endif  /* CONFIG_CGROUP_HUGETLB */
-#endif
+#endif /* _LINUX_HUGETLB_CGROUP_H */
_

Patches currently in -mm which might be from lienze@kylinos.cn are

mm-damon-core-introduce-damon_set_target_pid.patch
samples-damon-mtier-add-comment-for-struct-region_range.patch
maintainers-cover-all-hugetlb-headers-under-hugetlb-subsystem.patch
mm-hugetlb_cgroup-add-trailing-endif-comment-for-include-guard.patch
docs-hugetlbpagerst-fix-typo-in-per-node-attribute-description.patch

