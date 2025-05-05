Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A23929CB49
	for <mm-commits@vger.kernel.org>; Mon,  5 May 2025 22:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746485136; cv=none; b=Mo3xr4DyH7JY7pI+bygwsviXOAsKubQBCxvoMjHfo0WPrkWBAhKHDS9YIbCGCa1cz3JYVWOakMebYF1VKfFpAjhoe2d+BcGc7IWUDQz1g7TComYogHejlARRLcZJC5nLO2QJHxkZFlZYBGd6CGIkxwr4ZkXUei8Era7o08YGrS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746485136; c=relaxed/simple;
	bh=6RkCxI5werSdSFDAeBrA17LmwL0Dua2j0mldDVNiHxI=;
	h=Date:To:From:Subject:Message-Id; b=MNzQC9phn0qbSen/rJe9DJMAcRxBsN663a2tPLLpqRbQ++voxrNRsuEXUb8nuLY7juGoG/0CxzU0o3b0lfAtrkziO5HaW4LFk4pxKVIeDRzbTPh/UTz1J5yZQzsdbaPPaW07BSX3TwTngCUgF3NflSx9V2Y0R6pZSx/ETP8zlTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eNlRxEq+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eNlRxEq+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A7BC4CEE4;
	Mon,  5 May 2025 22:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746485133;
	bh=6RkCxI5werSdSFDAeBrA17LmwL0Dua2j0mldDVNiHxI=;
	h=Date:To:From:Subject:From;
	b=eNlRxEq+RaM1nCT5wgjMaE+Tk9n1Qq6t+QQhyGPYd+FO+PytXQEVc9+765v62bE76
	 pwF+r7GfNe6FDCzikgWIHZpqb8f345p6OfSIW4yhJHvTmgBNqhEKCDnS3eIPw58Wyz
	 0Rdg4WXP2NMtW+ybNBFnUTLHWAkYaLovtVzH7X5I=
Date: Mon, 05 May 2025 15:45:33 -0700
To: mm-commits@vger.kernel.org,yunjeong.mun@sk.com,ying.huang@linux.alibaba.com,rakie.kim@sk.com,osalvador@suse.de,joshua.hahnjy@gmail.com,Jonathan.Cameron@huawei.com,honggyu.kim@sk.com,gourry@gourry.net,david@redhat.com,dan.j.williams@intel.com,dan.carpenter@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-support-memory-hotplug-in-weighted-interleave-fix.patch added to mm-unstable branch
Message-Id: <20250505224533.B6A7BC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mempolicy: fix error code in sysfs_wi_node_add()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mempolicy-support-memory-hotplug-in-weighted-interleave-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-support-memory-hotplug-in-weighted-interleave-fix.patch

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

mm-mempolicy-support-memory-hotplug-in-weighted-interleave-fix.patch

