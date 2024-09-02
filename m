Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C388A1D12FA
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 01:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725238884; cv=none; b=PF4vAvRWOqoQMV5FV9n71iJNjJPYuZd2zzep0GqTHgbZZ0f5wV/2FZ1UcPnzWSE4fw5rk96zoaQwGMJIQsQyhgkKVQHkGWkcO+Xbw9Cx3b4F8T6VlWmXMdtqcT1WS6fMozI82X+r+B1X0zv2NRQjkREmLHvivZiUJNwT1Xd11rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725238884; c=relaxed/simple;
	bh=87f54bmnYXcerzQAtIE/8VLosvobk6WkS8lPjos66TM=;
	h=Date:To:From:Subject:Message-Id; b=uSb3stuVjI0wfWgpCbcgMDFwew2vrUzv/Rjv2WAFXPAAk0m5oNdoHRhwAlAQdWrLwztMwrbsMmOzYex3CEF3C0SBT38+BCYvM6IOZZb+euLvePH2G4au7iJhgc9WcRzgG6nPsu0O4/9gOQwldUYts3aicgBVNPTNj/TWV+4uGYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QIQ421ay; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QIQ421ay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57651C4CEC3;
	Mon,  2 Sep 2024 01:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725238884;
	bh=87f54bmnYXcerzQAtIE/8VLosvobk6WkS8lPjos66TM=;
	h=Date:To:From:Subject:From;
	b=QIQ421ay9KAUWER4CKH+X7frN2nX/8k3PwA2HuaGsn5Aj+cDfmYoB8quFo8LdQKKt
	 fEdL6bXh8bfW32ZF8A0eg4ZBnpEetp/BgwdnKxGVl93PQx18QkagC7cue/pHEeT8dv
	 pRWpIULRgbnmcr9TznV1AGCO3ctXtLZTTFLcW1kI=
Date: Sun, 01 Sep 2024 18:01:23 -0700
To: mm-commits@vger.kernel.org,dakr@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vmalloc-implement-vrealloc-fix.patch removed from -mm tree
Message-Id: <20240902010124.57651C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vrealloc: fix missing nommu implementation
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-implement-vrealloc-fix.patch

This patch was dropped because it was folded into mm-vmalloc-implement-vrealloc.patch

------------------------------------------------------
From: Danilo Krummrich <dakr@kernel.org>
Subject: mm: vrealloc: fix missing nommu implementation
Date: Thu, 25 Jul 2024 16:11:59 +0200

Commit 5ec6d992f460 ("mm: vmalloc: implement vrealloc()") introduces
vrealloc(), but lacks the implementation of the nommu version of this
function.

Note that currently nommu isn't actually broken without this.  The only
user, kvrealloc(), never actually calls into vrealloc() with nommu, since
it's guarded by is_vmalloc_addr(), which for nommu always returns false.

However, since this becomes a real issue once vrealloc() is used by other
code, fix this.

Link: https://lkml.kernel.org/r/20240725141227.13954-1-dakr@kernel.org
Fixes: 5ec6d992f460 ("mm: vmalloc: implement vrealloc()")
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/nommu.c~mm-vmalloc-implement-vrealloc-fix
+++ a/mm/nommu.c
@@ -126,6 +126,11 @@ void *__vmalloc_noprof(unsigned long siz
 }
 EXPORT_SYMBOL(__vmalloc_noprof);
 
+void *vrealloc_noprof(const void *p, size_t size, gfp_t flags)
+{
+	return krealloc_noprof(p, size, (flags | __GFP_COMP) & ~__GFP_HIGHMEM);
+}
+
 void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
 		unsigned long start, unsigned long end, gfp_t gfp_mask,
 		pgprot_t prot, unsigned long vm_flags, int node,
_

Patches currently in -mm which might be from dakr@kernel.org are

mm-vmalloc-implement-vrealloc.patch
mm-vmalloc-implement-vrealloc-fix-2.patch
mm-vmalloc-implement-vrealloc-fix-3.patch
mm-vmalloc-implement-vrealloc-fix-4.patch
mm-kvmalloc-align-kvrealloc-with-krealloc.patch
mm-kvmalloc-align-kvrealloc-with-krealloc-fix.patch
mm-kvmalloc-align-kvrealloc-with-krealloc-fix-2.patch
mm-kvmalloc-align-kvrealloc-with-krealloc-fix-3.patch
mm-krealloc-consider-spare-memory-for-__gfp_zero.patch
mm-krealloc-clarify-valid-usage-of-__gfp_zero.patch

