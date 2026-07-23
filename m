Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B4339184F;
	Thu, 23 Jul 2026 19:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784834926; cv=none; b=OXu2aIbRCL4ipgbYNBK9Seo5WfkQA5KngWwwqxfsJQxIV17MO1fKtUfAD8WcnKDtKvpMtraK8l3okFxd/gJXGygGKnKQq7UomXnGjbvd5qbkSv7TZF3ubmD9AP1R5XYH+neIHYuQJ5cRVVHwwDo/l3B7+2ScNuLvc5hD/q94li0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784834926; c=relaxed/simple;
	bh=WHizssShpetbiI3ySl30oBnHKVlydmhVH/VHMvwSxAY=;
	h=Date:To:From:Subject:Message-Id; b=H8+vHOrrLdh+P7Em+EqCd+5BiN4bZpB/cfH8X0G2A8P9jrtgS2MQLjzTcZlmk/h3+eDEXUMP88DuKasI0G1kSOpdhyzJ/QfVnYNMU3OgyhesVKgJoXc9wv3hW6DwVC71+fTVAW1lojpJx6pTX8YFPni8u/HpyAup4iJ8JHkV/Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TyQZbgjp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TyQZbgjp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD171F000E9;
	Thu, 23 Jul 2026 19:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784834924;
	bh=XDqlpZ766fl4kTNcd/nUOe4qA5KuXfg4s8+cWVF74zw=;
	h=Date:To:From:Subject;
	b=TyQZbgjpr8/VjfM4K0hkS6gwXCwsF2/9tzHc3XNCcdu1g+L7cNBWQFNIkc3Hxi38t
	 ruhBhYT4cnczXtPvy1R0xQPIAKzDxfFGcL097jaLRG3g5ClOdxoleo2VG1exs38MjX
	 cjEXko+RtXpYZMggUVhQnlI7L/qNWjd/ZO/7zNWw=
Date: Thu, 23 Jul 2026 12:28:44 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,oleg.deomi@gmail.com,bsingharora@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] kernel-taskstatsc-parse-fix-buffer-allocation-size.patch removed from -mm tree
Message-Id: <20260723192844.BBD171F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel/taskstats.c:parse(): fix buffer allocation size
has been removed from the -mm tree.  Its filename was
     kernel-taskstatsc-parse-fix-buffer-allocation-size.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel/taskstats.c:parse(): fix buffer allocation size
Date: Tue Jul 21 04:30:41 PM PDT 2026

parse() is failing to allow for the nla_strscpy()'s null termination of
the cpumask string.  This can result in the cpumask string being
truncated.

This can result in an inappropriate -EINVAL failure or in reporting for an
incorrect span of CPUs.

Fixes: f9fd8914c1ac ("[PATCH] per-task delay accounting taskstats interface: control exit data through cpumasks")
Reported-by: Oleg Deomi <oleg.deomi@gmail.com>
Closes: https://lore.kernel.org/CAByWkfZ6b1=3H9pwkz-dDQOs9cZaF-HYQ6b9Yb0=Hq2r1Vv_Pw@mail.gmail.com
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/taskstats.c~kernel-taskstatsc-parse-fix-buffer-allocation-size
+++ a/kernel/taskstats.c
@@ -368,7 +368,7 @@ static int parse(struct nlattr *na, stru
 		return -E2BIG;
 	if (len < 1)
 		return -EINVAL;
-	data = kmalloc(len, GFP_KERNEL);
+	data = kmalloc(len + 1, GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 	nla_strscpy(data, na, len);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mincore-use-walk_page_range_vma-in-do_mincore-fix.patch
csky-implement-flush_cache_vmap-in-c.patch
mm-annotate-data-race-in-cpu_needs_drain-fix.patch
mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-fix.patch
mm-rmap-use-huge_ptep_get-in-try_to_migrate_one-checkpatch-fixes.patch
mm-mprotect-use-huge_ptep_get-for-hugetlb-fix.patch
mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic-fix.patch
alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch
mm-vma-add-and-use-vma__pgoff-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

