Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BCA15491
	for <mm-commits@vger.kernel.org>; Mon, 15 Jul 2024 20:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721075294; cv=none; b=bM9H/wzjFTiweLOZntEXPRx2RwLcSd/GhwGg2Ppncn7Sjm1xkhoB5X9kX9pShDeJC/I1uTteuge5f8o9AEMD3GjJXEQwp9GW6uCgO3872tjY+QPgxZ0/UDBXWCGFcwJE0cA0Bmfo+xS0DY44Uz+JHVe1RadfpEOvd+QpsD4mjrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721075294; c=relaxed/simple;
	bh=P1agBzfscYEM2Fl9yvl4JQ4wjVtlhuiWG/D2Lt9HNWs=;
	h=Date:To:From:Subject:Message-Id; b=jZaJkMn9jNq5dqlqhgeDpblaaBVIZj5XdiU/OMZ+AUpAeRk+C/0Rvgm5w9X6pshz0kQM2XlI2/hvNEGTRXULq5uZAeSRhgDRF71VfpQDBECwLHTfmzCUtmZlWbNdUec4kF/2/fe8Z/9/skx4zAb+RF1YzeHN7B2hXZ4rrMzDX1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dPkVA+2s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dPkVA+2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 477D0C32782;
	Mon, 15 Jul 2024 20:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721075294;
	bh=P1agBzfscYEM2Fl9yvl4JQ4wjVtlhuiWG/D2Lt9HNWs=;
	h=Date:To:From:Subject:From;
	b=dPkVA+2sVm75PUi/ID8Qfl8b592JvcGza10fspSdIr+IZs98VsIiDeaGDa6wX5yg/
	 fWP4EwTTAQ0kMtGiP7VuhwJgI7biOaQmcAlRi3LRbHptWeCB99V68TJgDyuAXNOI1J
	 T84c2hIiFP3tOAjpp+QxOJ+k2A1ud2l1hNC88PSU=
Date: Mon, 15 Jul 2024 13:28:13 -0700
To: mm-commits@vger.kernel.org,dan.carpenter@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-fix-a-white-space-issue.patch added to mm-unstable branch
Message-Id: <20240715202814.477D0C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: fix a white space issue
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-fix-a-white-space-issue.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-fix-a-white-space-issue.patch

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
From: Dan Carpenter <dan.carpenter@linaro.org>
Subject: mm/zswap: fix a white space issue
Date: Mon, 15 Jul 2024 15:23:05 -0500

We accidentally deleted a tab in commit f84152e9efc5 ("mm/zswap: use only
one pool in zswap").  Add it back.

Link: https://lkml.kernel.org/r/c15066a0-f061-42c9-b0f5-d60281d3d5d8@stanley.mountain
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zswap.c~mm-zswap-fix-a-white-space-issue
+++ a/mm/zswap.c
@@ -803,7 +803,7 @@ static void zswap_entry_free(struct zswa
 		atomic_dec(&zswap_same_filled_pages);
 	else {
 		zswap_lru_del(&zswap_list_lru, entry);
-	zpool_free(entry->pool->zpool, entry->handle);
+		zpool_free(entry->pool->zpool, entry->handle);
 		zswap_pool_put(entry->pool);
 	}
 	if (entry->objcg) {
_

Patches currently in -mm which might be from dan.carpenter@linaro.org are

mm-zswap-fix-a-white-space-issue.patch

