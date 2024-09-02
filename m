Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1FFA2C80
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247845; cv=none; b=VS0P7eZsOY2dHjbjIFn8keyovKCH1OTLrEZZXpCoo+BmR3cVFtqYTx0BlIhk3dAW5D0tHmhKGVrH3Qfhr4ysGG1L7ILyx8+WsfNZ+/FvpuSlVyYiWGo2lsvIXMntL1C12OpPXfIqfVsHs42I+kHAveSKwgBBTnuyRVwGigLRcuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247845; c=relaxed/simple;
	bh=LETfujevItDzpgIMImFfVAR9IOKpmedVBvmWyPqOckA=;
	h=Date:To:From:Subject:Message-Id; b=msZ8qVltpshHFOgNGx+6cV9cFD3VbuCHuHwANgYuCs5v5Sqf/3S6si3HrJBVE5/ytMp2lslcHVPfGIK2aUqeMBMmFDtQqZ9N67V+8KdN6AZRFU8NreVyKpS/dtD/PoU7jArAvMVd0BzGU3ddxCey3r4A3Z9wyBvhyOL6wX7QkWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aIgX/0Hc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aIgX/0Hc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C88C4CEC2;
	Mon,  2 Sep 2024 03:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247845;
	bh=LETfujevItDzpgIMImFfVAR9IOKpmedVBvmWyPqOckA=;
	h=Date:To:From:Subject:From;
	b=aIgX/0HcxMuJZr+y4PWJIIuQPd7/81iTDhUcX3nFI9NnQ6kUAS1pU29nC9FZBIAnL
	 r1B9FuPMstRLSPhD0FzuUTIjO6n4I+HPUYp+VRFnInN3SgJFBVq1EbUoLBgJreaIgY
	 CSSnjnLrbt9HnWF7bbYo60wXvKCpnTkqE8NczpOw=
Date: Sun, 01 Sep 2024 20:30:45 -0700
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,ioworker0@gmail.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-override-mthp-enabled-defaults-at-kernel-cmdline.patch removed from -mm tree
Message-Id: <20240902033045.86C88C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: override mTHP "enabled" defaults at kernel cmdline
has been removed from the -mm tree.  Its filename was
     mm-override-mthp-enabled-defaults-at-kernel-cmdline.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: override mTHP "enabled" defaults at kernel cmdline
Date: Wed, 14 Aug 2024 14:02:47 +1200

Add thp_anon= cmdline parameter to allow specifying the default enablement
of each supported anon THP size.  The parameter accepts the following
format and can be provided multiple times to configure each size:

thp_anon=<size>,<size>[KMG]:<value>;<size>-<size>[KMG]:<value>

An example:

thp_anon=16K-64K:always;128K,512K:inherit;256K:madvise;1M-2M:never

See Documentation/admin-guide/mm/transhuge.rst for more details.

Configuring the defaults at boot time is useful to allow early user space
to take advantage of mTHP before its been configured through sysfs.

[v-songbaohua@oppo.com: use get_oder() and check size is is_power_of_2]
  Link: https://lkml.kernel.org/r/20240814224635.43272-1-21cnbao@gmail.com
