Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47C33597B
	for <mm-commits@vger.kernel.org>; Sat, 12 Apr 2025 00:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744418025; cv=none; b=Fhjr+7Y64seAvmhwIhzDKcGmHuqMoRB9GT5Zr3s7SXUTsRydNrLQ411RCa+kLrgk8ASm7rWAWuYmjxx9MMVuAOBofixAnCcK+NpSNubDfMJuceplXp0ZDBn4NopUf0MNMPxYpIyhpSomAF2aml2Vr/tT4v5xkRAjun8osSwTggk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744418025; c=relaxed/simple;
	bh=KB7BvlfV34VPvxFVcCdejoEcb8zNwp8Y99sEHnVVd0k=;
	h=Date:To:From:Subject:Message-Id; b=OC7di9KhWdHwAS5evsJsVAxTP4thcJDctZL5VU2IFRpLs8FoiTnirM5TFiuzWaiZAuT5tFtf5mcPqRC5H0a9QwUn6AF3aTghubKFbtQy3mBs0n9mZbEdu6IzpICDiE2Jy91Z7F/OqyKX6a9B1iPFemOR/jJ5lcyNI3SXHOakHgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NrUss+c5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NrUss+c5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 893DAC4CEE2;
	Sat, 12 Apr 2025 00:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744418025;
	bh=KB7BvlfV34VPvxFVcCdejoEcb8zNwp8Y99sEHnVVd0k=;
	h=Date:To:From:Subject:From;
	b=NrUss+c5e485dEhd668T4qR57KaeQF2zYZzT4JlA1vcPctZpTLw0IV8RGPn/3M036
	 TM4W39zdDLrdnOXBTD6tJlUhARUrx3HgTaWCsfMUI78RGJgt861x46WvDArnPuExW+
	 bSkaIJx+z+6B6eDA/ZrQTdoH/i2P4wmVGIkK+8NI=
Date: Fri, 11 Apr 2025 17:33:45 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,wangxuewen@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-add-a-line-break-at-the-end-of-the-format-string.patch removed from -mm tree
Message-Id: <20250412003345.893DAC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: add a line break at the end of the format string
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-a-line-break-at-the-end-of-the-format-string.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: wangxuewen <wangxuewen@kylinos.cn>
Subject: mm/hugetlb: add a line break at the end of the format string
Date: Mon, 7 Apr 2025 18:30:17 +0800

Missing line break at the end of the format string.

Link: https://lkml.kernel.org/r/20250407103017.2979821-1-18810879172@163.com
Signed-off-by: wangxuewen <wangxuewen@kylinos.cn>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-add-a-line-break-at-the-end-of-the-format-string
+++ a/mm/hugetlb.c
@@ -4647,7 +4647,7 @@ static void __init hugetlb_sysfs_init(vo
 		err = hugetlb_sysfs_add_hstate(h, hugepages_kobj,
 					 hstate_kobjs, &hstate_attr_group);
 		if (err)
-			pr_err("HugeTLB: Unable to add hstate %s", h->name);
+			pr_err("HugeTLB: Unable to add hstate %s\n", h->name);
 	}
 
 #ifdef CONFIG_NUMA
_

Patches currently in -mm which might be from wangxuewen@kylinos.cn are


