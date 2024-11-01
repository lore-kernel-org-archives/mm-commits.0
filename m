Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F561CEAAC
	for <mm-commits@vger.kernel.org>; Fri,  1 Nov 2024 18:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730485754; cv=none; b=QBq+2YArhsDnts7soMsaDUqmjftTaIVQOu+103Y+6nhpOfLkI+CqBRsITH2U3PdD49vmXGz01xNvhCXv6D7SilhScDMluwtgI07qTzjHP9u+Q9/SiTn2S99vXDxi8/Rb8Lbz63SER8J/a5G0qLgX/zS1OFJrFxYh+s4M26Ug/fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730485754; c=relaxed/simple;
	bh=PWD2bgf39fn/UY5WXiIV+uyJ0NH1XkyCfY/lUOT2IsM=;
	h=Date:To:From:Subject:Message-Id; b=cUtUQHpPE1Q8HZxZ82p6wz3iB+zA9itoUpRELVUSWPkBjlDhj05Q9IxD6iDR7gNW8kHNq2c3o4F3ZGqz3pMugF+YTC7IZC1ewX8U6+jR6uvUqq+nqoLm7dQrvOjfIlyGmV1D3eG9Xvc8EfmSl+ECk71Ba2dtkNiz0WwuFxNarkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LutYtOaZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LutYtOaZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F0BDC4CECD;
	Fri,  1 Nov 2024 18:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730485754;
	bh=PWD2bgf39fn/UY5WXiIV+uyJ0NH1XkyCfY/lUOT2IsM=;
	h=Date:To:From:Subject:From;
	b=LutYtOaZHuzgCRlbsr6UlRo2gGl1DSRB1EYl793Y2fwuv7Y/60A7ME1Sy/HOYaxtG
	 6FAdZlcpAC3lCAehzx7OdCRllqYHDNgnrrBMRMlWneNmbRmYEPpJ0KMG1V/LNYndH0
	 PhvTxu6ZRIpcPlT/oUjzwcBK9/UT5yjZ5GcxrHLw=
Date: Fri, 01 Nov 2024 11:29:13 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,mcanal@igalia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-override-mthp-shmem-default-with-a-kernel-parameter.patch added to mm-unstable branch
Message-Id: <20241101182914.1F0BDC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: override mTHP shmem default with a kernel parameter
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-override-mthp-shmem-default-with-a-kernel-parameter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-override-mthp-shmem-default-with-a-kernel-parameter.patch

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
From: Maíra Canal <mcanal@igalia.com>
Subject: mm: shmem: override mTHP shmem default with a kernel parameter
Date: Fri, 1 Nov 2024 13:54:08 -0300

Add the ``thp_shmem=`` kernel command line to allow specifying the default
policy of each supported shmem hugepage size.  The kernel parameter
accepts the following format:

thp_shmem=<size>[KMG],<size>[KMG]:<policy>;<size>[KMG]-<size>[KMG]:<policy>

For example,

thp_shmem=16K-64K:always;128K,512K:inherit;256K:advise;1M-2M:never;4M-8M:within_size

Some GPUs may benefit from using huge pages.  Since DRM GEM uses shmem to
allocate anonymous pageable memory, it's essential to control the huge
page allocation policy for the internal shmem mount.  This control can be
achieved through the ``transparent_hugepage_shmem=`` parameter.

Beyond just setting the allocation policy, it's crucial to have granular
control over the size of huge pages that can be allocated.  The GPU may
support only specific huge page sizes, and allocating pages larger/smaller
than those sizes would be ineffective.

Link: https://lkml.kernel.org/r/20241101165719.1074234-6-mcanal@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |   10 +
 Documentation/admin-guide/mm/transhuge.rst      |   17 ++
 mm/shmem.c                                      |  105 +++++++++++++-
 3 files changed, 131 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~mm-shmem-override-mthp-shmem-default-with-a-kernel-parameter
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -6700,6 +6700,16 @@
 			Force threading of all interrupt handlers except those
 			marked explicitly IRQF_NO_THREAD.
 
+	thp_shmem=	[KNL]
+			Format: <size>[KMG],<size>[KMG]:<policy>;<size>[KMG]-<size>[KMG]:<policy>
+			Control the default policy of each hugepage size for the
+			internal shmem mount. <policy> is one of policies available
+			for the shmem mount ("always", "inherit", "never", "within_size",
+			and "advise").
+			It can be used multiple times for multiple shmem THP sizes.
+			See Documentation/admin-guide/mm/transhuge.rst for more
+			details.
+
 	topology=	[S390,EARLY]
 			Format: {off | on}
 			Specify if the kernel should make use of the cpu
--- a/Documentation/admin-guide/mm/transhuge.rst~mm-shmem-override-mthp-shmem-default-with-a-kernel-parameter
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -332,6 +332,23 @@ allocation policy for the internal shmem
 seven valid policies for shmem (``always``, ``within_size``, ``advise``,
 ``never``, ``deny``, and ``force``).
 
