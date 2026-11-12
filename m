Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794453593;
	b=kmTGJOXYT+N8qDIpbWGYqA9eLV+HERm5Xk9nh9+eX21mim5KyWw4UT3rXBqxHl/AXY1B
	 2oC3CS1W8hKiCLlKuj5riEe4BBhad1cRhY1j+xdUMMX1HFkLFKVkVGTljnh4GQHqYS0tW
	 kuRT4RoDhqAxJkdCvZNkeg1VNqhCdariCEOMQSebhGga2lAOH1G5G+iZ4HqqYFyEjbL2m
	 t36ZJnJI0gn7fv2CKB2YoU1eLOPyhM6UdzeR6zrxeggnfTZ+mBon2HmawS7yJiDAf455T
	 L3aFJGPIQYx4EGcDVptXvxZ1iITfQWlHVtgy0embpWaIkUOZoaCZVfnP8H6HF6yzgbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794453593;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=X1Xcm2Pd3cLKO0qmRlfLp4SKtK/TsLBKcTHeK4JMYaM=;
	b=VVRAzQHgDwOSpyV7SGAq56fkxQ7cZ6v+TG6RmJN/bQ1ilJMaXpuNM4aqz9Z+NuqvXCY1
	 4rdbH7IBjTjnkym2hTwbA2bgSCN1PEvQDlLBu5n89ILbDVXOGurSOWtvML94As8SBX0XQ
	 xfr32/fDmhZcSM9e51Dpv7AeKMDe/eLacCHEE2V33nrRDq7xxoyMq2YkO/acpJKkrmLP/
	 Mlq4okkvijvIgAM4/0p08iSl4HWQfuJN+cITjKtswasbzF7ExojOS1qXGM9eww8LJhU0p
	 WXDB6EJQAGscV6b6IrKDFCWdes/lpxUlVQo0OL9PDAW6bwKxUSPGU1F82DzRny8XcJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=LV1tmCxG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034F1606A885;
	Thu, 12 Nov 2026 03:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=LV1tmCxG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E4501F00A08;
	Thu, 12 Nov 2026 03:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794453592;
	bh=X1Xcm2Pd3cLKO0qmRlfLp4SKtK/TsLBKcTHeK4JMYaM=;
	h=Date:To:From:Subject;
	b=LV1tmCxGL/tgBhCTuoewxhZx/IrLKMe0PzCeAaQsmvlBOXc2bjkw+l7+0wcX2awdT
	 TxmPfMR9SxiSmdTxoe3rrezqMkEWH9/q9SdyKxR/FsEhAwiPFMBLIqfqBjE34DuIS2
	 e360o/MnMlOKxe//i+xFT/GI3Q5AjydGnzhSHQdo=
Date: Wed, 11 Nov 2026 19:19:52 -0800
To: mm-commits@vger.kernel.org,vivek.kasireddy@intel.com,
	stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,
	kraxel@redhat.com,jgg@ziepe.ca,gourry@gourry.net,david@kernel.org,
	airlied@redhat.com,ackerleytng@google.com,4ncienth@gmail.com,
	lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-charge-hugetlb-cgroup-and-memcg-in-alloc_hugetlb_folio_reserve.patch added to mm-new branch
Message-Id: <20261112031952.7E4501F00A08@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/hugetlb: charge hugetlb cgroup and memcg in alloc_hugetlb_folio_reserve()
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-charge-hugetlb-cgroup-and-memcg-in-alloc_hugetlb_folio_reserve.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-charge-hugetlb-cgroup-and-memcg-in-alloc_hugetlb_folio_reserve.patch

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
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: mm/hugetlb: charge hugetlb cgroup and memcg in alloc_hugetlb_folio_reserve()
Date: Thu, 12 Nov 2026 10:15:33 +0800

alloc_hugetlb_folio_reserve() hands out a folio from the hugetlb pool and
consumes a global reservation, but unlike the fault path it never charged
the folio to the hugetlb cgroup or to the memcg.  Folios allocated for
memfd_pin_folios() through memfd_alloc_folio() were therefore silently
bypassing the accounting: they are never charged to the hugetlb cgroup
usage counter (hugetlb.<size>.current or hugetlb.<size>.usage_in_bytes),
so the limits (hugetlb.<size>.max or hugetlb.<size>.limit_in_bytes) are
bypassed.  In cgroup v2, with memory_hugetlb_accounting enabled, these
folios are also not accounted in memory.current and are not bounded by
memory.max.

