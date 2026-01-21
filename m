Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C4127FB28
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966089; cv=none; b=U5q9Y7WszrWOMgK0CSqsCldDGyLzap/j7MA746xy6Qwii6XZjJsFsm0+mLKpAq52YijgVWINFDUX+An7ecSQ/88CmNaB93a6O+vXl71MdZBlqUuVYh5CP04BFo4mCUzOEANfG6TlqzzaxHjq0UJJ+OUpD8x5HYiDEiGezj/IJUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966089; c=relaxed/simple;
	bh=Wmk52M204kvmxhCzUE7Z37yUQdWGx8VCh/KIhY1Y+EI=;
	h=Date:To:From:Subject:Message-Id; b=c+rZXdvcl7MP+3xpl2iZnhEps6tRWj+HLzZy6uACH/7KEwSVPJQJ0ZiUo959eW0Q0QYHlGJ3ZTgyQJQGcofVm/BuWIi+CE6ed6QxrQPn03a9r8cYamwooKba2gQTYH8eTf1MzTYfq44sFHppVuRLL8jVXWUqABdoatcSNFIJ0nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w73z7r0c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w73z7r0c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E1BC16AAE;
	Wed, 21 Jan 2026 03:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966089;
	bh=Wmk52M204kvmxhCzUE7Z37yUQdWGx8VCh/KIhY1Y+EI=;
	h=Date:To:From:Subject:From;
	b=w73z7r0cw/YS+edzAAH0VzC6tCxWes2DB2r8gU7z8TXAQv/s7thmb//DYIT6yLSnQ
	 qiJT5ucZatvf6d3lwFdlOZLTDX6S7baK0ZvLRi3k8zATaRPT5nF66As76H16yKVbjv
	 TpbhDmN+kA+MXDGZFLD3EIsyH4tUiH5xlreyY/F0=
Date: Tue, 20 Jan 2026 19:28:08 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,ruanjinjie@huawei.com,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-remove-struct-maple_alloc.patch removed from -mm tree
Message-Id: <20260121032809.02E1BC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: remove struct maple_alloc
has been removed from the -mm tree.  Its filename was
     maple_tree-remove-struct-maple_alloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: maple_tree: remove struct maple_alloc
Date: Wed, 3 Dec 2025 22:45:11 +0000

struct maple_alloc is deprecated after the maple tree conversion to
sheaves, remove the references from the header file.

Link: https://lkml.kernel.org/r/20251203224511.469978-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
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


