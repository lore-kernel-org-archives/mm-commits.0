Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFDB2F619B
	for <mm-commits@vger.kernel.org>; Thu,  4 Sep 2025 23:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757029319; cv=none; b=CStSzzHP/sSJVNCGtR/cOxqMpbzjvhI3N1ZRRxhCmHhdjVIkw84PdvUfI62/r/fcJe9sWtaaOQj+Y+6aid5jExNutu4NJOiqd/DKIvoKdbHag9g6piFNeWhnbUFkBkb4LuUnO2jaueY7cWIUTgVhMZIDDkPHmDanyO6vfQhCIxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757029319; c=relaxed/simple;
	bh=iG4uL8Y2LKC1R1bou+4fV2/6VibJ+UoTIsaeV0WGNPU=;
	h=Date:To:From:Subject:Message-Id; b=HVa8qL9IZ0DGJq+/VOg1IkLibGSyGoUDbZ9XdAeqfY4qrMjt9BdKfcT9mMJQ4OjHqD5YGlCTXmOGWPvlZ2ELeViuS5eYkBjUvIikKQFlIWhcMa19fn7mdTRea0uY5Y7uFxYajUueaLmt5GPuraUZE5UlUpNFhmFgTXa/0LkvW84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DjGqeBPf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DjGqeBPf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8358C4CEF0;
	Thu,  4 Sep 2025 23:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757029319;
	bh=iG4uL8Y2LKC1R1bou+4fV2/6VibJ+UoTIsaeV0WGNPU=;
	h=Date:To:From:Subject:From;
	b=DjGqeBPf2nBvLytCdap8Wev6SLVdfzYUTm6leXiNwozjytKgrJMJTBPIxghtxW9Z9
	 F6jVjAU1vWwjgwonAruHCZ2PwuvkLR+DufXrlKK4g7s+8uEmxe6eBKry7DRybTOkIM
	 0ttOqSqBoIx25DfZMiwV4wOK3YX3KR7beJ0plOrM=
Date: Thu, 04 Sep 2025 16:41:58 -0700
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,tglx@linutronix.de,mingo@redhat.com,hpa@zytor.com,dyoung@redhat.com,coxu@redhat.com,bp@alien8.de,bhe@redhat.com,fuqiang.wang@easystack.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-kexec-fix-potential-cmem-ranges-out-of-memory.patch added to mm-nonmm-unstable branch
Message-Id: <20250904234158.E8358C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/kexec: fix potential cmem->ranges out of memory
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     x86-kexec-fix-potential-cmem-ranges-out-of-memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-kexec-fix-potential-cmem-ranges-out-of-memory.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

x86-kexec-fix-potential-cmem-ranges-out-of-memory.patch

