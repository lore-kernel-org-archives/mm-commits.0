Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA1829C343
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 21:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765918943; cv=none; b=rzLoIErwd+K1BhhduPSGjKfCuCbesEMynly3Geg4CaVv9q+1FpUbitTw4F13dSmWcV3wy9emyLZaEs+gF0UQqPYF7EW4Juy0i4ilZx8090Mu5s938ebwD+BTZvAWwuYj0Py5PXTloVaIjT6O/bKntE4elo3Bf0Ey7lRX2qHYugM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765918943; c=relaxed/simple;
	bh=2R8gaghGAvWdB3M84MLxx9DVn7pM4WXYcZpPNFdfXlI=;
	h=Date:To:From:Subject:Message-Id; b=mraMw2WXDVxgiDyx3ElFnQEoxBhc6Uu6o0BMB6r21BpYzLz/j6uimdvA3CxcWo912IBc9xPzD+c2ecwB9rZjwSGVN93eY2xmudUJPvXiNGDjoHhKrd/XMACZlnNb9V0ueGuKg6dSu3ii3uJ5c4HSz0FyFyVbOMoLs6u5AWHqyaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kHQFZZxo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kHQFZZxo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BDFDC4CEF1;
	Tue, 16 Dec 2025 21:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765918943;
	bh=2R8gaghGAvWdB3M84MLxx9DVn7pM4WXYcZpPNFdfXlI=;
	h=Date:To:From:Subject:From;
	b=kHQFZZxoa1guPyZGQjKpt+t66LaGeSf4CZnuStJoiyz7oTaooJrSlR0+dgtM2kH7e
	 4jZVfb3JnwvQp4lWWi22bbkWuxdWLojOAUXeHisa8vUp0Jo7x5iASdXcCd8ita7yfh
	 /14pmDpx27pH6fqrwIJw9RjFkILRyQvvTxsqzEdY=
Date: Tue, 16 Dec 2025 13:02:22 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,ruanjinjie@huawei.com,liam.howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-remove-struct-maple_alloc.patch added to mm-new branch
Message-Id: <20251216210223.4BDFDC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: remove struct maple_alloc
has been added to the -mm mm-new branch.  Its filename is
     maple_tree-remove-struct-maple_alloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-remove-struct-maple_alloc.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: maple_tree: remove struct maple_alloc
Date: Wed, 3 Dec 2025 22:45:11 +0000

struct maple_alloc is deprecated after the maple tree conversion to
sheaves, remove the references from the header file.

Link: https://lkml.kernel.org/r/20251203224511.469978-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |    8 --------
 1 file changed, 8 deletions(-)

--- a/include/linux/maple_tree.h~maple_tree-remove-struct-maple_alloc
+++ a/include/linux/maple_tree.h
@@ -129,13 +129,6 @@ struct maple_arange_64 {
 	struct maple_metadata meta;
 };
 
-struct maple_alloc {
-	unsigned long total;
-	unsigned char node_count;
-	unsigned int request_count;
-	struct maple_alloc *slot[MAPLE_ALLOC_SLOTS];
-};
-
 struct maple_topiary {
 	struct maple_pnode *parent;
 	struct maple_enode *next; /* Overlaps the pivot */
@@ -306,7 +299,6 @@ struct maple_node {
 		};
 		struct maple_range_64 mr64;
 		struct maple_arange_64 ma64;
-		struct maple_alloc alloc;
 	};
 };
 
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

maple_tree-remove-struct-maple_alloc.patch

