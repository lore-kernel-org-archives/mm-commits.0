Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC28620CCDC
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898272; cv=none; b=aqlxcJeyQsrJpjovaPjdORdnGMORdBycXMaQ8OeQBSvDgUQQaI+w27VoCdsmQOl2ueorof3u6/y6boUY9MczXk31GpFNde4AWOJilHN2pcro6yyy+bWYGys/mF1V37SK6vUSQwdv8h7WQut1OzfvUr9udVU+hdXmp63Z/aEcGc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898272; c=relaxed/simple;
	bh=jdfTPjw4B+8aUqQuoA+pqaF398ClUdR2EWCVJPTZJj4=;
	h=Date:To:From:Subject:Message-Id; b=uoKjk6T7ihysaliygpqpd7j/Y1kqRqwSWdOMhD868IMuOK1FsV9ukMWSOAptVvmdZLa20C/9Qv5Ugmr37vOWw8louN3HZL/id2p1AjVMeaxSA+i55nkHzFQxEwlqVE1R6WjD19ttSSjRrfr4hixxwBynTqsj7fsnOsldbREkeDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ga3ACaJW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ga3ACaJW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B65BC4CEF1;
	Sat, 31 Jan 2026 22:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898272;
	bh=jdfTPjw4B+8aUqQuoA+pqaF398ClUdR2EWCVJPTZJj4=;
	h=Date:To:From:Subject:From;
	b=ga3ACaJWOotiXnwSmJd270bPz3LtikX17jRggNFYT00ek2GIocTfiJSPQmZsVos7Q
	 w4oImgR9OoLPMkZzVueklBwIz1m2PANc0Y0JTWfkVAPqOr/hQS60wm6ZUbgwzMuL2u
	 HnL0Gdy8gaF4YhPzH38JVt3ISCIqm7bolmCXsQpU=
Date: Sat, 31 Jan 2026 14:24:32 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xuanzhuo@linux.alibaba.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,rppt@kernel.org,osalvador@suse.de,npiggin@gmail.com,mst@redhat.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jerrin.shaji-george@broadcom.com,jasowang@redhat.com,gregkh@linuxfoundation.org,eperezma@redhat.com,corbet@lwn.net,christophe.leroy@csgroup.eu,arnd@arndb.de,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-drop-inclusion-of-balloon_compactionh.patch removed from -mm tree
Message-Id: <20260131222432.9B65BC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: drop inclusion of balloon_compaction.h
has been removed from the -mm tree.  Its filename was
     mm-vmscan-drop-inclusion-of-balloon_compactionh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: mm/vmscan: drop inclusion of balloon_compaction.h
Date: Tue, 20 Jan 2026 00:01:27 +0100

Before commit b1123ea6d3b3 ("mm: balloon: use general non-lru movable page
feature"), the include was required because of isolated_balloon_page().

It's no longer required, so let's remove it.

Link: https://lkml.kernel.org/r/20260119230133.3551867-20-david@kernel.org
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Eugenio Pérez <eperezma@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jerrin Shaji George <jerrin.shaji-george@broadcom.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-drop-inclusion-of-balloon_compactionh
+++ a/mm/vmscan.c
@@ -63,7 +63,6 @@
 #include <asm/div64.h>
 
 #include <linux/swapops.h>
-#include <linux/balloon_compaction.h>
 #include <linux/sched/sysctl.h>
 
 #include "internal.h"
_

Patches currently in -mm which might be from david@kernel.org are

mm-move-pte-table-reclaim-code-to-memoryc.patch
mm-memory-handle-non-split-locks-correctly-in-zap_empty_pte_table.patch

