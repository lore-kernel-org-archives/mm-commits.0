Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA501E991B
	for <mm-commits@vger.kernel.org>; Thu, 18 Dec 2025 23:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766102359; cv=none; b=sOLZ/staCKNPk+IgCjqklkH8R0azodR6FRbwNRSDwk2Nb6/jYqWpys83+IAQbyiYvQ8BfH3KkriPWwSPAfyfV8FpfL8oyYsdXIqzoBTE/AbBy8Xzrq1WXOMul3uJywtsQcvxZg5os2AuMAxaQa9kq/VKHUiyMUYyjNg1L/uwy7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766102359; c=relaxed/simple;
	bh=O4iGVyHCfl76PpYmU4wbIjJNNlqgEL1pMgybcHRO4oo=;
	h=Date:To:From:Subject:Message-Id; b=kEeKHcKjuopmYeWk0VyCra44TZkjnXyNkK5VsoSUgqbDzVOFq3oA+1UMk0SLUgkhqRgYwigr5xlYvTRiuw4cGVh1Dk8RuFiyURSos+a/I4KKa4482nAbFed9nOloT6Y1A2vWDcC0wR6n7E+rPraAwMIUEFyttTUztil7bVBMvG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WLVElm3p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WLVElm3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97ACFC4CEFB;
	Thu, 18 Dec 2025 23:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766102358;
	bh=O4iGVyHCfl76PpYmU4wbIjJNNlqgEL1pMgybcHRO4oo=;
	h=Date:To:From:Subject:From;
	b=WLVElm3pGM+zFBJvQomQ32kunxoahnBcHVUQLLysm+svdLy3P+KVHs3C5SaYY9j2V
	 pUvf+FeC8tpTUQqabVQf5LwBHVPlvqq561iczNUsRtPc79u6U58ymuqCcoGlHL/5OQ
	 xrxdAcESndYX5V5ihvzI0fbALb9tBckcUyee54J8=
Date: Thu, 18 Dec 2025 15:59:18 -0800
To: mm-commits@vger.kernel.org,kernel@xen0n.name,glider@google.com,elver@google.com,dvyukov@google.com,chenhuacai@kernel.org,yuanlinyu@honor.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + loongarch-kfence-avoid-use-config_kfence_num_objects.patch added to mm-new branch
Message-Id: <20251218235918.97ACFC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: LoongArch: kfence: avoid use CONFIG_KFENCE_NUM_OBJECTS
has been added to the -mm mm-new branch.  Its filename is
     loongarch-kfence-avoid-use-config_kfence_num_objects.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/loongarch-kfence-avoid-use-config_kfence_num_objects.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: yuan linyu <yuanlinyu@honor.com>
Subject: LoongArch: kfence: avoid use CONFIG_KFENCE_NUM_OBJECTS
Date: Thu, 18 Dec 2025 09:58:47 +0800

Patch series "kfence: allow change objects number".

patch01 use common KFENCE_POOL_SIZE for LoongArch
patch02 always create kfence debugfs dir/file
patch03 allow change objects number


This patch (of 3):

Use common kfence macro KFENCE_POOL_SIZE for KFENCE_AREA_SIZE definition

Link: https://lkml.kernel.org/r/20251218015849.1414609-1-yuanlinyu@honor.com
Link: https://lkml.kernel.org/r/20251218015849.1414609-2-yuanlinyu@honor.com
Signed-off-by: yuan linyu <yuanlinyu@honor.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Marco Elver <elver@google.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/include/asm/pgtable.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/loongarch/include/asm/pgtable.h~loongarch-kfence-avoid-use-config_kfence_num_objects
+++ a/arch/loongarch/include/asm/pgtable.h
@@ -10,6 +10,7 @@
 #define _ASM_PGTABLE_H
 
 #include <linux/compiler.h>
+#include <linux/kfence.h>
 #include <asm/addrspace.h>
 #include <asm/asm.h>
 #include <asm/page.h>
@@ -96,7 +97,7 @@ extern unsigned long empty_zero_page[PAG
 #define MODULES_END	(MODULES_VADDR + SZ_256M)
 
 #ifdef CONFIG_KFENCE
-#define KFENCE_AREA_SIZE	(((CONFIG_KFENCE_NUM_OBJECTS + 1) * 2 + 2) * PAGE_SIZE)
+#define KFENCE_AREA_SIZE	(KFENCE_POOL_SIZE + (2 * PAGE_SIZE))
 #else
 #define KFENCE_AREA_SIZE	0
 #endif
_

Patches currently in -mm which might be from yuanlinyu@honor.com are

loongarch-kfence-avoid-use-config_kfence_num_objects.patch
kfence-allow-create-debugfs-dir-file-unconditionally.patch
kfence-allow-change-number-of-object-by-early-parameter.patch

