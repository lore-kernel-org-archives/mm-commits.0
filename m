Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B84C145B27
	for <mm-commits@vger.kernel.org>; Wed, 11 Jun 2025 01:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749606980; cv=none; b=NuUJr0hjG2y+bcezK/o+OFKfvWZwJkdhArxevfKC84TiwplbtkAkFtjPpjsoPTOsw2G/N0mU5pvshJeqi0TRJxtasAojwvyIQ6BgDrqSCPSWKgaT1W7Cozmy18rsAddj99fNztEsEIqZJ8jX7eAnvXoh3+CdGQoikxsuC/1XVfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749606980; c=relaxed/simple;
	bh=Byh6BfhJk+/Z5fGbZ+g0r0ZIbxJ3DosRFwZawT9mp5Q=;
	h=Date:To:From:Subject:Message-Id; b=u3GQVappAPOwXQEDWW8VuOzg3QvG20dh9UId+85BwMU+/xG69cirrD73dSgWkjbZTqdwN4TmoTKozgjgUC2SQZ+Y5b+TIxLPSIF/pTvoUlTMPu/D+blSD/jGD8gcPYgt+ICxmkIg+IIlBSqJH+QepQ6tWr5gTDyHABnZ/xPGGPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2F5OBWPJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2F5OBWPJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866F7C4CEED;
	Wed, 11 Jun 2025 01:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749606976;
	bh=Byh6BfhJk+/Z5fGbZ+g0r0ZIbxJ3DosRFwZawT9mp5Q=;
	h=Date:To:From:Subject:From;
	b=2F5OBWPJdI7PFJbJgmYh+CN3mQJtdX8qjudCdjM+NVWk0Fh64nYcWr5cXFjvNB0Na
	 SQwtlrb6sTRH1JhAEOPbeREEJ18hXYDWws7z8CtHY/9uDVpAvuQU0Gbzba78XnhY9E
	 DReM3HorutBvHTJhZnkGPpesubrMFiGVe46+eJ4w=
Date: Tue, 10 Jun 2025 18:56:15 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-assert-retrieving-new-value-on-a-tree-containing-just-a-leaf-node.patch added to mm-new branch
Message-Id: <20250611015616.866F7C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: assert retrieving new value on a tree containing just a leaf node
has been added to the -mm mm-new branch.  Its filename is
     maple_tree-assert-retrieving-new-value-on-a-tree-containing-just-a-leaf-node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-assert-retrieving-new-value-on-a-tree-containing-just-a-leaf-node.patch

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: maple_tree: assert retrieving new value on a tree containing just a leaf node
Date: Wed, 11 Jun 2025 01:12:53 +0000

Original code may not get the new value after overwriting the whole range
on a maple tree containing just a leaf node.  The reason is we didn't set
the only root node dead during destroy.

Add a test case to ensure the new value is returned when overwriting a
tree containing just a leaf node.

Link: https://lkml.kernel.org/r/20250611011253.19515-4-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/maple.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/tools/testing/radix-tree/maple.c~maple_tree-assert-retrieving-new-value-on-a-tree-containing-just-a-leaf-node
+++ a/tools/testing/radix-tree/maple.c
@@ -35256,6 +35256,30 @@ static noinline void __init check_rcu_si
 	MT_BUG_ON(mt, mas_prev(&mas_reader, 0) != xa_mk_value(val));
 	rcu_read_unlock();
 
+	/* Clear out tree & create one with only root node */
+	mas_lock(&mas_writer);
+	mas_set_range(&mas_writer, 0, ULONG_MAX);
+	mas_store_gfp(&mas_writer, NULL, GFP_KERNEL);
+	mas_set_range(&mas_writer, 0, 0);
+	for (i = 0; i <= 5; i++) {
+		mas_writer.index = i * 10;
+		mas_writer.last = i * 10 + 5;
+		mas_store_gfp(&mas_writer, xa_mk_value(i), GFP_KERNEL);
+	}
+	mas_unlock(&mas_writer);
+	target = 10;
+	mas_set_range(&mas_reader, target, target);
+	rcu_read_lock();
+	MT_BUG_ON(mt, mas_walk(&mas_reader) != xa_mk_value(target/10));
+
+	/* Overwrite the whole range */
+	mas_lock(&mas_writer);
+	mas_set_range(&mas_writer, 0, ULONG_MAX);
+	mas_store_gfp(&mas_writer, xa_mk_value(val), GFP_KERNEL);
+	mas_unlock(&mas_writer);
+	MT_BUG_ON(mt, mas_walk(&mas_reader) != xa_mk_value(val));
+	rcu_read_unlock();
+
 	rcu_unregister_thread();
 }
 
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

maple_tree-fix-mt_destroy_walk-on-root-leaf-node.patch
maple_tree-restart-walk-on-correct-status.patch
maple_tree-assert-retrieving-new-value-on-a-tree-containing-just-a-leaf-node.patch

