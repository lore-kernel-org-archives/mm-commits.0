Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B812118E760
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925309; cv=none; b=h7t/ywce2B6w8r9MjZy4kVWfAk085WM4M3A9+P6HD1aKeE9q1IuyUCjnDdtz8lEqs0yfDzOimbmDuDv4Jq7jokrWfZGKtyl/oN7sWpP1zkoxl3tqg9y+7cDLDjoAyljKf0GT3znif7mCXx+TvcoyDO1FwwOPena78Fm2JRNT7QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925309; c=relaxed/simple;
	bh=0bnlJ/8NbHPAYNFZmOQZdUqBPRg6T1bHLwXcq7beTUc=;
	h=Date:To:From:Subject:Message-Id; b=OlAMkITCJD1CHH1GI6fqA0E+GZnKSZn262Q7f0hmWkuJQJ3PP8T+yvljcakXxt+YN2c6FDUkR7h8c9c2i0hgMJ1tVS/mB7GyITP72X+/pdD6cv93yp1T576qSXAIIayPcmhMlBlVOtf/zPNP1OB7zzfx8LxNEZXRXhRZN9+Rfd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tomsZozi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tomsZozi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CBC5C4CEC5;
	Mon,  9 Sep 2024 23:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925309;
	bh=0bnlJ/8NbHPAYNFZmOQZdUqBPRg6T1bHLwXcq7beTUc=;
	h=Date:To:From:Subject:From;
	b=tomsZozi2b0fHT1BjrpJBvhojmbHaXGeDkF7bENFPy2Afe1/JjX3sPMxcWD8D7JTr
	 fD75gHb2dYGIFIVK1ZK+5OvkThSM47v5UnvzA7cp1yzdAj3jCtPP3ZOZh0bJeY021E
	 eyXNv9adeoItAuJqiCHUw1GldVYtaQ1MNwsG7lVQ=
Date: Mon, 09 Sep 2024 16:41:49 -0700
To: mm-commits@vger.kernel.org,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-fix-build-with-config_unaccepted_memory=n.patch removed from -mm tree
Message-Id: <20240909234149.8CBC5C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: fix build with CONFIG_UNACCEPTED_MEMORY=n
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-build-with-config_unaccepted_memory=n.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/page_alloc: fix build with CONFIG_UNACCEPTED_MEMORY=n
Date: Thu, 5 Sep 2024 14:22:20 -0700

When has_unaccepted_memory() is unused, it prevents kernel builds
with clang, `make W=1` and CONFIG_WERROR=y:

mm/page_alloc.c:7036:20: error: unused function 'has_unaccepted_memory' [-Werror,-Wunused-function]
7036 | static inline bool has_unaccepted_memory(void)
|                    ^~~~~~~~~~~~~~~~~~~~~

Fix it by removeing the CONFIG_UNACCEPTED_MEMORY=n stub.

Link: https://lkml.kernel.org/r/20240905142220.49d93337a0abce5690e515d9@linux-foundation.org
Reported-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Closes: https://lkml.kernel.org/r/20240905171553.275054-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-build-with-config_unaccepted_memory=n
+++ a/mm/page_alloc.c
@@ -287,7 +287,6 @@ EXPORT_SYMBOL(nr_online_nodes);
 
 static bool page_contains_unaccepted(struct page *page, unsigned int order);
 static bool cond_accept_memory(struct zone *zone, unsigned int order);
-static inline bool has_unaccepted_memory(void);
 static bool __free_unaccepted(struct page *page);
 
 int page_group_by_mobility_disabled __read_mostly;
@@ -7061,6 +7060,11 @@ static bool try_to_accept_memory_one(str
 	return true;
 }
 
+static inline bool has_unaccepted_memory(void)
+{
+	return static_branch_unlikely(&zones_with_unaccepted_pages);
+}
+
 static bool cond_accept_memory(struct zone *zone, unsigned int order)
 {
 	long to_accept;
@@ -7088,11 +7092,6 @@ static bool cond_accept_memory(struct zo
 	return ret;
 }
 
-static inline bool has_unaccepted_memory(void)
-{
-	return static_branch_unlikely(&zones_with_unaccepted_pages);
-}
-
 static bool __free_unaccepted(struct page *page)
 {
 	struct zone *zone = page_zone(page);
@@ -7127,11 +7126,6 @@ static bool cond_accept_memory(struct zo
 {
 	return false;
 }
-
-static inline bool has_unaccepted_memory(void)
-{
-	return false;
-}
 
 static bool __free_unaccepted(struct page *page)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vma-return-the-exact-errno-in-vms_gather_munmap_vmas-fix.patch

