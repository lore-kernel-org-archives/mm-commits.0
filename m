Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5BF04A12
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739127; cv=none; b=apS5nKfXLPxuwkEZ4So6RVDhwzYbIqU34msSNwwtj7zKHjl8RKxluh6ZyJvIGwLlLy7RY9GZrEsx4d0FL5xXFkPg5OI8Mz1CqGTfz++iv99Nw3GtVAVG6kC8TKjjCYS9vRrCOiiXDMh0mVRKI2kNXF0J5ty7qawwJYsVmeJjIts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739127; c=relaxed/simple;
	bh=S4jjiKa9xHSPhhxaia8M8RCDfocEKL0XkzVgxrrTJ/U=;
	h=Date:To:From:Subject:Message-Id; b=NNg4ilWHaPrz1vQl94Ee5sW2YdxHCZGHGivaxEae5DhbsqNvcuDwRX0nWfQTuFCojH4n10utacoJ55HydqHkRXlrRbjtVbLoVKhJcsikKAk+A4vCWnk+W4e5cpXDsYmipVwu3VZBqXWjfA2e0fzu28t3tadVtn7j/T+TzIIAYEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rfM1cIis; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rfM1cIis"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D60DC433F1;
	Sat, 24 Feb 2024 01:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739127;
	bh=S4jjiKa9xHSPhhxaia8M8RCDfocEKL0XkzVgxrrTJ/U=;
	h=Date:To:From:Subject:From;
	b=rfM1cIisrEizASpJtDn4SH55nhtO3SLCffNy+Fb6i2MB7xM0RW22lnp9fQ0VLP+VP
	 +DX9hy0Q5MDkvRjrRm5qptbqSIV/mz6lpivBXFQC8BgZ8BpRyLuzJ4+3KVDelAqS3d
	 dn0ZISH1aWd8Rg66ZRfUU2ruuiZgqBnfLu9lZ3iQ=
Date: Fri, 23 Feb 2024 17:45:26 -0800
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,21cnbao@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-swapfile-__swap_duplicate-drop-redundant-write_once-on-swap_map-for-err-cases-fix.patch removed from -mm tree
Message-Id: <20240224014527.2D60DC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-swapfile-__swap_duplicate-drop-redundant-write_once-on-swap_map-for-err-cases-fix
has been removed from the -mm tree.  Its filename was
     mm-swapfile-__swap_duplicate-drop-redundant-write_once-on-swap_map-for-err-cases-fix.patch

This patch was dropped because it was folded into mm-swapfile-__swap_duplicate-drop-redundant-write_once-on-swap_map-for-err-cases.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-swapfile-__swap_duplicate-drop-redundant-write_once-on-swap_map-for-err-cases-fix
Date: Wed Feb 21 12:35:32 PM PST 2024

avoid using goto

Cc: Barry Song <21cnbao@gmail.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/swapfile.c~mm-swapfile-__swap_duplicate-drop-redundant-write_once-on-swap_map-for-err-cases-fix
+++ a/mm/swapfile.c
@@ -3335,10 +3335,8 @@ static int __swap_duplicate(swp_entry_t
 	} else
 		err = -ENOENT;			/* unused swap entry */
 
-	if (err)
-		goto unlock_out;
-
-	WRITE_ONCE(p->swap_map[offset], count | has_cache);
+	if (!err)
+		WRITE_ONCE(p->swap_map[offset], count | has_cache);
 
 unlock_out:
 	unlock_cluster_or_swap_info(p, ci);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-swapfile-__swap_duplicate-drop-redundant-write_once-on-swap_map-for-err-cases.patch
hugetlb-parallelize-1g-hugetlb-initialization-fix.patch
mm-vmscan-do-not-turn-on-cache_trim_mode-if-it-doesnt-work-fix.patch

