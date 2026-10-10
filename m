Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C696B352C5B
	for <mm-commits@vger.kernel.org>; Sat, 10 Oct 2026 20:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791664380; cv=none; b=A9BkEGy/JrMHkbO860qHDyfVoWdRIyxde9i5bbAOd2vFjvlj6rY4QTxKXapx91EyAxkd0KrVHyGiPer6nbWlvw+84mnGfuJnpoAFfqe81oASy74Qzcek6+rwcIfrtPsq6CKC6o05aX5BYst9cQt0UBO9XkhdQy5YEL0HjySQGj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791664380; c=relaxed/simple;
	bh=vqFGu+tLYTRej0gKxU7ye3ezAmVcFfxmWAbQ5mLYr4w=;
	h=Date:To:From:Subject:Message-Id; b=hcfpbPesGHUlJ5P9KfIfGrW4xYfAaeuYawpeJo5BO8Sdaya8h1rEkoKFlU3YuFfRRt1odscZgosspWe6YwcXcDIdgieUSwfT+UaKDcN3441bHcO3JoT/wN31eZYTtWl1s0v6oOxvcmKR6gV6e2mHocwvFIdwjW35LkfXBzSFEiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bb2N4M/F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bb2N4M/F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27EBD1F000FF;
	Sat, 10 Oct 2026 20:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791664378;
	bh=KsaSmOpl3EFwruo+amkF0VesqLJW7XWokFkbblJBJL8=;
	h=Date:To:From:Subject;
	b=Bb2N4M/Fg0XiFa0YmCTVWFsdkBcFUXw1H35MyrlOA4ul6puQ9HhoS3cSK99kS2oqD
	 rmJWhc6xj5mSOPSAB9hnJdt6JU5OgIqqkO6HR7CGCW99P1c+nGPRpkRIlerQgMbrF7
	 wKDZYjvqJ2APleasuscPe3RY2a2cvV9mMuooTdBQ=
Date: Sat, 10 Oct 2026 13:32:57 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,enze.li@gmx.com,david@kernel.org,lienze@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-prefix-log-messages-via-pr_fmt.patch added to mm-unstable branch
Message-Id: <20261010203258.27EBD1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: prefix log messages via pr_fmt
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-prefix-log-messages-via-pr_fmt.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-prefix-log-messages-via-pr_fmt.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Enze Li <lienze@kylinos.cn>
Subject: mm/hugetlb: prefix log messages via pr_fmt
Date: Sat, 10 Oct 2026 17:23:33 +0800

Pretty much every pr_* message in this file starts with "HugeTLB: ", typed
out by hand, and one of them even drifted to lowercase ("hugetlb:"). 
hugetlb_vmemmap.c already handles this with pr_fmt, so let's do the same
here instead of repeating the prefix over and over.

The output stays the same for almost everything; the only tweaks are that
the lowercase message now matches the others, and the ratelimited "killed
due to inadequate hugepage pool" warning picks up the prefix like
everything else.

Link: https://lore.kernel.org/20261010092333.137126-1-lienze@kylinos.cn
Signed-off-by: Enze Li <lienze@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Enze Li <enze.li@gmx.com>
---

 mm/hugetlb.c |   52 +++++++++++++++++++++++++------------------------
 1 file changed, 27 insertions(+), 25 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-prefix-log-messages-via-pr_fmt
+++ a/mm/hugetlb.c
@@ -3,6 +3,8 @@
  * Generic hugetlb support.
  * (C) Nadia Yvette Chambers, April 2004
  */
+#define pr_fmt(fmt)	"HugeTLB: " fmt
+
 #include <linux/list.h>
 #include <linux/init.h>
 #include <linux/mm.h>
@@ -458,7 +460,7 @@ static void hugetlb_vma_lock_alloc(struc
 		 * until the file is removed.  Warn in the unlikely case of
 		 * allocation failure.
 		 */
-		pr_warn_once("HugeTLB: unable to allocate vma specific lock\n");
+		pr_warn_once("unable to allocate vma specific lock\n");
 		return;
 	}
 
@@ -987,7 +989,7 @@ void hugetlb_fix_reserve_counts(struct i
 	}
 
 	if (!reserved)
