Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBC01F460B
	for <mm-commits@vger.kernel.org>; Sat, 16 Aug 2025 05:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755323811; cv=none; b=oGgw9BM5JoK59Tv32+vT0vNxIqPCqyDgczOm+dMsVH1wJE0dpiW0lRD2Q2AHkBKP1WA2gIL1IHbqF/arZLWHbYGU+wjG2RIOGMrGHjiLv90HQ4/3KoXk948gWKwI+TW+aySruXp6m9LmsJRKZ2XXGSldSDYAqRCSiJ2sUavnHLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755323811; c=relaxed/simple;
	bh=qdyJkydV6zrGyvehEPmulkqsOutYq6ZKWvRRAKwQqiM=;
	h=Date:To:From:Subject:Message-Id; b=eeDdQKHAiB47N2dOjJiGcpqnBtYQ9zGuaHpMSmW7X9c7lUA5JalNSfwai+geeqWI/AUjIahiCHrL3uJUy4f59dS2an6vBqid83NNboqPbFuFvXXLQG3l5KyDaqAObJFbeR9W6ToJee5PziY0U8IG8JpgP1+AM8SWEUSEIZ6Ilm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=feZRkFFA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="feZRkFFA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA360C4CEEF;
	Sat, 16 Aug 2025 05:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755323810;
	bh=qdyJkydV6zrGyvehEPmulkqsOutYq6ZKWvRRAKwQqiM=;
	h=Date:To:From:Subject:From;
	b=feZRkFFAjYnLjYi9zHmyPKEuLNqkn+6rBWKgetB43mZYQccRl+5fqWLYbuhIkC9rx
	 KIObzrYEgQvEoZ+BWaVjYplG7ZvS7MaLn0k5IS60oaEkckHnqvIoKqPwYWMjHzEi+5
	 AMmmM2HjPf48XeO5q2WgExjRtbs/FXKlNaC8NfEU=
Date: Fri, 15 Aug 2025 22:56:50 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,sidhartha.kumar@oracle.com,liam.howlett@oracle.com,pfalcato@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] testing-radix-tree-maple-hack-around-kfree_rcu-not-existing.patch removed from -mm tree
Message-Id: <20250816055650.CA360C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: testing/radix-tree/maple: hack around kfree_rcu not existing
has been removed from the -mm tree.  Its filename was
     testing-radix-tree-maple-hack-around-kfree_rcu-not-existing.patch

This patch was dropped because it is obsolete

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


