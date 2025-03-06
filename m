Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02AA29CF0
	for <mm-commits@vger.kernel.org>; Thu,  6 Mar 2025 05:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741239452; cv=none; b=UzLaRn6fseO6PlFKoCiGsTZimr2cjpLyvFW34a5KrI6pifhe2jxWUNiF8GyNzK5DYQDF5o+jCQ32gngxt6lYvlJmbnDyme1vcL8qU6yWt4tTIjSKJT8tPBE6mkCKfEe6x2glTeaSHuePgFw63eyDanSahtPXTpxikbzaviPK5H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741239452; c=relaxed/simple;
	bh=ojKVR7T0MO5VHN1aVrS0MhrAjF06neR4t1KCiZi1v3w=;
	h=Date:To:From:Subject:Message-Id; b=E7a/XStxVr8jGDndd+c6iCRPZhBZIBQOwBfAFIYH+nPDqH5/A4j9RuA0+iDUOIfUh5VuOeB19Dg/yEaaRb/swTPtSRUaUmYk9iFt+2ysH3EHG71YKxx0/WOxYtm698eXm4dSjecP/HyXSnHu6p4Gz0ovZG2HaXcOA3ncRvoSOkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JTjI8OH9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JTjI8OH9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5491CC4CEE4;
	Thu,  6 Mar 2025 05:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741239451;
	bh=ojKVR7T0MO5VHN1aVrS0MhrAjF06neR4t1KCiZi1v3w=;
	h=Date:To:From:Subject:From;
	b=JTjI8OH9nu8MTosnH4ICY7brpUvNvKMBddcrmaoYl6l9mn5AYfpMRXQDELQ7C1vg9
	 mkxVMq97G2RGmFke+WL0H8ujhxZfKb0d/sfqiGUgM/JMoLNkOUbUtKxjlU9KlfNA5R
	 QRhjiTW1TMshUWPTyrZ0PjwgDSqa2RP6avGtLhLQ=
Date: Wed, 05 Mar 2025 21:37:30 -0800
To: mm-commits@vger.kernel.org,kasong@tencent.com,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-swap-add-back-full-cluster-when-no-entry-is-reclaimed.patch removed from -mm tree
Message-Id: <20250306053731.5491CC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swap: add back full cluster when no entry is reclaimed
has been removed from the -mm tree.  Its filename was
     mm-swap-add-back-full-cluster-when-no-entry-is-reclaimed.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm: swap: add back full cluster when no entry is reclaimed
Date: Mon, 24 Feb 2025 19:39:10 +0800

If no swap cache is reclaimed, cluster taken off from full_clusters list
will not be put in any list and we can't reclaime HAS_CACHE slots
efficiently.  Do relocate_cluster for such cluster to avoid inefficiency.

Link: https://lkml.kernel.org/r/20250224113910.522439-1-shikemeng@huaweicloud.com
Fixes: 3b644773eefd ("mm, swap: reduce contention on device lock")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/swapfile.c~mm-swap-add-back-full-cluster-when-no-entry-is-reclaimed
+++ a/mm/swapfile.c
@@ -858,6 +858,10 @@ static void swap_reclaim_full_clusters(s
 			offset++;
 		}
 
+		/* in case no swap cache is reclaimed */
+		if (ci->flags == CLUSTER_FLAG_NONE)
+			relocate_cluster(si, ci);
+
 		unlock_cluster(ci);
 		if (to_scan <= 0)
 			break;
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-swap-remove-setting-swap_map_bad-for-discard-cluster.patch
mm-swap-correct-comment-in-swap_usage_sub.patch
mm-swap-remove-stale-comment-of-swap_reclaim_full_clusters.patch

