Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D245130495
	for <mm-commits@vger.kernel.org>; Thu,  4 Apr 2024 17:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712252113; cv=none; b=huxKaeWxzT8e5vbKWlLiiFuEr+YyJu3Y+QK5ngEv4wXNMxmjsLLp/J+52HSg9uvLTUE55C8/3Fzr2+6eb+pjaeFYpZWNew5nnGuqlrM+/AEnViBbfMCrdV6fA7DJIyHuvIi9YaBNjiK7AdwdrO6OJ9MiVHsg3wSfhEJLkrxiJp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712252113; c=relaxed/simple;
	bh=uA6BhgnhuCFDto+vDWxI3KyXZE5f53NTAGssTsDTXUY=;
	h=Date:To:From:Subject:Message-Id; b=atoeuCZ8wQn7XTRp1V7GfnhFlxwOVP7czLBlrYo3tkOfZQtswK5C5eXfTNeRmq2SuDN8rAgT9KfJ0RVKRrRc9xJxFOAYGn5FqnurpzHQ2NwPe++HvM84BMn5X8v7WbpXk+d7rghnOPuthYdKtsl2iwiiZEcccRj5V1cJeKzv1GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lMirMQ71; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lMirMQ71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1271C43394;
	Thu,  4 Apr 2024 17:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712252112;
	bh=uA6BhgnhuCFDto+vDWxI3KyXZE5f53NTAGssTsDTXUY=;
	h=Date:To:From:Subject:From;
	b=lMirMQ71CGnq5wE3ybmVnp/IOSwS8lvNeESm8ppDIq5t10ywencPrO4euj763KEIx
	 ObCWjGBitJ9UtUqDayCPxZpQvlndIhs7B8wm2Ik9HudOyyWWf8dFEPgP26DMoWFRoS
	 jPZxe/wn5DXXwF5Epefm3dnr3+80B4PRAeWFiZQ8=
Date: Thu, 04 Apr 2024 10:35:05 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,kent.overstreet@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fix-missing-vmalloch-includes-fix-4.patch added to mm-unstable branch
Message-Id: <20240404173512.A1271C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fixup! fix missing vmalloc.h includes
has been added to the -mm mm-unstable branch.  Its filename is
     fix-missing-vmalloch-includes-fix-4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fix-missing-vmalloch-includes-fix-4.patch

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
Date: Wed, 3 Apr 2024 23:47:43 -0400

Few places were depending on sizes.h (convenience human-readable-units
size macros) iplicitly; fix

Link: https://lkml.kernel.org/r/20240327002152.3339937-1-kent.overstreet@linux.dev
Link: https://lkml.kernel.org/r/20240404034744.1664840-1-kent.overstreet@linux.dev
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/io.h |    1 +
 include/linux/io.h       |    1 +
 2 files changed, 2 insertions(+)

--- a/include/asm-generic/io.h~fix-missing-vmalloch-includes-fix-4
+++ a/include/asm-generic/io.h
@@ -9,6 +9,7 @@
 
 #include <asm/page.h> /* I/O is all done through memory accesses */
 #include <linux/string.h> /* for memset() and memcpy() */
+#include <linux/sizes.h>
 #include <linux/types.h>
 #include <linux/instruction_pointer.h>
 
--- a/include/linux/io.h~fix-missing-vmalloch-includes-fix-4
+++ a/include/linux/io.h
@@ -6,6 +6,7 @@
 #ifndef _LINUX_IO_H
 #define _LINUX_IO_H
 
+#include <linux/sizes.h>
 #include <linux/types.h>
 #include <linux/init.h>
 #include <linux/bug.h>
_

Patches currently in -mm which might be from kent.overstreet@linux.dev are

fix-missing-vmalloch-includes.patch
fix-missing-vmalloch-includes-fix.patch
fix-missing-vmalloch-includes-fix-4.patch
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

