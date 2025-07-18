Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72745C2C9
	for <mm-commits@vger.kernel.org>; Fri, 18 Jul 2025 21:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752873344; cv=none; b=vAZ8GHq3Nmabyrjx79XuZ7l917uDOUlw+wXNKAuCAyNdyxPlMMZzocE+LjsdQxIo32m+6LhaNYJIZbtZcrypBj9yCHtS1hy5GAAnRIBXcJq10pwqcK7WVplLyL/2CyK1Nc/ZHu23vV/Ky45XEbHci5Ik6Ujv1Qz0padoxc11rew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752873344; c=relaxed/simple;
	bh=37q1OYO7dyv0M/96MW6NRndNnKZqaDCrKgpGfq5l/B8=;
	h=Date:To:From:Subject:Message-Id; b=cVR5CwF3lsyaCUDIwkMrxx0+/I+MSipzPH14pQd5M7kUuICNJz/rxQ2+xVRevysYbfJKA5RD2WjOsmO7QDBpH8B8EOtHVOjNTWYbJ2cCBswiyR8AcpFYU83tzX+gwu6Q/oV0PDBxS9w8xCB3DVGs/cxE4EKbSCgls5xjufxMCNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OpZ43ey0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OpZ43ey0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61A8C4CEF0;
	Fri, 18 Jul 2025 21:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752873343;
	bh=37q1OYO7dyv0M/96MW6NRndNnKZqaDCrKgpGfq5l/B8=;
	h=Date:To:From:Subject:From;
	b=OpZ43ey0+6EVYC5bSMAw2azHJPzjT/L8z8rDAqRTySHcJG1V1kpozzEigfuYKZZpS
	 NKJ2lChh6Qk2MZPTJ4lVyWzV/ufsPs2cJboSkuHzOT8rEh4cKWOffq83CLPHF7vSTR
	 do+L5sFiTe8Ty93hxeWdH6t6a+F1XMzTx4YeS7Qw=
Date: Fri, 18 Jul 2025 14:15:43 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,sidhartha.kumar@oracle.com,liam.howlett@oracle.com,pfalcato@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + testing-radix-tree-maple-hack-around-kfree_rcu-not-existing.patch added to mm-new branch
Message-Id: <20250718211543.D61A8C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: testing/radix-tree/maple: hack around kfree_rcu not existing
has been added to the -mm mm-new branch.  Its filename is
     testing-radix-tree-maple-hack-around-kfree_rcu-not-existing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/testing-radix-tree-maple-hack-around-kfree_rcu-not-existing.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Pedro Falcato <pfalcato@suse.de>
Subject: testing/radix-tree/maple: hack around kfree_rcu not existing
Date: Fri, 18 Jul 2025 18:21:37 +0100

liburcu doesn't have kfree_rcu (or anything similar).  Despite that, we
can hack around it in a trivial fashion, by adding a wrapper.

This wrapper only works for maple_nodes, and not anything else (due to us
not being able to know rcu_head offsets in any way), and thus we take
advantage of the type checking to avoid future silent breakage.

Link: https://lkml.kernel.org/r/20250718172138.103116-2-pfalcato@suse.de
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/maple.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/tools/testing/radix-tree/maple.c~testing-radix-tree-maple-hack-around-kfree_rcu-not-existing
+++ a/tools/testing/radix-tree/maple.c
@@ -23,6 +23,23 @@
 #define MODULE_LICENSE(x)
 #define dump_stack()	assert(0)
 
+
+#include <linux/maple_tree.h>
+
+static void free_node(struct rcu_head *head)
+{
+	struct maple_node *node = container_of(head, struct maple_node, rcu);
+
+	free(node);
+}
+
+static void kfree_rcu_node(struct maple_node *node)
+{
+	call_rcu(&node->rcu, free_node);
+}
+
+#define kfree_rcu(ptr, memb) kfree_rcu_node(ptr)
+
 #include "../../../lib/maple_tree.c"
 #include "../../../lib/test_maple_tree.c"
 
_

Patches currently in -mm which might be from pfalcato@suse.de are

maple_tree-use-kfree_rcu-in-ma_free_rcu.patch
testing-radix-tree-maple-hack-around-kfree_rcu-not-existing.patch

