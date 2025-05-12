Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C72829712E
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 22:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747088998; cv=none; b=HrBBiaMtx2cvMUj16pyLQqwZ9FUwNw8PXrHK3eFWQWCwdaEL3rxPo4vl8v+Ckg+5yUhdghJGxGkqZmyQZmMZkxZycigDgte4sLZwumWDpKGoo4QEMnkC71UXAlT5GcHZRERMwfIVkdyrZ/VyuL5nfF6vcPz2W4xv/FiVAauGb1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747088998; c=relaxed/simple;
	bh=fgi1DZqDwGUgu21rqKkdjjWXremFGdikMmfuGW8A/9Y=;
	h=Date:To:From:Subject:Message-Id; b=u2sJgCxXpPbozAqnPdbIDeIKbKkN8eifn1g8PGZda5sP5ynLnLFqhOI5QNSV/8TjA3JQ0Z8dOR9MHa0yJOOLYU9Kb2eM3WxJLkconz+owDGhvfzvQpeA4ZnM1MXTcO8K4hcwpzG+RqbzlUDUqkLgWGaG6nSCW1fw7NwLyQSbJLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GvlNxKKD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GvlNxKKD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DBDFC4CEE7;
	Mon, 12 May 2025 22:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747088997;
	bh=fgi1DZqDwGUgu21rqKkdjjWXremFGdikMmfuGW8A/9Y=;
	h=Date:To:From:Subject:From;
	b=GvlNxKKDkAxyHakgzcGavnqpqiqFwHIFo6pM35P8Ix8bCKeMnuc4WuLUZAm47OVfx
	 pYo6Hn4wki98pOAMnL537gKFnDNK3SHLjAZPdwKnPGl2YhUMa2r2dkP4pd/2205rFu
	 PG5whNqJ0OdlWoLWUd41KsPjGdcEZL4J3XNpN8sw=
Date: Mon, 12 May 2025 15:29:57 -0700
To: mm-commits@vger.kernel.org,yunjeong.mun@sk.com,ying.huang@linux.alibaba.com,osalvador@suse.de,lenb@kernel.org,Jonathan.Cameron@huawei.com,honggyu.kim@sk.com,hannes@cmpxchg.org,gregkh@linuxfoundation.org,gourry@gourry.net,dave.jiang@intel.com,dan.j.williams@intel.com,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-weighted-interleave-auto-tuning-fix-2.patch added to mm-unstable branch
Message-Id: <20250512222957.9DBDFC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-mempolicy-weighted-interleave-auto-tuning-fix-2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mempolicy-weighted-interleave-auto-tuning-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-weighted-interleave-auto-tuning-fix-2.patch

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
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: mm-mempolicy-weighted-interleave-auto-tuning-fix-2
Date: Mon, 12 May 2025 07:25:10 -0700

remove auto_kobj_attr field from struct sysfs_wi_group

Link: https://lkml.kernel.org/r/20250512142511.3959833-1-joshua.hahnjy@gmail.com
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Yunjeong Mun <yunjeong.mun@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-weighted-interleave-auto-tuning-fix-2
+++ a/mm/mempolicy.c
@@ -3543,7 +3543,6 @@ struct iw_node_attr {
 struct sysfs_wi_group {
 	struct kobject wi_kobj;
 	struct mutex kobj_lock;
-	struct kobj_attribute auto_kobj_attr;
 	struct iw_node_attr *nattrs[];
 };
 
@@ -3833,7 +3832,6 @@ static int __init add_weighted_interleav
 	err = sysfs_create_file(&wi_group->wi_kobj, &wi_auto_attr.attr);
 	if (err)
 		goto err_put_kobj;
-	wi_group->auto_kobj_attr = wi_auto_attr;
 
 	for_each_online_node(nid) {
 		if (!node_state(nid, N_MEMORY))
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are

mm-mempolicy-weighted-interleave-auto-tuning.patch
mm-mempolicy-weighted-interleave-auto-tuning-fix.patch
mm-mempolicy-weighted-interleave-auto-tuning-fix-2.patch

