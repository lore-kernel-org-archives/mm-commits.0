Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD9713BC0C
	for <mm-commits@vger.kernel.org>; Sun, 11 May 2025 03:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746935426; cv=none; b=EVWl9p2tEml1nxQPV0z58M2foOljzoZslRK0nkzv8dBnvWYXK1ESPE0JZ8WRum7cSv2XHIW2Kru25V1+bMC/qgzEO6pO2Lt1TMMyJXZNp+8oOXjtmx6weob9oibqwJvMz0Uv6OG2Ir72eVmzS6zI95sIm8IJ/LJFagbEfKxnds8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746935426; c=relaxed/simple;
	bh=vlFxfV+1f7BQG3YUPIbnz3obq8L5HiXdzIVAjFEmuRk=;
	h=Date:To:From:Subject:Message-Id; b=IuIFNKhZf4Il0GGWUX9Sdpxu/z9/iV9HZdCKsX+2a5+Z5X81k7yATDw3+5ajZHHnl2sF4EClfOt/YAaqxvBWlfwbGdpFmhys9XMF1a+dGU3P1xVZzqDyo6NmBrMKLQmWP3uJSxJAYiS02c+9MnYYmhlvgChvJ7TPIcMPP21TavY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yFjTEX1P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yFjTEX1P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE4DC4CEE4;
	Sun, 11 May 2025 03:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746935425;
	bh=vlFxfV+1f7BQG3YUPIbnz3obq8L5HiXdzIVAjFEmuRk=;
	h=Date:To:From:Subject:From;
	b=yFjTEX1PfZKziPNqKVme1scvo+ie/IR/xpOuionXckwZ53bsDI9w3O5SLMAzjcDbG
	 PxgxqOhLJhGzOvkep5FGYB/oUDxmVwoxv086v70sZD6m3qFPPOMJt9cmp2cIKjqA66
	 Ja04arYYfXe0ACg/WYG3ft15cqsMAXwbtRunmDNg=
Date: Sat, 10 May 2025 20:50:24 -0700
To: mm-commits@vger.kernel.org,yunjeong.mun@sk.com,ying.huang@linux.alibaba.com,rakie.kim@sk.com,osalvador@suse.de,joshua.hahnjy@gmail.com,Jonathan.Cameron@huawei.com,honggyu.kim@sk.com,gourry@gourry.net,david@redhat.com,dan.j.williams@intel.com,dan.carpenter@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-mempolicy-support-memory-hotplug-in-weighted-interleave-fix.patch removed from -mm tree
Message-Id: <20250511035025.5CE4DC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mempolicy: fix error code in sysfs_wi_node_add()
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-support-memory-hotplug-in-weighted-interleave-fix.patch

This patch was dropped because it was folded into mm-mempolicy-support-memory-hotplug-in-weighted-interleave.patch

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@linaro.org>
Subject: mm/mempolicy: fix error code in sysfs_wi_node_add()
Date: Mon, 5 May 2025 17:32:12 +0300

Smatch complains that there is a missing error code here.  Arguments could
be made either way about what correct behavior should be but in the end we
decided that returning -EINVAL probably made sense.

The wi_node_notifier() already prints an error so this pr_info() is
duplicative so delete it.

Link: https://lkml.kernel.org/r/aBjL7Bwc0QBzgajK@stanley.mountain
Fixes: bc7527e0a127 ("mm/mempolicy: support memory hotplug in weighted interleave")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Honggyu Kim <honggyu.kim@sk.com>
Reviewed-by: Rakie Kim <rakie.kim@sk.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Yunjeong Mun <yunjeong.mun@sk.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-support-memory-hotplug-in-weighted-interleave-fix
+++ a/mm/mempolicy.c
@@ -3539,7 +3539,7 @@ static const struct kobj_type wi_ktype =
 
 static int sysfs_wi_node_add(int nid)
 {
-	int ret = 0;
+	int ret;
 	char *name;
 	struct iw_node_attr *new_attr;
 
@@ -3568,7 +3568,7 @@ static int sysfs_wi_node_add(int nid)
 	mutex_lock(&wi_group->kobj_lock);
 	if (wi_group->nattrs[nid]) {
 		mutex_unlock(&wi_group->kobj_lock);
-		pr_info("node%d already exists\n", nid);
+		ret = -EEXIST;
 		goto out;
 	}
 
_

Patches currently in -mm which might be from dan.carpenter@linaro.org are

mm-mempolicy-support-memory-hotplug-in-weighted-interleave.patch

