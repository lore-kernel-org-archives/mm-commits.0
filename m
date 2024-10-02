Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00AFC8F5B
	for <mm-commits@vger.kernel.org>; Wed,  2 Oct 2024 20:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727902157; cv=none; b=az/q53f2fJtzDtTeUgpfzSDoT3V5pFeQQFlY9qdIpzpdLnFHCCBsghw0jawAdIdv4wH7QnQKEJPWLWafGozUtNVORcuRIHpnH3t783Sex48D6UWPGHrYIGeI2ptW+g3imVp0khzLfg5wQkCDosPGZ3SKoQ/hsTa4NOH4NqOcjW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727902157; c=relaxed/simple;
	bh=y4yHOaX26fBqsn1rAO6dZkDHGy2/Dc57inhulnUjjtA=;
	h=Date:To:From:Subject:Message-Id; b=CvQb7Oqf/hZZs1q684MbAFLld/4Ygs8g5oV7wfmKwu/zwwsGicgTtMPBf6amnc052ViRnxi3SnPEIzut/th9fH4oke+6XSpf+CTx6lfpbStGzmXGqxBMFykMezzSnCj7je9oDBJtGRg6yjmrkWdcO+x0PfveXl92TZofXGvHTqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lLxhioC9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lLxhioC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667B3C4CEC2;
	Wed,  2 Oct 2024 20:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727902156;
	bh=y4yHOaX26fBqsn1rAO6dZkDHGy2/Dc57inhulnUjjtA=;
	h=Date:To:From:Subject:From;
	b=lLxhioC9QV6inrOAyEFczo+Mkz7P7PdNs6hBI5W5oG4zwYM69CE6M21dGiC0yERK4
	 0tQTrFsAaiwvKdVjIj/+QlS+fpvfUQZM2vC+vd/ZDYa1IQKQyU9Pl9+y/aNsko14yn
	 Oxv34DNI+PS99sbWw8X7NZfvxYr4hfSdvZlvghzQ=
Date: Wed, 02 Oct 2024 13:49:15 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,wajdi.k.feghali@intel.com,usamaarif642@gmail.com,ryan.roberts@arm.com,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,kanchana.p.sridhar@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-delete-comments-for-value-member-of-struct-zswap_entry.patch added to mm-hotfixes-unstable branch
Message-Id: <20241002204916.667B3C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: delete comments for "value" member of 'struct zswap_entry'.
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-zswap-delete-comments-for-value-member-of-struct-zswap_entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-delete-comments-for-value-member-of-struct-zswap_entry.patch

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
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Subject: mm: zswap: delete comments for "value" member of 'struct zswap_entry'.
Date: Wed, 2 Oct 2024 12:42:13 -0700

Made a minor edit in the comments for 'struct zswap_entry' to delete the
description of the 'value' member that was deleted in commit 20a5532ffa53
("mm: remove code to handle same filled pages").

Link: https://lkml.kernel.org/r/20241002194213.30041-1-kanchana.p.sridhar@intel.com
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Fixes: 20a5532ffa53 ("mm: remove code to handle same filled pages")
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Usama Arif <usamaarif642@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wajdi Feghali <wajdi.k.feghali@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/zswap.c~mm-zswap-delete-comments-for-value-member-of-struct-zswap_entry
+++ a/mm/zswap.c
@@ -190,7 +190,6 @@ static struct shrinker *zswap_shrinker;
  *              section for context.
  * pool - the zswap_pool the entry's data is in
  * handle - zpool allocation handle that stores the compressed page data
- * value - value of the same-value filled pages which have same content
  * objcg - the obj_cgroup that the compressed memory is charged to
  * lru - handle to the pool's lru used to evict pages.
  */
_

Patches currently in -mm which might be from kanchana.p.sridhar@intel.com are

mm-zswap-delete-comments-for-value-member-of-struct-zswap_entry.patch
mm-define-obj_cgroup_get-if-config_memcg-is-not-defined.patch
mm-zswap-modify-zswap_compress-to-accept-a-page-instead-of-a-folio.patch
mm-zswap-rename-zswap_pool_get-to-zswap_pool_tryget.patch
mm-change-count_objcg_event-to-count_objcg_events-for-batch-event-updates.patch
mm-zswap-modify-zswap_stored_pages-to-be-atomic_long_t.patch
mm-zswap-support-large-folios-in-zswap_store.patch
mm-swap-count-successful-large-folio-zswap-stores-in-hugepage-zswpout-stats.patch
mm-zswap-zswap_store_page-will-initialize-entry-after-adding-to-xarray.patch

