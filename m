Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832464;
	b=xfRo4Lpa8yvA7Vphns/GgfO5OA1cIwiCI4KyKvMqc/z3W7HrGF1XkwoxVe4xP81MAWt3
	 n7QE0suyjF6JtwakpvLCwVmiiKAm2/K1u02aCjziHUIF1pek9FNjCDmlBImFHU+JtLXMW
	 o4ul13/LZQXiVRosDrDJvrUybk1Fz4FPET6+Y2LBjMgw1TZ0VoMg6SplFBCE0Z+EbvZ6z
	 DwxXvgWFab+sITxz543d5TUI2TmepADUPXEdS4Nrx17Us2J6VdCDhbL4XLY28wSm34P06
	 gIC/bgFK+fzaKTMAxDzisJsRWX+h7BQkCDE0f4pdRP9h1+EdWIdRr71FnP2vVnHWS1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832464;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=6ZqocgRXf2kgSbY7BFSA4xPspt6xzux9rhYMtb7GMn8=;
	b=h7v0U4kViSkxaokRkGGelVSsqtvOidmx37ZLDy4qFl1b0xZnrMfJYk4Hvz6JOOaSta2w
	 HZ1Jw04R2GgWYkbJqq3+OuB1t4FOZAQK0G2NPoZAN1+EmzmrM5FIGR5uX8OWEdZlMWf9g
	 qnWKZnW01iDxb3Kk13ngeXPWfBQ7Hu+AmyX6tUj5m2s/dFhCeed5pg/UPoKZp0up9jVFb
	 7+nJ1nr+8nAHK41Mb17LG34kbYrw3CsshOC/Gbinzbvs/DU8KoPZzYnusFK9QRs1b0A2L
	 UQm333wsy39fyPvVwrXSeMEHTSYDtOrZOOwJBFFICqE6gqOvlpjPzh8tLgMh4xNA2oQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=hKhK5v+f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F80606A31B
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=hKhK5v+f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD871F01825;
	Sat, 24 Oct 2026 09:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832463;
	bh=6ZqocgRXf2kgSbY7BFSA4xPspt6xzux9rhYMtb7GMn8=;
	h=Date:To:From:Subject;
	b=hKhK5v+f0p6rYNzxyRaiOh6vYd1l+Z4uvkDEWgRBmbFvIvL0RCg1tVNoumfmSuGk/
	 h5xrE7qQLSKp9nYzmP+7x1S9LvQc1Y8IDWdkAtEDnHi7XrnqU7VwxRQrND9iNvVwVt
	 J4910KI+ndnAaIino1HFw+gT5jfxkbFCnYuGLWKY=
Date: Sat, 24 Oct 2026 02:01:03 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,enze.li@gmx.com,david@kernel.org,lienze@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-prefix-log-messages-via-pr_fmt.patch removed from -mm tree
Message-Id: <20261024090103.BCD871F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/hugetlb: prefix log messages via pr_fmt
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-prefix-log-messages-via-pr_fmt.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -3408,7 +3410,7 @@ static unsigned long __init hugetlb_free
 		char buf[32];
 
 		string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, sizeof(buf));
-		pr_warn("HugeTLB: freed %lu cross-zone hugepages of size %s on node %d.\n",
+		pr_warn("freed %lu cross-zone hugepages of size %s on node %d.\n",
 			freed, buf, nid);
 	}
 
@@ -3454,7 +3456,7 @@ static void __init hugetlb_hstate_alloc_
 		return;
 
 	string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, 32);
-	pr_warn("HugeTLB: allocating %u of page size %s failed node%d.  Only allocated %lu hugepages.\n",
+	pr_warn("allocating %u of page size %s failed node%d.  Only allocated %lu hugepages.\n",
 		h->max_huge_pages_node[nid], buf, nid, i);
 	h->max_huge_pages -= (h->max_huge_pages_node[nid] - i);
 	h->max_huge_pages_node[nid] = i;
@@ -3481,7 +3483,7 @@ static void __init hugetlb_hstate_alloc_
 		char buf[32];
 
 		string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, 32);
-		pr_warn("HugeTLB: allocating %lu of page size %s failed.  Only allocated %lu hugepages.\n",
+		pr_warn("allocating %lu of page size %s failed.  Only allocated %lu hugepages.\n",
 			h->max_huge_pages, buf, allocated);
 		h->max_huge_pages = allocated;
 	}
@@ -3596,7 +3598,7 @@ static unsigned long __init hugetlb_page
 
 	jiffies_end = jiffies;
 
