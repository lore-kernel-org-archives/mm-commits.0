Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18DFB235360
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343252; cv=none; b=Q6SwJC76NDUImkxGxU/niiSILeibQPOc22AD7buih8kk5Z2tVyclGIhVtdXmO54LIafy92thReC/VIE1JmnROy4yem9S1tTn1eQhVwPHxJHc6ZNbygJH4A6AYtmrsUrRSSMwZ3xj08Xh3EEOHx/F1PfsYrJmtsAPP8uKtrRW+VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343252; c=relaxed/simple;
	bh=AbsFvwSdDvV/PPPno8RoZJDutvAp9NdZ8qSyUFGpC70=;
	h=Date:To:From:Subject:Message-Id; b=YfOsaF8ikAXJcnUUQ2+ODusaneHG2VnHTjw3bUKeotkRQ0kGP/g/KotEXPEfQKeMMBVrEDcwnkDlUIK+WqhrAZMdX5iBoKPD970ywcb4xnwkw7CBsIdhtG92fgcKocsNS5ocwa4pRdU06u7Njg6TUXhUUd8jfPSNFqKc8dmHSIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w+26XVQz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w+26XVQz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D2FC19422;
	Mon, 17 Nov 2025 01:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343251;
	bh=AbsFvwSdDvV/PPPno8RoZJDutvAp9NdZ8qSyUFGpC70=;
	h=Date:To:From:Subject:From;
	b=w+26XVQzfDeoerp0im5J8jNq1BjlIQ25Jbf2gXoR19mLJtWXBrXu3zBwMYqcDcBJ9
	 geUH9xHGzg8AgJekb+dLPUZfeqHJPa8La8eilWaovGpK+nA4Z4YO0nCwKT6jNnXZQi
	 VqyB9HXZKkNc9+5Fa42F4Cq0AxkCUCT91XEPjJxo=
Date: Sun, 16 Nov 2025 17:34:11 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kas@kernel.org,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,d@ilvokhin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-tmpfs-hugepage-defaults-config-choice.patch removed from -mm tree
Message-Id: <20251117013411.D9D2FC19422@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem/tmpfs hugepage defaults config choice
has been removed from the -mm tree.  Its filename was
     mm-shmem-tmpfs-hugepage-defaults-config-choice.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dmitry Ilvokhin <d@ilvokhin.com>
Subject: mm: shmem/tmpfs hugepage defaults config choice
Date: Thu, 23 Oct 2025 18:12:02 +0000

Allow to override defaults for shemem and tmpfs at config time.  This is
consistent with how transparent hugepages can be configured.

Same results can be achieved with the existing
'transparent_hugepage_shmem' and 'transparent_hugepage_tmpfs' settings in
the kernel command line, but it is more convenient to define basic
settings at config time instead of changing kernel command line later.

Defaults for shmem and tmpfs were not changed.  They are remained the same
as before: 'never' for both cases.  Options 'deny' and 'force' are omitted
intentionally since these are special values and supposed to be used for
emergencies or testing and are not expected to be permanent ones.

Primary motivation for adding config option is to enable policy
enforcement at build time.  In large-scale production environments (Meta's
for example), the kernel configuration is often maintained centrally close
to the kernel code itself and owned by the kernel engineers, while boot
parameters are managed independently (e.g.  by provisioning systems).  In
such setups, the kernel build defines the supported and expected behavior
in a single place, but there is no reliable or uniform control over the
kernel command line options.

A build-time default allows kernel integrators to enforce a predictable
hugepage policy for shmem/tmpfs on a base layer, ensuring reproducible
behavior and avoiding configuration drift caused by possible boot-time
differences.

In short, primary benefit is mostly operational: it provides a way to
codify preferred policy in the kernel configuration, which is versioned,
reviewed, and tested as part of the kernel build process, rather than
depending on potentially variable boot parameters.

[d@ilvokhin.com: v2]
  Link: https://lkml.kernel.org/r/aQECPpjd-fU_TC79@shell.ilvokhin.com
