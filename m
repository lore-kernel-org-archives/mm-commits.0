Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF06540D569
	for <mm-commits@vger.kernel.org>; Sun, 28 Jun 2026 02:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782614292; cv=none; b=KQhJuoILn4PHnr2elwK8gbkMHB/EGTB8wmNmEwfs+MKAz6Qh/dnZYNZ0e0yQ6Ddx1ytqJVvanaNYYmf3vAEUDPMqelpeux6/JCFPNvuYuRFt/hJlBBy3/TmF0+U2xnxj67caIA7KWTqhExmOTh4LRUSIRLVECwcg0jMTkEgZdCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782614292; c=relaxed/simple;
	bh=Gamd1/rPb7P6kcXLS+yTRJFdTZnK1HcXw2r8MsSobgg=;
	h=Date:To:From:Subject:Message-Id; b=ESEd+O6Opn7l4vM5D9CxQ7srsmgdE4z+n38/KIZCE0Bnb67AhqD7YrfF+g7jskytVrZiV3Oxq/wkzF1RtFPACEhRCInOX5exPk2zlHdVVCjrDmttnzDAADgKrF4MkW+Mo92ORR/QQ/Abq3q/xpB3YXC7boj+M9YyUeLVEqABYrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PyF9A0uD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PyF9A0uD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E4CC1F000E9;
	Sun, 28 Jun 2026 02:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782614291;
	bh=g35koecBqY/DHTulc7oXogdTY+Zp3pOrcLdG/OhY2S0=;
	h=Date:To:From:Subject;
	b=PyF9A0uDvOQZubMkrqNyB7xUduW3mj0BKdNP3f0rqxiXivnnjb8Bc0FUtkSjldtYz
	 DwtpKEb0o+qnBQ5crnWgy14yPXlwxgCt7mJ99qQKlbL5KrRM7tFynNIc1YDv8aryb9
	 eEDLMtrG9luDg/uolQhr1AUAxHiCG6QjfJOqUhiY=
Date: Sat, 27 Jun 2026 19:38:10 -0700
To: mm-commits@vger.kernel.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-add-missing-newline-to-count_threshold-format-string.patch added to mm-new branch
Message-Id: <20260628023811.3E4CC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_owner: add missing newline to count_threshold format string
has been added to the -mm mm-new branch.  Its filename is
     mm-page_owner-add-missing-newline-to-count_threshold-format-string.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-add-missing-newline-to-count_threshold-format-string.patch

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
Subject: mm/page_owner: add missing newline to count_threshold format string
Date: Fri, 26 Jun 2026 10:45:43 +0800

The DEFINE_SIMPLE_ATTRIBUTE format string for page_owner_threshold_fops is
missing a trailing \n.  simple_attr_read() uses scnprintf() with the
format string, which does not append a newline, so reading
/sys/kernel/debug/page_owner_stacks/count_threshold produces output
without a terminating newline.  Add the missing \n to match the standard
debugfs attribute convention.

Link: https://lore.kernel.org/20260626024550.25677-5-ye.liu@linux.dev
Signed-off-by: Ye Liu <ye.liu@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_owner.c~mm-page_owner-add-missing-newline-to-count_threshold-format-string
+++ a/mm/page_owner.c
@@ -981,7 +981,7 @@ static int page_owner_threshold_set(void
 }
 
 DEFINE_SIMPLE_ATTRIBUTE(page_owner_threshold_fops, &page_owner_threshold_get,
-			&page_owner_threshold_set, "%llu");
+			&page_owner_threshold_set, "%llu\n");
 
 
 static int __init pageowner_init(void)
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