Charge the folios to both the hugetlb cgroup and the memcg, just like
hugetlb_alloc_folio() does.

Test with a process that creates a hugetlb memfd and pins pages through
UDMABUF_CREATE. The counters were read while the folio was still pinned:

Before this patch:
$ echo $$ > /sys/fs/cgroup/test/cgroup.procs
$ ./memfd-alloc-folio 1 &
$ cat /sys/fs/cgroup/test/hugetlb.2MB.current
0
$ cat /sys/fs/cgroup/test/memory.current
1351680
$

After this patch:
$ echo $$ > /sys/fs/cgroup/test/cgroup.procs
$ ./memfd-alloc-folio 1 &
$ cat /sys/fs/cgroup/test/hugetlb.2MB.current
2097152
$ cat /sys/fs/cgroup/test/memory.current
3313664
$

memfd_pin_folios() can now fail because the memcg charge fails. Two
tasks allocating concurrently against the same memory.max may see a
spurious failure. That failure frees the folio, returns the global
reservation, and undoes the hugetlb cgroup charge, so no accounting is
left behind.

Link: https://lore.kernel.org/20261112-for-alloc_hugetlb-1109-v3-1-7a144510a373@kylinos.cn
Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: Daehyeon Ko <4ncienth@gmail.com>
Cc: <stable@vger.kernel.org>
---

 mm/hugetlb.c |   33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-charge-hugetlb-cgroup-and-memcg-in-alloc_hugetlb_folio_reserve
+++ a/mm/hugetlb.c
@@ -2223,12 +2223,19 @@ struct folio *alloc_buddy_hugetlb_folio(
 struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
 		nodemask_t *nmask, gfp_t gfp_mask)
 {
+	struct hugetlb_cgroup *h_cg = NULL;
+	size_t nr_pages = pages_per_huge_page(h);
 	struct folio *folio;
+	int idx = hstate_index(h);
+	int ret;
+
+	if (hugetlb_cgroup_charge_cgroup(idx, nr_pages, &h_cg))
+		return NULL;
 
 	spin_lock_irq(&hugetlb_lock);
 	if (!h->resv_huge_pages) {
 		spin_unlock_irq(&hugetlb_lock);
-		return NULL;
+		goto err_uncharge_hugetlb_cgroup;
 	}
 
 	folio = dequeue_hugetlb_folio_nodemask(h, gfp_mask, preferred_nid,
@@ -2236,11 +2243,31 @@ struct folio *alloc_hugetlb_folio_reserv
 	if (folio) {
 		folio_set_hugetlb_restore_reserve(folio);
 		h->resv_huge_pages--;
-	}
+		hugetlb_cgroup_commit_charge(idx, nr_pages, h_cg, folio);
 
+		spin_unlock_irq(&hugetlb_lock);
+
+		ret = mem_cgroup_charge_hugetlb(folio, current->mm,
+						gfp_mask | __GFP_RETRY_MAYFAIL);
+		if (ret == -ENOMEM) {
+			folio_put(folio);
+			/*
+			 * Skip uncharging hugetlb_cgroup since the charges
+			 * were committed to the folio and freeing the folio
+			 * would have cleared those up.
+			 */
+			return NULL;
+		}
+
+		mod_hugetlb_memcg_state(folio, nr_pages);
+
+		return folio;
+	}
 	spin_unlock_irq(&hugetlb_lock);
 
-	return folio;
+err_uncharge_hugetlb_cgroup:
+	hugetlb_cgroup_uncharge_cgroup(idx, nr_pages, h_cg);
+	return NULL;
 }
 
 /* folio migration callback function */
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

selftests-mm-mlock2-tests-fix-fclosenull-in-is_vmflag_set.patch
mm-hugetlb-charge-hugetlb-cgroup-and-memcg-in-alloc_hugetlb_folio_reserve.patch

