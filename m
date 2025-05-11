Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D997F14C5B0
	for <mm-commits@vger.kernel.org>; Sun, 11 May 2025 03:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746935365; cv=none; b=eKWEWAQQysNzE/f68qJD8FvO37rKNYehJC/vbt7/vlhZjAKtoxJ4ZiUIOE/b7wT6UOWYzr76aBSHGOD8IXDR5KLkgn/tyb2DYLgSaOOZuglbzH3lKsH03XiKb+6e0sLsMRc/POSK6UR7fRZhXhWzpcs9kdnFNPwFVvhbdgCXb/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746935365; c=relaxed/simple;
	bh=jwUwVM9UDZU9WXIR7DPjBuZ/FvDxuYUS7G47iUgZ+Xs=;
	h=Date:To:From:Subject:Message-Id; b=qCwwwz8tJRKSZpdooRQeYC/sL3axHb9DRnzvzJuCkqnB1PzPXmHBhsOycUU/jWLgVFccqzblJJxa4qMtNx3B6j9DWo0G+wBWoFKnNF7yyfTYhIaP5ovM8CSaMvLXQzoZih4KF+BPpowqcRPL4LEXkNkNy92fixiQIPlN0gNk2Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MFCOpdRm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MFCOpdRm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF54C4CEE4;
	Sun, 11 May 2025 03:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746935365;
	bh=jwUwVM9UDZU9WXIR7DPjBuZ/FvDxuYUS7G47iUgZ+Xs=;
	h=Date:To:From:Subject:From;
	b=MFCOpdRmuidffH15vnG9kVRZYNioACMA1sZZwquVNk3CZrapeXtbVntZaBWkox8Rr
	 rb5DBgxDE8Rwhfhr/7ZZ2de67YYB5N14remeb4oREaCuQmTejCBCKG/QBhKA0M+PQU
	 6MGqDCHNiF3hgnL+Ba3Czk1CClRblIUEMJg4dWbI=
Date: Sat, 10 May 2025 20:49:24 -0700
To: mm-commits@vger.kernel.org,mjguzik@gmail.com,lkp@intel.com,hch@infradead.org,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] lib-test_vmallocc-replace-rwsem-to-srcu-for-setup-fix.patch removed from -mm tree
Message-Id: <20250511034924.EDF54C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/test_vmalloc.c: fix compile error with CONFIG_TINY_RCU
has been removed from the -mm tree.  Its filename was
     lib-test_vmallocc-replace-rwsem-to-srcu-for-setup-fix.patch

This patch was dropped because it was folded into lib-test_vmallocc-replace-rwsem-to-srcu-for-setup.patch

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: lib/test_vmalloc.c: fix compile error with CONFIG_TINY_RCU
Date: Sun, 20 Apr 2025 16:20:29 +0200

When the kernel is built with CONFIG_TINY_RCU, compiling the
test_vmalloc.c fails, due to conflicting definitions like "struct
srcu_usage", etc.  between "srcutiny.h" and "srcutree.h".

It happens because of direct including the "srcutree.h" bypassing the
automatic selection mechanism.  A correct approach is to include a generic
<linux/srcu.h> which properly select SRCU implementation based on a kernel
configuration.

Fix it by replacing the "srcutree.h" include with "srcu.h".

Link: https://lkml.kernel.org/r/20250420142029.103169-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202504190717.tJHs381f-lkp@intel.com/
Cc: Baoquan He <bhe@redhat.com>
Cc: Christop Hellwig <hch@infradead.org>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_vmalloc.c~lib-test_vmallocc-replace-rwsem-to-srcu-for-setup-fix
+++ a/lib/test_vmalloc.c
@@ -15,7 +15,7 @@
 #include <linux/delay.h>
 #include <linux/mm.h>
 #include <linux/rcupdate.h>
-#include <linux/srcutree.h>
+#include <linux/srcu.h>
 #include <linux/slab.h>
 
 #define __param(type, name, init, msg)		\
_

Patches currently in -mm which might be from urezki@gmail.com are

maintainers-add-myself-as-vmalloc-co-maintainer.patch
vmalloc-add-for_each_vmap_node-helper.patch
vmalloc-switch-to-for_each_vmap_node-helper.patch
vmalloc-use-for_each_vmap_node-in-purge-vmap-area.patch
vmalloc-use-atomic_long_add_return_relaxed.patch
lib-test_vmallocc-replace-rwsem-to-srcu-for-setup.patch
lib-test_vmallocc-allow-built-in-execution.patch
maintainers-add-test_vmallocc-to-vmalloc-section.patch
vmalloc-align-nr_vmalloc_pages-and-vmap_lazy_nr.patch

