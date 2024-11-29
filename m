Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526C318A956
	for <mm-commits@vger.kernel.org>; Fri, 29 Nov 2024 10:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732876695; cv=none; b=adUFOrLp1hVVd6Xr4ZiH2LmBUFAZYiczvaQ9+wer+8mU2Tw5dH6fkiBzkZiwEH+fCFuZa+H/nx2kjrdoGjsPajKuQIve0nFocbHCNDTXwFQdrWc5f6soUwHm7T8HLDuOeb6m33BsCSm/OXlI835TorYL6ggDuBwyXuJN46tPMIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732876695; c=relaxed/simple;
	bh=lYvxbLlVtXqODpIOWCd/rizHvHrwil1ScHKhBEYEcoM=;
	h=Date:To:From:Subject:Message-Id; b=Qcm1L4Gg3bSyIKKC1mD4AzZkZ7czsa3c20WhiQIvyBoRX1bhpSiBNCORrFg3wffgPissZpEBJimJJvkWkw/K//BmYiH+zQucrTa2TE+WlNRmVk4DJFFlsjr7FbaNvDgmgG7sGZnxlQ/uHek7PI1gQZR3kV1U0YZLYwvn9yqcQ3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BRnfNDzt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BRnfNDzt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18639C4CECF;
	Fri, 29 Nov 2024 10:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732876695;
	bh=lYvxbLlVtXqODpIOWCd/rizHvHrwil1ScHKhBEYEcoM=;
	h=Date:To:From:Subject:From;
	b=BRnfNDztK1s0EngW/OVviYfcIKzhfLp3qM8iuu0prop1JAzWNB+1l2rZqJTKPhXkT
	 WHfOds06ffz2TNSEIlTLNj1g1WKMtDiuoa3i2Qz4WMQpNt5W5fI42E+5A20gBF5SfA
	 ksq3vwQtP3u40XFstdZHRMVw9LaUDTg7bG/JaJfE=
Date: Fri, 29 Nov 2024 02:38:14 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,ioworker0@gmail.com,hughd@google.com,da.gomez@samsung.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-tmpfs-update-the-large-folios-policy-for-tmpfs-and-shmem.patch added to mm-unstable branch
Message-Id: <20241129103815.18639C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs: tmpfs: update the large folios policy for tmpfs and shmem
has been added to the -mm mm-unstable branch.  Its filename is
     docs-tmpfs-update-the-large-folios-policy-for-tmpfs-and-shmem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-tmpfs-update-the-large-folios-policy-for-tmpfs-and-shmem.patch

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

mm-mempolicy-fix-migrate_to_node-assuming-there-is-at-least-one-vma-in-a-mm.patch
docs-tmpfs-update-the-large-folios-policy-for-tmpfs-and-shmem.patch

