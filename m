Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753AE7FBA2
	for <mm-commits@vger.kernel.org>; Sat, 29 Nov 2025 18:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764441720; cv=none; b=YBZt/JYoaQ6jVPFdC9zNsUsWZ6dJP2vhobP6dKpRg3YFQRLKAklCeHfLsJmqUAP3f/75cFPtd6MY31pGA0ZfyX5HWl0z3xHlDBFUMKt3RGBvQWxQTNKqsM01kUV0Q51/97zMikA0gb+R2TA6Oh6pWD6AUVIAzyuvY8NT6cF6448=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764441720; c=relaxed/simple;
	bh=LV8KEFncdkTLzQ2pJ+RcdoryqdOUQ2iPceiUGyHTUik=;
	h=Date:To:From:Subject:Message-Id; b=G17NwFuy1Ygrs9aHwWFQkCLu18Bg4abLUVCaHR7zQRDfYqSb9IEN917PcfRT6K4k1S5RH6JfPZu9SiSHUbz5tLOUGyxZNTP99UAfsCtwd0TYbzBAR06Hcubk2el1V3sVuGoCE5ejTzsB3l3wb9Chp/WmDh49if7c/0jgZW/Rimk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=18OnGGiX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="18OnGGiX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BDECC4CEF7;
	Sat, 29 Nov 2025 18:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764441720;
	bh=LV8KEFncdkTLzQ2pJ+RcdoryqdOUQ2iPceiUGyHTUik=;
	h=Date:To:From:Subject:From;
	b=18OnGGiXNyWimYYMkJIzvhaOxk4J6GdvbzFMVRXPHlaIdjdG5sprEBIu1l+0noALX
	 2VJLO7FDsFlmVAvk9GYqpJOdJXxLWP4VjbVJHSmErIeC7feUjm+O0pfIn5k+RrzRAX
	 njoxbBE48UQ01tWpbVOF2d3X8m0powIWs39pu99E=
Date: Sat, 29 Nov 2025 10:41:59 -0800
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,youngjun.park@lge.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swapfile-use-plist_for_each_entry-in-__folio_throttle_swaprate.patch removed from -mm tree
Message-Id: <20251129184200.0BDECC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swapfile: use plist_for_each_entry in __folio_throttle_swaprate
has been removed from the -mm tree.  Its filename was
     mm-swapfile-use-plist_for_each_entry-in-__folio_throttle_swaprate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Youngjun Park <youngjun.park@lge.com>
Subject: mm/swapfile: use plist_for_each_entry in __folio_throttle_swaprate
Date: Thu, 27 Nov 2025 19:03:03 +0900

The loop breaks immediately after finding the first swap device and
never modifies the list. Replace plist_for_each_entry_safe() with
plist_for_each_entry() and remove the unused next variable.

Link: https://lkml.kernel.org/r/20251127100303.783198-3-youngjun.park@lge.com
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Acked-by: Kairui Song <kasong@tencent.com>
Acked-by: Chris Li <chrisl@kernel.org>
Cc: Barry Song <baohua@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/swapfile.c~mm-swapfile-use-plist_for_each_entry-in-__folio_throttle_swaprate
+++ a/mm/swapfile.c
@@ -4023,7 +4023,7 @@ static bool __has_usable_swap(void)
 
 void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 {
-	struct swap_info_struct *si, *next;
+	struct swap_info_struct *si;
 
 	if (!(gfp & __GFP_IO))
 		return;
@@ -4042,8 +4042,7 @@ void __folio_throttle_swaprate(struct fo
 		return;
 
 	spin_lock(&swap_avail_lock);
-	plist_for_each_entry_safe(si, next, &swap_avail_head,
-				  avail_list) {
+	plist_for_each_entry(si, &swap_avail_head, avail_list) {
 		if (si->bdev) {
 			blkcg_schedule_throttle(si->bdev->bd_disk, true);
 			break;
_

Patches currently in -mm which might be from youngjun.park@lge.com are


