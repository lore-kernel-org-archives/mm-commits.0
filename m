Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3503158545
	for <mm-commits@vger.kernel.org>; Fri, 18 Apr 2025 03:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945871; cv=none; b=YAcwNMVQZF3AM+siO19smR1f683Uds2ShUGNGXtQ37MKU64+kwgcebdeaxAxpZtJF3vP1Afq3pmqBlCrZNF5npxvYXPSycFLe4Fwpr8MscRhfLGs0CiB5HTODHFTVSSzrN1AzU1tRD/JeEYe9KwCL2+AOMg8OZWoAP99BJCTi44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945871; c=relaxed/simple;
	bh=XYzqahrGWGfVRZGeqnL3HLIgOkp87+YDTnMXqhFZOOI=;
	h=Date:To:From:Subject:Message-Id; b=lAACp/fjgmWM+PNHG2mdwC0ZFqdc6mJd17LPn7ZK20gblNwmYc6wFEpRB3Dyovkz3Fj9sdMg7hR3CeHk67kb+1PMBiqJcpd/Pk2OSRyjtf2vu94W2fm/fZotq88Ftuff4h5XyfMRmZRRRGIQ1Hv8YlxlDYJk1ph4ti/hekUJvrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sHp6HIyR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sHp6HIyR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F36FC4CEE4;
	Fri, 18 Apr 2025 03:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744945871;
	bh=XYzqahrGWGfVRZGeqnL3HLIgOkp87+YDTnMXqhFZOOI=;
	h=Date:To:From:Subject:From;
	b=sHp6HIyRiNEKzbc8e2Kw9czKrfNgsy405TBumQq++neInvwmXcCOX3s8YxCVXDdfh
	 a9hcrfnhGtlksBAdvPlGqdNFcEeNwj8iRFID8LXpksuAS3MX5lkkcbW2zKmII6ac5j
	 eiNooa8QWbCdIarr+8d5Oq37VJ6fVYgf7OVlHu2o=
Date: Thu, 17 Apr 2025 20:11:10 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,sj@kernel.org,rostedt@goodmis.org,lorenzo.stoakes@oracle.com,jannh@google.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-mmap-trace-events-to-memory-mapping.patch removed from -mm tree
Message-Id: <20250418031111.2F36FC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add mmap trace events to MEMORY MAPPING
has been removed from the -mm tree.  Its filename was
     maintainers-add-mmap-trace-events-to-memory-mapping.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: MAINTAINERS: add mmap trace events to MEMORY MAPPING
Date: Fri, 11 Apr 2025 13:33:28 -0400

MEMORY MAPPING does not list the mmap.h trace point file, but does list
the mmap.c file.  Couple the trace points with the users and authors of
the trace points for notifications of updates.

Link: https://lkml.kernel.org/r/20250411173328.8172-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: SeongJae Park <sj@kernel.org>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-mmap-trace-events-to-memory-mapping
+++ a/MAINTAINERS
@@ -15562,6 +15562,7 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	include/trace/events/mmap.h
 F:	mm/mlock.c
 F:	mm/mmap.c
 F:	mm/mprotect.c
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