-		pr_warn("hugetlb: Huge Page Reserved count may go negative.\n");
+		pr_warn("Huge Page Reserved count may go negative.\n");
 }
 
 /*
@@ -3419,7 +3421,7 @@ static unsigned long __init hugetlb_free
 		char buf[32];
 
 		string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, sizeof(buf));
-		pr_warn("HugeTLB: freed %lu cross-zone hugepages of size %s on node %d.\n",
+		pr_warn("freed %lu cross-zone hugepages of size %s on node %d.\n",
 			freed, buf, nid);
 	}
 
@@ -3465,7 +3467,7 @@ static void __init hugetlb_hstate_alloc_
 		return;
 
 	string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, 32);
-	pr_warn("HugeTLB: allocating %u of page size %s failed node%d.  Only allocated %lu hugepages.\n",
+	pr_warn("allocating %u of page size %s failed node%d.  Only allocated %lu hugepages.\n",
 		h->max_huge_pages_node[nid], buf, nid, i);
 	h->max_huge_pages -= (h->max_huge_pages_node[nid] - i);
 	h->max_huge_pages_node[nid] = i;
@@ -3492,7 +3494,7 @@ static void __init hugetlb_hstate_alloc_
 		char buf[32];
 
 		string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, 32);
-		pr_warn("HugeTLB: allocating %lu of page size %s failed.  Only allocated %lu hugepages.\n",
+		pr_warn("allocating %lu of page size %s failed.  Only allocated %lu hugepages.\n",
 			h->max_huge_pages, buf, allocated);
 		h->max_huge_pages = allocated;
 	}
@@ -3607,7 +3609,7 @@ static unsigned long __init hugetlb_page
 
 	jiffies_end = jiffies;
 
-	pr_info("HugeTLB: allocation took %dms with hugepage_allocation_threads=%ld\n",
+	pr_info("allocation took %dms with hugepage_allocation_threads=%ld\n",
 		jiffies_to_msecs(jiffies_end - jiffies_start),
 		hugepage_allocation_threads);
 
@@ -3635,7 +3637,7 @@ static void __init hugetlb_hstate_alloc_
 	 */
 	if (hstate_is_gigantic(h) && hugetlb_cma_total_size() &&
 	    !hugetlb_early_cma(h)) {
-		pr_warn_once("HugeTLB: hugetlb_cma is enabled, skip boot time allocation\n");
+		pr_warn_once("hugetlb_cma is enabled, skip boot time allocation\n");
 		return;
 	}
 
@@ -3703,9 +3705,9 @@ static void __init report_hugepages(void
 		char buf[32];
 
 		string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, 32);
-		pr_info("HugeTLB: registered %s page size, pre-allocated %ld pages\n",
+		pr_info("registered %s page size, pre-allocated %ld pages\n",
 			buf, h->nr_huge_pages);
-		pr_info("HugeTLB: %d KiB vmemmap can be freed for a %s page\n",
+		pr_info("%d KiB vmemmap can be freed for a %s page\n",
 			hugetlb_vmemmap_optimizable_size(h) / SZ_1K, buf);
 	}
 }
