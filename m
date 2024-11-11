Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A826D165EED
	for <mm-commits@vger.kernel.org>; Mon, 11 Nov 2024 08:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731313727; cv=none; b=fnIZDpCKwlQlNKmr4K8qA9V8hKIGUgbgMykYJ2qq9M9Tq8L5hXwzODrLUyajJtNvIKSjbDa73gc3LsXP6Ay3ZumHXV+B3xcPv2u3QsjgX3NU2iIxQPq7zrevF3Xi107KNqjEgtDfpkaxkstHiKriJR33oS0GbgdxdrWdylKqGXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731313727; c=relaxed/simple;
	bh=BQSMxmwiVNF6jMIlTGyejzCeH+3PMCkm8K+m1QKrrMo=;
	h=Date:To:From:Subject:Message-Id; b=fALuWm2hw3OjEjaCv1bmimByfx0Naru2KVom6fAoGfjsFK/Pe317YGVAdRjWU0Tmmx8JX0cuT+fm+bbXcjAt5GUBW9oHAPdI5vbxEx3hQDQNSfQR3UbGKwEjpQsneBoRNDpLajtxuNC651CilyFlXZVaWVeNOa1qPFbPWhsfHJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FxVAWgha; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FxVAWgha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D087C4CED0;
	Mon, 11 Nov 2024 08:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731313727;
	bh=BQSMxmwiVNF6jMIlTGyejzCeH+3PMCkm8K+m1QKrrMo=;
	h=Date:To:From:Subject:From;
	b=FxVAWghatYSZAnTOgQx/sCRYDawXMeA8Ba5uOVwa7HP2ENnVIuAh6T0io2J1iAwm3
	 ZMp0AzFrVG30a1nPfraJ9j2TPg55kqD79bId8ZAZ7m45qz6lC3nzFVLXuy9ctDUdOZ
	 rFF3osH66nSQnpPsKXZWpmmxnWlZvYr0xxbiRglE=
Date: Mon, 11 Nov 2024 00:28:46 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,mcanal@igalia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-control-thp-support-through-the-kernel-command-line.patch removed from -mm tree
Message-Id: <20241111082847.7D087C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: control THP support through the kernel command line
has been removed from the -mm tree.  Its filename was
     mm-shmem-control-thp-support-through-the-kernel-command-line.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Maíra Canal <mcanal@igalia.com>
Subject: mm: shmem: control THP support through the kernel command line
Date: Fri, 1 Nov 2024 13:54:06 -0300

Patch series "mm: add more kernel parameters to control mTHP", v5.

This series introduces four patches related to the kernel parameters
controlling mTHP and a fifth patch replacing `strcpy()` for `strscpy()` in
the file `mm/huge_memory.c`.

The first patch is a straightforward documentation update, correcting the
format of the kernel parameter ``thp_anon=``.

The second, third, and fourth patches focus on controlling THP support for
shmem via the kernel command line.  The second patch introduces a
parameter to control the global default huge page allocation policy for
the internal shmem mount.  The third patch moves a piece of code to a
shared header to ease the implementation of the fourth patch.  Finally,
the fourth patch implements a parameter similar to ``thp_anon=``, but for
shmem.

The goal of these changes is to simplify the configuration of systems that
rely on mTHP support for shmem.  For instance, a platform with a GPU that
benefits from huge pages may want to enable huge pages for shmem.  Having
these kernel parameters streamlines the configuration process and ensures
consistency across setups.


This patch (of 4):

Add a new kernel command line to control the hugepage allocation policy
for the internal shmem mount, ``transparent_hugepage_shmem``. The
parameter is similar to ``transparent_hugepage`` and has the following
format:

transparent_hugepage_shmem=<policy>

where ``<policy>`` is one of the seven valid policies available for
shmem.

Configuring the default huge page allocation policy for the internal
shmem mount can be beneficial for DRM GPU drivers. Just as CPU
architectures, GPUs can also take advantage of huge pages, but this is
possible only if DRM GEM objects are backed by huge pages.

Since GEM uses shmem to allocate anonymous pageable memory, having control
over the default huge page allocation policy allows for the exploration of
huge pages use on GPUs that rely on GEM objects backed by shmem.

Link: https://lkml.kernel.org/r/20241101165719.1074234-2-mcanal@igalia.com
Link: https://lkml.kernel.org/r/20241101165719.1074234-4-mcanal@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: dri-devel@lists.freedesktop.org
Cc: Hugh Dickins <hughd@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: kernel-dev@igalia.com
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    7 +
 Documentation/admin-guide/mm/transhuge.rst      |    6 +
 mm/shmem.c                                      |   72 +++++++++-----
 3 files changed, 62 insertions(+), 23 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~mm-shmem-control-thp-support-through-the-kernel-command-line
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -6926,6 +6926,13 @@
 			See Documentation/admin-guide/mm/transhuge.rst
 			for more details.
 
