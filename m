Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDE0306776
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 06:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788243228; cv=none; b=Xe0rf5MgKlm8o2ZgHPG3dCbOcYHCns+4NxDBWy8W6IUGtKiQezb/JzTGwjVYPmxXXjrEAbXK4xJm/jMF7HA/0B9RjKH4uesvg3HbrtHj6qJmcktCDh+oW6qqq0P+/BTN2lq8lt8qSmdpebBlHqoEsq4+48i1Q4pTi9F42gHGp5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788243228; c=relaxed/simple;
	bh=sHXHnXfL+q9gS0pEHqw88Z8Fs3j7NJALVvyZ115ZvSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WymRYrutmaH6XhlCH9TPjNjOBZf50O329n6pITm78lwe37F6CKtkQJAYBbCqYTGBTesZeei78Clr2mKyICbBO5iHQP2H8AVeIx/5N+gMzEGqgtSu9A7QQ2Zt2d5SY/zLy/Ab/SZzrDo5ABJ5MB1oHA25jq/wC9m1Itk+rFj6DYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JyJ+BXPP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JyJ+BXPP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 470EB1F000E9;
	Tue,  1 Sep 2026 06:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788243226;
	bh=adTR2P64EFni8ZOZywKDurp8df9Iq2ppJ5M7V4Fyra0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JyJ+BXPPCoo282jxpZjefVV0JmiR7gzzA0nu5hdAxKJRb/x9QRlXRWAchl6EnE+J9
	 0VWPJYuFy4mu0yCGNSklTvdDUsU+7CyWN30bSftoEECV4J0EpitkbmzobS2ZhlSDvC
	 ThlhfEFv2G0AA8XUagl2Br9ExBBSmvXnV3qjp2lh2KLuhBXR70AS+XPysU5znyCQ48
	 eNwU2G4UR9SgtGl+auy1GHIJY8kvWSlPN5UNBT8M/fwcPe9Nsp+LkBoll6PWx8LNgw
	 e+IlXGnqCFW1VLn2DX0bM2UIy10bHPDgreucD2qB7YBbEl6ibwQpcanA//jJsAzZFO
	 /8pvOXxG6QPHg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	mm-commits@vger.kernel.org,
	vbabka@kernel.org,
	surenb@google.com,
	rppt@kernel.org,
	rdunlap@infradead.org,
	mhocko@suse.com,
	ljs@kernel.org,
	liam@infradead.org,
	david@kernel.org,
	corbet@lwn.net,
	gutierrez.asier@huawei-partners.com
Subject: Re: + mm-damon-introduce-damos_quota_hugepage-auto-tuning.patch added to mm-new branch
Date: Mon, 31 Aug 2026 23:13:38 -0700
Message-ID: <20260901061339.117806-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260831232424.6C29F1F000E9@smtp.kernel.org>
References: 
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello Andrew,

On Mon, 31 Aug 2026 16:24:24 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> The patch titled
>      Subject: mm/damon: introduce DAMOS_QUOTA_HUGEPAGE auto tuning
> has been added to the -mm mm-new branch.  Its filename is
>      mm-damon-introduce-damos_quota_hugepage-auto-tuning.patch
[...]
> This patch (of 3):
> 
> Introduce DAMOS_QUOTA_HUGEPAGE_MEM_BP auto tuning.  Add a new DAMOS quota
> goal metric to measure the amount of huge page consumption to total memory
> consumption ratio.
> 
> Vmstat may lag, which in some cases may lead to NR_FREE_PAGES being
> greater than or equal to the amount of RAM in the system.  A guard is
> added to avoid the extremely unlikely case [6].  In the case, return 100%
> (10000 bp).
> 
> Link: https://lore.kernel.org/20260831144732.80910-1-sj@kernel.org
> Link: https://lore.kernel.org/20260831144732.80910-2-sj@kernel.org
> Link: https://dl.acm.org/doi/pdf/10.1145/3307650.3322227 [1]
> Link: https://lore.kernel.org/e67f05ad-dbb9-45e6-ba30-b167a99ac67d@huawei-partners.com [2]
> Link: https://lore.kernel.org/20260616150316.580819-3-gutierrez.asier@huawei-partners.com [3]
> Link: https://github.com/asierHuawei/damo/commit/79ae1a4ab1c012a7161db85a000d14f08fa36736 [4]
> Link: https://lore.kernel.org/all/03f678dd-9ef3-4b97-b753-c2e4554c5159@huawei-partners.com/ [5]
> Link: https://lore.kernel.org/all/20260715151615.99767-1-sj@kernel.org/ [6]
> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> Signed-off-by: SJ Park <sj@kernel.org>
> Reviewed-by: SJ Park <sj@kernel.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Liam R. Howlett <liam@infradead.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> 
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Seems an empty line before your S-o-b: line is accidentally added.  Could we
remove that?


Thanks,
SJ

[...]
