Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C90E20CCDC
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898246; cv=none; b=DLnRM+gx/GR/DwMvvaHL3UmIBrEN2dcA+vexR6J0XYRUn0a9wGrGdgxPdSMcnctA5gIPDu7BF11DKdaiQYADCi8msvNwzQpM/xk4ilwJYlCS9/yiU1WoksicLwFvKfhlitHmBnrFrUSQY/lihzhhe0xA335Y99EcSj3eE6tJfZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898246; c=relaxed/simple;
	bh=SM0pSGz7VCqr0qpqiaOJAOkZihJDrVLwKmK1CyY8H3M=;
	h=Date:To:From:Subject:Message-Id; b=dhythMcQ0rMA32ccvPpmk6T5B+5Ox16q1HVoFutXLdKie3euRIjShIIu8IdKLRZ5iDAfRQyjcbHJS6CwqKdF/iB+bY+gZmQlXmB0srNM7GQSY1ZJwzW1QRA8Q4S0XIN7q/37qYPE3pKkZPGqTVCMJGztSMja0zAlShXWcztYJW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UIb86RJ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UIb86RJ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C970C4CEF1;
	Sat, 31 Jan 2026 22:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898246;
	bh=SM0pSGz7VCqr0qpqiaOJAOkZihJDrVLwKmK1CyY8H3M=;
	h=Date:To:From:Subject:From;
	b=UIb86RJ4fYi+tLusxD6ZvdQUqJk1MuqusLMbgtai44iwE0PitpHV2GkEU6qasEss/
	 +/X+rfVZIaRetrVPBSw0V/fhTjUe0psJgEA7yaVlemged4u/ZzpQKQdmh9Pmcaa/b3
	 H4+/oHOirxl5w7cQXEb0e3EtwYCEtxb3pCgIo/P4=
Date: Sat, 31 Jan 2026 14:24:05 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xuanzhuo@linux.alibaba.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,rppt@kernel.org,osalvador@suse.de,npiggin@gmail.com,mst@redhat.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jerrin.shaji-george@broadcom.com,jasowang@redhat.com,gregkh@linuxfoundation.org,eperezma@redhat.com,corbet@lwn.net,christophe.leroy@csgroup.eu,arnd@arndb.de,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-balloon_compaction-improve-comments-for-warn_on_onceb_dev_info.patch removed from -mm tree
Message-Id: <20260131222406.1C970C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/balloon_compaction: improve comments for WARN_ON_ONCE(!b_dev_info)
has been removed from the -mm tree.  Its filename was
     mm-balloon_compaction-improve-comments-for-warn_on_onceb_dev_info.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: mm/balloon_compaction: improve comments for WARN_ON_ONCE(!b_dev_info)
Date: Tue, 20 Jan 2026 00:01:12 +0100

Let's clarify a bit by extending the comments.

Link: https://lkml.kernel.org/r/20260119230133.3551867-5-david@kernel.org
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Eugenio Pérez <eperezma@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jerrin Shaji George <jerrin.shaji-george@broadcom.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michael S. Tsirkin <mst@redhat.com>
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

 mm/balloon_compaction.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/mm/balloon_compaction.c~mm-balloon_compaction-improve-comments-for-warn_on_onceb_dev_info
+++ a/mm/balloon_compaction.c
@@ -222,7 +222,11 @@ static void balloon_page_putback(struct
 	struct balloon_dev_info *b_dev_info = balloon_page_device(page);
 	unsigned long flags;
 
-	/* Isolated balloon pages cannot get deflated. */
+	/*
+	 * When we isolated the page, the page was still inflated in a balloon
+	 * device. As isolated balloon pages cannot get deflated, we still have
+	 * a balloon device here.
+	 */
 	if (WARN_ON_ONCE(!b_dev_info))
 		return;
 
@@ -241,7 +245,11 @@ static int balloon_page_migrate(struct p
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);
 
-	/* Isolated balloon pages cannot get deflated. */
+	/*
+	 * When we isolated the page, the page was still inflated in a balloon
+	 * device. As isolated balloon pages cannot get deflated, we still have
+	 * a balloon device here.
+	 */
 	if (WARN_ON_ONCE(!balloon))
 		return -EAGAIN;
 
_

Patches currently in -mm which might be from david@kernel.org are

mm-move-pte-table-reclaim-code-to-memoryc.patch
mm-memory-handle-non-split-locks-correctly-in-zap_empty_pte_table.patch

