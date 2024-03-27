Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335F8150980
	for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2024 20:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711570355; cv=none; b=A+gDgRWCqc615vcpWk0YBJiiLXeDp30+k0feL+nOyPp9PtJyQ3lIlaaHIXxF70iyWl9UxNdtMQFNherRZkdrAjyrf47BTccXN0J26zHRxHT9mAH3wjuBO7RmLP1bBHl4ptEIYN0mY8qhrrH91Fvn7RcD/ULzhVAciUKbyICCSEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711570355; c=relaxed/simple;
	bh=hZphOrlIBZxZDaOWTC1Vvom7CiO9CPdvB3XyZmVu2Ls=;
	h=Date:To:From:Subject:Message-Id; b=O9X8rDOmbg+J2Fyla/fcTtWEgVFOPUfGPUbRVSvuorqJzYfX9wLe6X4NkDw1B9sx9lXxdIBK2U0x6qvynnzQgLcqo3LDcfJt3iEcuT2RGgjKrlE1auc3VEhhUpCL26kbIwGgcM6oYI5rY4/ZC5liWyI7XyAnEKJys3ql/+d3gPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qCpYWiHw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qCpYWiHw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5397C433F1;
	Wed, 27 Mar 2024 20:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711570354;
	bh=hZphOrlIBZxZDaOWTC1Vvom7CiO9CPdvB3XyZmVu2Ls=;
	h=Date:To:From:Subject:From;
	b=qCpYWiHwEDtaThxuYBuEhIkYjtVHoaVlqE1vam+tziISfYrZAjnoJF30SkoUjHZmc
	 NCzY7dKHJ2jU5rwpQNFYd57lL1BbmQ20ZLO6cZrWiRYc/+4ZYynlOuOmz434vbnvRa
	 bpm9ah4Ssc1T1V6xR2eXV/vqxnAR6/bbBWD0Il6c=
Date: Wed, 27 Mar 2024 13:12:33 -0700
To: mm-commits@vger.kernel.org,kent.overstreet@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fix-missing-vmalloch-includes-fix.patch added to mm-unstable branch
Message-Id: <20240327201234.A5397C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fixup! fix missing vmalloc.h includes
has been added to the -mm mm-unstable branch.  Its filename is
     fix-missing-vmalloch-includes-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fix-missing-vmalloch-includes-fix.patch

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
From: Kent Overstreet <kent.overstreet@linux.dev>
Subject: fixup! fix missing vmalloc.h includes
Date: Tue, 26 Mar 2024 20:21:52 -0400

The previous patch added string.h to arch/alpha/lib/memcpy.c to fix a
warning about a missing forward declaration - but this breaks with -
presumably - some fortify source shenanigans that redefine memcpy as a
macro.

Link: https://lkml.kernel.org/r/20240327002152.3339937-1-kent.overstreet@linux.dev
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/lib/memcpy.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/alpha/lib/memcpy.c~fix-missing-vmalloch-includes-fix
+++ a/arch/alpha/lib/memcpy.c
@@ -18,7 +18,6 @@
 
 #include <linux/types.h>
 #include <linux/export.h>
-#include <linux/string.h>
 
 /*
  * This should be done in one go with ldq_u*2/mask/stq_u. Do it
_

Patches currently in -mm which might be from kent.overstreet@linux.dev are

fix-missing-vmalloch-includes.patch
fix-missing-vmalloch-includes-fix.patch
asm-generic-ioh-kill-vmalloch-dependency.patch
mm-slub-mark-slab_free_freelist_hook-__always_inline.patch
scripts-kallysms-always-include-__start-and-__stop-symbols.patch
fs-convert-alloc_inode_sb-to-a-macro.patch
rust-add-a-rust-helper-for-krealloc.patch
mempool-hook-up-to-memory-allocation-profiling.patch
mm-percpu-introduce-pcpuobj_ext.patch
mm-percpu-add-codetag-reference-into-pcpuobj_ext.patch
mm-vmalloc-enable-memory-allocation-profiling.patch
rhashtable-plumb-through-alloc-tag.patch
maintainers-add-entries-for-code-tagging-and-memory-allocation-profiling.patch
memprofiling-documentation.patch

