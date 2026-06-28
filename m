Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CFF40D569
	for <mm-commits@vger.kernel.org>; Sun, 28 Jun 2026 02:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782614290; cv=none; b=i3Wq4yReMIHVaOgaEUOrGXiQykaSfgbKXmQKqzroDP0uPABL5ESeYoJ8SX4IQMUqgYFzSbZWMqxnhLNKARLqOL0Oswe/c+asnKpld7/NW+sPdgyoAn6z8pzq70+AqaDtKJo6JMJlgSVn1ZdKOuh+zEnDE/iGxvaA0IHmk8EdptE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782614290; c=relaxed/simple;
	bh=+vqC/RFmHzHVOoF0krumCYW5jjIo79ceDzGOL16bS64=;
	h=Date:To:From:Subject:Message-Id; b=cN1h/ZElZ1/jrMmsnYxeRCWpKxZcVlgUxXLDq2QCLVl5h7zROrVjj4AJQjPuSdaJOg16h13PHU4YemG4q9MHURmaIFcsaf5q7qpOSOgPvZejkf+AJvo0b2lxzIrxcmZfB6BmZebcFyJJUZXbjwvwHqOjhrsxZsnw6uuyh+ZJBZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rrNeLZ76; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rrNeLZ76"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444211F000E9;
	Sun, 28 Jun 2026 02:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782614289;
	bh=3bXE9d3SXgchfZyMmgGmVaCY2nBHEiIRXin/Ohz50Bw=;
	h=Date:To:From:Subject;
	b=rrNeLZ76xpQP6IZr8D56y4MGrCWCWH/7D2g41kk/7juRzDxwPVCH2zxoIAb1L3LPz
	 WhQVGAja6j+1HfVlb1VN0NGM5urmPTgFpQV/w5IFbKA5n6a/HsCzkTd8MK5kD/du+m
	 aeTrHqk+qPiP7OaLWgsCN9wYcRyHJreuEyIYQG04=
Date: Sat, 27 Jun 2026 19:38:08 -0700
To: mm-commits@vger.kernel.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-hoist-config_memcg-to-function-level-for-print_page_owner_memcg.patch added to mm-new branch
Message-Id: <20260628023809.444211F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_owner: hoist CONFIG_MEMCG to function level for print_page_owner_memcg()
has been added to the -mm mm-new branch.  Its filename is
     mm-page_owner-hoist-config_memcg-to-function-level-for-print_page_owner_memcg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-hoist-config_memcg-to-function-level-for-print_page_owner_memcg.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

mm-page_owner-extract-skip_buddy_pages-helper-to-unify-buddy-page-skipping.patch
mm-page_owner-use-migrate_reason_none-instead-of-1-for-last_migrate_reason.patch
mm-page_owner-hoist-config_memcg-to-function-level-for-print_page_owner_memcg.patch
mm-page_owner-add-missing-newline-to-count_threshold-format-string.patch
mm-page_owner-move-free_ts_nsec-output-to-free-section-in-__dump_page_owner.patch
mm-page_owner-drop-redundant-page_owner-prefix-from-static-symbols.patch
mm-page_owner-clamp-skip_buddy_pages-pfn-advance-at-max_order_nr_pages-boundary.patch
mm-page_owner-use-memcg_data-snapshot-instead-of-pagememcgkmem-to-avoid-toctou-vm_bug_on.patch

