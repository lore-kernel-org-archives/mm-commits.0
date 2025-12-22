Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5EF2BE03D
	for <mm-commits@vger.kernel.org>; Mon, 22 Dec 2025 19:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766430934; cv=none; b=QLH1P1j6EZN69xwRxAa1RAEwsRWM4//0T6jF9uXsclp36FyrBmZ5icV1zDqQcSiv1fgh7YeRnvq6mQUbkn/RBEBwCJz6tz7UIWqs483djCgcxCTOhbRXE6uuH+IZb5sBNJ6DT83cgCPKmVqUh8mBjoSgL+hmhlATkudrYIZGSsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766430934; c=relaxed/simple;
	bh=m1CGRxCnPdk+vhPRmZjgEkfKi0iYKsJDYRWInGVjzCU=;
	h=Date:To:From:Subject:Message-Id; b=qZ+KyKZpP9wiEKxlkdARp8DCUD63m+FldjsW5VGflFUiZ3XEveq3iTFidCTF5d7gFi04jMppS6jq6mGXFeQ8zdh9kwFgeE1IPJm4mH1ApVhFSwDEK4Q/GfXPKLsIA7iigLhFvb1+X36Dyuyr40Ppb1asDf18RNwqWICaFX0YMmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DcfpiFOb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DcfpiFOb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC99C116D0;
	Mon, 22 Dec 2025 19:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766430934;
	bh=m1CGRxCnPdk+vhPRmZjgEkfKi0iYKsJDYRWInGVjzCU=;
	h=Date:To:From:Subject:From;
	b=DcfpiFObn5CQAn6dPrea+mwuHXyBscr9Lc5WDu948mMwS2s6SWHbnfweg1sfgjJWu
	 zb6ciQpHlsAMFyPnT+qZVEZ7TB3/12OVO4jG5OpEdo0uJqkmo3HflqdEinCch1AAJb
	 lkfPveYIcE9If1AADZpiHLeBDt7kM7bAXtxoFcrI=
Date: Mon, 22 Dec 2025 11:15:33 -0800
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,lkp@intel.com,david@kernel.org,xiujianfeng@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_cgroup-fix-wformat-truncation-warning.patch added to mm-unstable branch
Message-Id: <20251222191534.2AC99C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb_cgroup: fix -Wformat-truncation warning
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_cgroup-fix-wformat-truncation-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_cgroup-fix-wformat-truncation-warning.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

mm-hugetlb_cgroup-fix-wformat-truncation-warning.patch

