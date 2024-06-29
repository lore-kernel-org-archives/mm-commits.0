Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F97228E3
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628223; cv=none; b=GwxNU2uFHYhJM1xRaDBlTxgE3Cqa2xS7EE8R0eWo9fnfijxIHGM91WYlSSiE/6H6SI1BIiHol8Cm6K7C+IkRwM4GSibHG5zx8d1WibsetgEAtK2r/5fAeTTEgu8FcKVttxbIMB8Vd5KLzwPMSHoXPckk5+iRj6U7rDgBIFxA3SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628223; c=relaxed/simple;
	bh=iNGrWIkE6yJwTFdStzqtKLyxbhaGG7TTVXENmVkiOAI=;
	h=Date:To:From:Subject:Message-Id; b=lMcLiTCFbHCoMQOPYiZ0GDIVLxCYUXKTsj3Vpdue/D7N4fS2NNHAYJpTFT0Z+5/4eTAe7HjD8Uh8AaDOoXNRHdbBGNr2CKIdWo6Egv2h5yoh3PvpBpn4L2o2qMge6mjp0wtnoGA0f1FY989W+Z3vqoiK0ebHqz/eMOr3PIN2gQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wWz5ar/S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wWz5ar/S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC38C32786;
	Sat, 29 Jun 2024 02:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628223;
	bh=iNGrWIkE6yJwTFdStzqtKLyxbhaGG7TTVXENmVkiOAI=;
	h=Date:To:From:Subject:From;
	b=wWz5ar/SnVCNBC7Jo5XeAedwrx1WAdFUu0DPVmHSDQAEQEzWDX9M5sMV5vLKnOpPb
	 fBV+T29JCVgtDd9rxopPs2kDVeENyFzSlD74BvVQ0ztP7KeKtc/kdmp8eEvcWmfhHW
	 ga0i8Ku2cMDOZW12QXIKzxLDOMcwFv8kDkSyNCqo=
Date: Fri, 28 Jun 2024 19:30:22 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_initc-move-build-check-on-max_zonelists-out-of-ifdef.patch removed from -mm tree
Message-Id: <20240629023022.EAC38C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init.c: move build check on MAX_ZONELISTS out of ifdef
has been removed from the -mm tree.  Its filename was
     mm-mm_initc-move-build-check-on-max_zonelists-out-of-ifdef.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/mm_init.c: move build check on MAX_ZONELISTS out of ifdef
Date: Wed, 19 Jun 2024 01:06:10 +0000

Current check on MAX_ZONELISTS is wrapped in CONFIG_DEBUG_MEMORY_INIT,
which may not be triggered all the time.

Let's move it out to a more general place.

Link: https://lkml.kernel.org/r/20240619010612.20740-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mm_init.c~mm-mm_initc-move-build-check-on-max_zonelists-out-of-ifdef
+++ a/mm/mm_init.c
@@ -54,7 +54,6 @@ void __init mminit_verify_zonelist(void)
 		struct zonelist *zonelist;
 		int i, listid, zoneid;
 
-		BUILD_BUG_ON(MAX_ZONELISTS > 2);
 		for (i = 0; i < MAX_ZONELISTS * MAX_NR_ZONES; i++) {
 
 			/* Identify the zone and nodelist */
@@ -2657,6 +2656,7 @@ static void __init mem_init_print_info(v
 void __init mm_core_init(void)
 {
 	/* Initializations relying on SMP setup */
+	BUILD_BUG_ON(MAX_ZONELISTS > 2);
 	build_all_zonelists(NULL);
 	page_alloc_init_cpuhp();
 
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


