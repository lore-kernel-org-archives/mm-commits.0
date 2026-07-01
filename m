Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2434E3B47F7
	for <mm-commits@vger.kernel.org>; Wed,  1 Jul 2026 23:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782950249; cv=none; b=k76nJhtsBzBooCQ78sPdKZ42DZUB5oDRzu6YengCS0gXmKF0ICOLg2QG5d0djnR70MXmfmVUFNGr74QvQG8q2wJt/DIdKmjBHflvv44VQxUo9NJjGQ/aorQ6KUGLwOBH3+3fdOrt6H9FgmSt5X1fwuhHrUx0nWqKslMJ6yC5sCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782950249; c=relaxed/simple;
	bh=s1CRqUjk4gKgCruhc50e4RwgAQqaoI4vE5peUppoQj8=;
	h=Date:To:From:Subject:Message-Id; b=lFfURO3TvqCckPZj34pFZFmn1AmQXbkqXLEY+NnPGfEd9RAISAChVRjhvySLrEUlMk6tOB1dkJf9lJkEa9/0katzpi5DdmetyYsUgrX+fd4uXwc6fYoOuHdX/LJMgtdVNKQPz6pHYzJ5sWKSYMVLZ7Rp7o9IEP9RAgTl/J5sOcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Red0Di+2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Red0Di+2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C538D1F00A3A;
	Wed,  1 Jul 2026 23:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782950247;
	bh=SbVLe7AZm5RYXvk3KCYZ0+gTO1JCOxGhDsqAs+b/0r4=;
	h=Date:To:From:Subject;
	b=Red0Di+22VKeJFIKBFCX1imlvqH0fQIzE3LDB9njHkdDbXQZZAEbDRsJVi6s7Z+qO
	 LXtU/RMEqyVXbuBY0Cug5IBxBNllgCyedoRKe4kozipm4TOfXw67F62ROCLbdLk3gI
	 CMrftEDe+S/Ci+nG8iR4ny81LRT1WXzur6y0ApPw=
Date: Wed, 01 Jul 2026 16:57:27 -0700
To: mm-commits@vger.kernel.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_owner-hoist-config_memcg-to-function-level-for-print_page_owner_memcg.patch removed from -mm tree
Message-Id: <20260701235727.C538D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_owner: hoist CONFIG_MEMCG to function level for print_page_owner_memcg()
has been removed from the -mm tree.  Its filename was
     mm-page_owner-hoist-config_memcg-to-function-level-for-print_page_owner_memcg.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Ye Liu <ye.liu@linux.dev>
Subject: mm/page_owner: hoist CONFIG_MEMCG to function level for print_page_owner_memcg()
Date: Wed, 1 Jul 2026 09:22:30 +0800

The print_page_owner_memcg() function has CONFIG_MEMCG guarding its entire
body via #ifdef inside the function, which leaves a no-op { return ret; }
when the config is disabled.  Hoist the #ifdef to the top level so the
real implementation and the empty stub are two clearly separated
definitions.

No functional change.

Link: https://lore.kernel.org/20260701012239.315262-5-ye.liu@linux.dev
Signed-off-by: Ye Liu <ye.liu@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-hoist-config_memcg-to-function-level-for-print_page_owner_memcg
+++ a/mm/page_owner.c
@@ -522,13 +522,13 @@ ext_put_continue:
 	seq_putc(m, '\n');
 }
 
+#ifdef CONFIG_MEMCG
 /*
  * Looking for memcg information and print it out
  */
 static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
 					 struct page *page)
 {
-#ifdef CONFIG_MEMCG
 	unsigned long memcg_data;
 	struct mem_cgroup *memcg;
 	bool online;
@@ -556,10 +556,16 @@ static inline int print_page_owner_memcg
 			name);
 out_unlock:
 	rcu_read_unlock();
-#endif /* CONFIG_MEMCG */
 
 	return ret;
 }
+#else
+static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
+					 struct page *page)
+{
+	return ret;
+}
+#endif
 
 static ssize_t
 print_page_owner(char __user *buf, size_t count, unsigned long pfn,
_

Patches currently in -mm which might be from ye.liu@linux.dev are

mm-page_owner-add-missing-newline-to-count_threshold-format-string.patch
mm-page_owner-move-free_ts_nsec-output-to-free-section-in-__dump_page_owner.patch
mm-page_owner-drop-redundant-page_owner-prefix-from-static-symbols.patch

