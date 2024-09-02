Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7B51388
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247053; cv=none; b=U3O3Yf3EKclsQPWVUV2IGLnkNRMp6Ds0knR4vthUfNByh+xj+DirsgEdTvA956O2pTT1AH72nOjQz1fTwYJkyEtKdKXpbwf9m1ZqkHdJs1B/OHnZqRCGW6MPHLM9i5BMPuRp0Aq1kA+kAkGYFsOgCmfhZJQ4Wqabus3MUrmCTlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247053; c=relaxed/simple;
	bh=mAzw/K04MyWxjtAcwn5Ou/RpxVF3qALIHkJvoCAKDio=;
	h=Date:To:From:Subject:Message-Id; b=cDeRzaTFHIkSxbGKKhATw066FDuV+bMtdqtDJfl81LpSeZwc9aVI848amARGW2+2+JqFfyuT1clJIoIv+r5mPlQ+P9YAyBQbkEvzK+wuGAwLJqHZ8kcA6IjKq8s0ej1WP0QERWj+InbLzUD1+gTJofL2jIevQTImSGGvr815qqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OcaHjHkN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OcaHjHkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E321C4CEC3;
	Mon,  2 Sep 2024 03:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247052;
	bh=mAzw/K04MyWxjtAcwn5Ou/RpxVF3qALIHkJvoCAKDio=;
	h=Date:To:From:Subject:From;
	b=OcaHjHkNjTCYL8KE0niIJn5CMFlOAcRGbtkly5TXZFIIETfx10HZDwIACF29Ellg7
	 aDD6n6AEgM1fRMFSbxO2Ca8Z0oynkheiXQvZf1+8tvD7XfmOeldk7e/piwrG43IBWU
	 XZl0e2gUWwPO290Nor2atAn/utdRD4a3BPp/FvBE=
Date: Sun, 01 Sep 2024 20:17:32 -0700
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,ioworker0@gmail.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-override-mthp-enabled-defaults-at-kernel-cmdline-v6.patch removed from -mm tree
Message-Id: <20240902031732.9E321C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: override mTHP "enabled" defaults at kernel cmdline
has been removed from the -mm tree.  Its filename was
     mm-override-mthp-enabled-defaults-at-kernel-cmdline-v6.patch

This patch was dropped because it was folded into mm-override-mthp-enabled-defaults-at-kernel-cmdline.patch

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: override mTHP "enabled" defaults at kernel cmdline
Date: Tue, 20 Aug 2024 22:52:44 +1200

some minor cleanup according to David's comments

Link: https://lkml.kernel.org/r/20240820105244.62703-1-21cnbao@gmail.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Co-developed-by: Barry Song <v-songbaohua@oppo.com>
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <ioworker0@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    4 -
 Documentation/admin-guide/mm/transhuge.rst      |    5 +
 mm/huge_memory.c                                |   41 ++++++--------
 3 files changed, 25 insertions(+), 25 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~mm-override-mthp-enabled-defaults-at-kernel-cmdline-v6
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -6632,8 +6632,8 @@
 	thp_anon=	[KNL]
 			Format: <size>,<size>[KMG]:<state>;<size>-<size>[KMG]:<state>
 			state is one of "always", "madvise", "never" or "inherit".
-			Can be used to control the default behavior of the
-			system with respect to anonymous transparent hugepages.
+			Control the default behavior of the system with respect
+			to anonymous transparent hugepages.
 			Can be used multiple times for multiple anon THP sizes.
 			See Documentation/admin-guide/mm/transhuge.rst for more
 			details.
--- a/Documentation/admin-guide/mm/transhuge.rst~mm-override-mthp-enabled-defaults-at-kernel-cmdline-v6
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -294,8 +294,9 @@ kernel command line.
 
 Alternatively, each supported anonymous THP size can be controlled by
 passing ``thp_anon=<size>,<size>[KMG]:<state>;<size>-<size>[KMG]:<state>``,
-where ``<size>`` is the THP size and ``<state>`` is one of ``always``,
-``madvise``, ``never`` or ``inherit``.
+where ``<size>`` is the THP size (must be a power of 2 of PAGE_SIZE and
+supported anonymous THP)  and ``<state>`` is one of ``always``, ``madvise``,
+``never`` or ``inherit``.
 
 For example, the following will set 16K, 32K, 64K THP to ``always``,
 set 128K, 512K to ``inherit``, set 256K to ``madvise`` and 1M, 2M
