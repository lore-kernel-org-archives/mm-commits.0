Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5B542AB5
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 01:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724808911; cv=none; b=HwPVbfhC5wH6Vyi1EB5Hgo8yQ3vXVsAZ44gFduOymgijcUS+4DTFEUF/Ku8LMGst1YS/8di610JXbc+DnSAwKPaIzrdV+zYrEwC/qM1eG/97uJnr9jKuebW1pOryAo9MJ2iUGulsMPsFTv+Tw3ji6yllfd/GO/XZpwl88nNZbTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724808911; c=relaxed/simple;
	bh=8eCOXj/mcxRl7SuTPJKhZJ159hrvyyC8nBzIigbym0Q=;
	h=Date:To:From:Subject:Message-Id; b=JZP9KrlFLMLp+tv4+V5QzyFcrWNSI2oJ2h7+Hq27BXOJfo1BTDM9Esi7bs0CVggBo6VFFV7vw9CT0LyO8kyRYAR5fMhZi2rHaNjA+oAOCwxkCGcbI8LVpdxvmuO3xo5BFkLPQ1cXw1BkoI4Wpb14W7L+yk19WCzvA5qw0P4aNLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TQoMyxdS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TQoMyxdS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00037C32782;
	Wed, 28 Aug 2024 01:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724808911;
	bh=8eCOXj/mcxRl7SuTPJKhZJ159hrvyyC8nBzIigbym0Q=;
	h=Date:To:From:Subject:From;
	b=TQoMyxdS3WPp3gM0K6+opKqnGpZNUU6Yib0c+Xq8LEcBy4pcTOajGnGuvAdoD2w+G
	 7dwBruzaeLurVJjnZ3E5/2VnBHzgP8YO6d9LlHX49RKV3vm1twb7UT02mF4i3pkcsk
	 zmbJuEqfqqLKiKff1eStjZNZUT3YdL+NaPkK5aN8=
Date: Tue, 27 Aug 2024 18:35:10 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,Liam.Howlett@oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-arange64-node-is-not-a-leaf-node.patch added to mm-unstable branch
Message-Id: <20240828013511.00037C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: arange64 node is not a leaf node
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-arange64-node-is-not-a-leaf-node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-arange64-node-is-not-a-leaf-node.patch

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
Subject: maple_tree: arange64 node is not a leaf node
Date: Mon, 26 Aug 2024 01:24:21 +0000

mt_dump_arange64() only applies to an entry whose type is maple_arange_64,
in which mte_is_leaf() must return false.

Since mte_is_leaf() here is always false, we can remove this condition
check.

Link: https://lkml.kernel.org/r/20240826012422.29935-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/lib/maple_tree.c~maple_tree-arange64-node-is-not-a-leaf-node
+++ a/lib/maple_tree.c
@@ -7203,7 +7203,6 @@ static void mt_dump_arange64(const struc
 	enum mt_dump_format format)
 {
 	struct maple_arange_64 *node = &mte_to_node(entry)->ma64;
-	bool leaf = mte_is_leaf(entry);
 	unsigned long first = min;
 	int i;
 
@@ -7237,10 +7236,7 @@ static void mt_dump_arange64(const struc
 			break;
 		if (last == 0 && i > 0)
 			break;
-		if (leaf)
-			mt_dump_entry(mt_slot(mt, node->slot, i),
-					first, last, depth + 1, format);
-		else if (node->slot[i])
+		if (node->slot[i])
 			mt_dump_node(mt, mt_slot(mt, node->slot, i),
 					first, last, depth + 1, format);
 
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-improve-code-consistency-with-zonelist_-helper-functions.patch
mm-memory_hotplug-get-rid-of-__ref.patch
maple_tree-fix-comment-typo-of-ma_root.patch
maple_tree-fix-comment-typo-with-corresponding-maple_status.patch
maple_tree-arange64-node-is-not-a-leaf-node.patch
maple_tree-dump-error-message-based-on-format.patch

