Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D427636403B
	for <mm-commits@vger.kernel.org>; Wed,  1 Jul 2026 03:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782876973; cv=none; b=bD9CSCevR+rMoEtI8s30jOZ/jFDdudr7Eciwn5okIR+Na4ZxOlMc+LYvPlEAXXd8J1e41n2HZaDb72fpN24XXltzXf0jtGCl44x9FqJW3fiEYl61vFCklJ4IaFicGGmAFnhvPSk4H5i6FM3kMMlPnwYIuj+siXkHM0npERTz09o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782876973; c=relaxed/simple;
	bh=C6maHkjxw/QtB/6IwxkzHYYG1BWiJxPzjsvLYnQMJZc=;
	h=Date:To:From:Subject:Message-Id; b=LrtXV8liLn8uB+eeXBzZbAmFIk5p5wtT+c4pGHTEP2FQ7+MrV+BOSBdYc2WVeYG2+VpeKzCfqgA1c6ip7neA/WIv5wGKg9bGwDOgSJWheSkZCODX6CM1W1Xn3gDHyA+50626L77koSiJ0GOqACr6/zmsCdFSQAp+cdUc3/rDDVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C/ltyHv+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C/ltyHv+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88BED1F00A3D;
	Wed,  1 Jul 2026 03:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782876971;
	bh=xM2DO6BdNzKCa/8fpxf+rz8bIVQAsz/YSuNFSwRKp3s=;
	h=Date:To:From:Subject;
	b=C/ltyHv+hzD0jeoFjZ/WFu4l7WGBo5gMYfBiJFqx39sXPWtrniBVPO0a8DyNrpZNo
	 z9xhQ/1GdFLDvpTQO9h3li1L/Fi8lRuVPv86d2+Skkt2lemu69lG/pWFchs81kRT20
	 NB4lSl+O7woTB4CAuka4qJIBYCcd++nSJY7/uIxc=
Date: Tue, 30 Jun 2026 20:36:11 -0700
To: mm-commits@vger.kernel.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_owner-hoist-config_memcg-to-function-level-for-print_page_owner_memcg.patch removed from -mm tree
Message-Id: <20260701033611.88BED1F00A3D@smtp.kernel.org>
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
Date: Tue, 30 Jun 2026 09:53:21 +0800

print_page_owner_memcg() has CONFIG_MEMCG guarding its entire body via
#ifdef inside the function, which leaves a no-op { return ret; } when the
config is disabled.  Hoist the #ifdef to the top level so the real
implementation and the empty stub are two clearly separated definitions.

No functional change.

Link: https://lore.kernel.org/20260630015331.147174-5-ye.liu@linux.dev
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

a.patch
mm-page_owner-add-missing-newline-to-count_threshold-format-string.patch
mm-page_owner-move-free_ts_nsec-output-to-free-section-in-__dump_page_owner.patch
mm-page_owner-drop-redundant-page_owner-prefix-from-static-symbols.patch
mm-page_owner-clamp-skip_buddy_pages-pfn-advance-at-max_order_nr_pages-boundary.patch
mm-page_owner-use-memcg_data-snapshot-instead-of-pagememcgkmem-to-avoid-toctou-vm_bug_on.patch