+In the same manner as ``thp_anon`` controls each supported anonymous THP
+size, ``thp_shmem`` controls each supported shmem THP size. ``thp_shmem``
+has the same format as ``thp_anon``, but also supports the policy
+``within_size``.
+
+``thp_shmem=`` may be specified multiple times to configure all THP sizes
+as required. If ``thp_shmem=`` is specified at least once, any shmem THP
+sizes not explicitly configured on the command line are implicitly set to
+``never``.
+
+``transparent_hugepage_shmem`` setting only affects the global toggle. If
+``thp_shmem`` is not specified, PMD_ORDER hugepage will default to
+``inherit``. However, if a valid ``thp_shmem`` setting is provided by the
+user, the PMD_ORDER hugepage policy will be overridden. If the policy for
+PMD_ORDER is not defined within a valid ``thp_shmem``, its policy will
+default to ``never``.
+
 Hugepages in tmpfs/shmem
 ========================
 
--- a/mm/shmem.c~mm-shmem-override-mthp-shmem-default-with-a-kernel-parameter
+++ a/mm/shmem.c
@@ -136,6 +136,7 @@ static unsigned long huge_shmem_orders_a
 static unsigned long huge_shmem_orders_madvise __read_mostly;
 static unsigned long huge_shmem_orders_inherit __read_mostly;
 static unsigned long huge_shmem_orders_within_size __read_mostly;
+static bool shmem_orders_configured __initdata;
 #endif
 
 #ifdef CONFIG_TMPFS
@@ -5026,7 +5027,8 @@ void __init shmem_init(void)
 	 * Default to setting PMD-sized THP to inherit the global setting and
 	 * disable all other multi-size THPs.
 	 */
-	huge_shmem_orders_inherit = BIT(HPAGE_PMD_ORDER);
+	if (!shmem_orders_configured)
+		huge_shmem_orders_inherit = BIT(HPAGE_PMD_ORDER);
 #endif
 	return;
 
@@ -5194,6 +5196,107 @@ static int __init setup_transparent_huge
 }
 __setup("transparent_hugepage_shmem=", setup_transparent_hugepage_shmem);
 
+static char str_dup[PAGE_SIZE] __initdata;
+static int __init setup_thp_shmem(char *str)
+{
+	char *token, *range, *policy, *subtoken;
+	unsigned long always, inherit, madvise, within_size;
+	char *start_size, *end_size;
+	int start, end, nr;
+	char *p;
+
+	if (!str || strlen(str) + 1 > PAGE_SIZE)
+		goto err;
+	strscpy(str_dup, str);
+
+	always = huge_shmem_orders_always;
+	inherit = huge_shmem_orders_inherit;
+	madvise = huge_shmem_orders_madvise;
+	within_size = huge_shmem_orders_within_size;
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
+				start = get_order_from_str(start_size,
+							   THP_ORDERS_ALL_FILE_DEFAULT);
+				end = get_order_from_str(end_size,
+							 THP_ORDERS_ALL_FILE_DEFAULT);
+			} else {
+				start_size = end_size = subtoken;
+				start = end = get_order_from_str(subtoken,
+								 THP_ORDERS_ALL_FILE_DEFAULT);
+			}
+
+			if (start == -EINVAL) {
+				pr_err("invalid size %s in thp_shmem boot parameter\n",
+				       start_size);
+				goto err;
+			}
+
+			if (end == -EINVAL) {
+				pr_err("invalid size %s in thp_shmem boot parameter\n",
+				       end_size);
+				goto err;
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
+				bitmap_clear(&within_size, start, nr);
+			} else if (!strcmp(policy, "advise")) {
+				bitmap_set(&madvise, start, nr);
+				bitmap_clear(&inherit, start, nr);
+				bitmap_clear(&always, start, nr);
+				bitmap_clear(&within_size, start, nr);
+			} else if (!strcmp(policy, "inherit")) {
+				bitmap_set(&inherit, start, nr);
+				bitmap_clear(&madvise, start, nr);
+				bitmap_clear(&always, start, nr);
+				bitmap_clear(&within_size, start, nr);
+			} else if (!strcmp(policy, "within_size")) {
+				bitmap_set(&within_size, start, nr);
+				bitmap_clear(&inherit, start, nr);
+				bitmap_clear(&madvise, start, nr);
+				bitmap_clear(&always, start, nr);
+			} else if (!strcmp(policy, "never")) {
+				bitmap_clear(&inherit, start, nr);
+				bitmap_clear(&madvise, start, nr);
+				bitmap_clear(&always, start, nr);
+				bitmap_clear(&within_size, start, nr);
+			} else {
+				pr_err("invalid policy %s in thp_shmem boot parameter\n", policy);
+				goto err;
+			}
+		}
+	}
+
+	huge_shmem_orders_always = always;
+	huge_shmem_orders_madvise = madvise;
+	huge_shmem_orders_inherit = inherit;
+	huge_shmem_orders_within_size = within_size;
+	shmem_orders_configured = true;
+	return 1;
+
+err:
+	pr_warn("thp_shmem=%s: error parsing string, ignoring setting\n", str);
+	return 0;
+}
+__setup("thp_shmem=", setup_thp_shmem);
+
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #else /* !CONFIG_SHMEM */
_

Patches currently in -mm which might be from mcanal@igalia.com are

mm-fix-docs-for-the-kernel-parameter-thp_anon=.patch
mm-shmem-control-thp-support-through-the-kernel-command-line.patch
mm-move-get_order_from_str-to-internalh.patch
mm-shmem-override-mthp-shmem-default-with-a-kernel-parameter.patch
mm-huge_memory-use-strscpy-instead-of-strcpy.patch

