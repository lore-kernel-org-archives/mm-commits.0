Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8922F38A9C4
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898342; cv=none; b=AbaQ4KbTlMatqsn0v5cwzLm9YD2o8RDcI29dM/XbvGrxnooIP1wfl3cQB4qwky8lLZxjozlCkF3g+M6oceZrF82zb7bcZ4ZZA3voDcBp6JbbNtcf3mioHriU0omKLh7Jn4xX7es304S1L1oUQoN/YTDmuW6L+dVIzeaYkN9qqN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898342; c=relaxed/simple;
	bh=VPM/1hslG96JTfpso1lIeDuHZ+5ZLv2DJK/eqW6YhJA=;
	h=Date:To:From:Subject:Message-Id; b=mHjPVOIYNA6vNOdbNIPPm4ilGjmEWT7urgc6hEgJtwLOxFxO19uiD0heec0APUoyRR9FpRGS6XAOVc7YFCDweR1SgHhEZi4PpOo+NcILD6/cTzUQSvvb+Led+hrClflusioGwF/03ET+ER2cZUXvpR54GP6GE34D0ngMj4YxqRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cYH4Nz/n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cYH4Nz/n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C7A5C19425;
	Sat, 31 Jan 2026 22:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898342;
	bh=VPM/1hslG96JTfpso1lIeDuHZ+5ZLv2DJK/eqW6YhJA=;
	h=Date:To:From:Subject:From;
	b=cYH4Nz/nGO+HbGpRACaV5zYnSPRFM4hLS7f0T3i5V7dqfoW0cubyfXxEIErJcWEYO
	 +xzfGDalGRBGkGY7Iqx74C2euk5pOPe6l3/oWlDn4eo1ed9dKWPdVKktauH6z4kGNF
	 rtZlPMBdOsAlbTOF91QprNRzLNlaHJ4fHTVECBpY=
Date: Sat, 31 Jan 2026 14:25:41 -0800
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,akpm@linux-foundation.org,maainnewkin59@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-update-kernel-doc-for-__swap_cache_clear_shadow.patch removed from -mm tree
Message-Id: <20260131222542.1C7A5C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: update kernel-doc for __swap_cache_clear_shadow()
has been removed from the -mm tree.  Its filename was
     mm-update-kernel-doc-for-__swap_cache_clear_shadow.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Taeyang Kim <maainnewkin59@gmail.com>
Subject: mm: update kernel-doc for __swap_cache_clear_shadow()
Date: Sat, 17 Jan 2026 19:14:28 +0900

The kernel-doc comment referred to swap_cache_clear_shadow(), but the
actual function name is __swap_cache_clear_shadow().

Update the comment to match the function name.

Link: https://lkml.kernel.org/r/20260117101428.113154-1-maainnewkin59@gmail.com
Signed-off-by: Taeyang Kim <maainnewkin59@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swap_state.c~mm-update-kernel-doc-for-__swap_cache_clear_shadow
+++ a/mm/swap_state.c
@@ -283,7 +283,7 @@ void __swap_cache_replace_folio(struct s
 }
 
 /**
- * swap_cache_clear_shadow - Clears a set of shadows in the swap cache.
+ * __swap_cache_clear_shadow - Clears a set of shadows in the swap cache.
  * @entry: The starting index entry.
  * @nr_ents: How many slots need to be cleared.
  *
_

Patches currently in -mm which might be from maainnewkin59@gmail.com are


