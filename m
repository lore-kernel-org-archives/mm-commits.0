Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644B73B14C3
	for <mm-commits@vger.kernel.org>; Wed,  2 Sep 2026 22:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788389185; cv=none; b=YpBxRX+XvtXHMuwV0ctqQ5I0u059kgXKC71rKyLSC9fqF0/XRJcFuTF/ESINOBpUtH/VUcO1ibrdPEIxjitxLDHdX2medKxlsW2GPLA6K3XRahR6jRgJdQ8+gUaJb0LY46ljpVznb8/S37hpiqFkMCiv8zKd1v81D+HICNdL89g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788389185; c=relaxed/simple;
	bh=8sh1l/Ym7pf7KWdBKMhv/ht/+RuddgT7A5TcWTbTyh0=;
	h=Date:To:From:Subject:Message-Id; b=oNeLXAgWYJWNx7vV3Cix6WmjsSiMyrnmbaeDzVMSfO556ziAX2EdV8XyZZoUii2VJmPXS5qN35tfn/vIw1cxpIzjuzo8Em9OV8OLvJS1W/CQrfkyqcCVARi/1ZkQF0cvlNzhUgBGZC5m8dBWHqkw0RP5DxxinqxVgVJvvXbFSuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dsrkxxOv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dsrkxxOv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB311F000E9;
	Wed,  2 Sep 2026 22:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788389173;
	bh=dfmtfdyqurJVFivpdPbiGMFtoNzNw95xbK9mwHxWeHc=;
	h=Date:To:From:Subject;
	b=dsrkxxOvkKOUvTmkMORWqGBnZCR1GWB3Eb2wLTYoSD3jOu08yQrgQCs9P7lSwGtmq
	 fXd7btZsRHOOFNFFQzpw62bENjb16/1EkR/611DkGltVX6VZmKp0SxwCwAXvEKVDoR
	 BGRubsYUDPpQSTZE7cMNtyeTMPh4A/YJngMkLD6M=
Date: Wed, 02 Sep 2026 15:46:13 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,seanjc@google.com,hughd@google.com,fuad.tabba@linux.dev,david@kernel.org,binbin.wu@linux.intel.com,ackerleytng@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-folio-export_symbol_for_kvmlru_cache_drain_for_folio.patch added to mm-hotfixes-unstable branch
Message-Id: <20260902224613.7DB311F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/folio: EXPORT_SYMBOL_FOR_KVM(lru_cache_drain_for_folio)
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-folio-export_symbol_for_kvmlru_cache_drain_for_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-folio-export_symbol_for_kvmlru_cache_drain_for_folio.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Ackerley Tng <ackerleytng@google.com>
Subject: mm/folio: EXPORT_SYMBOL_FOR_KVM(lru_cache_drain_for_folio)
Date: Tue, 1 Sep 2026 20:38:40 -0700 (PDT)

To simplify independent development in the KVM and MM subsystems, now
export to KVM the lru_cache_drain_for_folio() which MM added in 7.3-rc1.

Link: https://lore.kernel.org/lkml/bd6c9c74-e374-a9d3-ba1f-8b6f430894fc@google.com/T/#u
Link: https://lore.kernel.org/02876cea-5727-2ca4-bead-73659ea6fec4@google.com
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Suggested-by: David Hildenbrand <david@kernel.org>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/folio.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/folio.c~mm-folio-export_symbol_for_kvmlru_cache_drain_for_folio
+++ a/mm/folio.c
@@ -33,6 +33,7 @@
 #include <linux/page_idle.h>
 #include <linux/local_lock.h>
 #include <linux/buffer_head.h>
+#include <linux/kvm_types.h>
 
 #include "internal.h"
 #include "page_alloc.h"
@@ -926,6 +927,7 @@ void lru_cache_drain_for_folio(const str
 			*drained = LRU_CACHE_DRAINED_ALL;
 	}
 }
+EXPORT_SYMBOL_FOR_KVM(lru_cache_drain_for_folio);
 
 atomic_t lru_disable_count = ATOMIC_INIT(0);
 
_

Patches currently in -mm which might be from ackerleytng@google.com are

mm-folio-export_symbol_for_kvmlru_cache_drain_for_folio.patch
mm-hugetlb-return-enospc-on-memcg-charge-failure.patch
mm-hugetlb-drop-refcount-before-freeing-on-memcg-charge-failure.patch

