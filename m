Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACE9207A28;
	Tue,  1 Apr 2025 22:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743545713; cv=none; b=nYWzNqx5rDLy38jI5ZhssT1vMQ6IkBuUBexdL0KHI+g6IgGNMR7U1lTOM3UJhcHH+jKVlMNjQQzBaSUAVbC2cUl9nWRUir1druNyYT/iGDiVYNI4jxBDYWbCH4DxaVGpbZ52GsWWqY4HtoF3NJ8UIZ1kCyRPZROVWyp5vvszqMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743545713; c=relaxed/simple;
	bh=u4TsnAY2bAXGX+/yqr1XECvD3gqQMeK64whKC72vq00=;
	h=Date:To:From:Subject:Message-Id; b=pmwyZ2kE7mrJ3Yvqml/HsyiOq+lF1rCTFlY/hg1W/CG0VefC+nMoInHlRV0dEoME6VU1LADqhkdm5Hg02hRDy5qsbZ3tAL+oc4KTi7DEEBJ0q5+TBM+7ykdtlGsX2NT99EIYcLXqO3VN92G6KC63cwB/b/DRcwU6EX17uxXxgPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BYSbvTXe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BYSbvTXe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F36C4CEE8;
	Tue,  1 Apr 2025 22:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743545712;
	bh=u4TsnAY2bAXGX+/yqr1XECvD3gqQMeK64whKC72vq00=;
	h=Date:To:From:Subject:From;
	b=BYSbvTXegC/pMfrK6y+znsbWWXW11RlxKUe8dNLDGpAMoxxco+bG6tGqWHMiQ9N1V
	 G4+3f9Ps2M5zwhwfMDY4AgaUt3TVBbEul8tC2uw2VIg0iB47JNPuoz25DyNhl7GAY1
	 Oza9pGEZRx8viwtWikhxoXSK9hIzymRMdtSNE5hs=
Date: Tue, 01 Apr 2025 15:15:12 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,muchun.song@linux.dev,anshuman.khandual@arm.com,Marc.Herbert@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-move-hugetlb_sysctl_init-to-the-__init-section.patch removed from -mm tree
Message-Id: <20250401221512.B1F36C4CEE8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: move hugetlb_sysctl_init() to the __init section
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-move-hugetlb_sysctl_init-to-the-__init-section.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Marc Herbert <Marc.Herbert@linux.intel.com>
Subject: mm/hugetlb: move hugetlb_sysctl_init() to the __init section
Date: Wed, 19 Mar 2025 06:00:30 +0000

hugetlb_sysctl_init() is only invoked once by an __init function and is
merely a wrapper around another __init function so there is not reason to
keep it.

Fixes the following warning when toning down some GCC inline options:

 WARNING: modpost: vmlinux: section mismatch in reference:
   hugetlb_sysctl_init+0x1b (section: .text) ->
     __register_sysctl_init (section: .init.text)

Link: https://lkml.kernel.org/r/20250319060041.2737320-1-marc.herbert@linux.intel.com
Signed-off-by: Marc Herbert <Marc.Herbert@linux.intel.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-move-hugetlb_sysctl_init-to-the-__init-section
+++ a/mm/hugetlb.c
@@ -5179,7 +5179,7 @@ static const struct ctl_table hugetlb_ta
 	},
 };
 
-static void hugetlb_sysctl_init(void)
+static void __init hugetlb_sysctl_init(void)
 {
 	register_sysctl_init("vm", hugetlb_table);
 }
_

Patches currently in -mm which might be from Marc.Herbert@linux.intel.com are


