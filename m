Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3C120CCDC
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898257; cv=none; b=e9tQnX9OKlL3dO2llWlBPYjLU1NGdmZgnc1+AO53SPm/Wk6UwzGl8obCkmyYyuA0OD/vYF6/8l3ZARKvJWd0rscg02c+RSA/gHIS5V581VoJEC7lPP+ibCqStpoKEi1AFe1fdn79UTBjhnDncgWj0lwDozeduRhq4w8hENfUKpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898257; c=relaxed/simple;
	bh=fk1azaDI46roAXR8IPOzPPqNrUGV0qx1Vqvpg/HkLk0=;
	h=Date:To:From:Subject:Message-Id; b=hYTGwHnzhTNO1Cv2NQmZ4mu7KD7P3EJRGrnC5U7kEwVY+l3REKKi4WI9aEe3pswJoJffBlR+p0C+7hvIGnivStODJyLRwi7GV/xnmABPY0m4R9DKvu2PuxlYC7Fax/AzBy/1OHk/+G43zfesqmTMdV230pUVKhwwKCRhi/ffBoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MOHl8i25; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MOHl8i25"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2750C4CEF1;
	Sat, 31 Jan 2026 22:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898257;
	bh=fk1azaDI46roAXR8IPOzPPqNrUGV0qx1Vqvpg/HkLk0=;
	h=Date:To:From:Subject:From;
	b=MOHl8i25GXUI8z9yMCYlJOWC9vtTr25CBBPX6H1y5hWWqrzk5RfGm2gIPa37+UvcK
	 uiJclqOWRSLRV/lbo+/1S1wVzAvfeZ3JHMR4N12JhfufjlE5B4kfksqFZE57MyERg3
	 RHyO1UDK1EaEuJ9FUOyVk2CT0JNrNfAhUsQd2Pes=
Date: Sat, 31 Jan 2026 14:24:17 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xuanzhuo@linux.alibaba.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,rppt@kernel.org,osalvador@suse.de,npiggin@gmail.com,mst@redhat.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jerrin.shaji-george@broadcom.com,jasowang@redhat.com,gregkh@linuxfoundation.org,eperezma@redhat.com,corbet@lwn.net,christophe.leroy@csgroup.eu,arnd@arndb.de,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-balloon_compaction-drop-fsh-include-from-balloon_compactionh.patch removed from -mm tree
Message-Id: <20260131222417.B2750C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/balloon_compaction: drop fs.h include from balloon_compaction.h
has been removed from the -mm tree.  Its filename was
     mm-balloon_compaction-drop-fsh-include-from-balloon_compactionh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: mm/balloon_compaction: drop fs.h include from balloon_compaction.h
Date: Tue, 20 Jan 2026 00:01:19 +0100

Ever since commit 68f2736a8583 ("mm: Convert all PageMovable users to
movable_operations") we no longer store an inode in balloon_dev_info, so
we can stop including "fs.h".

Link: https://lkml.kernel.org/r/20260119230133.3551867-12-david@kernel.org
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

 include/linux/balloon_compaction.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/balloon_compaction.h~mm-balloon_compaction-drop-fsh-include-from-balloon_compactionh
+++ a/include/linux/balloon_compaction.h
@@ -42,7 +42,6 @@
 #include <linux/migrate.h>
 #include <linux/gfp.h>
 #include <linux/err.h>
-#include <linux/fs.h>
 #include <linux/list.h>
 
 /*
_

Patches currently in -mm which might be from david@kernel.org are

mm-move-pte-table-reclaim-code-to-memoryc.patch
mm-memory-handle-non-split-locks-correctly-in-zap_empty_pte_table.patch

