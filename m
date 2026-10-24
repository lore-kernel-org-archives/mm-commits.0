Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832473;
	b=X8yVf/MAsTY92OKj+ng/kXmBCOfdU1J3t60QdNqT3JrFrQYVrrt/TjEyAoNjiyMX2Lsl
	 VqwlAxsUXsAUJS0tsVMj6MyAqomlOMANypUmJnREF02kSggZtVlkG7iaAeTdmB+p0tgEF
	 WoPOVPdLTJxDpB/XgTdnzyL+6AQvT4r7LrBSvoXnsorrVHxyPX3NU1ur+ZZWHw4EDIxjj
	 rBao+2FJdB+2ObGbTFBy+DbOU6hB7jb4htyuWJ7eHe+IfunQALoYHvVNGW7bbjIKMfdT0
	 AroW42YMN5+G3CYXQQaMBXWJB05XNpyLEn83dYv7aKTZZ+El3Seh9lHjKSAeGDxkFNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832473;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=QK3JBSh7fk+95mBZnL1KlmdlD2TI9YO1dGSsrGpSmfQ=;
	b=mpd8sltmO7so7jzMTEIpjNZ9iARcoRuphvsc5nZjVKMny384heDAVmbscBA5serDp+vq
	 RMGNJnD1h8hZwH/ON6rXWgwMS1HQrJKqiOl4lDIbLJDGX+ORV0rfUdHlwXV/GxcdhHB86
	 UYE89yENJK7LDDWhc6tju3QfNLIrGSGSsUq3moct0xzYztKMcesZv3Zlxi6ilxftF0jUL
	 152HfZlYsUsdnJvLrYRo42+kfSzuvL/tcLFsfvJpNSY5Ckgz0UI3gHMZiEDyBTLrb9dVe
	 jvyHf587urd86CR2+PGBBrUk6592+dupqlayRWui5OCZAS5ZmZPWpNbDnXiRFpeMgwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ouesZ2AK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A379F606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ouesZ2AK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6551F01825;
	Sat, 24 Oct 2026 09:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832473;
	bh=QK3JBSh7fk+95mBZnL1KlmdlD2TI9YO1dGSsrGpSmfQ=;
	h=Date:To:From:Subject;
	b=ouesZ2AKKPJzEfAt/juPSlG8YKxqO74sJUPODUNXeXBn1ebEs6ppk+9B0xFql6m+1
	 sLC2dblEjHx3phj7dareLkyOY69xLqnbID/BoSuG4LlXdM9+q5X4pNn/tjUktJBDnh
	 t0BT8oafRWV+1WoWc7AbAJQhg9sks52gu/mwjrk8=
Date: Sat, 24 Oct 2026 02:01:13 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,lienze@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-use-sizeofbuf-in-string_get_size-calls.patch removed from -mm tree
Message-Id: <20261024090113.6D6551F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/hugetlb: use sizeof(buf) in string_get_size() calls
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-use-sizeofbuf-in-string_get_size-calls.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Enze Li <lienze@kylinos.cn>
Subject: mm/hugetlb: use sizeof(buf) in string_get_size() calls
Date: Wed, 14 Oct 2026 11:11:47 +0800

Replace the hardcoded 32 with sizeof(buf) at the remaining four call
sites, for consistency with the rest of the file.

Link: https://lore.kernel.org/20261014031147.444733-1-lienze@kylinos.cn
Signed-off-by: Enze Li <lienze@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>
---

 mm/hugetlb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-use-sizeofbuf-in-string_get_size-calls
+++ a/mm/hugetlb.c
@@ -3455,7 +3455,7 @@ static void __init hugetlb_hstate_alloc_
 	if (i == h->max_huge_pages_node[nid])
 		return;
 
-	string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, 32);
+	string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, sizeof(buf));
 	pr_warn("allocating %u of page size %s failed node%d.  Only allocated %lu hugepages.\n",
 		h->max_huge_pages_node[nid], buf, nid, i);
 	h->max_huge_pages -= (h->max_huge_pages_node[nid] - i);
@@ -3482,7 +3482,7 @@ static void __init hugetlb_hstate_alloc_
 	if (allocated < h->max_huge_pages) {
 		char buf[32];
 
-		string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, 32);
+		string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, sizeof(buf));
 		pr_warn("allocating %lu of page size %s failed.  Only allocated %lu hugepages.\n",
 			h->max_huge_pages, buf, allocated);
 		h->max_huge_pages = allocated;
@@ -3693,7 +3693,7 @@ static void __init report_hugepages(void
 	for_each_hstate(h) {
 		char buf[32];
 
-		string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, 32);
+		string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, sizeof(buf));
 		pr_info("registered %s page size, pre-allocated %ld pages\n",
 			buf, h->nr_huge_pages);
 		pr_info("%d KiB vmemmap can be freed for a %s page\n",
@@ -4205,7 +4205,7 @@ static int __init hugetlb_init(void)
 				char buf[32];
 
 				string_get_size(huge_page_size(&default_hstate),
-					1, STRING_UNITS_2, buf, 32);
+					1, STRING_UNITS_2, buf, sizeof(buf));
 				pr_warn("Ignoring hugepages=%lu associated with %s page size\n",
 					default_hstate.max_huge_pages, buf);
 				pr_warn("Using hugepages=%lu for number of default huge pages\n",
_

Patches currently in -mm which might be from lienze@kylinos.cn are