[ryan.roberts@arm.com: some minor cleanup according to David's comments]
  Link: https://lkml.kernel.org/r/20240820105244.62703-1-21cnbao@gmail.com
Link: https://lkml.kernel.org/r/20240814020247.67297-1-21cnbao@gmail.com
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

 Documentation/admin-guide/kernel-parameters.txt |    9 +
 Documentation/admin-guide/mm/transhuge.rst      |   36 ++++-
 mm/huge_memory.c                                |   98 +++++++++++++-
 3 files changed, 136 insertions(+), 7 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~mm-override-mthp-enabled-defaults-at-kernel-cmdline
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -6614,6 +6614,15 @@
 			<deci-seconds>: poll all this frequency
 			0: no polling (default)
 
+	thp_anon=	[KNL]
+			Format: <size>,<size>[KMG]:<state>;<size>-<size>[KMG]:<state>
+			state is one of "always", "madvise", "never" or "inherit".
+			Control the default behavior of the system with respect
+			to anonymous transparent hugepages.
+			Can be used multiple times for multiple anon THP sizes.
+			See Documentation/admin-guide/mm/transhuge.rst for more
+			details.
+
 	threadirqs	[KNL,EARLY]
 			Force threading of all interrupt handlers except those
 			marked explicitly IRQF_NO_THREAD.
--- a/Documentation/admin-guide/mm/transhuge.rst~mm-override-mthp-enabled-defaults-at-kernel-cmdline
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -284,13 +284,37 @@ that THP is shared. Exceeding the number
 
 A higher value may increase memory footprint for some workloads.
 
-Boot parameter
-==============
+Boot parameters
+===============
 
-You can change the sysfs boot time defaults of Transparent Hugepage
-Support by passing the parameter ``transparent_hugepage=always`` or
-``transparent_hugepage=madvise`` or ``transparent_hugepage=never``
-to the kernel command line.
+You can change the sysfs boot time default for the top-level "enabled"
+control by passing the parameter ``transparent_hugepage=always`` or
+``transparent_hugepage=madvise`` or ``transparent_hugepage=never`` to the
+kernel command line.
+
+Alternatively, each supported anonymous THP size can be controlled by
+passing ``thp_anon=<size>,<size>[KMG]:<state>;<size>-<size>[KMG]:<state>``,
+where ``<size>`` is the THP size (must be a power of 2 of PAGE_SIZE and
+supported anonymous THP)  and ``<state>`` is one of ``always``, ``madvise``,
+``never`` or ``inherit``.
+
+For example, the following will set 16K, 32K, 64K THP to ``always``,
+set 128K, 512K to ``inherit``, set 256K to ``madvise`` and 1M, 2M
+to ``never``::
+
+	thp_anon=16K-64K:always;128K,512K:inherit;256K:madvise;1M-2M:never
+
+``thp_anon=`` may be specified multiple times to configure all THP sizes as
+required. If ``thp_anon=`` is specified at least once, any anon THP sizes
+not explicitly configured on the command line are implicitly set to
+``never``.
+
+``transparent_hugepage`` setting only affects the global toggle. If
+``thp_anon`` is not specified, PMD_ORDER THP will default to ``inherit``.
+However, if a valid ``thp_anon`` setting is provided by the user, the
+PMD_ORDER THP policy will be overridden. If the policy for PMD_ORDER
+is not defined within a valid ``thp_anon``, its policy will default to
+``never``.
 
 Hugepages in tmpfs/shmem
 ========================
--- a/mm/huge_memory.c~mm-override-mthp-enabled-defaults-at-kernel-cmdline
+++ a/mm/huge_memory.c
@@ -81,6 +81,7 @@ unsigned long huge_zero_pfn __read_mostl
 unsigned long huge_anon_orders_always __read_mostly;
 unsigned long huge_anon_orders_madvise __read_mostly;
 unsigned long huge_anon_orders_inherit __read_mostly;
+static bool anon_orders_configured __initdata;
 
 unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 					 unsigned long vm_flags,
@@ -649,7 +650,8 @@ static int __init hugepage_init_sysfs(st
 	 * disable all other sizes. powerpc's PMD_ORDER isn't a compile-time
 	 * constant so we have to do this here.
 	 */
-	huge_anon_orders_inherit = BIT(PMD_ORDER);
+	if (!anon_orders_configured)
+		huge_anon_orders_inherit = BIT(PMD_ORDER);
 
 	*hugepage_kobj = kobject_create_and_add("transparent_hugepage", mm_kobj);
 	if (unlikely(!*hugepage_kobj)) {
@@ -834,6 +836,100 @@ out:
 }
 __setup("transparent_hugepage=", setup_transparent_hugepage);
 
+static inline int get_order_from_str(const char *size_str)
+{
+	unsigned long size;
+	char *endptr;
+	int order;
+
+	size = memparse(size_str, &endptr);
+
+	if (!is_power_of_2(size))
+		goto err;
+	order = get_order(size);
+	if (BIT(order) & ~THP_ORDERS_ALL_ANON)
+		goto err;
+
+	return order;
+err:
+	pr_err("invalid size %s in thp_anon boot parameter\n", size_str);
+	return -EINVAL;
+}
+
+static char str_dup[PAGE_SIZE] __initdata;
+static int __init setup_thp_anon(char *str)
+{
+	char *token, *range, *policy, *subtoken;
+	unsigned long always, inherit, madvise;
+	char *start_size, *end_size;
+	int start, end, nr;
+	char *p;
+
+	if (!str || strlen(str) + 1 > PAGE_SIZE)
+		goto err;
+	strcpy(str_dup, str);
+
+	always = huge_anon_orders_always;
+	madvise = huge_anon_orders_madvise;
+	inherit = huge_anon_orders_inherit;
+	p = str_dup;
+	while ((token = strsep(&p, ";")) != NULL) {
+		range = strsep(&token, ":");
+		policy = token;
+
+		if (!policy)
+			goto err;
+
+		while ((subtoken = strsep(&range, ",")) != NULL) {
+			if (strchr(subtoken, '-')) {
+				start_size = strsep(&subtoken, "-");
+				end_size = subtoken;
+
+				start = get_order_from_str(start_size);
+				end = get_order_from_str(end_size);
+			} else {
+				start = end = get_order_from_str(subtoken);
+			}
+
+			if (start < 0 || end < 0 || start > end)
+				goto err;
+
+			nr = end - start + 1;
+			if (!strcmp(policy, "always")) {
+				bitmap_set(&always, start, nr);
+				bitmap_clear(&inherit, start, nr);
+				bitmap_clear(&madvise, start, nr);
+			} else if (!strcmp(policy, "madvise")) {
+				bitmap_set(&madvise, start, nr);
+				bitmap_clear(&inherit, start, nr);
+				bitmap_clear(&always, start, nr);
+			} else if (!strcmp(policy, "inherit")) {
+				bitmap_set(&inherit, start, nr);
+				bitmap_clear(&madvise, start, nr);
+				bitmap_clear(&always, start, nr);
+			} else if (!strcmp(policy, "never")) {
+				bitmap_clear(&inherit, start, nr);
+				bitmap_clear(&madvise, start, nr);
+				bitmap_clear(&always, start, nr);
+			} else {
+				pr_err("invalid policy %s in thp_anon boot parameter\n", policy);
+				goto err;
+			}
+		}
+	}
+
+	huge_anon_orders_always = always;
+	huge_anon_orders_madvise = madvise;
+	huge_anon_orders_inherit = inherit;
+	anon_orders_configured = true;
+	return 1;
+
+err:
+	pr_warn("thp_anon=%s: error parsing string, ignoring setting\n", str);
+	return 0;
+}
+__setup("thp_anon=", setup_thp_anon);
+
 pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma)
 {
 	if (likely(vma->vm_flags & VM_WRITE))
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-cleanup-count_mthp_stat-definition.patch
mm-tidy-up-shmem-mthp-controls-and-stats.patch

