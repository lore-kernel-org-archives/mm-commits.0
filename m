Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8963C147
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739452; cv=none; b=dT+wOawMLxEK3zijuv9tACgWOXvN4c+vh3hdcUNjL35/gTd13ZDXm3SZh1eEO7NcpD9b9sqprLEOuSlHnlmj0lhKEjyF1o7qBqHzKJ9X62q74mF2CwAt5z/ocKEY54bcUrmnsXXbDgbPCwxv0v/W50iUVOEbDrvvh4LL+ozi0+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739452; c=relaxed/simple;
	bh=lWmH5Rm7R5M/ir3uL6O7Sp8EevfdmEzTUewRIlEHWeY=;
	h=Date:To:From:Subject:Message-Id; b=SLWAgqpTEfSS9mg3VDl7Gz1df7qfn69vdS9HPURMMgH6YsD+4LeZhyHYl90kIFrcbHsgB8GqzpHLk8znYmk68Utax5QMP6EfSmeUCFLiHfu316//pjsk/LCZy+PDjPOvftGOXKnxM1Z6DPzdFRniPtjs5ayovopI1e65UJ7i/+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1KWnxXWf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1KWnxXWf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E920C433C7;
	Sat, 24 Feb 2024 01:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739452;
	bh=lWmH5Rm7R5M/ir3uL6O7Sp8EevfdmEzTUewRIlEHWeY=;
	h=Date:To:From:Subject:From;
	b=1KWnxXWfnMy3EgHxncw31pefvH9H4BbHbCeEtEiSiAaFMDluyc5HNHF7i2E5GUCbI
	 HP0eW2vKdg21RFTLaglW/TYmyulR7byIevqqyrfdIKb56UXJFOMb6eHjpTYhxbiiFM
	 diCGwv/QWjiO2USd0QZ48RWXKB7BfxX51dn/MQg8=
Date: Fri, 23 Feb 2024 17:50:51 -0800
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,21cnbao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swapfile-__swap_duplicate-drop-redundant-write_once-on-swap_map-for-err-cases.patch removed from -mm tree
Message-Id: <20240224015052.7E920C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swapfile:__swap_duplicate: drop redundant WRITE_ONCE on swap_map for err cases
has been removed from the -mm tree.  Its filename was
     mm-swapfile-__swap_duplicate-drop-redundant-write_once-on-swap_map-for-err-cases.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Barry Song <21cnbao@gmail.com>
Subject: mm/swapfile:__swap_duplicate: drop redundant WRITE_ONCE on swap_map for err cases
Date: Wed, 21 Feb 2024 22:10:28 +1300

From: Barry Song <v-songbaohua@oppo.com>

The code is quite hard to read, we are still writing swap_map after
errors happen. Though the written value is as before,

 has_cache = count & SWAP_HAS_CACHE;
 count &= ~SWAP_HAS_CACHE;
 [snipped]
 WRITE_ONCE(p->swap_map[offset], count | has_cache);

It would be better to entirely drop the WRITE_ONCE for both
performance and readability.

[akpm@linux-foundation.org: avoid using goto]
Link: https://lkml.kernel.org/r/20240221091028.123122-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swapfile-__swap_duplicate-drop-redundant-write_once-on-swap_map-for-err-cases
+++ a/mm/swapfile.c
@@ -3335,7 +3335,8 @@ static int __swap_duplicate(swp_entry_t
 	} else
 		err = -ENOENT;			/* unused swap entry */
 
-	WRITE_ONCE(p->swap_map[offset], count | has_cache);
+	if (!err)
+		WRITE_ONCE(p->swap_map[offset], count | has_cache);
 
 unlock_out:
 	unlock_cluster_or_swap_info(p, ci);
_

Patches currently in -mm which might be from 21cnbao@gmail.com are