@@ -4045,7 +4047,7 @@ long demote_pool_huge_page(struct hstate
 
 	/* We should never get here if no demote order */
 	if (!src->demote_order) {
-		pr_warn("HugeTLB: NULL demote order passed to demote_pool_huge_page.\n");
+		pr_warn("NULL demote order passed to demote_pool_huge_page.\n");
 		return -EINVAL;		/* internal error */
 	}
 	dst = size_to_hstate(PAGE_SIZE << src->demote_order);
@@ -4190,7 +4192,7 @@ static int __init hugetlb_init(void)
 
 	if (!hugepages_supported()) {
 		if (hugetlb_max_hstate || default_hstate_max_huge_pages)
-			pr_warn("HugeTLB: huge pages not supported, ignoring associated command-line parameters\n");
+			pr_warn("huge pages not supported, ignoring associated command-line parameters\n");
 		return 0;
 	}
 
@@ -4215,9 +4217,9 @@ static int __init hugetlb_init(void)
 
 				string_get_size(huge_page_size(&default_hstate),
 					1, STRING_UNITS_2, buf, 32);
-				pr_warn("HugeTLB: Ignoring hugepages=%lu associated with %s page size\n",
+				pr_warn("Ignoring hugepages=%lu associated with %s page size\n",
 					default_hstate.max_huge_pages, buf);
-				pr_warn("HugeTLB: Using hugepages=%lu for number of default huge pages\n",
+				pr_warn("Using hugepages=%lu for number of default huge pages\n",
 					default_hstate_max_huge_pages);
 			}
 			default_hstate.max_huge_pages =
@@ -4357,12 +4359,12 @@ static int __init hugepages_setup(char *
 	char *p = s;
 
 	if (!hugepages_supported()) {
-		pr_warn("HugeTLB: hugepages unsupported, ignoring hugepages=%s cmdline\n", s);
+		pr_warn("hugepages unsupported, ignoring hugepages=%s cmdline\n", s);
 		return 0;
 	}
 
 	if (!parsed_valid_hugepagesz) {
-		pr_warn("HugeTLB: hugepages=%s does not follow a valid hugepagesz, ignoring\n", s);
+		pr_warn("hugepages=%s does not follow a valid hugepagesz, ignoring\n", s);
 		parsed_valid_hugepagesz = true;
 		return -EINVAL;
 	}
@@ -4379,7 +4381,7 @@ static int __init hugepages_setup(char *
 		mhp = &parsed_hstate->max_huge_pages;
 
 	if (mhp == last_mhp) {
-		pr_warn("HugeTLB: hugepages= specified twice without interleaving hugepagesz=, ignoring hugepages=%s\n", s);
+		pr_warn("hugepages= specified twice without interleaving hugepagesz=, ignoring hugepages=%s\n", s);
 		return 1;
 	}
 
@@ -4390,7 +4392,7 @@ static int __init hugepages_setup(char *
 		/* Parameter is node format */
 		if (p[count] == ':') {
 			if (!hugetlb_node_alloc_supported()) {
-				pr_warn("HugeTLB: architecture can't support node specific alloc, ignoring!\n");
+				pr_warn("architecture can't support node specific alloc, ignoring!\n");
 				return 1;
 			}
 			if (tmp >= MAX_NUMNODES || !node_online(tmp))
@@ -4423,7 +4425,7 @@ static int __init hugepages_setup(char *
 	return 0;
 
 invalid:
-	pr_warn("HugeTLB: Invalid hugepages parameter %s\n", p);
+	pr_warn("Invalid hugepages parameter %s\n", p);
 	hugepages_clear_pages_in_node();
 	return -EINVAL;
 }
@@ -4442,7 +4444,7 @@ static int __init hugepagesz_setup(char
 	struct hstate *h;
 
 	if (!hugepages_supported()) {
-		pr_warn("HugeTLB: hugepages unsupported, ignoring hugepagesz=%s cmdline\n", s);
+		pr_warn("hugepages unsupported, ignoring hugepagesz=%s cmdline\n", s);
 		return 0;
 	}
 
@@ -4450,7 +4452,7 @@ static int __init hugepagesz_setup(char
 	size = (unsigned long)memparse(s, NULL);
 
 	if (!arch_hugetlb_valid_size(size)) {
-		pr_err("HugeTLB: unsupported hugepagesz=%s\n", s);
+		pr_err("unsupported hugepagesz=%s\n", s);
 		return -EINVAL;
 	}
 
@@ -4465,7 +4467,7 @@ static int __init hugepagesz_setup(char
 		 */
 		if (!parsed_default_hugepagesz ||  h != &default_hstate ||
 		    default_hstate.max_huge_pages) {
-			pr_warn("HugeTLB: hugepagesz=%s specified twice, ignoring\n", s);
+			pr_warn("hugepagesz=%s specified twice, ignoring\n", s);
 			return -EINVAL;
 		}
 
@@ -4495,21 +4497,21 @@ static int __init default_hugepagesz_set
 	int i;
 
 	if (!hugepages_supported()) {
-		pr_warn("HugeTLB: hugepages unsupported, ignoring default_hugepagesz=%s cmdline\n",
+		pr_warn("hugepages unsupported, ignoring default_hugepagesz=%s cmdline\n",
 			s);
 		return 0;
 	}
 
 	parsed_valid_hugepagesz = false;
 	if (parsed_default_hugepagesz) {
-		pr_err("HugeTLB: default_hugepagesz previously specified, ignoring %s\n", s);
+		pr_err("default_hugepagesz previously specified, ignoring %s\n", s);
 		return -EINVAL;
 	}
 
 	size = (unsigned long)memparse(s, NULL);
 
 	if (!arch_hugetlb_valid_size(size)) {
-		pr_err("HugeTLB: unsupported default_hugepagesz=%s\n", s);
+		pr_err("unsupported default_hugepagesz=%s\n", s);
 		return -EINVAL;
 	}
 
@@ -4774,7 +4776,7 @@ static void hugetlb_vm_op_open(struct vm
 				vma->vm_private_data = NULL;
 				hugetlb_vma_lock_alloc(vma);
 			} else {
-				pr_warn("HugeTLB: vma_lock already exists in %s.\n", __func__);
+				pr_warn("vma_lock already exists in %s.\n", __func__);
 			}
 		} else {
 			hugetlb_vma_lock_alloc(vma);
_

Patches currently in -mm which might be from lienze@kylinos.cn are

maintainers-cover-all-hugetlb-headers-under-hugetlb-subsystem.patch
mm-hugetlb_cgroup-add-trailing-endif-comment-for-include-guard.patch
docs-hugetlbpagerst-fix-typo-in-per-node-attribute-description.patch
mm-hugetlb-prefix-log-messages-via-pr_fmt.patch

