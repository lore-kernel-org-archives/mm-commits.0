Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9424C22089
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957065; cv=none; b=HQBKBeaZsiZ4pojiktyNWNPAO4OEgnmYrcYnW3sJGp92unvpvqWkNGu8BgukSmUATCITDjdcvr3VmCgNE078XzW418eTOYah/6SXAdnOY0gCkeFk1meyjz/k2iTLG12quIccckXp2eWE2jkCEcgpiaiHT4mn70Z9W+xx0B+SbHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957065; c=relaxed/simple;
	bh=IkgPUAIqiiPIzof4yjzKUoKJ2yyG8IWrPq6OWYVtZ3A=;
	h=Date:To:From:Subject:Message-Id; b=tsUrRWcTt3WRdfptC1pJgcx1z85HWctXfaazo3syGNtpvEeKD+584cHdCO9zQnqaAVRbgbHOX8F7OnDh3/n7Fdi7aWsVsQWu9qIIVB2uswGWKEqmfusI7q1btfihsb6Us+JSxAARcYgPD33MV/B3T2h5Ga37JqYvCQi7Z2If8Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LCBTl90r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LCBTl90r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67975C113CC;
	Mon,  6 May 2024 00:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957065;
	bh=IkgPUAIqiiPIzof4yjzKUoKJ2yyG8IWrPq6OWYVtZ3A=;
	h=Date:To:From:Subject:From;
	b=LCBTl90ra3gIdihgcqVBOarrTb7btNZJvl+wq5kr1XN1yoYR4R904ba7yNQaAp5xj
	 Lp/XR7+uljlrUwO/4IzswV/jbMymW4KGfNGv0jQ7EBQVVWBXFJEZkkt/u+Cm+75MgJ
	 aCjWm6r0NJAqjIQ6Zq4LyQTns4XyiJVkaNwTDbk4=
Date: Sun, 05 May 2024 17:57:44 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,osalvador@suse.de,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-guard-the-size-of-mem_section-is-power-of-2.patch removed from -mm tree
Message-Id: <20240506005745.67975C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse: guard the size of mem_section is power of 2
has been removed from the -mm tree.  Its filename was
     mm-sparse-guard-the-size-of-mem_section-is-power-of-2.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/sparse: guard the size of mem_section is power of 2
Date: Tue, 16 Apr 2024 01:25:59 +0000

We usually have this check, while commit 2a3cb8baef71 ("mm/sparse: delete
old sparse_init and enable new one") missed to take it.

Link: https://lkml.kernel.org/r/20240416012559.4536-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/sparse.c~mm-sparse-guard-the-size-of-mem_section-is-power-of-2
+++ a/mm/sparse.c
@@ -560,6 +560,8 @@ void __init sparse_init(void)
 	unsigned long pnum_end, pnum_begin, map_count = 1;
 	int nid_begin;
 
+	/* see include/linux/mmzone.h 'struct mem_section' definition */
+	BUILD_BUG_ON(!is_power_of_2(sizeof(struct mem_section)));
 	memblocks_present();
 
 	pnum_begin = first_present_section_nr();
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


