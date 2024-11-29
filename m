Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C53C18A935
	for <mm-commits@vger.kernel.org>; Fri, 29 Nov 2024 10:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732876693; cv=none; b=SHyVWkMbJ6oNHC3G5e2DG/fPDMC+uxMf4Wcd7ZDbjuRn7kP13if6rDHjMt+cR3vfJDSms/mUBm3sF+a8wu8Bezk9K16H/1Si3KEoXkM5oqA61joXHJpU3UOqefZIDMOb2185byi4mJJ8BUG9QAJ9NtbeeGRbgXv69BrEHVi5jwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732876693; c=relaxed/simple;
	bh=3jrisxPswPxaOPigrpTqb/PN1o4hNoYo9nr9RfXKCzw=;
	h=Date:To:From:Subject:Message-Id; b=Ek3L/DHU9RCpwxBjxJaKV+UsA+FuCpvSwYrfGfCJQbDlzkCNsLTcZQrl9ghMnnVLdi7cCinVdY/qgZ+adMwx36fD1T5+kZpOLapCafuAYVQ6tmMAR2siLqrUH3HtUANVnzSJW6PWHsWTObF7bUh8WPA3yJgFU3Up3u4R+nd03DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fcrU6NX8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fcrU6NX8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6301CC4CECF;
	Fri, 29 Nov 2024 10:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732876692;
	bh=3jrisxPswPxaOPigrpTqb/PN1o4hNoYo9nr9RfXKCzw=;
	h=Date:To:From:Subject:From;
	b=fcrU6NX89jr5mxNqj0BYtzHBKqvNW6dl+NVTaLUI2lHMJI5zrj+jSguCCMi8M4u2f
	 kiRrX8pIZcQkESLQWPX04X9m97MnFzU+tEO8e/2iU2xWWgBrcQi05W5f82m4hMZLn8
	 Aui5i6KvzZyuZFvecHRmE5swOd+qYtOpq+Au/Apw=
Date: Fri, 29 Nov 2024 02:38:11 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-add-a-kernel-command-line-to-change-the-default-huge-policy-for-tmpfs.patch added to mm-unstable branch
Message-Id: <20241129103812.6301CC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: add a kernel command line to change the default huge policy for tmpfs
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-add-a-kernel-command-line-to-change-the-default-huge-policy-for-tmpfs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-add-a-kernel-command-line-to-change-the-default-huge-policy-for-tmpfs.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: add a kernel command line to change the default huge policy for tmpfs
Date: Thu, 28 Nov 2024 15:40:42 +0800

Now the tmpfs can allow to allocate any sized large folios, and the default
huge policy is still preferred to be 'never'. Due to tmpfs not behaving like
other file systems in some cases as previously explained by David[1]:

: I think I raised this in the past, but tmpfs/shmem is just like any
: other file system .. except it sometimes really isn't and behaves much
: more like (swappable) anonymous memory. (or mlocked files)
: 
: There are many systems out there that run without swap enabled, or with
: extremely minimal swap (IIRC until recently kubernetes was completely
: incompatible with swapping). Swap can even be disabled today for shmem
: using a mount option.
: 
: That's a big difference to all other file systems where you are
: guaranteed to have backend storage where you can simply evict under
: memory pressure (might temporarily fail, of course).
: 
: I *think* that's the reason why we have the "huge=" parameter that also
: controls the THP allocations during page faults (IOW possible memory
: over-allocation). Maybe also because it was a new feature, and we only
: had a single THP size.

Thus adding a new command line to change the default huge policy will be
helpful to use the large folios for tmpfs, which is similar to the
'transparent_hugepage_shmem' cmdline for shmem.

[1] https://lore.kernel.org/all/cbadd5fe-69d5-4c21-8eb8-3344ed36c721@redhat.com/

