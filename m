Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95354173
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 18:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754159884; cv=none; b=lPFMtWG8RZnFkuPJQ9S2LRRCkK5o/2G0XKQ+MF4sej9Dxt7jjwjXeES4luuw+qioog2AIar+P9gRyFwyBy9nuk2RcZ+TyU9TNKyAZMH6T+554BYz+hLbWlbkF83wJcCuNhej3qYQvUzgsWNO8Kcfk+imQJlRHhSxQmGh+kRMzEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754159884; c=relaxed/simple;
	bh=OpBWDth/kjC+AGXDWqtaizV0BTI9gnVT0Zyr1PEcGvA=;
	h=Date:To:From:Subject:Message-Id; b=a+B2sIL26ZAlf1BTKZiJr2L2Djcf2peTz7t2XOcsQgL0yc6A557PH/a+yqk5LQ2KWil81PRBeOJf4V5hxSd0dlMTz+cby9cqGXjS+g8BaZObgWgXGckbm+NZToBwFBy5MQcRNEA+f/Qc2G8s49TiO3YrWNug5szcfjApN9TbrDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Swd8tTXo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Swd8tTXo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A21C4CEEF;
	Sat,  2 Aug 2025 18:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754159884;
	bh=OpBWDth/kjC+AGXDWqtaizV0BTI9gnVT0Zyr1PEcGvA=;
	h=Date:To:From:Subject:From;
	b=Swd8tTXo0ugkbw7LOC7+QR1VnxREngo4Jmtp4PoY54Xf936cdye0MF29zRXCd54ij
	 gZKue+m8vt9TuzLcI/ha0pfm4rOH0aNmk8QUCxfqozE8pg4eDU0yntOjIamcVW1RmK
	 Gn1NpbvBtHxqBEXsjWjZzU+QuEiaLGqiPA3tqL/w=
Date: Sat, 02 Aug 2025 11:38:03 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-remove-mm-io-mappingc-fix.patch removed from -mm tree
Message-Id: <20250802183804.17A21C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-remove-mm-io-mappingc-fix
has been removed from the -mm tree.  Its filename was
     mm-remove-mm-io-mappingc-fix.patch

This patch was dropped because it was folded into mm-remove-mm-io-mappingc.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-remove-mm-io-mappingc-fix
Date: Fri Jul 25 04:14:00 PM PDT 2025

update Documentation/core-api/mm-api.rst, per Vlastimil

Cc: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/mm-api.rst |    1 -
 1 file changed, 1 deletion(-)

--- a/Documentation/core-api/mm-api.rst~mm-remove-mm-io-mappingc-fix
+++ a/Documentation/core-api/mm-api.rst
@@ -139,4 +139,3 @@ More Memory Management Functions
 .. kernel-doc:: mm/mmu_notifier.c
 .. kernel-doc:: mm/balloon_compaction.c
 .. kernel-doc:: mm/huge_memory.c
-.. kernel-doc:: mm/io-mapping.c
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-remove-mm-io-mappingc.patch
init-kconfig-restore-config_broken-help-text.patch