Link: https://lkml.kernel.org/r/aPpv8sAa2sYgNu3L@shell.ilvokhin.com
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Kiryl Shutsemau <kas@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |    5 +
 mm/Kconfig                                 |   91 +++++++++++++++++++
 mm/shmem.c                                 |   33 ++++++
 3 files changed, 127 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-shmem-tmpfs-hugepage-defaults-config-choice
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -381,6 +381,11 @@ hugepage allocation policy for the tmpfs
 four valid policies for tmpfs (``always``, ``within_size``, ``advise``,
 ``never``). The tmpfs mount default policy is ``never``.
 
+Additionally, Kconfig options are available to set the default hugepage
+policies for shmem (``CONFIG_TRANSPARENT_HUGEPAGE_SHMEM_HUGE_*``) and tmpfs
+(``CONFIG_TRANSPARENT_HUGEPAGE_TMPFS_HUGE_*``) at build time. Refer to the
+Kconfig help for more details.
+
 In the same manner as ``thp_anon`` controls each supported anonymous THP
 size, ``thp_shmem`` controls each supported shmem THP size. ``thp_shmem``
 has the same format as ``thp_anon``, but also supports the policy
--- a/mm/Kconfig~mm-shmem-tmpfs-hugepage-defaults-config-choice
+++ a/mm/Kconfig
@@ -853,6 +853,97 @@ choice
 	  enabled at runtime via sysfs.
 endchoice
 
+choice
+	prompt "Shmem hugepage allocation defaults"
+	depends on TRANSPARENT_HUGEPAGE
+	default TRANSPARENT_HUGEPAGE_SHMEM_HUGE_NEVER
+	help
+	  Selects the hugepage allocation policy defaults for
+	  the internal shmem mount.
+
+	  The selection made here can be overridden by using the kernel
+	  command line 'transparent_hugepage_shmem=' option.
+
+	config TRANSPARENT_HUGEPAGE_SHMEM_HUGE_NEVER
+		bool "never"
+	help
+	  Disable hugepage allocation for shmem mount by default. It can
+	  still be enabled with the kernel command line
+	  'transparent_hugepage_shmem=' option or at runtime via sysfs
+	  knob. Note that madvise(MADV_COLLAPSE) can still cause
+	  transparent huge pages to be obtained even if this mode is
+	  specified.
+
+	config TRANSPARENT_HUGEPAGE_SHMEM_HUGE_ALWAYS
+		bool "always"
+	help
+	  Always attempt to allocate hugepage for shmem mount, can
+	  increase the memory footprint of applications without a
+	  guaranteed benefit but it will work automatically for all
+	  applications.
+
+	config TRANSPARENT_HUGEPAGE_SHMEM_HUGE_WITHIN_SIZE
+		bool "within_size"
+	help
+	  Enable hugepage allocation for shmem mount if the allocation
+	  will be fully within the i_size. This configuration also takes
+	  into account any madvise(MADV_HUGEPAGE) hints that may be
+	  provided by the applications.
+
+	config TRANSPARENT_HUGEPAGE_SHMEM_HUGE_ADVISE
+		bool "advise"
+	help
+	  Enable hugepage allocation for the shmem mount exclusively when
+	  applications supply the madvise(MADV_HUGEPAGE) hint.
+	  This ensures that hugepages are used only in response to explicit
+	  requests from applications.
+endchoice
+
+choice
+	prompt "Tmpfs hugepage allocation defaults"
+	depends on TRANSPARENT_HUGEPAGE
+	default TRANSPARENT_HUGEPAGE_TMPFS_HUGE_NEVER
+	help
+	  Selects the hugepage allocation policy defaults for
+	  the tmpfs mount.
+
+	  The selection made here can be overridden by using the kernel
+	  command line 'transparent_hugepage_tmpfs=' option.
+
+	config TRANSPARENT_HUGEPAGE_TMPFS_HUGE_NEVER
+		bool "never"
+	help
+	  Disable hugepage allocation for tmpfs mount by default. It can
+	  still be enabled with the kernel command line
+	  'transparent_hugepage_tmpfs=' option. Note that
+	  madvise(MADV_COLLAPSE) can still cause transparent huge pages
+	  to be obtained even if this mode is specified.
+
+	config TRANSPARENT_HUGEPAGE_TMPFS_HUGE_ALWAYS
+		bool "always"
+	help
+	  Always attempt to allocate hugepage for tmpfs mount, can
+	  increase the memory footprint of applications without a
+	  guaranteed benefit but it will work automatically for all
+	  applications.
+
+	config TRANSPARENT_HUGEPAGE_TMPFS_HUGE_WITHIN_SIZE
+		bool "within_size"
+	help
+	  Enable hugepage allocation for tmpfs mount if the allocation
+	  will be fully within the i_size. This configuration also takes
+	  into account any madvise(MADV_HUGEPAGE) hints that may be
+	  provided by the applications.
+
+	config TRANSPARENT_HUGEPAGE_TMPFS_HUGE_ADVISE
+		bool "advise"
+	help
+	  Enable hugepage allocation for the tmpfs mount exclusively when
+	  applications supply the madvise(MADV_HUGEPAGE) hint.
+	  This ensures that hugepages are used only in response to explicit
+	  requests from applications.
+endchoice
+
 config THP_SWAP
 	def_bool y
 	depends on TRANSPARENT_HUGEPAGE && ARCH_WANTS_THP_SWAP && SWAP && 64BIT
