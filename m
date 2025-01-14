Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8814F1C1F15
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836945; cv=none; b=K3AjElC/IIMC6NGx/++Fbf/n9Zgigd32q0lBiSzxmYnAVS0VtAoLrBFh2FAqeHRfkJfDl03BFRvRVN3JSO4GasoEyaO8XO40ZdwWKT0IkdMZWWd8yEHUckddmfWZVqFzQ59Rwe9oRZns9yFoANuewXb5Dfk6nUstMToZbO2vFtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836945; c=relaxed/simple;
	bh=S0By1DibSa2ZFMP1o1Rz4OAgjhhTbziPwjkQ5SJGhFg=;
	h=Date:To:From:Subject:Message-Id; b=o2cyxWF7nPPS1DeSH4/zZLlvSY9MkehscjKGTZ516NM2hE43+bzV88KeofYXoJQ6CX8vbTf2MQrDeXQs9LKyJ8A12ZU9XxIhiIrHYrgK2TtG1BbT7YoEJsvgXtT75Cjg9yM/L1uZMj7myOK7dMGICno+F4v7VxBUxlgM1mGyWlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fs9j41EM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fs9j41EM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB0ABC4CEDD;
	Tue, 14 Jan 2025 06:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836945;
	bh=S0By1DibSa2ZFMP1o1Rz4OAgjhhTbziPwjkQ5SJGhFg=;
	h=Date:To:From:Subject:From;
	b=Fs9j41EMylbYqP8nluJqF2yhQl79LA7kXS4/t0naX9u2EvDIFIR0w0BI+2p5sc20R
	 8rG2EiuyL3PQyacr1PLQloxOvTSZscmRxwOrabD3OMC/oh4IydlQLfdKLZpoPOLIgv
	 6FidjXkyt6QJDwYhfBhmasNDLecEj/GhdLVdMxPw=
Date: Mon, 13 Jan 2025 22:42:24 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-add-a-kernel-command-line-to-change-the-default-huge-policy-for-tmpfs.patch removed from -mm tree
Message-Id: <20250114064224.EB0ABC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: add a kernel command line to change the default huge policy for tmpfs
has been removed from the -mm tree.  Its filename was
     mm-shmem-add-a-kernel-command-line-to-change-the-default-huge-policy-for-tmpfs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -6992,6 +6992,13 @@
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
@@ -4954,7 +4955,12 @@ static int shmem_fill_super(struct super
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
 
@@ -5505,6 +5511,21 @@ static int __init setup_transparent_huge
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


