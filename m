Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7FC1553A3
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011033; cv=none; b=sJOCX7c5M1eAVonYDay60psek3otVkUUy3HDyMK++TETkDZXDn2gVMl5V/T88uvp7REOPQwxnDvQiwln1gLNeqtUg8FHtlurdmx18yjH03IuiTzOr+x8goQ+O6bGXIN3ZbvS8tE3yaGdofdXO4dSlwp4WdTbRBUpMdV3C8LNtac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011033; c=relaxed/simple;
	bh=rbKCDYLG3AlZW4uZHHtADnpfuOaA6vuF2/d7dvzv66Q=;
	h=Date:To:From:Subject:Message-Id; b=fLZLOv7UyJaabVTORcccZnNofjNfEsHNUu3KGo5ptm1LgMEQWCIDe9ng4XjkesXL98rv377unoJZ8kBEQ96DklTmG17zNnCHod4HChUT39fvsDZmb7c7lODvwJds6afpzxbbbS3xD+k2fvdHexfWhZNDtOD62QMpjrFwTaHlta0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gn/pt3aU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gn/pt3aU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139D9C4CEE4;
	Mon, 12 May 2025 00:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011033;
	bh=rbKCDYLG3AlZW4uZHHtADnpfuOaA6vuF2/d7dvzv66Q=;
	h=Date:To:From:Subject:From;
	b=Gn/pt3aULhBGTXzGkp7miqM9lCmQ6uAkcpqpQWE7LD8xZXP0v6Zn+H+bElxcSLEsZ
	 MDrReHgDIbMRHVE3EHhmvxNm/RM0MyIbtoGMqN8sN0SWB2oJr9Y8Qx1MhQi9+GIGTc
	 8Ej2S14nWh55V+I46piRHJBRY4bJSqT0/C5yAxGU=
Date: Sun, 11 May 2025 17:50:32 -0700
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,kasong@tencent.com,bhe@redhat.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-use-swap_entries_free-drop-last-ref-count-in-swap_entries_put_nr.patch removed from -mm tree
Message-Id: <20250512005033.139D9C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swap: use swap_entries_free() drop last ref count in swap_entries_put_nr()
has been removed from the -mm tree.  Its filename was
     mm-swap-use-swap_entries_free-drop-last-ref-count-in-swap_entries_put_nr.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm: swap: use swap_entries_free() drop last ref count in swap_entries_put_nr()
Date: Wed, 26 Mar 2025 00:25:24 +0800

Use swap_entries_free() to directly free swap entries when the swap
entries are not cached and referenced, without needing to set swap entries
to set intermediate SWAP_HAS_CACHE state.

Link: https://lkml.kernel.org/r/20250325162528.68385-5-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/swapfile.c~mm-swap-use-swap_entries_free-drop-last-ref-count-in-swap_entries_put_nr
+++ a/mm/swapfile.c
@@ -1498,10 +1498,11 @@ static bool swap_entries_put_nr(struct s
 		unlock_cluster(ci);
 		goto fallback;
 	}
-	for (i = 0; i < nr; i++)
-		WRITE_ONCE(si->swap_map[offset + i], SWAP_HAS_CACHE);
 	if (!has_cache)
 		swap_entries_free(si, ci, entry, nr);
+	else
+		for (i = 0; i < nr; i++)
+			WRITE_ONCE(si->swap_map[offset + i], SWAP_HAS_CACHE);
 	unlock_cluster(ci);
 
 	return has_cache;
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


