Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FCF34677A
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966098; cv=none; b=SzhM1Br5WZyFq/OdHsxuHMUcg8Vztss7Vd47Wx9i5/Tpyp0IhouiGr9/pe099rZCSYFDLwpw9NXMXs5W8+XJ1v+pTV+VehFABsh1pHD/lYy0rKy11JcP4kcKB0ICqV8bkgiC6O9e//tKOYPSq5ogzYT8hemRv+uO6skh7WHAWhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966098; c=relaxed/simple;
	bh=4qDGdEZyCGGrhM6sWqylsxiedCQrfjgP4EQFBffPPSk=;
	h=Date:To:From:Subject:Message-Id; b=cs7Gft7RmduMkPuZ4eR7jBWDzea0zjoX29o3/R/ZwHAZN+7up87STePsz7rAp+n90S2pGvNY92we80waDpWbkzJgbFEc3z1s494cW/KQ4ETglZSy57YXQSn6qBbe6UpGb4hiL4ztzsdKcoJKTGEegZ/OfwEhMQowcluQ4GhKRl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0+t2agOu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0+t2agOu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504B3C16AAE;
	Wed, 21 Jan 2026 03:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966098;
	bh=4qDGdEZyCGGrhM6sWqylsxiedCQrfjgP4EQFBffPPSk=;
	h=Date:To:From:Subject:From;
	b=0+t2agOums81pXEu0WclgqG+k8Xhi2EvA8YFN/5u4hk/A7lZIe0kZgtgn0+Jkk944
	 SVtfxLluqYaG5n70cRid0cVuLfWrqMX5lPQjOR6LdOqtEWSN8mkQUgQFccYOYPhKhG
	 Jy62em/7F72IGZrQNFr5ART2JajND/RD630MX8xc=
Date: Tue, 20 Jan 2026 19:28:17 -0800
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,lkp@intel.com,david@kernel.org,akpm@linux-foundation.org,xiujianfeng@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_cgroup-fix-wformat-truncation-warning.patch removed from -mm tree
Message-Id: <20260121032818.504B3C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb_cgroup: fix -Wformat-truncation warning
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_cgroup-fix-wformat-truncation-warning.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xiu Jianfeng <xiujianfeng@huawei.com>
Subject: mm/hugetlb_cgroup: fix -Wformat-truncation warning
Date: Mon, 22 Dec 2025 07:23:59 +0000

A false-positive compile warnings with -Wformat-trucation was introduced
by commit 47179fe03588 ("mm/hugetlb_cgroup: prepare cftypes based on
template") on arch s390.  Suppress it by replacing snprintf() with
scnprintf().

mm/hugetlb_cgroup.c: In function 'hugetlb_cgroup_file_init':
mm/hugetlb_cgroup.c:829:44: warning: '%s' directive output may be truncated writing up to 1623 bytes into a region of size between 32 and 63 [-Wformat-truncation=]
  829 |   snprintf(cft->name, MAX_CFTYPE_NAME, "%s.%s", buf, tmpl->name);
      |                                            ^~

Link: https://lkml.kernel.org/r/20251222072359.3626182-1-xiujianfeng@huaweicloud.com
Fixes: 47179fe03588 ("mm/hugetlb_cgroup: prepare cftypes based on template")
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202512212332.9lFRbgdS-lkp@intel.com/
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb_cgroup.c~mm-hugetlb_cgroup-fix-wformat-truncation-warning
+++ a/mm/hugetlb_cgroup.c
@@ -822,7 +822,7 @@ hugetlb_cgroup_cfttypes_init(struct hsta
 	for (i = 0; i < tmpl_size; cft++, tmpl++, i++) {
 		*cft = *tmpl;
 		/* rebuild the name */
-		snprintf(cft->name, MAX_CFTYPE_NAME, "%s.%s", buf, tmpl->name);
+		scnprintf(cft->name, MAX_CFTYPE_NAME, "%s.%s", buf, tmpl->name);
 		/* rebuild the private */
 		cft->private = MEMFILE_PRIVATE(idx, tmpl->private);
 		/* rebuild the file_offset */
_

Patches currently in -mm which might be from xiujianfeng@huawei.com are


