Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B1C204080
	for <mm-commits@vger.kernel.org>; Tue,  1 Apr 2025 22:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743545891; cv=none; b=Cxg66VJaxwIiXjUxf5cCAh5TA6NrKSm0maTGh3w1gRmsMVIZCylvjsA6YwMxm+i1Jtq2b9rExjX0t/OifYYaj/CRYHw7Gv8p45MIuYaFqpa6JnfppfhQa796H83gxdDJD4zR1mGIUiCBOKV1QGiCAEBzttwiNg6PrPjhXbiUeO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743545891; c=relaxed/simple;
	bh=kZWLh4ZcGn2iO7Asl2akjtbThscYYjECooD7fr/bNnM=;
	h=Date:To:From:Subject:Message-Id; b=Dc5Gl5NLG7cDgt48A2p69fqrFFxm6abGm4lZx/3oqF4pzWzs8l+Bqi41LXTOP5/LDVKZ3QTLWqWutjyzj3d1t200QkJWE140DyN0q+YXdbuQfYR7H+nYP+8Be96TcbtFHUGocz7j99NPqOQPE0CWqAWhreJrDjeC2Ujg64wBDi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BqN/vsWv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BqN/vsWv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E104C4CEE4;
	Tue,  1 Apr 2025 22:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743545890;
	bh=kZWLh4ZcGn2iO7Asl2akjtbThscYYjECooD7fr/bNnM=;
	h=Date:To:From:Subject:From;
	b=BqN/vsWvkeaYs5LmxBC7WdZluvBZEH4UmsDf5ITfXO6HaLgk4QnnXYkhA5XXpvvZg
	 TWLRuCSfGI7AsdG377lqDVAHRJ3O08nzODYTytAAz4MNL0B+SQQ8qraaXF00TgiwYD
	 /uCMoD0v8MjL5rexdozOBLVRTeparnJafJZrFux0=
Date: Tue, 01 Apr 2025 15:18:09 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,peterx@redhat.com,osalvador@suse.de,mhocko@suse.com,dan.j.williams@intel.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-mm-add-entry-for-secretmem.patch removed from -mm tree
Message-Id: <20250401221810.3E104C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: mm: add entry for secretmem
has been removed from the -mm tree.  Its filename was
     maintainers-mm-add-entry-for-secretmem.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: MAINTAINERS: mm: add entry for secretmem
Date: Wed, 26 Mar 2025 23:55:41 +0200

Link: https://lkml.kernel.org/r/20250326215541.1809379-5-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Willaims <dan.j.williams@intel.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/MAINTAINERS~maintainers-mm-add-entry-for-secretmem
+++ a/MAINTAINERS
@@ -15515,6 +15515,14 @@ F:	mm/numa.c
 F:	mm/numa_emulation.c
 F:	mm/numa_memblks.c
 
+MEMORY MANAGEMENT - SECRETMEM
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	Mike Rapoport <rppt@kernel.org>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	include/linux/secretmem.h
+F:	mm/secretmem.c
+
 MEMORY MANAGEMENT - USERFAULTFD
 M:	Andrew Morton <akpm@linux-foundation.org>
 R:	Peter Xu <peterx@redhat.com>
_

Patches currently in -mm which might be from rppt@kernel.org are


