Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556BD33EA
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714100888; cv=none; b=BtCs7E6A4OLajF7pHgoWeBEnbCkuZvF6b5Fs+fEU8Ti4tMstUeCmrmVOcxskovm7iBarMJ9KpdC6RIp4GOn15yzpwMkkMRI8cf+6O6VjIvgH4cT5py0ZXhvjvHiA6I/SvFs5OgDSSQteeb2Vyi1AmQ4zDJ8nzkfKEMxiXNZM28E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714100888; c=relaxed/simple;
	bh=BELGro9s6coq67wanm6rVVjadQP3cbm02H243Ilc67Y=;
	h=Date:To:From:Subject:Message-Id; b=VBz6WZkNGaLZt0N9Y7TtQwWQu7ZyUMxbMFGU0A2yZArVxNftH+URQ4JjbEk1ZXGcq9r63Omqtv3fqORLkSBOOBUYJWh2DXVmzbbA9ou0Sgue4rYItlO7bkVhJztUX69eqeNPqvUXdXRrhPV9o47qau+lj9+AKnPXNiYYe9+q82o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pSPrXitM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pSPrXitM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C25C2BBFC;
	Fri, 26 Apr 2024 03:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714100887;
	bh=BELGro9s6coq67wanm6rVVjadQP3cbm02H243Ilc67Y=;
	h=Date:To:From:Subject:From;
	b=pSPrXitMXil8U8qsu4+tAhyQPgJ1fzKZSbMpySO8JDnP3EtYCjPqwXZCD80CQUSWz
	 ryAcP/TuG30HI0iVlR1APaDVeD7IAJX9/pEy1hOjBeYVLm/MZyjM+XtYX8bEbf/I8K
	 Dq8yHOAa0NwrB0OLV8ASqEKCZWuGuurKwHsU+YK4=
Date: Thu, 25 Apr 2024 20:08:07 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,kent.overstreet@linux.dev,keescook@chromium.org,klarasmodin@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix-3.patch removed from -mm tree
Message-Id: <20240426030807.C3C25C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memprofiling: explicitly include irqflags.h in alloc_tag.h
has been removed from the -mm tree.  Its filename was
     lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix-3.patch

This patch was dropped because it was folded into lib-add-allocation-tagging-support-for-memory-allocation-profiling.patch

------------------------------------------------------
From: Klara Modin <klarasmodin@gmail.com>
Subject: mm/memprofiling: explicitly include irqflags.h in alloc_tag.h
Date: Sun, 7 Apr 2024 15:32:52 +0200

linux/alloc_tag.h uses the macro this_cpu_inc which eventually expands to:

 #define this_cpu_generic_to_op(pcp, val, op)				\
 do {									\
 	unsigned long __flags;						\
 	raw_local_irq_save(__flags);					\
 	raw_cpu_generic_to_op(pcp, val, op);				\
 	raw_local_irq_restore(__flags);					\
 } while (0)

The macros raw_local_irq_save and raw_local_irq_restore are defined in
linux/irqflags.h which is not included implicitly on all configs.
Therefore, include it explicitly.

Link: https://lkml.kernel.org/r/20240407133252.173636-1-klarasmodin@gmail.com
Fixes: ac906a377c67 ("lib: add allocation tagging support for memory allocation profiling")
Link: https://lore.kernel.org/lkml/6b8149f3-80e6-413c-abcb-1925ecda9d8c@gmail.com/
Signed-off-by: Klara Modin <klarasmodin@gmail.com>
Acked-by: Kent Overstreet <kent.overstreet@linux.dev>
Tested-by: Kees Cook <keescook@chromium.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/alloc_tag.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/alloc_tag.h~lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix-3
+++ a/include/linux/alloc_tag.h
@@ -12,6 +12,7 @@
 #include <asm/percpu.h>
 #include <linux/cpumask.h>
 #include <linux/static_key.h>
+#include <linux/irqflags.h>
 
 struct alloc_tag_counters {
 	u64 bytes;
_

Patches currently in -mm which might be from klarasmodin@gmail.com are

lib-add-allocation-tagging-support-for-memory-allocation-profiling.patch

