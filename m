Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BCDC23D7F0
	for <mm-commits@vger.kernel.org>; Wed,  9 Sep 2026 06:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788935330; cv=none; b=h1J5umNeTDU+H46pnI3R2dNHRXUi1+lH/7togCI7La/TQPp9PVQvaw+UDGtzOKocbYDsntyOVYc5Oz7qJcaMNpoDQovd0h0KDrKaVaGp27jrmHOyOlyKrtCD9MscnuJByze9n3WuNLgWiz7tDDUmBVA/oHL0QIcOh9ilERQwxyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788935330; c=relaxed/simple;
	bh=EI/z5UAGo6SadBhvk1RZAbH/kPI7ewf1Cynk2HLO5Qc=;
	h=Date:To:From:Subject:Message-Id; b=HdQIURdjWmf73ZIE2sjVyw3Y7JMQUXTGopUC0R7O4Ip9U7MQQPjVrz2Y7ediz/Ohjy3xz6d0TSSmFrltXgN/H1emX1y1HZrvrcTKTvR15gk9kdHqvCOLeW7Ba7TbrY0Q3E50EToTOC36UYOw/lSY/R+hE/9RljBvLrZOJUK5VUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UWrZQyOS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UWrZQyOS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CFC71F00A3A;
	Wed,  9 Sep 2026 06:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788935329;
	bh=HWsjbNuzBDQqbi1AgnSOiNnCVWnFG6os2VDBHSBM404=;
	h=Date:To:From:Subject;
	b=UWrZQyOSEWjfv0k4+U8n7w8QjlxMgcELiw9QhGtlcJtXTgMC8HzJJbOOSSVMJtwiF
	 QhflovrhhAKWWoEkaNUium1CBzA+0LXRxOFgH3eOkAXDCi8JDz3vdWcbCy7VHTUWr4
	 2JiC/NqTp6e1AYGFgAZ+kP5lXExgO6LKbLJ8hYIg=
Date: Tue, 08 Sep 2026 23:28:48 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@kernel.org,seanjc@google.com,hughd@google.com,fuad.tabba@linux.dev,david@kernel.org,binbin.wu@linux.intel.com,ackerleytng@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-folio-export_symbol_for_kvmlru_cache_drain_for_folio.patch removed from -mm tree
Message-Id: <20260909062849.0CFC71F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/folio: EXPORT_SYMBOL_FOR_KVM(lru_cache_drain_for_folio)
has been removed from the -mm tree.  Its filename was
     mm-folio-export_symbol_for_kvmlru_cache_drain_for_folio.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-hugetlb-return-enospc-on-memcg-charge-failure.patch
mm-hugetlb-drop-refcount-before-freeing-on-memcg-charge-failure.patch

