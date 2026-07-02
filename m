Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA8E282F36
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 23:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783036198; cv=none; b=i1PJgwFz5A0iufcVNI08zLUZAnRwl0xhpd3+IbDftA5TOyYztqHpFp8XJfCa08ALcOSJfeKnugTXcC04ghi/ypp/dBhHYLlkOLVrihNo0Y4tJ6JXoZhLZ/8y8Sm+qJhxZmLAk34kQ/s/rhE/ZrVg2qyPVOdVdF8F7UcKl+8Ei58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783036198; c=relaxed/simple;
	bh=MNtY7eLdn6pmTyo/Scc3wscVX2IAk0Vv0IQT84B3B7s=;
	h=Date:To:From:Subject:Message-Id; b=Hhqtd3wcYEA8d1CherNepN3fWR/9QxJldDKhnHewSjiu6p3SlC8aY2i5tutEE+1050/BRY7qH//x2x16DyMyd7V2pp5Nsai+0gnYAYkUQcbBAvG5ZhqbM4eO0+yvssRSTNaeOwU3x0ueFsjXvDuPwFoDcQ/psPrt3DTU+UiP6e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jf0j8jfX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jf0j8jfX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 263B71F000E9;
	Thu,  2 Jul 2026 23:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783036197;
	bh=DWkldmTb2Tp5MM4JdZZMmsZZVhPSj+X6rGdiayrtRjU=;
	h=Date:To:From:Subject;
	b=jf0j8jfXS/zVuukU1pyzeb9H5sqJ8ly1Sw7pGlqqASF06zKTNcGCVUe8ffGGmL9Aj
	 6LkXLVr4JdM5i1q42g3qNZdLYaPnxADdQl0la2LOzo1zIEzQN7+8uGSp9JBlFQl5cB
	 USKi+ahXIdOyRaRQrFRxdKe6B7qO+8qkMK/Tbxuo=
Date: Thu, 02 Jul 2026 16:49:56 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,feng.tang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-add-alignment-info-in-warning-print-as-possible-failure-reason.patch added to mm-new branch
Message-Id: <20260702234957.263B71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: add alignment info in warning print as possible failure reason
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-add-alignment-info-in-warning-print-as-possible-failure-reason.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-add-alignment-info-in-warning-print-as-possible-failure-reason.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Feng Tang <feng.tang@linux.alibaba.com>
Subject: mm/vmalloc: add alignment info in warning print as possible failure reason
Date: Thu, 2 Jul 2026 19:26:10 +0800

When running 'fix_align_alloc_test' case of test_vmalloc module with
command:
    insmod ./test_vmalloc.ko run_test_mask=64

It will fail, which is the expected result, as the case increment
the alignment parameter gradually to 64bit limit. And the dmesg has
warning msg:
    "vmalloc_test/0: vmalloc error: size 4096, vm_struct allocation failed, mode:0xdc0(GFP_KERNEL|__GFP_ZERO), nodemask=(null),cpuset=/,mems_allowed=0"

It doesn't give the alignment info, which is the real reason for the
failure (not the 'size').

Add alignment info to the warning print to give the necessary hint
for possible failure reason, and the message will be:
    "vmalloc_test/0: vmalloc error: size 4096, align 0x800000000000, vm_struct allocation failed, mode:0xdc0(GFP_KERNEL|__GFP_ZERO), nodemask=(null),cpuset=/,mems_allowed=0"

Link: https://lore.kernel.org/20260702112610.21589-1-feng.tang@linux.alibaba.com
Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-add-alignment-info-in-warning-print-as-possible-failure-reason
+++ a/mm/vmalloc.c
@@ -4195,8 +4195,8 @@ again:
 	if (!area) {
 		bool nofail = gfp_mask & __GFP_NOFAIL;
 		warn_alloc(gfp_mask, NULL,
-			"vmalloc error: size %lu, vm_struct allocation failed%s",
-			size, (nofail) ? ". Retrying." : "");
+			"vmalloc error: size %lu, align 0x%lx, vm_struct allocation failed%s",
+			size, align, (nofail) ? ". Retrying." : "");
 		if (nofail) {
 			schedule_timeout_uninterruptible(1);
 			goto again;
_

Patches currently in -mm which might be from feng.tang@linux.alibaba.com are

mm-vmalloc-add-alignment-info-in-warning-print-as-possible-failure-reason.patch

