Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479701C1F15
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836946; cv=none; b=R1z0NB54NFd8mrjt0uJ8jgQdfEmZqKgTYDgLa52ZSlXLzzeb0SGvsoF3wDy8gO6wiqsQZVaOMfNieLZyf7engPWMwf54BJE+yEbj7Y0IYrOpKuKtYABoi1nOQ/XvddnmEwEcg16spWvaBWbB7BsBJzcqDN86wyMpcgk0y8vU+Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836946; c=relaxed/simple;
	bh=d9/LWbvgbmYAPYkp0BIQdrBKLYJgNpOCr44finkwT1U=;
	h=Date:To:From:Subject:Message-Id; b=mYD+wx+ELe9k/UxKvdYoMahX2xsLOY4fG332TSYizOttXirNwARJsXNfiWIMlld8J33yQp6kOg+lzuBt/rgxupLqTQoVPnlWRSJdSzRdRlrW2GPBD5NuE+iMX/UckNF7lnJUmFsxNYcHfzgGI5+9vIHpoY4gxfYvoP9wdPbmJ/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=veyRVjTO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="veyRVjTO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E55C4CEDD;
	Tue, 14 Jan 2025 06:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836946;
	bh=d9/LWbvgbmYAPYkp0BIQdrBKLYJgNpOCr44finkwT1U=;
	h=Date:To:From:Subject:From;
	b=veyRVjTOmZK+gCxjt6A4CnRRRM27Gb6sqYtkeoZ6t7aIj/EUBr9/0zgANURQ88Htj
	 aKkCAaLSY7R7iqryWgkF6jmw5GyF5tzmvUqu+d7xVsJ7+ryr1dkHqkd8KyHiJCU8zX
	 a4aJ/lLJZxuVopxJWcdF/IT5/3/lsHzgfDbtkRwY=
Date: Mon, 13 Jan 2025 22:42:25 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,ioworker0@gmail.com,hughd@google.com,da.gomez@samsung.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-tmpfs-update-the-large-folios-policy-for-tmpfs-and-shmem.patch removed from -mm tree
Message-Id: <20250114064226.19E55C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs: tmpfs: update the large folios policy for tmpfs and shmem
has been removed from the -mm tree.  Its filename was
     docs-tmpfs-update-the-large-folios-policy-for-tmpfs-and-shmem.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: docs: tmpfs: update the large folios policy for tmpfs and shmem
Date: Thu, 28 Nov 2024 15:40:43 +0800

Update the large folios policy for tmpfs and shmem.

Link: https://lkml.kernel.org/r/9b7418af30e300d1eb05721b81d79074d0bb0ec9.1732779148.git.baolin.wang@linux.alibaba.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |   58 +++++++++++++------
 1 file changed, 41 insertions(+), 17 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~docs-tmpfs-update-the-large-folios-policy-for-tmpfs-and-shmem
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -358,8 +358,21 @@ default to ``never``.
 Hugepages in tmpfs/shmem
 ========================
 
-You can control hugepage allocation policy in tmpfs with mount option
-``huge=``. It can have following values:
+Traditionally, tmpfs only supported a single huge page size ("PMD"). Today,
+it also supports smaller sizes just like anonymous memory, often referred
+to as "multi-size THP" (mTHP). Huge pages of any size are commonly
+represented in the kernel as "large folios".
+
+While there is fine control over the huge page sizes to use for the internal
+shmem mount (see below), ordinary tmpfs mounts will make use of all available
+huge page sizes without any control over the exact sizes, behaving more like
+other file systems.
+
+tmpfs mounts
+------------
+
+The THP allocation policy for tmpfs mounts can be adjusted using the mount
+option: ``huge=``. It can have following values:
 
 always
     Attempt to allocate huge pages every time we need a new page;
@@ -374,19 +387,19 @@ within_size
 advise
     Only allocate huge pages if requested with fadvise()/madvise();
 
-The default policy is ``never``.
+Remember, that the kernel may use huge pages of all available sizes, and
+that no fine control as for the internal tmpfs mount is available.
+
+The default policy in the past was ``never``, but it can now be adjusted
+using the kernel parameter ``transparent_hugepage_tmpfs=<policy>``.
 
 ``mount -o remount,huge= /mountpoint`` works fine after mount: remounting
 ``huge=never`` will not attempt to break up huge pages at all, just stop more
 from being allocated.
 
-There's also sysfs knob to control hugepage allocation policy for internal
-shmem mount: /sys/kernel/mm/transparent_hugepage/shmem_enabled. The mount
-is used for SysV SHM, memfds, shared anonymous mmaps (of /dev/zero or
-MAP_ANONYMOUS), GPU drivers' DRM objects, Ashmem.
-
-In addition to policies listed above, shmem_enabled allows two further
-values:
+In addition to policies listed above, the sysfs knob
+/sys/kernel/mm/transparent_hugepage/shmem_enabled will affect the
+allocation policy of tmpfs mounts, when set to the following values:
 
 deny
     For use in emergencies, to force the huge option off from
@@ -394,13 +407,24 @@ deny
 force
     Force the huge option on for all - very useful for testing;
 
-Shmem can also use "multi-size THP" (mTHP) by adding a new sysfs knob to
-control mTHP allocation:
-'/sys/kernel/mm/transparent_hugepage/hugepages-<size>kB/shmem_enabled',
-and its value for each mTHP is essentially consistent with the global
-setting.  An 'inherit' option is added to ensure compatibility with these
-global settings.  Conversely, the options 'force' and 'deny' are dropped,
-which are rather testing artifacts from the old ages.
+shmem / internal tmpfs
+----------------------
+The mount internal tmpfs mount is used for SysV SHM, memfds, shared anonymous
+mmaps (of /dev/zero or MAP_ANONYMOUS), GPU drivers' DRM  objects, Ashmem.
+
+To control the THP allocation policy for this internal tmpfs mount, the
+sysfs knob /sys/kernel/mm/transparent_hugepage/shmem_enabled and the knobs
+per THP size in
+'/sys/kernel/mm/transparent_hugepage/hugepages-<size>kB/shmem_enabled'
+can be used.
+
+The global knob has the same semantics as the ``huge=`` mount options
+for tmpfs mounts, except that the different huge page sizes can be controlled
+individually, and will only use the setting of the global knob when the
+per-size knob is set to 'inherit'.
+
+The options 'force' and 'deny' are dropped for the individual sizes, which
+are rather testing artifacts from the old ages.
 
 always
     Attempt to allocate <size> huge pages every time we need a new page;
_

Patches currently in -mm which might be from david@redhat.com are

mm-huge_memory-convert-has_hwpoisoned-into-a-pure-folio-flag.patch
mm-hugetlb-rename-isolate_hugetlb-to-folio_isolate_hugetlb.patch
mm-migrate-dont-call-folio_putback_active_hugetlb-on-dst-hugetlb-folio.patch
mm-hugetlb-rename-folio_putback_active_hugetlb-to-folio_putback_hugetlb.patch
mm-hugetlb-cgroup-convert-hugetlb_cgroup_css_offline-to-work-on-folios.patch
mm-hugetlb-use-folio-lru-int-demote_free_hugetlb_folios.patch

