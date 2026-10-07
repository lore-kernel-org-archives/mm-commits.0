Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666932EF653
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334235; cv=none; b=mz/5D3iezhuJljmlj4wFklFo0knMlNDriZUtnxrAeVRR4qsTjYoUJNJmAKrgXgSc819mJW25O3ZhFvDARAExafymLl6geRCXaJLne6zhx2xMXyLEIakx+HXw6/jSJoh+LFMg6YGx92e/JClu44GNcbmdYeMFXlNyHe+2aR+zfPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334235; c=relaxed/simple;
	bh=RVgZgZutFORQYoQGXlqq45UJUhvu4+LK8xMAjretuQs=;
	h=Date:To:From:Subject:Message-Id; b=NxM9dOn0t0IrRQHxqvAaROYEoqeojwxuGzRkCu2fBlHn2Hmz92MWpF5sivaQRdP3Y0aOOqANPBAIEMv6KAWRa/WIr/qfGuhQdkJX5j/AMtiHTlgK5gI4K2CjyPX86RfSzH1f3jzRlj7k3x4t5TVmvawdIrJlVnaHPBJf4gcITB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yMNjudg/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yMNjudg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D30B1F0089C;
	Wed,  7 Oct 2026 00:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334234;
	bh=stxQlYPIA2ZqqRbyvhS2w/CyFUTS83onYN3QObX6LWE=;
	h=Date:To:From:Subject;
	b=yMNjudg//e46wWuW9JhC98ee/I4t5QUWSihiMXvV5JoAbzFh1ppkEyprn8TxKhEVM
	 +Px/5Zhbfu78mKNQ71+QWxR38Aj9jNPP2ZCjicJQFx3hO3z97N6pzqjqAXdlpi55dO
	 AIWDVbQi+KScvFhMXIvBcYMQag64Z2WwEKZH/SDs=
Date: Tue, 06 Oct 2026 17:50:33 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,stevensd@chromium.org,shakeel.butt@linux.dev,mhocko@kernel.org,ljs@kernel.org,lianux.mm@gmail.com,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,chenridong@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-make-type-fallback-logic-explicit-in-isolate_folios.patch removed from -mm tree
Message-Id: <20261007005034.3D30B1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: make type fallback logic explicit in isolate_folios()
has been removed from the -mm tree.  Its filename was
     mm-mglru-make-type-fallback-logic-explicit-in-isolate_folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ridong Chen <chenridong@xiaomi.com>
Subject: mm/mglru: make type fallback logic explicit in isolate_folios()
Date: Sat, 29 Aug 2026 15:42:03 +0800

Patch series "mm/mglru: clean up isolate_folios for readability and
clarity", v2.

Right now, isolate_folios() is quite difficult to follow:

1. It uses for_each_evictable_type(i, swappiness) to iterate over
   the types, but 'i' is not actually used as the type within the
   loop body.

2. It retries the same type when folios were scanned but none could
   be isolated, but the retry is implemented in a rather subtle way
   that is difficult to understand.

This patchset makes both behaviors explicit and much easier to follow.

There are no functional changes for swappiness values from 1 to 200. 
There is a slight functional change for 0 and 201: with the existing code,
there is no chance to retry for these values because
for_each_evictable_type() only iterates once.  After this patch, 0 and 201
have behavior that is more consistent with the 1-200 range.


This patch (of 2):

The for_each_evictable_type() loop in isolate_folios() is misleading: it
does not actually iterate over each evictable type.  Instead,
get_type_to_scan() selects the type to scan, while the iterator `i` merely
bounds the number of attempts.

Make the fallback behavior explicit in the code and remove the opaque
for_each_evictable_type(i, swappiness).

Link: https://lore.kernel.org/20260829074204.45304-1-baohua@kernel.org
Link: https://lore.kernel.org/20260829074204.45304-2-baohua@kernel.org
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Stevens <stevensd@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
---

 mm/vmscan.c |   50 ++++++++++++++++++++++++++++----------------------
 1 file changed, 28 insertions(+), 22 deletions(-)

--- a/mm/vmscan.c~mm-mglru-make-type-fallback-logic-explicit-in-isolate_folios
+++ a/mm/vmscan.c
@@ -4826,35 +4826,41 @@ static int get_type_to_scan(struct lruve
 	return positive_ctrl_err(&sp, &pv);
 }
 
+static inline bool is_single_type_reclaim(int swappiness)
+{
+	return swappiness == MIN_SWAPPINESS ||
+	       swappiness == SWAPPINESS_ANON_ONLY;
+}
+
 static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			  struct scan_control *sc, int swappiness,
 			  struct list_head *list, int *isolated,
 			  int *isolate_type, int *isolate_scanned)
 {
-	int i;
-	int total_scanned = 0;
+	bool type_fallback_allowed = !is_single_type_reclaim(swappiness);
 	int type = get_type_to_scan(lruvec, swappiness);
+	int total_scanned = 0, scanned, tier;
+
+retry:
+	tier = get_tier_idx(lruvec, type);
+	scanned = scan_folios(nr_to_scan, lruvec, sc,
+			      type, tier, list, isolated);
+
+	total_scanned += scanned;
+	if (*isolated) {
+		*isolate_type = type;
+		*isolate_scanned = scanned;
+		return total_scanned;
+	}
 
-	for_each_evictable_type(i, swappiness) {
-		int scanned;
-		int tier = get_tier_idx(lruvec, type);
-
-		scanned = scan_folios(nr_to_scan, lruvec, sc,
-				      type, tier, list, isolated);
-
-		total_scanned += scanned;
-		if (*isolated) {
-			*isolate_type = type;
-			*isolate_scanned = scanned;
-			break;
-		}
-		/*
-		 * If scanned > 0 and isolated == 0, avoid falling back to the
-		 * other type, as this type remains sufficient. Falling back
-		 * too readily can disrupt the positive_ctrl_err() bias.
-		 */
-		if (!scanned)
-			type = !type;
+	/*
+	 * We are running out of the current reclaim type. Fall back to
+	 * the other type if allowed.
+	 */
+	if (!scanned && type_fallback_allowed) {
+		type = !type;
+		type_fallback_allowed = false;
+		goto retry;
 	}
 
 	return total_scanned;
_

Patches currently in -mm which might be from chenridong@xiaomi.com are

mm-page_counter-avoid-integer-overflow-in-effective_protection.patch
mm-mglru-fix-ineffective-memory-protection-for-non-kswapd-reclaim.patch
mm-vmscan-put-rotation-missed-folios-at-the-lru-tail.patch