-	pr_info("HugeTLB: allocation took %dms with hugepage_allocation_threads=%ld\n",
+	pr_info("allocation took %dms with hugepage_allocation_threads=%ld\n",
 		jiffies_to_msecs(jiffies_end - jiffies_start),
 		hugepage_allocation_threads);
 
@@ -3624,7 +3626,7 @@ static void __init hugetlb_hstate_alloc_
 	 */
 	if (hstate_is_gigantic(h) && hugetlb_cma_total_size() &&
 	    !hugetlb_early_cma(h)) {
-		pr_warn_once("HugeTLB: hugetlb_cma is enabled, skip boot time allocation\n");
+		pr_warn_once("hugetlb_cma is enabled, skip boot time allocation\n");
 		return;
 	}
 
@@ -3692,9 +3694,9 @@ static void __init report_hugepages(void
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
@@ -4034,7 +4036,7 @@ long demote_pool_huge_page(struct hstate
 
 	/* We should never get here if no demote order */
 	if (!src->demote_order) {
-		pr_warn("HugeTLB: NULL demote order passed to demote_pool_huge_page.\n");
+		pr_warn("NULL demote order passed to demote_pool_huge_page.\n");
 		return -EINVAL;		/* internal error */
 	}
 	dst = size_to_hstate(PAGE_SIZE << src->demote_order);
@@ -4179,7 +4181,7 @@ static int __init hugetlb_init(void)
 
 	if (!hugepages_supported()) {
 		if (hugetlb_max_hstate || default_hstate_max_huge_pages)
-			pr_warn("HugeTLB: huge pages not supported, ignoring associated command-line parameters\n");
+			pr_warn("huge pages not supported, ignoring associated command-line parameters\n");
 		return 0;
 	}
 
@@ -4204,9 +4206,9 @@ static int __init hugetlb_init(void)
 
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
@@ -4346,12 +4348,12 @@ static int __init hugepages_setup(char *
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
@@ -4368,7 +4370,7 @@ static int __init hugepages_setup(char *
 		mhp = &parsed_hstate->max_huge_pages;
 
 	if (mhp == last_mhp) {
-		pr_warn("HugeTLB: hugepages= specified twice without interleaving hugepagesz=, ignoring hugepages=%s\n", s);
+		pr_warn("hugepages= specified twice without interleaving hugepagesz=, ignoring hugepages=%s\n", s);
 		return 1;
 	}
 
@@ -4379,7 +4381,7 @@ static int __init hugepages_setup(char *
 		/* Parameter is node format */
 		if (p[count] == ':') {
 			if (!hugetlb_node_alloc_supported()) {
-				pr_warn("HugeTLB: architecture can't support node specific alloc, ignoring!\n");
+				pr_warn("architecture can't support node specific alloc, ignoring!\n");
 				return 1;
 			}
 			if (tmp >= MAX_NUMNODES || !node_online(tmp))
@@ -4412,7 +4414,7 @@ static int __init hugepages_setup(char *
 	return 0;
 
 invalid:
-	pr_warn("HugeTLB: Invalid hugepages parameter %s\n", p);
+	pr_warn("Invalid hugepages parameter %s\n", p);
 	hugepages_clear_pages_in_node();
 	return -EINVAL;
 }
@@ -4431,7 +4433,7 @@ static int __init hugepagesz_setup(char
 	struct hstate *h;
 
 	if (!hugepages_supported()) {
-		pr_warn("HugeTLB: hugepages unsupported, ignoring hugepagesz=%s cmdline\n", s);
+		pr_warn("hugepages unsupported, ignoring hugepagesz=%s cmdline\n", s);
 		return 0;
 	}
 
@@ -4439,7 +4441,7 @@ static int __init hugepagesz_setup(char
 	size = (unsigned long)memparse(s, NULL);
 
 	if (!arch_hugetlb_valid_size(size)) {
-		pr_err("HugeTLB: unsupported hugepagesz=%s\n", s);
+		pr_err("unsupported hugepagesz=%s\n", s);
 		return -EINVAL;
 	}
 
@@ -4454,7 +4456,7 @@ static int __init hugepagesz_setup(char
 		 */
 		if (!parsed_default_hugepagesz ||  h != &default_hstate ||
 		    default_hstate.max_huge_pages) {
-			pr_warn("HugeTLB: hugepagesz=%s specified twice, ignoring\n", s);
+			pr_warn("hugepagesz=%s specified twice, ignoring\n", s);
 			return -EINVAL;
 		}
 
@@ -4484,21 +4486,21 @@ static int __init default_hugepagesz_set
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
 
@@ -4763,7 +4765,7 @@ static void hugetlb_vm_op_open(struct vm
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


