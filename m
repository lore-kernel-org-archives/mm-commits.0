Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4102D3BBD7
	for <mm-commits@vger.kernel.org>; Tue, 19 Mar 2024 21:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710884933; cv=none; b=drFVxz9kZqNLembA5aPdozob24csaO6NQd5kFPVAwq9H/PrN3tI3YAYVLOZppf4cMi2Qjtr1ONkiHX22PzfIf9Q8vyJk7p2f6hVIJdbiM5/N/aeQTaJgMALOl6Bn/d80hFusXJLitFLtqY1NS/WYFf54lA6LxfrAxdrrKfNjths=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710884933; c=relaxed/simple;
	bh=vQDodFsyOUsoWcVSBBywktdBihJPmc3SP23kP+1LGaE=;
	h=Date:To:From:Subject:Message-Id; b=sExWYjFiKeeWtRgnNMg+/SKscrd8vOngvti7tfJbQcfnj6K51fapDnujkryRlnQqeTgS8p/pe8TLJ7ST4q9uJx9qH53BAoJNk7S3/ko+w8hK0yuHP2Tp4bB6iF9hqASYgPbvIVV4JIvysQxzC5BVRLZRbqee/de0Rm3egFMTPx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dE2oM82o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dE2oM82o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A6B6C433F1;
	Tue, 19 Mar 2024 21:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710884932;
	bh=vQDodFsyOUsoWcVSBBywktdBihJPmc3SP23kP+1LGaE=;
	h=Date:To:From:Subject:From;
	b=dE2oM82oRskA1o4wpsCHCB1fmLhI9g+iELIPgHchU6n+ANdXwxytZswWMpmUcl2Sv
	 5lfrS9NhOhbyzZ8Yn2U8UtVGzkLef1DfK18QZqirMkHioiEgNyhmRGf1GPYE0iQq2p
	 uW1Ip6lnXYwevEfbuqn94lVdr0PIM3Osa+qwXMXI=
Date: Tue, 19 Mar 2024 14:48:52 -0700
To: mm-commits@vger.kernel.org,nphamcs@gmail.com,hannes@cmpxchg.org,chengming.zhou@linux.dev,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-remove-unnecessary-check-in-zswap_find_zpool.patch added to mm-unstable branch
Message-Id: <20240319214852.9A6B6C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: remove unnecessary check in zswap_find_zpool()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-remove-unnecessary-check-in-zswap_find_zpool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-remove-unnecessary-check-in-zswap_find_zpool.patch

This patch will later appear in the mm-unstable branch at
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
Subject: mm: zswap: remove unnecessary check in zswap_find_zpool()
Date: Mon, 11 Mar 2024 23:52:10 +0000

zswap_find_zpool() checks if ZSWAP_NR_ZPOOLS > 1, which is always true. 
This is a remnant from a patch version that had ZSWAP_NR_ZPOOLS as a
config option and never made it upstream.  Remove the unnecessary check.

Link: https://lkml.kernel.org/r/20240311235210.2937484-1-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/mm/zswap.c~mm-zswap-remove-unnecessary-check-in-zswap_find_zpool
+++ a/mm/zswap.c
@@ -871,12 +871,7 @@ static void zswap_entry_cache_free(struc
 
 static struct zpool *zswap_find_zpool(struct zswap_entry *entry)
 {
-	int i = 0;
-
-	if (ZSWAP_NR_ZPOOLS > 1)
-		i = hash_ptr(entry, ilog2(ZSWAP_NR_ZPOOLS));
-
-	return entry->pool->zpools[i];
+	return entry->pool->zpools[hash_ptr(entry, ilog2(ZSWAP_NR_ZPOOLS))];
 }
 
 /*
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-memcg-add-null-check-to-obj_cgroup_put.patch
mm-zswap-remove-unnecessary-check-in-zswap_find_zpool.patch