--- a/mm/huge_memory.c~mm-override-mthp-enabled-defaults-at-kernel-cmdline-v6
+++ a/mm/huge_memory.c
@@ -81,7 +81,7 @@ unsigned long huge_zero_pfn __read_mostl
 unsigned long huge_anon_orders_always __read_mostly;
 unsigned long huge_anon_orders_madvise __read_mostly;
 unsigned long huge_anon_orders_inherit __read_mostly;
-static bool anon_orders_configured;
+static bool anon_orders_configured __initdata;
 
 unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 					 unsigned long vm_flags,
@@ -734,10 +734,8 @@ static int __init hugepage_init_sysfs(st
 	 * disable all other sizes. powerpc's PMD_ORDER isn't a compile-time
 	 * constant so we have to do this here.
 	 */
-	if (!anon_orders_configured) {
+	if (!anon_orders_configured)
 		huge_anon_orders_inherit = BIT(PMD_ORDER);
-		anon_orders_configured = true;
-	}
 
 	*hugepage_kobj = kobject_create_and_add("transparent_hugepage", mm_kobj);
 	if (unlikely(!*hugepage_kobj)) {
@@ -930,10 +928,10 @@ static inline int get_order_from_str(con
 
 	size = memparse(size_str, &endptr);
 
-	if (!is_power_of_2(size >> PAGE_SHIFT))
+	if (!is_power_of_2(size))
 		goto err;
 	order = get_order(size);
-	if ((1 << order) & ~THP_ORDERS_ALL_ANON)
+	if (BIT(order) & ~THP_ORDERS_ALL_ANON)
 		goto err;
 
 	return order;
@@ -942,13 +940,13 @@ err:
 	return -EINVAL;
 }
 
-static char str_dup[PAGE_SIZE] __meminitdata;
+static char str_dup[PAGE_SIZE] __initdata;
 static int __init setup_thp_anon(char *str)
 {
 	char *token, *range, *policy, *subtoken;
 	unsigned long always, inherit, madvise;
 	char *start_size, *end_size;
-	int start, end;
+	int start, end, nr;
 	char *p;
 
 	if (!str || strlen(str) + 1 > PAGE_SIZE)
@@ -980,22 +978,23 @@ static int __init setup_thp_anon(char *s
 			if (start < 0 || end < 0 || start > end)
 				goto err;
 
+			nr = end - start + 1;
 			if (!strcmp(policy, "always")) {
-				bitmap_set(&always, start, end - start + 1);
-				bitmap_clear(&inherit, start, end - start + 1);
-				bitmap_clear(&madvise, start, end - start + 1);
+				bitmap_set(&always, start, nr);
+				bitmap_clear(&inherit, start, nr);
+				bitmap_clear(&madvise, start, nr);
 			} else if (!strcmp(policy, "madvise")) {
-				bitmap_set(&madvise, start, end - start + 1);
-				bitmap_clear(&inherit, start, end - start + 1);
-				bitmap_clear(&always, start, end - start + 1);
+				bitmap_set(&madvise, start, nr);
+				bitmap_clear(&inherit, start, nr);
+				bitmap_clear(&always, start, nr);
 			} else if (!strcmp(policy, "inherit")) {
-				bitmap_set(&inherit, start, end - start + 1);
-				bitmap_clear(&madvise, start, end - start + 1);
-				bitmap_clear(&always, start, end - start + 1);
+				bitmap_set(&inherit, start, nr);
+				bitmap_clear(&madvise, start, nr);
+				bitmap_clear(&always, start, nr);
 			} else if (!strcmp(policy, "never")) {
-				bitmap_clear(&inherit, start, end - start + 1);
-				bitmap_clear(&madvise, start, end - start + 1);
-				bitmap_clear(&always, start, end - start + 1);
+				bitmap_clear(&inherit, start, nr);
+				bitmap_clear(&madvise, start, nr);
+				bitmap_clear(&always, start, nr);
 			} else {
 				pr_err("invalid policy %s in thp_anon boot parameter\n", policy);
 				goto err;
@@ -1010,7 +1009,7 @@ static int __init setup_thp_anon(char *s
 	return 1;
 
 err:
-	pr_warn("thp_anon=%s: cannot parse, ignored\n", str);
+	pr_warn("thp_anon=%s: error parsing string, ignoring setting\n", str);
 	return 0;
 }
 __setup("thp_anon=", setup_thp_anon);
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-override-mthp-enabled-defaults-at-kernel-cmdline.patch
mm-cleanup-count_mthp_stat-definition.patch
mm-tidy-up-shmem-mthp-controls-and-stats.patch

