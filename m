Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282E538F62F
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298415; cv=none; b=b4SNi8He91eysYP24bsqFSRDnkDucsOvKxZwxPdpe39CZJvEejFIT1PbGkbKFqXDva/1XfXaX81r56zlIsNSKc6Ghq65uMnhHZs0I7A7KwHgSZ9/SN2KK54KzIe1+l7DM9Suyzh5tUNmQKdqNXyV71g82k0fhYVK3g+yfJ1MXbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298415; c=relaxed/simple;
	bh=b+x93i313RsXQWfESkHOL7SSnd1fdZ9IbqJmRvN/Hao=;
	h=Date:To:From:Subject:Message-Id; b=eoemNd/OhfIjd3nWf8yCPXbt2v/fMbYHByZaVphxNH20S6h3Tc8foSVW9Xe2pzL/U7+k+fKVVthba4efQ1Gnj95SjCOYSsjB12TdPAAKaPG7f5KPPILwL2+pqqzH80o7YRUFyVMWmP0DYgOwVTeVyi9sGsQwBUVXewMfYVe2DQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PwPARxdD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PwPARxdD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0DB61F000E9;
	Wed, 29 Jul 2026 04:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298414;
	bh=zjj78qWger6EOUde8cz671y3DFEhUg0zHbw4us/9dws=;
	h=Date:To:From:Subject;
	b=PwPARxdDrLmAKXdSoyS1dDJNQSkBNvAfpsO3nUCpBuMLrpStLEjpjfSkXZCyiYUTh
	 AkDhoPU7LPOe+Ba1FWCSg0xKtfP7e3NAg/ffgNQvJD/3OP+m4yzZ2LMBZTAXXcgf9l
	 SlheCIJCJ4bVy1228xVRyHtiaCEiGmVf+U3cYL9k=
Date: Tue, 28 Jul 2026 21:13:33 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,ljs@kernel.org,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_owner-hoist-config_memcg-to-function-level-for-print_page_owner_memcg.patch removed from -mm tree
Message-Id: <20260729041333.F0DB61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_owner: hoist CONFIG_MEMCG to function level for print_page_owner_memcg()
has been removed from the -mm tree.  Its filename was
     mm-page_owner-hoist-config_memcg-to-function-level-for-print_page_owner_memcg.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ye Liu <ye.liu@linux.dev>
Subject: mm/page_owner: hoist CONFIG_MEMCG to function level for print_page_owner_memcg()
Date: Tue, 14 Jul 2026 09:51:03 +0800

The print_page_owner_memcg() function has CONFIG_MEMCG guarding its entire
body via #ifdef inside the function, which leaves a no-op { return ret; }
when the config is disabled.  Hoist the #ifdef to the top level so the
real implementation and the empty stub are two clearly separated
definitions.

No functional change.

Link: https://lore.kernel.org/20260714015117.78351-5-ye.liu@linux.dev
Signed-off-by: Ye Liu <ye.liu@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
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


