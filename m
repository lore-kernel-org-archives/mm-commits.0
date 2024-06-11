Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E9B15217E
	for <mm-commits@vger.kernel.org>; Tue, 11 Jun 2024 20:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718137722; cv=none; b=OH9uttTaDoTvNMF2kiAPRNXfee/1EZmOLPsQIgBYZVUQXDzk9Sw3f1w4NYsLdrKUHvHC8bcX8z8WjHp5BsTn9A59XyRoVCJJmtvhQ4wWAg6mAWIT2jJ16hvPGsYoRXEgBqX7aVel+i36CpBYmqNAje7jDk3JNWM4We03kbrZBj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718137722; c=relaxed/simple;
	bh=4EXQzLvqD22/O4QWdKn7g75Lx3VZI9EueN9mWHlBOHc=;
	h=Date:To:From:Subject:Message-Id; b=gEA1cHpbriW1wuNBgi6WTTYCR3bDhgjrdn0v40w9Od4uJFXeh36ZCiWv2wBcM1kkPKJnk6X35/KY7zO6CzvGUGnJaRCNcTUXtqJZKSwm1uMHGDTMYYtTBwcKHiar6ngupAioFOgMiRAsdc3Y8Im3Gp3b+5EIxht7t0Fv9myRvCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ySO6vREy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ySO6vREy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D1BC4AF4D;
	Tue, 11 Jun 2024 20:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718137722;
	bh=4EXQzLvqD22/O4QWdKn7g75Lx3VZI9EueN9mWHlBOHc=;
	h=Date:To:From:Subject:From;
	b=ySO6vREyZDYsBoJckCu1+gbgEHpeJ9wT8J0uE2yh1jkKmTkFZAPsPEGuPQUmctJC7
	 9IK1hvolfEymkIYRCfrUwhYlv2pY/4r6PtuqctIQ9/KFBA8kEDtpz6b+WNDoMGNeck
	 tV1kmr/rp5yJ5o01l89in+zFzQTjIBcOpeqLPxBQ=
Date: Tue, 11 Jun 2024 13:28:40 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,nphamcs@gmail.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,chengming.zhou@linux.dev,baohua@kernel.org,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-rename-is_zswap_enabled-to-zswap_is_enabled.patch added to mm-unstable branch
Message-Id: <20240611202842.41D1BC4AF4D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: rename is_zswap_enabled() to zswap_is_enabled()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-rename-is_zswap_enabled-to-zswap_is_enabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-rename-is_zswap_enabled-to-zswap_is_enabled.patch

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
Subject: mm: zswap: rename is_zswap_enabled() to zswap_is_enabled()
Date: Tue, 11 Jun 2024 02:45:14 +0000

In preparation for introducing a similar function, rename
is_zswap_enabled() to use zswap_* prefix like other zswap functions.

Link: https://lkml.kernel.org/r/20240611024516.1375191-1-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zswap.h |    4 ++--
 mm/memcontrol.c       |    2 +-
 mm/zswap.c            |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/zswap.h~mm-zswap-rename-is_zswap_enabled-to-zswap_is_enabled
+++ a/include/linux/zswap.h
@@ -35,7 +35,7 @@ void zswap_swapoff(int type);
 void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg);
 void zswap_lruvec_state_init(struct lruvec *lruvec);
 void zswap_folio_swapin(struct folio *folio);
-bool is_zswap_enabled(void);
+bool zswap_is_enabled(void);
 #else
 
 struct zswap_lruvec_state {};
@@ -60,7 +60,7 @@ static inline void zswap_memcg_offline_c
 static inline void zswap_lruvec_state_init(struct lruvec *lruvec) {}
 static inline void zswap_folio_swapin(struct folio *folio) {}
 
-static inline bool is_zswap_enabled(void)
+static inline bool zswap_is_enabled(void)
 {
 	return false;
 }
--- a/mm/memcontrol.c~mm-zswap-rename-is_zswap_enabled-to-zswap_is_enabled
+++ a/mm/memcontrol.c
@@ -8434,7 +8434,7 @@ void obj_cgroup_uncharge_zswap(struct ob
 bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg)
 {
 	/* if zswap is disabled, do not block pages going to the swapping device */
-	return !is_zswap_enabled() || !memcg || READ_ONCE(memcg->zswap_writeback);
+	return !zswap_is_enabled() || !memcg || READ_ONCE(memcg->zswap_writeback);
 }
 
 static u64 zswap_current_read(struct cgroup_subsys_state *css,
--- a/mm/zswap.c~mm-zswap-rename-is_zswap_enabled-to-zswap_is_enabled
+++ a/mm/zswap.c
@@ -131,7 +131,7 @@ static bool zswap_shrinker_enabled = IS_
 		CONFIG_ZSWAP_SHRINKER_DEFAULT_ON);
 module_param_named(shrinker_enabled, zswap_shrinker_enabled, bool, 0644);
 
-bool is_zswap_enabled(void)
+bool zswap_is_enabled(void)
 {
 	return zswap_enabled;
 }
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-zswap-use-sg_set_folio-in-zswap_compress-decompress.patch
mm-zswap-use-kmap_local_folio-in-zswap_load.patch
mm-zswap-make-same_filled-functions-folio-friendly.patch
mm-rmap-abstract-updating-per-node-and-per-memcg-stats.patch
mm-swap-remove-synchronous-argument-to-swap_read_folio.patch
mm-zswap-rename-is_zswap_enabled-to-zswap_is_enabled.patch
mm-zswap-add-zswap_never_enabled.patch
mm-zswap-handle-incorrect-attempts-to-load-large-folios.patch

