Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331E6261B91
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744883; cv=none; b=kj3V7761xnxi+THRBYMjIZPmBFhz94djbWtqr2pvXbF+UOY2Q4Y0ydm+rKjKZ1lVhtHg7YYHFXJ+p851UGBSyPkrm0fHD5yj1eszKxOJBGsf2il0fvD0USHUDsZ1vJ6zIY3YpJLoezrenWQal3Flg9rLFNPFoetYPV64/GBciuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744883; c=relaxed/simple;
	bh=CFl01WEh14dSdh9ck/66Sva85AplYvXPzqJpAd/IduQ=;
	h=Date:To:From:Subject:Message-Id; b=FI7LtDm32mar9SEGBp5LUAyFNpZegdYPqZE7v420JKijYtlsjwoiVamSmOV/4lPkDJIa2ulvaYxEVX9PBcUW1vfRwEfTR/dgZvppuTBx2fltwLB1CfIjriFwL4xNtw+ZAPUSWnbJ3x3BPY2hTKlB6UIvx72c9ouF7k+ELQu1JvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QbZxBtau; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QbZxBtau"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BDC0C4CEF7;
	Sun, 29 Mar 2026 00:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744883;
	bh=CFl01WEh14dSdh9ck/66Sva85AplYvXPzqJpAd/IduQ=;
	h=Date:To:From:Subject:From;
	b=QbZxBtau7dY6K9EkndjSEExGNobavfgnjhKMW0bhMa8+vQl9achBsgrqIA9hghZc/
	 CiwkxbprW3S9FSBgwy+Bd1GQmxMhWu9U4iA/OQI25HfIGNlF88nGMaiXghM8+QFtpP
	 6AmtXu82UBVFGLX8V9edzu2YcS2X+TmRFHv5nvno=
Date: Sat, 28 Mar 2026 17:41:22 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usamaarif642@gmail.com,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,richard.weiyang@gmail.com,npache@redhat.com,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,lance.yang@linux.dev,jackmanb@google.com,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ratelimit-min_free_kbytes-adjustment-messages.patch removed from -mm tree
Message-Id: <20260329004123.0BDC0C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: ratelimit min_free_kbytes adjustment messages
has been removed from the -mm tree.  Its filename was
     mm-ratelimit-min_free_kbytes-adjustment-messages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: mm: ratelimit min_free_kbytes adjustment messages
Date: Tue, 17 Mar 2026 08:33:59 -0700

The "raising min_free_kbytes" pr_info message in
set_recommended_min_free_kbytes() and the "min_free_kbytes is not updated
to" pr_warn in calculate_min_free_kbytes() can spam the kernel log when
called repeatedly.

Switch the pr_info in set_recommended_min_free_kbytes() and the pr_warn in
calculate_min_free_kbytes() to their _ratelimited variants to prevent the
log spam for this message.

Link: https://lkml.kernel.org/r/20260317-thp_logs-v7-4-31eb98fa5a8b@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    4 ++--
 mm/page_alloc.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/mm/khugepaged.c~mm-ratelimit-min_free_kbytes-adjustment-messages
+++ a/mm/khugepaged.c
@@ -2701,8 +2701,8 @@ void set_recommended_min_free_kbytes(voi
 
 	if (recommended_min > min_free_kbytes) {
 		if (user_min_free_kbytes >= 0)
-			pr_info("raising min_free_kbytes from %d to %lu to help transparent hugepage allocations\n",
-				min_free_kbytes, recommended_min);
+			pr_info_ratelimited("raising min_free_kbytes from %d to %lu to help transparent hugepage allocations\n",
+					    min_free_kbytes, recommended_min);
 
 		min_free_kbytes = recommended_min;
 	}
--- a/mm/page_alloc.c~mm-ratelimit-min_free_kbytes-adjustment-messages
+++ a/mm/page_alloc.c
@@ -6514,8 +6514,8 @@ void calculate_min_free_kbytes(void)
 	if (new_min_free_kbytes > user_min_free_kbytes)
 		min_free_kbytes = clamp(new_min_free_kbytes, 128, 262144);
 	else
-		pr_warn("min_free_kbytes is not updated to %d because user defined value %d is preferred\n",
-				new_min_free_kbytes, user_min_free_kbytes);
+		pr_warn_ratelimited("min_free_kbytes is not updated to %d because user defined value %d is preferred\n",
+				    new_min_free_kbytes, user_min_free_kbytes);
 
 }
 
_

Patches currently in -mm which might be from leitao@debian.org are

mm-kmemleak-add-config_debug_kmemleak_verbose-build-option.patch
kho-add-size-parameter-to-kho_add_subtree.patch
kho-rename-fdt-parameter-to-blob-in-kho_add-remove_subtree.patch
kho-persist-blob-size-in-kho-fdt.patch
kho-fix-kho_in_debugfs_init-to-handle-non-fdt-blobs.patch
kho-kexec-metadata-track-previous-kernel-chain.patch
kho-document-kexec-metadata-tracking-feature.patch

