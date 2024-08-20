Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27931C8FBE
	for <mm-commits@vger.kernel.org>; Tue, 20 Aug 2024 23:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724198243; cv=none; b=u5TDWPpUBCYskoOcJ3qES8ji3KSsBt5HPv1YreFJ6/tY1pouoU6nZy4I8mg/UA4CS/nl32twZInsR+DAKnJhTPbrbOd0HWWFLCGlafLfNzmVbhQOtOjAPuRb1wJxqL/X1B3+lDBTeBSCa4RJ76jeEPfHI/Ifw3JdabzdfGc4CDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724198243; c=relaxed/simple;
	bh=Ol8qZLyNm1W/zh62h8MPJ5YztMfBWd/s9iPkuT8atTE=;
	h=Date:To:From:Subject:Message-Id; b=R3g/efPNxRDdrDpPYVORdySZyuSZlzxNB9D3zNmRehul46b9MKZIs67yZjQf83QXCILN6GC4nIqA9PnaPk+W+rKu0NfTvOfLP9P+Q2peeqoNWmruIjVSGnVznxRUYRhh49JDfGuB3YGCFkvSUUpZIi3L5Rf0cW0kcvP19hE/UIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bWd1LEWw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bWd1LEWw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D81CC4AF0B;
	Tue, 20 Aug 2024 23:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724198243;
	bh=Ol8qZLyNm1W/zh62h8MPJ5YztMfBWd/s9iPkuT8atTE=;
	h=Date:To:From:Subject:From;
	b=bWd1LEWw1rdDTPKxWbH0MHBTU3L+RiQsGv8QnezYeUdu/nQvx6dHOh5i2ao7TzC2m
	 z33j00wvatDMonzXBvFL3p2LxQi51nOAlgIs51B8TJTRTqiFJ8Rqvp743ZltYiqbYi
	 iXciHx8rDg2jJukKTi5XUbDjjkA3HAWlmJQks+v4=
Date: Tue, 20 Aug 2024 16:57:22 -0700
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,ioworker0@gmail.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-override-mthp-enabled-defaults-at-kernel-cmdline-v6.patch added to mm-unstable branch
Message-Id: <20240820235723.5D81CC4AF0B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: override mTHP "enabled" defaults at kernel cmdline
has been added to the -mm mm-unstable branch.  Its filename is
     mm-override-mthp-enabled-defaults-at-kernel-cmdline-v6.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-override-mthp-enabled-defaults-at-kernel-cmdline-v6.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-cleanup-count_mthp_stat-definition.patch
mm-tidy-up-shmem-mthp-controls-and-stats.patch
mm-override-mthp-enabled-defaults-at-kernel-cmdline.patch
mm-override-mthp-enabled-defaults-at-kernel-cmdline-v6.patch