--- a/mm/shmem.c~mm-shmem-tmpfs-hugepage-defaults-config-choice
+++ a/mm/shmem.c
@@ -570,8 +570,37 @@ static int shmem_confirm_swap(struct add
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /* ifdef here to avoid bloating shmem.o when not necessary */
 
-static int shmem_huge __read_mostly = SHMEM_HUGE_NEVER;
-static int tmpfs_huge __read_mostly = SHMEM_HUGE_NEVER;
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE_SHMEM_HUGE_NEVER)
+#define SHMEM_HUGE_DEFAULT SHMEM_HUGE_NEVER
+#elif defined(CONFIG_TRANSPARENT_HUGEPAGE_SHMEM_HUGE_ALWAYS)
+#define SHMEM_HUGE_DEFAULT SHMEM_HUGE_ALWAYS
+#elif defined(CONFIG_TRANSPARENT_HUGEPAGE_SHMEM_HUGE_WITHIN_SIZE)
+#define SHMEM_HUGE_DEFAULT SHMEM_HUGE_WITHIN_SIZE
+#elif defined(CONFIG_TRANSPARENT_HUGEPAGE_SHMEM_HUGE_ADVISE)
+#define SHMEM_HUGE_DEFAULT SHMEM_HUGE_ADVISE
+#else
+#define SHMEM_HUGE_DEFAULT SHMEM_HUGE_NEVER
+#endif
+
+static int shmem_huge __read_mostly = SHMEM_HUGE_DEFAULT;
+
+#undef SHMEM_HUGE_DEFAULT
+
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE_TMPFS_HUGE_NEVER)
+#define TMPFS_HUGE_DEFAULT SHMEM_HUGE_NEVER
+#elif defined(CONFIG_TRANSPARENT_HUGEPAGE_TMPFS_HUGE_ALWAYS)
+#define TMPFS_HUGE_DEFAULT SHMEM_HUGE_ALWAYS
+#elif defined(CONFIG_TRANSPARENT_HUGEPAGE_TMPFS_HUGE_WITHIN_SIZE)
+#define TMPFS_HUGE_DEFAULT SHMEM_HUGE_WITHIN_SIZE
+#elif defined(CONFIG_TRANSPARENT_HUGEPAGE_TMPFS_HUGE_ADVISE)
+#define TMPFS_HUGE_DEFAULT SHMEM_HUGE_ADVISE
+#else
+#define TMPFS_HUGE_DEFAULT SHMEM_HUGE_NEVER
+#endif
+
+static int tmpfs_huge __read_mostly = TMPFS_HUGE_DEFAULT;
+
+#undef TMPFS_HUGE_DEFAULT
 
 static unsigned int shmem_get_orders_within_size(struct inode *inode,
 		unsigned long within_size_orders, pgoff_t index,
_

Patches currently in -mm which might be from d@ilvokhin.com are


