Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053BD369D51;
	Tue, 25 Aug 2026 01:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622960; cv=none; b=Y1Bx+Ou+6Cm/Tf/2Yu9j+RACllZCx0U0mGHV3yy2l7n8JeGsvVie8rih7edvW3BxzachCVxiqFuInCZtnXmGUFLiT56zVO11pujjCgcUBmOezV+IpdScBxxtOz7FVWDpnSK8amiE6Nvz7Jfax25lPMsTycLpTZap8KpKDgbnW24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622960; c=relaxed/simple;
	bh=h68WxliiAM98eqpQclSdDH7g3rMWBR93KAabbl4MS6E=;
	h=Date:To:From:Subject:Message-Id; b=Cic/LwIvCnuXYeM7s4X5nGvJCr45lXjB4wRsq5GmoSmsmXfOUZY4d2oe1HtxiEGjqaMw6X/Qhb5C0Aef0kcEvBgwwB6mCGUUMGFKJ/cAkpDPsIwuSO7+7KUzVVqPzQW0ei8hvSEasOwZFqV/rOgB/McNupX5SIDY+UMqYh+w95s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lOGIGL4F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lOGIGL4F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD98D1F00A3A;
	Tue, 25 Aug 2026 01:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622958;
	bh=haePXnmC4NTXD6UfextFfV+k/p0/oXERsEllcbEqyPU=;
	h=Date:To:From:Subject;
	b=lOGIGL4FfDtlAZAkXr0oVgBwe1IX4UoAq3a/ccncwVmw//aydP2iF1o0t05J91tTO
	 qulxkczlvMJ4EEngG+rV7thp3WdIA2KPlXq/byzvIAsUfEtlvKhMexUnAeF0c2ueDs
	 quxn5AE/a7feCiN9KSUzPysb/hCbij7g1E1nPqQo=
Date: Mon, 24 Aug 2026 18:55:58 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shikemeng@huaweicloud.com,osalvador@suse.de,nphamcs@gmail.com,linmiaohe@huawei.com,kasong@tencent.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-ratelimit-bad-swap-entry-reports.patch removed from -mm tree
Message-Id: <20260825015558.CD98D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: ratelimit bad swap entry reports
has been removed from the -mm tree.  Its filename was
     mm-swap-ratelimit-bad-swap-entry-reports.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: mm, swap: ratelimit bad swap entry reports
Date: Tue, 18 Aug 2026 02:03:40 -0700

A corrupt page table hands the same bogus entry to get_swap_device() on
every access to the mapping, and every rejection is logged.  One machine
logged 6185620 copies of the same line in a few hours.

swap_dup_entry_direct() prints the same message from the fork path, once
per call: the WARN_ON_ONCE() guarding it warns once, the pr_err() inside
does not.

Rate limit all three prints.

Link: https://lore.kernel.org/20260818-swap_part_one-v1-1-a4fc58119fc0@debian.org
Fixes: 23b230ba8ac3 ("mm/swap: print bad swap offset entry in get_swap_device")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Kairui Song <kasong@tencent.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/swapfile.c~mm-swap-ratelimit-bad-swap-entry-reports
+++ a/mm/swapfile.c
@@ -1899,11 +1899,11 @@ struct swap_info_struct *get_swap_device
 
 	return si;
 bad_nofile:
-	pr_err("%s: %s%08lx\n", __func__, Bad_file, entry.val);
+	pr_err_ratelimited("%s: %s%08lx\n", __func__, Bad_file, entry.val);
 out:
 	return NULL;
 put_out:
-	pr_err("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
+	pr_err_ratelimited("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
 	percpu_ref_put(&si->users);
 	return NULL;
 }
@@ -3883,7 +3883,7 @@ int swap_dup_entry_direct(swp_entry_t en
 
 	si = swap_entry_to_info(entry);
 	if (WARN_ON_ONCE(!si)) {
-		pr_err("%s%08lx\n", Bad_file, entry.val);
+		pr_err_ratelimited("%s%08lx\n", Bad_file, entry.val);
 		return -EINVAL;
 	}
 
_

Patches currently in -mm which might be from leitao@debian.org are


