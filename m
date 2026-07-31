Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5693328635
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465790; cv=none; b=tyWaBY/qoX5sNxmmhGqPN0eiKNgB2AdkC6zdkbSHPw56z80rtU2nj/v59eZbDbdVV2Gx7JZenwbeKqTApXbUF+C4Hyl53v8vymj4FjZPb4tC2iRamiHTFEMzTgSsxkyZ+24WbiQQuc5KVK3WfyT+zgOkFsOWc8dpgeB9LgNmN34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465790; c=relaxed/simple;
	bh=nf+bV1+Q7b9n06hYYShjAboU2rVh83L/WX69I9jqSDE=;
	h=Date:To:From:Subject:Message-Id; b=Tq+VU8grIRQ+N9SqV8vSevVKeOEL9f/1keR2id9Ss6gxssAlqSWQPpDieUTyFg6OEQoPiG1q0Oc2c+o6vWl1ZAAyF+MItIQTRca9gBtD1hL+w4ECLoz2kFM42bnXwycxdKLUiv9rC1CbegPk5FbS7zj7PNq2mFiDdChz1g6BVew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GntahSwX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GntahSwX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5151F000E9;
	Fri, 31 Jul 2026 02:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465789;
	bh=lsIyUSrNmaco7DmywysTN+tK1PuR8Sl0W8idV33+HZQ=;
	h=Date:To:From:Subject;
	b=GntahSwXXQ4gRPrSJ6MrpZ0brNywqJiWUWSHkQ720Qo9aNN1EFNuYo9xONb9lmh33
	 Ohm5FPYzlhpANx+lLuUsVl21NPdRNwku20FA2YU7Q3Q138kCwJxxOLmdJqIE2eScfu
	 SyJsC2fg7GKD2OchpKvlkQfBtYusXzqMePQgpIEc=
Date: Thu, 30 Jul 2026 19:43:09 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,feng.tang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-add-alignment-info-in-warning-print-as-possible-failure-reason.patch removed from -mm tree
Message-Id: <20260731024309.7A5151F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: add alignment info in warning print as possible failure reason
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-add-alignment-info-in-warning-print-as-possible-failure-reason.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-add-alignment-info-in-warning-print-as-possible-failure-reason
+++ a/mm/vmalloc.c
@@ -4045,8 +4045,8 @@ again:
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


