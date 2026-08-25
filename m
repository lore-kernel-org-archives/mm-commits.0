Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0380E36197D
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622879; cv=none; b=YNSdpBqgt82IHbwhLeuP16FbBjQxyS+/5Ryl9WPeDVETR4qgyL+eIYW0XI5//nJgCblP7mNUV2mx2AMfllJHUl+mRrIR4JqXmjPvYxWgIL9c+7YNZpLXZPd+MgO7Nq5kQt+r4ktgW1fNQSagcCmvFEue+bnW/RIAn6Kzadbx6zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622879; c=relaxed/simple;
	bh=jjjEfXliW4rI5xrGXeMqxIr463EH7cSzqth+HbNhMuY=;
	h=Date:To:From:Subject:Message-Id; b=DYyJhrHOqXp7e8MVKEI4iZQEwfAD50GKeWLnqpBbuAzLNQBqTTi26y8wGRrncPVE3SVbv+aShXHbiK9s1KpVaP6ghFc5w9u2OfIH8KtpVTF6A1qB8rgCZ06bl3bSrL4uTPe1xYjZ0OnqS/D1huPU/QvsWHMZ9pXyrvydMOJuXPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KDiW0Kzx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KDiW0Kzx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 875E61F00A3A;
	Tue, 25 Aug 2026 01:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622877;
	bh=YU1ovCI7wZm8XF1rwrtuITggZEy5zoFQ1wWqb1hmsu4=;
	h=Date:To:From:Subject;
	b=KDiW0Kzxqopfqr4Viy/byyTbFdpHQai3pBOhW/aBSy66M8t4LjukcQI8jrjAnbp0Y
	 gBg/y75hzlVBYK100fwaSmaYSCwTVKAc9Z6uNCPGrFbOjzR+HlkYeZi0MCME5JD0PF
	 FNZDPqOo+lD3X7qfoSZ0arTnfG0Zg/rniie6Txg8=
Date: Mon, 24 Aug 2026 18:54:37 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,jannh@google.com,aliceryhl@google.com,enelsonmoore@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-config_stack_growsup-typo-in-tools-testing-vma-include-duph.patch removed from -mm tree
Message-Id: <20260825015437.875E61F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix CONFIG_STACK_GROWSUP typo in tools/testing/vma/include/dup.h
has been removed from the -mm tree.  Its filename was
     mm-fix-config_stack_growsup-typo-in-tools-testing-vma-include-duph.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Subject: mm: fix CONFIG_STACK_GROWSUP typo in tools/testing/vma/include/dup.h
Date: Wed, 10 Jun 2026 18:22:44 -0700

Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") significantly
refactored the header file include/linux/mm.h.  In that step, it
introduced a typo in an ifdef, referring to a non-existing config option
STACK_GROWS_UP, whereas the actual config option is called STACK_GROWSUP.

Commit 40a4af52e047 ("mm: fix CONFIG_STACK_GROWSUP typo in mm.h") fixed
this typo in the mm.h header file, but did not update the copy of the code
in tools/testing/vma/include/dup.h.  Update this copy as well.

Commit message adapted from the above-referenced fix to mm.h.

Link: https://lore.kernel.org/20260611012258.432043-1-enelsonmoore@gmail.com
Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/vma/include/dup.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/vma/include/dup.h~mm-fix-config_stack_growsup-typo-in-tools-testing-vma-include-duph
+++ a/tools/testing/vma/include/dup.h
@@ -243,7 +243,7 @@ enum {
 #define VM_NOHUGEPAGE	INIT_VM_FLAG(NOHUGEPAGE)
 #define VM_MERGEABLE	INIT_VM_FLAG(MERGEABLE)
 #define VM_STACK	INIT_VM_FLAG(STACK)
-#ifdef CONFIG_STACK_GROWS_UP
+#ifdef CONFIG_STACK_GROWSUP
 #define VM_STACK_EARLY	INIT_VM_FLAG(STACK_EARLY)
 #define VMA_STACK_EARLY mk_vma_flags(VMA_STACK_EARLY_BIT)
 #else
_

Patches currently in -mm which might be from enelsonmoore@gmail.com are


