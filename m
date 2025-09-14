Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168DD156C6A
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810158; cv=none; b=fh6Gu7sBvsIPpRgJqpkJlWvM3IWSGWHjpD/INhtDDy2nNvBb9vYaOeIHklxWn67zif46YlW3xmfw8O2LMivqMvEqYOvOs9mYw6oxei1af241pQbFnhSu13hn31LM562yizHrPMCfM5EP6tW3Ohtfs8wEh3MQwE2kvSXxBsWgOHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810158; c=relaxed/simple;
	bh=1h1QkgPAN7dN8254DcsYXY8VFV/f1NE4RSrIE0buGCU=;
	h=Date:To:From:Subject:Message-Id; b=K0dBjMjdbcWxjsH/61pc3vCCJ2ehzSLG3J5LRVHeFoFY25vp08ucrstMmfykLrgw74d1mgRv2qtj2KkFD2xVAtjAtCMvU0LBGD5KoegEfz6oI5uSqkUOcNXRx+9/mv8jpQb/Yrftutsm+AZRyXsoR5Bo7B9eoAId2ty63Lr3ixA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HuKastWR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HuKastWR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F7EC4CEEB;
	Sun, 14 Sep 2025 00:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810158;
	bh=1h1QkgPAN7dN8254DcsYXY8VFV/f1NE4RSrIE0buGCU=;
	h=Date:To:From:Subject:From;
	b=HuKastWRicqAw41Z4bvLAhxq8AUWLf1Beak2yxrvgSSgv9SGow10Vh93TgT1YPyYl
	 eads/09X7yF/pNmC8qkfE2opqT1AH1lE1V3k/upEQJE44WKEcXf6VQvVs4tkh5LE13
	 jHwdjrgYs9uROJVysySC9ho30Db9NTcLhPk20qoo=
Date: Sat, 13 Sep 2025 17:35:57 -0700
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,tglx@linutronix.de,mingo@redhat.com,hpa@zytor.com,dyoung@redhat.com,coxu@redhat.com,bp@alien8.de,bhe@redhat.com,fuqiang.wang@easystack.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] x86-kexec-fix-potential-cmem-ranges-out-of-memory.patch removed from -mm tree
Message-Id: <20250914003557.E0F7EC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/kexec: fix potential cmem->ranges out of memory
has been removed from the -mm tree.  Its filename was
     x86-kexec-fix-potential-cmem-ranges-out-of-memory.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: fuqiang wang <fuqiang.wang@easystack.cn>
Subject: x86/kexec: fix potential cmem->ranges out of memory
Date: Thu, 4 Sep 2025 17:38:52 +0800

In memmap_exclude_ranges(), elfheader will be excluded from crashk_res. 
In the current x86 architecture code, the elfheader is always allocated at
crashk_res.start.  It seems that there won't be a new split range.  But it
depends on the allocation position of elfheader in crashk_res.  To avoid
potential out of memory in future, add a extra slot.  Otherwise loading
the kdump kernel will fail because crash_exclude_mem_range will return
-ENOMEM.  random kexec_buf for passing dm crypt keys may cause a range
split too, add another extra slot here.

The similar issue also exists in fill_up_crash_elf_data().  The range to
be excluded is [0, 1M], start (0) is special and will not appear in the
middle of existing cmem->ranges[].  But in cast the low 1M could be
changed in the future, add a extra slot too.

Previous discussions:
[1] https://lore.kernel.org/kexec/ZXk2oBf%2FT1Ul6o0c@MiWiFi-R3L-srv/
[2] https://lore.kernel.org/kexec/273284e8-7680-4f5f-8065-c5d780987e59@easystack.cn/
[3] https://lore.kernel.org/kexec/ZYQ6O%2F57sHAPxTHm@MiWiFi-R3L-srv/

Link: https://lkml.kernel.org/r/20250904093855.1180154-1-coxu@redhat.com
Signed-off-by: fuqiang wang <fuqiang.wang@easystack.cn>
Signed-off-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Coiby Xu <coxu@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/crash.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/crash.c~x86-kexec-fix-potential-cmem-ranges-out-of-memory
+++ a/arch/x86/kernel/crash.c
@@ -165,8 +165,18 @@ static struct crash_mem *fill_up_crash_e
 	/*
 	 * Exclusion of crash region, crashk_low_res and/or crashk_cma_ranges
 	 * may cause range splits. So add extra slots here.
+	 *
+	 * Exclusion of low 1M may not cause another range split, because the
+	 * range of exclude is [0, 1M] and the condition for splitting a new
+	 * region is that the start, end parameters are both in a certain
+	 * existing region in cmem and cannot be equal to existing region's
+	 * start or end. Obviously, the start of [0, 1M] cannot meet this
+	 * condition.
+	 *
+	 * But in order to lest the low 1M could be changed in the future,
+	 * (e.g. [start, 1M]), add a extra slot.
 	 */
-	nr_ranges += 2 + crashk_cma_cnt;
+	nr_ranges += 3 + crashk_cma_cnt;
 	cmem = vzalloc(struct_size(cmem, ranges, nr_ranges));
 	if (!cmem)
 		return NULL;
@@ -322,10 +332,15 @@ int crash_setup_memmap_entries(struct ki
 	struct crash_mem *cmem;
 
 	/*
-	 * Using random kexec_buf for passing dm crypt keys may cause a range
-	 * split. So use two slots here.
+	 * In the current x86 architecture code, the elfheader is always
+	 * allocated at crashk_res.start. But it depends on the allocation
+	 * position of elfheader in crashk_res. To avoid potential out of
+	 * bounds in future, add an extra slot.
+	 *
+	 * And using random kexec_buf for passing dm crypt keys may cause a
+	 * range split too, add another extra slot here.
 	 */
-	nr_ranges = 2;
+	nr_ranges = 3;
 	cmem = vzalloc(struct_size(cmem, ranges, nr_ranges));
 	if (!cmem)
 		return -ENOMEM;
_

Patches currently in -mm which might be from fuqiang.wang@easystack.cn are


