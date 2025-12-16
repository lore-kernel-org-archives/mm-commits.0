Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAB631280E
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 04:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765859240; cv=none; b=OBdRakjJSbozB+vTpOReFUgm8BbsQtUfl7hA8REyS7KBngYSYvH3RugEaMbzLoNyJcwO2DafYYObrWjP+LqVeM2JdC64SsBkS0ODGkgbozRM6BpOeJ2w6TW+v+uCA3FX0cOOR6t9v8wDJJ+1QgOC7YbDEX6CRP7abAnYYvgQtPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765859240; c=relaxed/simple;
	bh=TAhVancRH+eDJ4DC6pfjopd+4YNayUmCOILZOTL9ozc=;
	h=Date:To:From:Subject:Message-Id; b=QRt1RM4XViZkB3zgLQYv7KGBcqGFU05cSfDA1Qr8m5srSVXDIOiJXw07GSvyvAYD0HKdv8cE7vXaaT28TA1iTLwYZV/FzmrehUMainJWqaa9WFvNjBFFegalxxFkeqXMR3li+1oAS8KaY3unFKNu7TD5zQkQ24+FSPJQNSenxKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k79Ww3ht; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k79Ww3ht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6622C4CEF1;
	Tue, 16 Dec 2025 04:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765859239;
	bh=TAhVancRH+eDJ4DC6pfjopd+4YNayUmCOILZOTL9ozc=;
	h=Date:To:From:Subject:From;
	b=k79Ww3htQQhn0AGQ4lb3lRYrRjDm/Pf4fiCiDuOAdaAh/MJhu/Qy79yRZhxH/MIig
	 ffy1biYBLHpDWSb81B3DDcNLx8wfXV78NvDQsTqi76kMnpn0jdewKJf4hEOR8EA/0x
	 4RJWsZ8/YcyaIZ1wl6PikIZc7pY/Wp3WSfu/LJAw=
Date: Mon, 15 Dec 2025 20:27:19 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,nphamcs@gmail.com,chengming.zhou@linux.dev,anshuman.khandual@arm.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-delete-unused-acomp-is_sleepable.patch added to mm-new branch
Message-Id: <20251216042719.C6622C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: delete unused acomp->is_sleepable
has been added to the -mm mm-new branch.  Its filename is
     mm-zswap-delete-unused-acomp-is_sleepable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-delete-unused-acomp-is_sleepable.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zswap: delete unused acomp->is_sleepable
Date: Wed, 10 Dec 2025 21:56:45 -0500

This hasn't been used since 7d4c9629b74f ("mm: zswap: use object
read/write APIs instead of object mapping APIs").  Drop it.

Link: https://lkml.kernel.org/r/20251211025645.820517-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/zswap.c~mm-zswap-delete-unused-acomp-is_sleepable
+++ a/mm/zswap.c
@@ -141,7 +141,6 @@ struct crypto_acomp_ctx {
 	struct crypto_wait wait;
 	u8 *buffer;
 	struct mutex mutex;
-	bool is_sleepable;
 };
 
 /*
@@ -781,7 +780,6 @@ static int zswap_cpu_comp_prepare(unsign
 
 	acomp_ctx->buffer = buffer;
 	acomp_ctx->acomp = acomp;
-	acomp_ctx->is_sleepable = acomp_is_async(acomp);
 	acomp_ctx->req = req;
 	mutex_unlock(&acomp_ctx->mutex);
 	return 0;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-zswap-delete-unused-acomp-is_sleepable.patch
mm-memcontrol-rename-mem_cgroup_from_slab_obj.patch

