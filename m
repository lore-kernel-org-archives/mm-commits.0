Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0298C13B
	for <mm-commits@vger.kernel.org>; Sun, 20 Apr 2025 20:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745181020; cv=none; b=iqIhgGHsSuhOkJ53/gcBi4rnw2E/Sx2COM8D10AmJjpEE0+pmbXcxxLfXfmXTfNAy6nxrYWGVcnNm29kv8bHwRW0HGEz6lcXe1303Tv5pjpNMt7vibHClbc3xB2hASKnzOsq3IWfGiuyEwNb1o0kqHo6bylb6eO8brRxIPoEAfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745181020; c=relaxed/simple;
	bh=DPFpUAYlm41KEIBZKxGgE971qNAFnDmnIBMn32dHb3w=;
	h=Date:To:From:Subject:Message-Id; b=nyheupsRxxsjax/nC4ye4KZkOZiOvrAIXtGQ+9XSB+icD4loDfhg63d6fNPVruD+ra1JQm2Mbs9t32dVutOQNCrei2Z1OObNcKV/1zYOzeR3r1X8KzLeU8/lNzdJkCrW234miku8tEgDZqkqU+/MJn1tv2xb+mgwKufG8Ei2xqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NdKESztB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NdKESztB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6618C4CEED;
	Sun, 20 Apr 2025 20:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745181019;
	bh=DPFpUAYlm41KEIBZKxGgE971qNAFnDmnIBMn32dHb3w=;
	h=Date:To:From:Subject:From;
	b=NdKESztBNDAwk5mWmaJPgrumZoyhw+B5ohuSrDHxfTvjeYkaw6aKI22dw/rygoI5T
	 elqBAnhHPBcakL5B9+bjpRZvCs6Z1twyA6VKLNzBwj731xHqfheO5T5ogJdKBuRvif
	 ggeabnQDuG73g9QrxNZRmnWfxhO6eeFoeogXBJSY=
Date: Sun, 20 Apr 2025 13:30:18 -0700
To: mm-commits@vger.kernel.org,mjguzik@gmail.com,lkp@intel.com,hch@infradead.org,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_vmallocc-replace-rwsem-to-srcu-for-setup-fix.patch added to mm-unstable branch
Message-Id: <20250420203018.E6618C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_vmalloc.c: fix compile error with CONFIG_TINY_RCU
has been added to the -mm mm-unstable branch.  Its filename is
     lib-test_vmallocc-replace-rwsem-to-srcu-for-setup-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_vmallocc-replace-rwsem-to-srcu-for-setup-fix.patch

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

vmalloc-add-for_each_vmap_node-helper.patch
vmalloc-switch-to-for_each_vmap_node-helper.patch
vmalloc-use-for_each_vmap_node-in-purge-vmap-area.patch
vmalloc-use-atomic_long_add_return_relaxed.patch
lib-test_vmallocc-replace-rwsem-to-srcu-for-setup.patch
lib-test_vmallocc-replace-rwsem-to-srcu-for-setup-fix.patch
lib-test_vmallocc-allow-built-in-execution.patch
maintainers-add-test_vmallocc-to-vmalloc-section.patch
vmalloc-align-nr_vmalloc_pages-and-vmap_lazy_nr.patch