+	transparent_hugepage_shmem= [KNL]
+			Format: [always|within_size|advise|never|deny|force]
+			Can be used to control the hugepage allocation policy for
+			the internal shmem mount.
+			See Documentation/admin-guide/mm/transhuge.rst
+			for more details.
+
 	trusted.source=	[KEYS]
 			Format: <string>
 			This parameter identifies the trust source as a backend
--- a/Documentation/admin-guide/mm/transhuge.rst~mm-shmem-control-thp-support-through-the-kernel-command-line
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -326,6 +326,12 @@ PMD_ORDER THP policy will be overridden.
 is not defined within a valid ``thp_anon``, its policy will default to
 ``never``.
 
+Similarly to ``transparent_hugepage``, you can control the hugepage
+allocation policy for the internal shmem mount by using the kernel parameter
+``transparent_hugepage_shmem=<policy>``, where ``<policy>`` is one of the
+seven valid policies for shmem (``always``, ``within_size``, ``advise``,
+``never``, ``deny``, and ``force``).
+
 Hugepages in tmpfs/shmem
 ========================
 
--- a/mm/shmem.c~mm-shmem-control-thp-support-through-the-kernel-command-line
+++ a/mm/shmem.c
@@ -582,24 +582,39 @@ static bool shmem_huge_global_enabled(st
 	}
 }
 
-#if defined(CONFIG_SYSFS)
 static int shmem_parse_huge(const char *str)
 {
+	int huge;
+
+	if (!str)
+		return -EINVAL;
+
 	if (!strcmp(str, "never"))
-		return SHMEM_HUGE_NEVER;
-	if (!strcmp(str, "always"))
-		return SHMEM_HUGE_ALWAYS;
-	if (!strcmp(str, "within_size"))
-		return SHMEM_HUGE_WITHIN_SIZE;
-	if (!strcmp(str, "advise"))
-		return SHMEM_HUGE_ADVISE;
-	if (!strcmp(str, "deny"))
-		return SHMEM_HUGE_DENY;
-	if (!strcmp(str, "force"))
-		return SHMEM_HUGE_FORCE;
-	return -EINVAL;
+		huge = SHMEM_HUGE_NEVER;
+	else if (!strcmp(str, "always"))
+		huge = SHMEM_HUGE_ALWAYS;
+	else if (!strcmp(str, "within_size"))
+		huge = SHMEM_HUGE_WITHIN_SIZE;
+	else if (!strcmp(str, "advise"))
+		huge = SHMEM_HUGE_ADVISE;
+	else if (!strcmp(str, "deny"))
+		huge = SHMEM_HUGE_DENY;
+	else if (!strcmp(str, "force"))
+		huge = SHMEM_HUGE_FORCE;
+	else
+		return -EINVAL;
+
+	if (!has_transparent_hugepage() &&
+	    huge != SHMEM_HUGE_NEVER && huge != SHMEM_HUGE_DENY)
+		return -EINVAL;
+
+	/* Do not override huge allocation policy with non-PMD sized mTHP */
+	if (huge == SHMEM_HUGE_FORCE &&
+	    huge_shmem_orders_inherit != BIT(HPAGE_PMD_ORDER))
+		return -EINVAL;
+
+	return huge;
 }
-#endif
 
 #if defined(CONFIG_SYSFS) || defined(CONFIG_TMPFS)
 static const char *shmem_format_huge(int huge)
@@ -5065,15 +5080,7 @@ static ssize_t shmem_enabled_store(struc
 
 	huge = shmem_parse_huge(tmp);
 	if (huge == -EINVAL)
-		return -EINVAL;
-	if (!has_transparent_hugepage() &&
-			huge != SHMEM_HUGE_NEVER && huge != SHMEM_HUGE_DENY)
-		return -EINVAL;
-
-	/* Do not override huge allocation policy with non-PMD sized mTHP */
-	if (huge == SHMEM_HUGE_FORCE &&
-	    huge_shmem_orders_inherit != BIT(HPAGE_PMD_ORDER))
-		return -EINVAL;
+		return huge;
 
 	shmem_huge = huge;
 	if (shmem_huge > SHMEM_HUGE_DENY)
@@ -5170,6 +5177,25 @@ struct kobj_attribute thpsize_shmem_enab
 	__ATTR(shmem_enabled, 0644, thpsize_shmem_enabled_show, thpsize_shmem_enabled_store);
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE && CONFIG_SYSFS */
 
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE)
+
+static int __init setup_transparent_hugepage_shmem(char *str)
+{
+	int huge;
+
+	huge = shmem_parse_huge(str);
+	if (huge == -EINVAL) {
+		pr_warn("transparent_hugepage_shmem= cannot parse, ignored\n");
+		return huge;
+	}
+
+	shmem_huge = huge;
+	return 1;
+}
+__setup("transparent_hugepage_shmem=", setup_transparent_hugepage_shmem);
+
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+
 #else /* !CONFIG_SHMEM */
 
 /*
_

Patches currently in -mm which might be from mcanal@igalia.com are


