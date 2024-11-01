Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD83FBE4F
	for <mm-commits@vger.kernel.org>; Fri,  1 Nov 2024 00:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730420441; cv=none; b=iUjCZ9wueFCHekExtHPa+y64Gy9Y4+saNWB8Kj56Tifyvr6QNp3YLWeVuPg9snMkl2gQLAaMlEqma8KEUkgmVQwvcZ9rqdXKxWMac3HZ5O/WYNNL8oZsmsEzQ2OlVZkNfx1UQwUIHQ4wcci15wl18jNSkqgtXjRTtTj9djDdYjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730420441; c=relaxed/simple;
	bh=eZGmFdI4k8C0M2m/wdhwwHnuhr4DXrdmU2vvKvxuAVE=;
	h=Date:To:From:Subject:Message-Id; b=AXpufH0pgo9cQbaBqWGvPCRyzx7c71BwQf3EqpBYGiiNRRIoSXbWuHlfTZnVfJWOqI0+eVm6WrfQQE3RDKX+9fYySTSNF5eMhg11Sn6QyV8zPSp4kXUIJQtom6rwmTgSxHPTGGa/AQ8P77/nKqZMolI8ksXy4kJXQHV2yqdmQPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VwavqONQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VwavqONQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2D5C4CEC3;
	Fri,  1 Nov 2024 00:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730420440;
	bh=eZGmFdI4k8C0M2m/wdhwwHnuhr4DXrdmU2vvKvxuAVE=;
	h=Date:To:From:Subject:From;
	b=VwavqONQhvrK3sFXtykSNlc12/TMGsqeP8CoxwjCAldljgmg7Srjd1/8ticxnpPWD
	 BCLmbQp9GZbCJbQr4JnF/mqbDiohtiZg7oviiQnClgqF5MovhvtN7bfY/Ks/0j9rZt
	 Yd2M+Lyx7fB1ENvuZSB9ASKpWxjBheho5L87M5yA=
Date: Thu, 31 Oct 2024 17:20:39 -0700
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-print-empty-for-an-empty-tree-on-mt_dump.patch added to mm-unstable branch
Message-Id: <20241101002040.1E2D5C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: print empty for an empty tree on mt_dump()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-print-empty-for-an-empty-tree-on-mt_dump.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-print-empty-for-an-empty-tree-on-mt_dump.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: maple_tree: print empty for an empty tree on mt_dump()
Date: Thu, 31 Oct 2024 23:16:23 +0000

Patch series "refine storing null", v5.

When overwriting the whole range with NULL, current behavior is not
correct.


This patch (of 5):

Currently for an empty tree, it would print:

  maple_tree(0x7ffcd02c6ee0) flags 1, height 0 root (nil)
  0: (nil)

This is a little misleading.

Let's print (empty) for an empty tree.

Link: https://lkml.kernel.org/r/20241031231627.14316-1-richard.weiyang@gmail.com
Link: https://lkml.kernel.org/r/20241031231627.14316-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/lib/maple_tree.c~maple_tree-print-empty-for-an-empty-tree-on-mt_dump
+++ a/lib/maple_tree.c
@@ -7273,10 +7273,12 @@ void mt_dump(const struct maple_tree *mt
 
 	pr_info("maple_tree(" PTR_FMT ") flags %X, height %u root " PTR_FMT "\n",
 		 mt, mt->ma_flags, mt_height(mt), entry);
-	if (!xa_is_node(entry))
-		mt_dump_entry(entry, 0, 0, 0, format);
-	else if (entry)
+	if (xa_is_node(entry))
 		mt_dump_node(mt, entry, 0, mt_node_max(entry), 0, format);
+	else if (entry)
+		mt_dump_entry(entry, 0, 0, 0, format);
+	else
+		pr_info("(empty)\n");
 }
 EXPORT_SYMBOL_GPL(mt_dump);
 
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-mlock-set-the-correct-prev-on-failure.patch
maple_tree-i-is-always-less-than-or-equal-to-mas_end.patch
maple_tree-goto-complete-directly-on-a-pivot-of-0.patch
maple_tree-remove-maple_big_nodeparent.patch
maple_tree-memset-maple_big_node-as-a-whole.patch
maple_tree-root-node-could-be-handled-by-p_slot-too.patch
maple_tree-clear-request_count-for-new-allocated-one.patch
maple_tree-total-is-not-changed-for-nomem_one-case.patch
maple_tree-simplify-mas_push_node.patch
maple_tree-calculate-new_end-when-needed.patch
maple_tree-remove-sanity-check-from-mas_wr_slot_store.patch
mm-vma-the-pgoff-is-correct-if-can_merge_right.patch
maple_tree-print-empty-for-an-empty-tree-on-mt_dump.patch
maple_tree-the-return-value-of-mas_root_expand-is-not-used.patch
maple_tree-not-necessary-to-check-index-last-again.patch
maple_tree-refine-mas_store_root-on-storing-null.patch
maple_tree-add-a-test-checking-storing-null.patch

