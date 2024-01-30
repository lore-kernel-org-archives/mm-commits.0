Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B26051C3D
	for <mm-commits@vger.kernel.org>; Tue, 30 Jan 2024 06:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706596778; cv=none; b=VoRMSGJI4G0pvcv+SZFJQD3lP0UwreEgxen/A0b+wthkNVU3pkOVU5xXRaN42Fm4I2I9bXcxqGDEhwe7TLAXgV2cgQMDKur2tobWEUkPMs9J4dvjBQKq9A50YkRt5y3OlX7T7LRzdMgDylV6fmO1d7Kuj4QCzR8APDtxIKdWoZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706596778; c=relaxed/simple;
	bh=zuBOW497FHPbvgz0SH5PE+Gy4ToZ+bBIvsbBp27MLWg=;
	h=Date:To:From:Subject:Message-Id; b=gnQLx+ZBpeH1Qedl2+nnGEttvz2MtB0pG+1J1OIyE5ZJjArXPW5ZKscq8skTSEi0dZH5gv/MnhL4GXp3s1xRBPSQmMmmgec/falXw7Ut8u2TZ6ptlQWNboi/AcTJmQc/7lAdXSnMqmXoc2DkNcwZuzMKFUZ5nJGl7MjxYzcwSoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WGncuS3s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WGncuS3s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F85C433C7;
	Tue, 30 Jan 2024 06:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706596777;
	bh=zuBOW497FHPbvgz0SH5PE+Gy4ToZ+bBIvsbBp27MLWg=;
	h=Date:To:From:Subject:From;
	b=WGncuS3sROMyq34IYl4U0k5ipKkLH6n/Cl/xHlqkZw3juiKuJP9Djr09OpbPpEb6A
	 chnLvm8QNcCQhX73HJ1vn/pCm2jgdcTrAlR1hYseNqROQ7Lz7FePdBe2Ohw5EJS0lR
	 K0DHkwHik/HcFyHLjhZdBe8pF1ZPFtp+zaFMow7Q=
Date: Mon, 29 Jan 2024 22:39:23 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-rename-zswap_free_entry-to-zswap_entry_free.patch added to mm-unstable branch
Message-Id: <20240130063935.E5F85C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: rename zswap_free_entry to zswap_entry_free
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-rename-zswap_free_entry-to-zswap_entry_free.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-rename-zswap_free_entry-to-zswap_entry_free.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zswap: rename zswap_free_entry to zswap_entry_free
Date: Mon, 29 Jan 2024 20:36:37 -0500

There is a zswap_entry_ namespace with multiple functions already.

Link: https://lkml.kernel.org/r/20240130014208.565554-2-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/zswap.c~mm-zswap-rename-zswap_free_entry-to-zswap_entry_free
+++ a/mm/zswap.c
@@ -520,7 +520,7 @@ static struct zpool *zswap_find_zpool(st
  * Carries out the common pattern of freeing and entry's zpool allocation,
  * freeing the entry itself, and decrementing the number of stored pages.
  */
-static void zswap_free_entry(struct zswap_entry *entry)
+static void zswap_entry_free(struct zswap_entry *entry)
 {
 	if (!entry->length)
 		atomic_dec(&zswap_same_filled_pages);
@@ -555,7 +555,7 @@ static void zswap_entry_put(struct zswap
 	WARN_ON_ONCE(refcount < 0);
 	if (refcount == 0) {
 		WARN_ON_ONCE(!RB_EMPTY_NODE(&entry->rbnode));
-		zswap_free_entry(entry);
+		zswap_entry_free(entry);
 	}
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-zswap-fix-objcg-use-after-free-in-entry-destruction.patch
mm-zswap-rename-zswap_free_entry-to-zswap_entry_free.patch
mm-zswap-inline-and-remove-zswap_entry_find_get.patch
mm-zswap-move-zswap_invalidate_entry-to-related-functions.patch
mm-zswap-warn-when-referencing-a-dead-entry.patch
mm-zswap-clean-up-zswap_entry_put.patch
mm-zswap-rename-__zswap_load-to-zswap_decompress.patch
mm-zswap-break-out-zwap_compress.patch
mm-zswap-further-cleanup-zswap_store.patch
mm-zswap-simplify-zswap_invalidate.patch
mm-zswap-function-ordering-pool-alloc-free.patch
mm-zswap-function-ordering-pool-refcounting.patch
mm-zswap-function-ordering-zswap_pools.patch
mm-zswap-function-ordering-pool-params.patch
mm-zswap-function-ordering-public-lru-api.patch
mm-zswap-function-ordering-move-entry-sections-out-of-lru-section.patch
mm-zswap-function-ordering-move-entry-section-out-of-tree-section.patch
mm-zswap-function-ordering-compress-decompress-functions.patch
mm-zswap-function-ordering-per-cpu-compression-infra.patch
mm-zswap-function-ordering-writeback.patch
mm-zswap-function-ordering-shrink_memcg_cb.patch

