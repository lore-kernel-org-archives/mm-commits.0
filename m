Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7EC623C70B
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837031; cv=none; b=f8l9h0IhBUBCkuKj+P7LlH763WXBg+HCB5nSt1D66fFpI6Jw1s+ILo0l20Ykq7lDhCbUHvFgTjyGsOVlZME1NbCbU7tbA6B9tLn1kNfQeFiVfyNBUCml8Vtzcfi9Jalle97brLHyoWv2yww4AB3x78kXqkpnQdB+SV48LpOvER0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837031; c=relaxed/simple;
	bh=UWaYzl3Xjw8MD3rP6OljOy/8j5aEroNaWfaMZ57oxuM=;
	h=Date:To:From:Subject:Message-Id; b=RgU1eY+AIduDrcmOs2AYG7RGiOOBvGVIqJsv6VCoVzbpl1adnHqjedEc2C3f/Qv2djQvNV3JPWGlEdcnDlQfzZpfqHmY2uGjj49VbTp4qyRzSZkxhZ6TwU++5Z9BkGdrEDVAWoIGo988Jiiv8lK1GMbOoGAGpfYQl97cSbUujII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gynjtpyj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gynjtpyj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3507C4CEDD;
	Tue, 14 Jan 2025 06:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837030;
	bh=UWaYzl3Xjw8MD3rP6OljOy/8j5aEroNaWfaMZ57oxuM=;
	h=Date:To:From:Subject:From;
	b=GynjtpyjCUa4hUGQvBAa2z/vVu2VN9XNBZIvfA4TKrwdkbDuOFWTTzsrR9BbPFGmr
	 gwpIsKNUcsksBR4sGq1JJOiGYFJkHUheobUzEZEW5AurZms6Xog8KEZoFyynLTP11J
	 FeVqFCVn5fVKYQ4zCDSyyA+CuDHcJWeHcrPxIbDU=
Date: Mon, 13 Jan 2025 22:43:50 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,rdunlap@infradead.org,pedro.falcato@gmail.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,keescook@chromium.org,jorgelo@chromium.org,jeffxu@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mseal-remove-can_do_mseal.patch removed from -mm tree
Message-Id: <20250114064350.B3507C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mseal: remove can_do_mseal()
has been removed from the -mm tree.  Its filename was
     mseal-remove-can_do_mseal.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jeff Xu <jeffxu@chromium.org>
Subject: mseal: remove can_do_mseal()
Date: Fri, 6 Dec 2024 19:48:39 +0000

No code logic change.

can_do_mseal() is called exclusively by mseal.c, and mseal.c is compiled
only when CONFIG_64BIT flag is set in makefile.  Therefore, it is
unnecessary to have 32 bit stub function in the header file, remove this
function and merge the logic into do_mseal().

Link: https://lkml.kernel.org/r/20241206013934.2782793-1-jeffxu@google.com
Link: https://lkml.kernel.org/r/20241206194839.3030596-2-jeffxu@google.com
Signed-off-by: Jeff Xu <jeffxu@chromium.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jorge Lucangeli Obes <jorgelo@chromium.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |   16 ----------------
 mm/mseal.c    |    6 +++---
 2 files changed, 3 insertions(+), 19 deletions(-)

--- a/mm/internal.h~mseal-remove-can_do_mseal
+++ a/mm/internal.h
@@ -1451,22 +1451,6 @@ void __meminit __init_single_page(struct
 unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
 			  int priority);
 
-#ifdef CONFIG_64BIT
-static inline int can_do_mseal(unsigned long flags)
-{
-	if (flags)
-		return -EINVAL;
-
-	return 0;
-}
-
-#else
-static inline int can_do_mseal(unsigned long flags)
-{
-	return -EPERM;
-}
-#endif
-
 #ifdef CONFIG_SHRINKER_DEBUG
 static inline __printf(2, 0) int shrinker_debugfs_name_alloc(
 			struct shrinker *shrinker, const char *fmt, va_list ap)
--- a/mm/mseal.c~mseal-remove-can_do_mseal
+++ a/mm/mseal.c
@@ -217,9 +217,9 @@ int do_mseal(unsigned long start, size_t
 	unsigned long end;
 	struct mm_struct *mm = current->mm;
 
-	ret = can_do_mseal(flags);
-	if (ret)
-		return ret;
+	/* Verify flags not set. */
+	if (flags)
+		return -EINVAL;
 
 	start = untagged_addr(start);
 	if (!PAGE_ALIGNED(start))
_

Patches currently in -mm which might be from jeffxu@chromium.org are


