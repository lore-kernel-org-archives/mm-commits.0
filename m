Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E025B1CF90
	for <mm-commits@vger.kernel.org>; Tue, 11 Jun 2024 19:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718135842; cv=none; b=tt9K5/7z/v6RACCYnAW+uda1ofdZoK4gUBk5hZUg9icAOu2NAsyaa7QSrjGSroMG3x5d78FsoTf90rTZKiKO1FoF+e/nmGjxVhpRDdgYxB6HwmnZsT0QgcR5nfrouZDUOSdwm2oL33zLihgQ6iXysILPaMqqzi9veVcbJSdOb3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718135842; c=relaxed/simple;
	bh=pioFOL8TrLREYu4+NtQQ85wbQUMQ910uKSfBLf5LgNA=;
	h=Date:To:From:Subject:Message-Id; b=gcbjtrsRb82YOsjYvKLP5RpDcguy9HlO6wtGPNtnEMd5sKQ887zG264ZwndTkU6kIVTw6sd+4nifoS5XyCPywv4rcxMfwB04WR2MkTfEylPQ1gx5vUTPJZSKULoF7a/zhgaA+0Yzxf7aREX3ZTRxX4kfVX69RKa0crkNoO40rTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vIcL+BYu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vIcL+BYu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703E7C32786;
	Tue, 11 Jun 2024 19:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718135841;
	bh=pioFOL8TrLREYu4+NtQQ85wbQUMQ910uKSfBLf5LgNA=;
	h=Date:To:From:Subject:From;
	b=vIcL+BYueFym8tn7l3odmQCvvDU3R70rRvX9UYUd9xquYw0Z7MgxrXhot3o4waWdx
	 E+nbJMHNv9bYrxMf0zeAWnoQmBz6fmBE+sbf2H9egkxWn+svlsLvyMtMfSTC8Au+6D
	 on7Is3j8x59L+yeFekq8OuKe76n5Mg/7xwths7UM=
Date: Tue, 11 Jun 2024 12:57:20 -0700
To: mm-commits@vger.kernel.org,xiongwei.song@windriver.com,willy@infradead.org,urezki@gmail.com,shubhang@os.amperecomputing.com,guoren@kernel.org,corbet@lwn.net,cl@linux.com,Shubhang@os.amperecomputing.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vmalloc-modify-the-alloc_vmap_area-error-message-for-better-diagnostics-v5.patch added to mm-unstable branch
Message-Id: <20240611195721.703E7C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: vmalloc: modify the alloc_vmap_area() error message for better diagnostics
has been added to the -mm mm-unstable branch.  Its filename is
     vmalloc-modify-the-alloc_vmap_area-error-message-for-better-diagnostics-v5.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmalloc-modify-the-alloc_vmap_area-error-message-for-better-diagnostics-v5.patch

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
From: Shubhang Kaushik OS <Shubhang@os.amperecomputing.com>
Subject: vmalloc: modify the alloc_vmap_area() error message for better diagnostics
Date: Tue, 11 Jun 2024 19:38:44 +0000

use `vend' in warning printk

Link: https://lkml.kernel.org/r/CH2PR01MB5894B0182EA0B28DF2EFB916F5C72@CH2PR01MB5894.prod.exchangelabs.com
Signed-off-by: Shubhang Kaushik <shubhang@os.amperecomputing.com>
Reviewed-by: Christoph Lameter (Ampere) <cl@linux.com>
Cc: Guo Ren <guoren@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Xiongwei Song <xiongwei.song@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~vmalloc-modify-the-alloc_vmap_area-error-message-for-better-diagnostics-v5
+++ a/mm/vmalloc.c
@@ -2057,7 +2057,7 @@ overflow:
 
 	if (!(gfp_mask & __GFP_NOWARN) && printk_ratelimit())
 		pr_warn("vmalloc_node_range for size %lu failed: Address range restricted to %#lx - %#lx\n",
-				size, addr, addr+size);
+				size, vstart, vend);
 
 	kmem_cache_free(vmap_area_cachep, va);
 	return ERR_PTR(-EBUSY);
_

Patches currently in -mm which might be from Shubhang@os.amperecomputing.com are

vmalloc-modify-the-alloc_vmap_area-error-message-for-better-diagnostics.patch
vmalloc-modify-the-alloc_vmap_area-error-message-for-better-diagnostics-v5.patch

