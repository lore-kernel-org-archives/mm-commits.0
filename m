Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2922475CB
	for <mm-commits@vger.kernel.org>; Wed, 15 Oct 2025 21:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760563163; cv=none; b=RGWiqO9W+XhmAsA5JQ/xhg90qa147hbP4ATGk7OtFre04iO3G9cE9nfUZ8L2aJ9Y/0ka3zbiktstsrlFgEGg99T3nt8O747O0czcTWzZ6SmlapH4iOogKypCUjMDd4g+jgMtkju+XrRsm3dMxUbZ9R+1HsMk1fWVIALXzune3yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760563163; c=relaxed/simple;
	bh=+Xjgel4AvHo3oSZYxWwASQl5YQtxf3el61s6XZ/zLUs=;
	h=Date:To:From:Subject:Message-Id; b=lcYedp1cCU7erY8Yf3hV/VmJ0HbjpKxL+XjZzkQBuozMmV5KI1TctD+Kw9z/bF3OGi+qdVniSk+4TfMkPsh3TZO65IKAUfq9/RgyvvfPawsIHWVgQNMbKgCeqPmokazIvA4H1Dd3GjGZFI0/jX5EKHCgPVeJ5F83CaFY+qCKuOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rTwmaz6q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rTwmaz6q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F868C4CEF8;
	Wed, 15 Oct 2025 21:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760563163;
	bh=+Xjgel4AvHo3oSZYxWwASQl5YQtxf3el61s6XZ/zLUs=;
	h=Date:To:From:Subject:From;
	b=rTwmaz6q1a2LcwGjbpwYkQ2ZLYNHtsgebcxgB7jFoyTrStpxAEcCjlLHc7eu68j9Q
	 Fe7YmTqaZ7QobunXsUB/b0Z8YGkZiEGo7N6z60ZpHkQS8xwLOPS14E4J3TtwYNNEmq
	 Gk6cXM8jSQa/BqShc6LDnj6zBqw8dNh3iPoCLDWQ=
Date: Wed, 15 Oct 2025 14:19:22 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,rppt@kernel.org,ritesh.list@gmail.com,peterz@infradead.org,osalvador@suse.de,mingo@redhat.com,maddy@linux.ibm.com,gregkh@linuxfoundation.org,donettom@linux.ibm.com,david@redhat.com,dave.jiang@intel.com,dakr@kernel.org,christophe.leroy@csgroup.eu,aboorvad@linux.ibm.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drivers-base-node-fold-register_node-into-register_one_node-fix.patch added to mm-new branch
Message-Id: <20251015211923.0F868C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drivers-base-node-fold-register_node-into-register_one_node-fix
has been added to the -mm mm-new branch.  Its filename is
     drivers-base-node-fold-register_node-into-register_one_node-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drivers-base-node-fold-register_node-into-register_one_node-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers-base-node-fold-register_node-into-register_one_node-fix
Date: Wed Oct 15 02:17:42 PM PDT 2025

fix kerneldoc, per David

Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/node.c~drivers-base-node-fold-register_node-into-register_one_node-fix
+++ a/drivers/base/node.c
@@ -882,7 +882,7 @@ void register_memory_blocks_under_node_h
 
 /**
  * register_node - Initialize and register the node device.
- * @nid - Node number to use when creating the device.
+ * @nid: Node number to use when creating the device.
  *
  * Return: 0 on success, -errno otherwise
  */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch
mm-swap-do-not-choose-swap-device-according-to-numa-node-fix.patch
drivers-base-node-fold-register_node-into-register_one_node-fix.patch
liveupdate-kho-move-to-kernel-liveupdate-fix.patch

