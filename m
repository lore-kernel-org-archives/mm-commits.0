Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35BF8528E
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 19:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744052746; cv=none; b=uoPw1UdJENjwdkarlEmuAw2T3JPElcSZW3JIxKwTbr8Ex+hztNFCQlkFs0s8HwR+6E9HO0J3tR0W6aotsafKzmOR3MVakK7eudTcHg5xtKt9yi9dALPIWNPhxA49U0pbpU66WhLrmV+Tv79iT+jaPTYinqHgf5eMfVO7NOyy+tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744052746; c=relaxed/simple;
	bh=GoDRcMyKS6MouLlC7VchHeOisgBDtrpitH+lridTD6U=;
	h=Date:To:From:Subject:Message-Id; b=rnPFQqvNzSWAdhW1S9i5jz7aTgreDlMs8TJ4Yfxqr5yI7wKb98taH+SFruvNKfM+vaTDtIRGOkNj3K1fJhR+k9S1/p0LPUnGiZOIHEX8047znfyhxjUEp754oU5wy6PQe1Bj3d0cDGTajdx3Ge89814N8h4vaA1vmjmzvi/B8mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=utN42XSw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="utN42XSw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50506C4CEDD;
	Mon,  7 Apr 2025 19:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744052745;
	bh=GoDRcMyKS6MouLlC7VchHeOisgBDtrpitH+lridTD6U=;
	h=Date:To:From:Subject:From;
	b=utN42XSwnSv7dPiBLHzEjTNA9SOMPs9xInj/ahGdL5jftnEV17PuUOon/+iwtLU+C
	 wA2700WOeWZvkXEBczTHq0d2gd+tL9qQlhzQ2HqutgygZ/ZAyz5Szr8rkKqahwwm4r
	 zDrjUFhHcPuIAp9FD9bD2Eo28mGhTHXTuXBMNtik=
Date: Mon, 07 Apr 2025 12:05:44 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,wangxuewen@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-add-a-line-break-at-the-end-of-the-format-string.patch added to mm-hotfixes-unstable branch
Message-Id: <20250407190545.50506C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: add a line break at the end of the format string
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-add-a-line-break-at-the-end-of-the-format-string.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-add-a-line-break-at-the-end-of-the-format-string.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

mm-hugetlb-add-a-line-break-at-the-end-of-the-format-string.patch

