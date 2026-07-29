Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CAC390CA9
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298418; cv=none; b=KdZBXsBKZJbBrMCgPO8ZL3A9kFRBkbKsmZhsn6ok/JWYd4B5TZZEAFKtAtY/3nKFBX88z9BRVLtyhu18pmV8uij0+8IByPnEnVQ9BPSrWD8rGMnsMvUiP4bz3qOCMJp8/kpEVB9eSSiD+Zkr40MmxaopSDX4CrF5/kTgWDyjDLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298418; c=relaxed/simple;
	bh=VUU+WbDCC2N0g2LPUomYD/YvOLNTcogOaJbSoBnnCLQ=;
	h=Date:To:From:Subject:Message-Id; b=Br3VMLEbQgRtXGU3VKkdqlYeNLmEIWi2j2R017FwlNEN/WiHksVY/lnDcOgKHyKMn0k37Vbn3GSu6K/ieIQffMyFh7KAZapLBzXm9WA+bYTxGnwVVKzgF+ZCaFKbvKb7ctE/x2jC1Rg9QrsjScW5G1Qze0v3pbHYUydBAW3JSLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hpV7eraR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hpV7eraR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F031F00A3A;
	Wed, 29 Jul 2026 04:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298417;
	bh=u8WynCws5qXbPjk4vbQR9NZOL/bnKRTUXIJNkcjKdkY=;
	h=Date:To:From:Subject;
	b=hpV7eraRIPHFQNX8vFNtXZD+mTM1lfFl17SXsclL0S6wsmHvAZiZkgT1qkvjbxj0P
	 vuMn/GrHSxhic5GQbnB81AjO9FAtVw8GRp+MC1+SrmFq/SVQFTwB84sOX4A0sTIw4/
	 SBCuP6LHmIp1AuHo4TJL8byeeEi0o6kFYZUaVbvs=
Date: Tue, 28 Jul 2026 21:13:36 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,ljs@kernel.org,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_owner-move-free_ts_nsec-output-to-free-section-in-__dump_page_owner.patch removed from -mm tree
Message-Id: <20260729041337.12F031F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_owner: move free_ts_nsec output to free section in __dump_page_owner()
has been removed from the -mm tree.  Its filename was
     mm-page_owner-move-free_ts_nsec-output-to-free-section-in-__dump_page_owner.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ye Liu <ye.liu@linux.dev>
Subject: mm/page_owner: move free_ts_nsec output to free section in __dump_page_owner()
Date: Tue, 14 Jul 2026 09:51:05 +0800

The free_ts_nsec field is a free-event timestamp, but it was printed in
the allocation summary line alongside ts_nsec (allocation time).  Move it
to the free section where it logically belongs, together with free_pid and
free_tgid.  This also makes __dump_page_owner() consistent with
print_page_owner(), which only prints ts_nsec in the allocation summary.

The output now groups all free-related information (pid, tgid, timestamp,
stack trace) in one place.

No functional change except output formatting.

Link: https://lore.kernel.org/20260714015117.78351-7-ye.liu@linux.dev
Signed-off-by: Ye Liu <ye.liu@linux.dev>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-move-free_ts_nsec-output-to-free-section-in-__dump_page_owner
+++ a/mm/page_owner.c
@@ -653,10 +653,10 @@ void __dump_page_owner(const struct page
 	else
 		pr_alert("page_owner tracks the page as freed\n");
 
-	pr_alert("page last allocated via order %u, migratetype %s, gfp_mask %#x(%pGg), pid %d, tgid %d (%s), ts %llu, free_ts %llu\n",
+	pr_alert("page last allocated via order %u, migratetype %s, gfp_mask %#x(%pGg), pid %d, tgid %d (%s), ts %llu\n",
 		 page_owner->order, migratetype_names[mt], gfp_mask, &gfp_mask,
 		 page_owner->pid, page_owner->tgid, page_owner->comm,
-		 page_owner->ts_nsec, page_owner->free_ts_nsec);
+		 page_owner->ts_nsec);
 
 	handle = READ_ONCE(page_owner->handle);
 	if (!handle)
@@ -668,8 +668,9 @@ void __dump_page_owner(const struct page
 	if (!handle) {
 		pr_alert("page_owner free stack trace missing\n");
 	} else {
-		pr_alert("page last free pid %d tgid %d stack trace:\n",
-			  page_owner->free_pid, page_owner->free_tgid);
+		pr_alert("page last free pid %d tgid %d ts %llu stack trace:\n",
+			  page_owner->free_pid, page_owner->free_tgid,
+			  page_owner->free_ts_nsec);
 		stack_depot_print(handle);
 	}
 
_

Patches currently in -mm which might be from ye.liu@linux.dev are


