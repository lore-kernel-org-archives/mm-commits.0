Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4253370
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719627617; cv=none; b=baG9cSFxowLcQVeXgQoEVDTHJ+0EZ2G7kwRQzOqJgpW9QoasrUNvq8jRXK7EUVqNV9b5afaTDlc2rnTy45qKBFuXBN8KvJhrEeceVox2xISDhUeAZkxmEuQx8vjSj0gJRD1ydOt0wxVfm9CRzzTNOOadgW0avIssNl1rIstclgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719627617; c=relaxed/simple;
	bh=KZj7WeLLf3j4tBrliOVDZHX3pqIPVUwI1j9cncnYGOY=;
	h=Date:To:From:Subject:Message-Id; b=tIlp8yYUX0g5VW/BPTYrlbtY0uL3drS3P3/GWcCYo/5LpMcgv4Z9Sjwkssl6o6/LuilTIaqiHPs9/Mdi1IafdKIpM8hJ5RziCtdPlr89wBktBnG6Quiviu9RefsfGLUgJ66zFmgkT++DoZtJ672iP8EmbnvwGktDvpZ4kwCoFL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SoI6GbZp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SoI6GbZp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88016C116B1;
	Sat, 29 Jun 2024 02:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719627617;
	bh=KZj7WeLLf3j4tBrliOVDZHX3pqIPVUwI1j9cncnYGOY=;
	h=Date:To:From:Subject:From;
	b=SoI6GbZpk6hmq/I60SGwhpItzvsLKc/dEA2RgY5F9cNYLbxc7lnQCaVocuxJzo/xf
	 7LLLMU9P8yZXDKJLG8L/UbQCHYpC1MFsqBDCZeEV7+VTI9SIhZ0qATk+sfG7IYE+rh
	 JthiaGviT0npHXpiKLUB5fB2cWycU+I0t+IRAmGk=
Date: Fri, 28 Jun 2024 19:20:16 -0700
To: mm-commits@vger.kernel.org,xiongwei.song@windriver.com,willy@infradead.org,urezki@gmail.com,shubhang@os.amperecomputing.com,guoren@kernel.org,corbet@lwn.net,cl@linux.com,Shubhang@os.amperecomputing.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] vmalloc-modify-the-alloc_vmap_area-error-message-for-better-diagnostics-v5.patch removed from -mm tree
Message-Id: <20240629022017.88016C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: vmalloc: modify the alloc_vmap_area() error message for better diagnostics
has been removed from the -mm tree.  Its filename was
     vmalloc-modify-the-alloc_vmap_area-error-message-for-better-diagnostics-v5.patch

This patch was dropped because it was folded into vmalloc-modify-the-alloc_vmap_area-error-message-for-better-diagnostics.patch

------------------------------------------------------
From: Shubhang Kaushik OS <Shubhang@os.amperecomputing.com>
Subject: vmalloc: modify the alloc_vmap_area() error message for better diagnostics
Date: Tue, 11 Jun 2024 19:38:44 +0000

replace the vmalloc range parameters in the overflow warning message to be
between vstart and vend

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

