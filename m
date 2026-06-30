Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E140433F5AE
	for <mm-commits@vger.kernel.org>; Tue, 30 Jun 2026 02:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782786368; cv=none; b=ZVSqPjf0q2J+YOhpLV+dXHAKhnl5Bw77HrkpZpN9hAQZ2rVb6iO2BE2o6RmXwKZ8AF6Tey0BCCsVc/t5tHfGcFeb9sRB6w7KsliVIxoQKz8eWLhv0HwruscgvIITw5wHJE9loSMxP1yIuXl+pJs3rlRqVOjRtrR/tZYzZe6ADrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782786368; c=relaxed/simple;
	bh=q5xENBI8kEk8oJDP1Ihl7kucl47obIJiUOjehqUEBoo=;
	h=Date:To:From:Subject:Message-Id; b=Fm689A3xSu7/pr+Exq/0VArqlgAdGLosxn42pOLPR3GkBgIVAPeyv2xDf2NfzHTBmoxyT5bWxtDKwJTxMRCRTFoduyEWc3N4U+nK3842yIZnRfnncsLZxM9a2bLqrZHzeh9hJES0t8PV9xofJ/Qhl44k+HFDb9khfsrpL5469qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=19d5OlDT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="19d5OlDT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 897671F000E9;
	Tue, 30 Jun 2026 02:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782786366;
	bh=BXUDBmMuncLqOonEoqVFQP6RB5DcM8ySD8OELc5zVoM=;
	h=Date:To:From:Subject;
	b=19d5OlDTA50LvQ1gnjbrFlPZ+Fm4qxImcJo5+LZoU2o66EEgmo4o7jH881Ft4WlGE
	 uW0FYeUm1XogivJSix8NaiCkr6/dlHW/PRP0EhFj0fAGUAfyOXf8Hl+D0QdgNh5DHv
	 n35KoDO5pDLVHSZYMJ4xOUezDUx6GPG4sMcxhxnc=
Date: Mon, 29 Jun 2026 19:26:06 -0700
To: mm-commits@vger.kernel.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_owner-hoist-config_memcg-to-function-level-for-print_page_owner_memcg.patch removed from -mm tree
Message-Id: <20260630022606.897671F000E9@smtp.kernel.org>
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
Date: Fri, 26 Jun 2026 10:45:42 +0800

The print_page_owner_memcg() function has CONFIG_MEMCG guarding its entire
body via #ifdef inside the function, which leaves a no-op { return ret; }
when the config is disabled.  Hoist the #ifdef to the top level so the
real implementation and the empty stub are two clearly separated
definitions.

No functional change.

Link: https://lore.kernel.org/20260626024550.25677-4-ye.liu@linux.dev
Signed-off-by: Ye Liu <ye.liu@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-hoist-config_memcg-to-function-level-for-print_page_owner_memcg
+++ a/mm/page_owner.c
@@ -529,13 +529,13 @@ ext_put_continue:
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
@@ -563,10 +563,16 @@ static inline int print_page_owner_memcg
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
mm-page_owner-clamp-skip_buddy_pages-pfn-advance-at-max_order_nr_pages-boundary.patch
mm-page_owner-use-memcg_data-snapshot-instead-of-pagememcgkmem-to-avoid-toctou-vm_bug_on.patch

