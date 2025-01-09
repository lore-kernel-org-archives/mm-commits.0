Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B12921345
	for <mm-commits@vger.kernel.org>; Thu,  9 Jan 2025 02:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736388530; cv=none; b=XokQsy6BJOFlw3caTnrBR92J8dXw6vWdnhM4E/of3wh8I4Cm7YYzktFAelikMiJk6iJvU92KiGkI2OYxTvkInUVUXkwdChcChH/4630sE/e32eqfBrNxMpdAHsXeH0ZVGHcHvluD3U2/h9dcuBdoPOXCNr5VCrB6Pu2g0go2lMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736388530; c=relaxed/simple;
	bh=UcdfBsSroXy+UrhrKP1MHT5mnqboE1dpXdV8JkpX/Pc=;
	h=Date:To:From:Subject:Message-Id; b=IK+s4pYPigcfrwO+zEtZwpid0IEi0tCkBZj4aT9Vno7sOlOhjan6sYt6XTj7s7BnbCLXoolo8FtIV1S1sy4h2ryvY0XhghfDtWq3c7qQLGKYA9FkZriOBwPg9eUmDUU+gOG6qHtffrwu9vDdVK9ukYv7thxhcgPqV4KBzS9aXTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KsOWgGel; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KsOWgGel"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD069C4CED3;
	Thu,  9 Jan 2025 02:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736388529;
	bh=UcdfBsSroXy+UrhrKP1MHT5mnqboE1dpXdV8JkpX/Pc=;
	h=Date:To:From:Subject:From;
	b=KsOWgGelFxkM+CxK6c5ZPh0P7ZuO9cA7ieBhyV1/gms+tP8O4BHLujTOqCWNz6/q3
	 wY96tpg0x6dV2TFpE3RCj5eBUsfNpay8n2iYNoue4pfamhk9YhofrfiT76Clq2ZH5f
	 9KmLBcsPSil5SbsLHVUVz39OuCAjFrdk7kOkRqcc=
Date: Wed, 08 Jan 2025 18:08:49 -0800
To: mm-commits@vger.kernel.org,vitalywool@gmail.com,samsun1006219@gmail.com,nphamcs@gmail.com,kanchana.p.sridhar@intel.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,baohua@kernel.org,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-properly-synchronize-freeing-resources-during-cpu-hotunplug-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20250109020849.AD069C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-zswap-properly-synchronize-freeing-resources-during-cpu-hotunplug-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-zswap-properly-synchronize-freeing-resources-during-cpu-hotunplug-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-properly-synchronize-freeing-resources-during-cpu-hotunplug-fix.patch

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
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm-zswap-properly-synchronize-freeing-resources-during-cpu-hotunplug-fix
Date: Wed, 8 Jan 2025 16:25:56 -0800

remove comment

Link: https://lkml.kernel.org/r/CAJD7tkaxS1wjn+swugt8QCvQ-rVF5RZnjxwPGX17k8x9zSManA@mail.gmail.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Sam Sun <samsun1006219@gmail.com>
Cc: Vitaly Wool <vitalywool@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/zswap.c~mm-zswap-properly-synchronize-freeing-resources-during-cpu-hotunplug-fix
+++ a/mm/zswap.c
@@ -848,8 +848,6 @@ static int zswap_cpu_comp_prepare(unsign
 		ret = -ENOMEM;
 		goto req_fail;
 	}
-
-	/* acomp_ctx->req must be NULL if the acomp_ctx is not fully initialized */
 	acomp_ctx->req = req;
 
 	crypto_init_wait(&acomp_ctx->wait);
_

Patches currently in -mm which might be from yosryahmed@google.com are

revert-mm-zswap-fix-race-between-compression-and-cpu-hotunplug.patch
mm-zswap-properly-synchronize-freeing-resources-during-cpu-hotunplug.patch
mm-zswap-properly-synchronize-freeing-resources-during-cpu-hotunplug-fix.patch

