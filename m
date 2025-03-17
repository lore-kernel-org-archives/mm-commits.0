Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA69A59
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188183; cv=none; b=ZPaa4pgh8xV4NrRKyGdtMFSWeUdSrbIu3YLpZjdVV7yar6YyyOZ3w5uAIRp+jzLfEwDonDhRyh4t9lJfLW1JUgtimT0mMeRswf+3UMwZa18VlhJF13YoCsiLf1T3b296HOrU6+ObyHn0yK5gg63lo41ERpfocujV0IRqxb4nYmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188183; c=relaxed/simple;
	bh=t+JbxvGsrTKW0L//Nc4ppPuaVAY8vKqQT52t19V8SQY=;
	h=Date:To:From:Subject:Message-Id; b=Xv1O/wU1/EzmByk0UG5i2x0NypKCGq8TslQJGe6ZI8njmOyFE49JTjyhJFgTJGiDmHS3eAC/R2CJ4XR1odccq2GiFECtYUwUt70LE3V1SpEZnW2BQO06FTigQn6iubbKL47LhDhk+e5lfmKr4FYVcM4G7YrD18KekFwKv+2HUA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E4otyacv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E4otyacv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02341C4CEEC;
	Mon, 17 Mar 2025 05:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188183;
	bh=t+JbxvGsrTKW0L//Nc4ppPuaVAY8vKqQT52t19V8SQY=;
	h=Date:To:From:Subject:From;
	b=E4otyacvlbsnjB3yJSKu7YB0iNd01fZnSwd0ssAK3GBhXGKSjpt/I+bY7svlRTnAu
	 GwNEqHALqlB7qpan0TICgTpk7BmifdyGpsyqIYeWGqc56NdBlp7x76BUYPX+PChOTA
	 yTNeubJ26rG1lu9wHnMlIuF1dNRQYLiZu5Klwn2Q=
Date: Sun, 16 Mar 2025 22:09:42 -0700
To: mm-commits@vger.kernel.org,rafael@kernel.org,osalvador@suse.de,david@redhat.com,ruansy.fnst@fujitsu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] drivers-base-memory-simplify-outputting-of-valid_zones_show.patch removed from -mm tree
Message-Id: <20250317050943.02341C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drivers/base/memory: simplify outputting of valid_zones_show()
has been removed from the -mm tree.  Its filename was
     drivers-base-memory-simplify-outputting-of-valid_zones_show.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Subject: drivers/base/memory: simplify outputting of valid_zones_show()
Date: Wed, 8 Jan 2025 09:52:23 +0800

No need to specify position at the first writing to the buf because the
@len is always 0 at this time.  Use sysfs_emit() instead to simplify it. 
Also avoid setting/checking default_zone with a conditional operator.

Link: https://lkml.kernel.org/r/20250108015223.1522887-1-ruansy.fnst@fujitsu.com
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/drivers/base/memory.c~drivers-base-memory-simplify-outputting-of-valid_zones_show
+++ a/drivers/base/memory.c
@@ -455,7 +455,7 @@ static ssize_t valid_zones_show(struct d
 	struct memory_group *group = mem->group;
 	struct zone *default_zone;
 	int nid = mem->nid;
-	int len = 0;
+	int len;
 
 	/*
 	 * Check the existing zone. Make sure that we do that only on the
@@ -466,22 +466,18 @@ static ssize_t valid_zones_show(struct d
 		 * If !mem->zone, the memory block spans multiple zones and
 		 * cannot get offlined.
 		 */
-		default_zone = mem->zone;
-		if (!default_zone)
-			return sysfs_emit(buf, "%s\n", "none");
-		len += sysfs_emit_at(buf, len, "%s", default_zone->name);
-		goto out;
+		return sysfs_emit(buf, "%s\n",
+				  mem->zone ? mem->zone->name : "none");
 	}
 
 	default_zone = zone_for_pfn_range(MMOP_ONLINE, nid, group,
 					  start_pfn, nr_pages);
 
-	len += sysfs_emit_at(buf, len, "%s", default_zone->name);
+	len = sysfs_emit(buf, "%s", default_zone->name);
 	len += print_allowed_zone(buf, len, nid, group, start_pfn, nr_pages,
 				  MMOP_ONLINE_KERNEL, default_zone);
 	len += print_allowed_zone(buf, len, nid, group, start_pfn, nr_pages,
 				  MMOP_ONLINE_MOVABLE, default_zone);
-out:
 	len += sysfs_emit_at(buf, len, "\n");
 	return len;
 }
_

Patches currently in -mm which might be from ruansy.fnst@fujitsu.com are