Link: https://lkml.kernel.org/r/ff390b2656f0d39649547f8f2cbb30fcb7e7be2d.1732779148.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    7 ++++
 Documentation/admin-guide/mm/transhuge.rst      |    6 +++
 mm/shmem.c                                      |   23 +++++++++++++-
 3 files changed, 35 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~mm-shmem-add-a-kernel-command-line-to-change-the-default-huge-policy-for-tmpfs
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -6987,6 +6987,13 @@
 			See Documentation/admin-guide/mm/transhuge.rst
 			for more details.
 
+	transparent_hugepage_tmpfs= [KNL]
+			Format: [always|within_size|advise|never]
+			Can be used to control the default hugepage allocation policy
+			for the tmpfs mount.
+			See Documentation/admin-guide/mm/transhuge.rst
+			for more details.
+
 	trusted.source=	[KEYS]
 			Format: <string>
 			This parameter identifies the trust source as a backend
--- a/Documentation/admin-guide/mm/transhuge.rst~mm-shmem-add-a-kernel-command-line-to-change-the-default-huge-policy-for-tmpfs
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -332,6 +332,12 @@ allocation policy for the internal shmem
 seven valid policies for shmem (``always``, ``within_size``, ``advise``,
 ``never``, ``deny``, and ``force``).
 
+Similarly to ``transparent_hugepage_shmem``, you can control the default
+hugepage allocation policy for the tmpfs mount by using the kernel parameter
+``transparent_hugepage_tmpfs=<policy>``, where ``<policy>`` is one of the
+four valid policies for tmpfs (``always``, ``within_size``, ``advise``,
+``never``). The tmpfs mount default policy is ``never``.
+
 In the same manner as ``thp_anon`` controls each supported anonymous THP
 size, ``thp_shmem`` controls each supported shmem THP size. ``thp_shmem``
 has the same format as ``thp_anon``, but also supports the policy
--- a/mm/shmem.c~mm-shmem-add-a-kernel-command-line-to-change-the-default-huge-policy-for-tmpfs
+++ a/mm/shmem.c
@@ -553,6 +553,7 @@ static bool shmem_confirm_swap(struct ad
 /* ifdef here to avoid bloating shmem.o when not necessary */
 
 static int shmem_huge __read_mostly = SHMEM_HUGE_NEVER;
+static int tmpfs_huge __read_mostly = SHMEM_HUGE_NEVER;
 
 /**
  * shmem_mapping_size_orders - Get allowable folio orders for the given file size.
@@ -4951,7 +4952,12 @@ static int shmem_fill_super(struct super
 	sbinfo->gid = ctx->gid;
 	sbinfo->full_inums = ctx->full_inums;
 	sbinfo->mode = ctx->mode;
-	sbinfo->huge = ctx->huge;
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	if (ctx->seen & SHMEM_SEEN_HUGE)
+		sbinfo->huge = ctx->huge;
+	else
+		sbinfo->huge = tmpfs_huge;
+#endif
 	sbinfo->mpol = ctx->mpol;
 	ctx->mpol = NULL;
 
@@ -5502,6 +5508,21 @@ static int __init setup_transparent_huge
 }
 __setup("transparent_hugepage_shmem=", setup_transparent_hugepage_shmem);
 
+static int __init setup_transparent_hugepage_tmpfs(char *str)
+{
+	int huge;
+
+	huge = shmem_parse_huge(str);
+	if (huge < 0) {
+		pr_warn("transparent_hugepage_tmpfs= cannot parse, ignored\n");
+		return huge;
+	}
+
+	tmpfs_huge = huge;
+	return 1;
+}
+__setup("transparent_hugepage_tmpfs=", setup_transparent_hugepage_tmpfs);
+
 static char str_dup[PAGE_SIZE] __initdata;
 static int __init setup_thp_shmem(char *str)
 {
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-factor-out-the-order-calculation-into-a-new-helper.patch
mm-shmem-change-shmem_huge_global_enabled-to-return-huge-order-bitmap.patch
mm-shmem-add-large-folio-support-for-tmpfs.patch
mm-shmem-add-a-kernel-command-line-to-change-the-default-huge-policy-for-tmpfs.patch
docs-tmpfs-drop-fadvise-from-the-documentation.patch

