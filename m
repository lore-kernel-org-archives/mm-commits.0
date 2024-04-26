Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9394C7EF0C
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104030; cv=none; b=beKEEJx4FwHdm5LegJB6CMvPtK7mDpNMPCP2lqTywiGhESh4UOh9Faf7iC2lfHkjc1dQYEjEPTUPAfraMUuJRD4BMTkaNyW48eHDrZVpt7enGdssKTeTuqdSstJFj549SKI/ofDkUfTxo+SXCyLqFEVwe2FalVX5TH+sDJbSLK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104030; c=relaxed/simple;
	bh=wmseMrYv4zPUsaQuln32YwgsVVRO2jHk8VP4vTuS4qg=;
	h=Date:To:From:Subject:Message-Id; b=MR/jKO5tA4WlqyQfCr0UyeK5R3fe9/PgobypM7l1X/NYsArC9WEJpwy5CMsxVP/BDVXTPAQeHJWIOwkFE6A38BTaksMoH/TLG+Zv+ZIJnp95nxkCQPtg0E1W+9CEMQ7FyR+PRen2WifThGh6+tBkjtKRYdsXUzTefyxh/fax3rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nrDX/i/j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nrDX/i/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691EEC113CD;
	Fri, 26 Apr 2024 04:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104030;
	bh=wmseMrYv4zPUsaQuln32YwgsVVRO2jHk8VP4vTuS4qg=;
	h=Date:To:From:Subject:From;
	b=nrDX/i/jlOhua/PrZ7UBti/1Rm0eXSAXtNu5i/fsHbubAfFP8Nf8nQJtjnZT6haOc
	 fs3Al9PPvbko3IZt7xGa1XWGtrk6Mn2j/2DTKNtWAEFt1ZrMOt421TaMcbUg27XjVl
	 g6ihzGD/gbv6ReakZIrrgXj/GoGfHVOKMmRk+XDo=
Date: Thu, 25 Apr 2024 21:00:29 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,mgorman@suse.de,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-init-remove-the-unnecessary-special-treatment-for-memory-less-node.patch removed from -mm tree
Message-Id: <20240426040030.691EEC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/init: remove the unnecessary special treatment for memory-less node
has been removed from the -mm tree.  Its filename was
     mm-init-remove-the-unnecessary-special-treatment-for-memory-less-node.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/init: remove the unnecessary special treatment for memory-less node
Date: Tue, 26 Mar 2024 14:11:28 +0800

Because memory-less node's ->node_present_pages and its zone's
->present_pages are all 0, the judgement before calling node_set_state()
to set N_MEMORY, N_HIGH_MEMORY, N_NORMAL_MEMORY for node is enough to skip
memory-less node.  The 'continue;' statement inside for_each_node() loop
of free_area_init() is gilding the lily.

Here, remove the special handling to make memory-less node share the same
code flow as normal node.

And also rephrase the code comments above the 'continue' statement
and move them above above line 'if (pgdat->node_present_pages)'.

[bhe@redhat.com: redo code comments, per Mike]
  Link: https://lkml.kernel.org/r/ZhYJAVQRYJSTKZng@MiWiFi-R3L-srv
Link: https://lkml.kernel.org/r/20240326061134.1055295-3-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |   27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

--- a/mm/mm_init.c~mm-init-remove-the-unnecessary-special-treatment-for-memory-less-node
+++ a/mm/mm_init.c
@@ -1835,28 +1835,23 @@ void __init free_area_init(unsigned long
 				panic("Cannot allocate %zuB for node %d.\n",
 				       sizeof(*pgdat), nid);
 			arch_refresh_nodedata(nid, pgdat);
-			free_area_init_node(nid);
-
-			/*
-			 * We do not want to confuse userspace by sysfs
-			 * files/directories for node without any memory
-			 * attached to it, so this node is not marked as
-			 * N_MEMORY and not marked online so that no sysfs
-			 * hierarchy will be created via register_one_node for
-			 * it. The pgdat will get fully initialized by
-			 * hotadd_init_pgdat() when memory is hotplugged into
-			 * this node.
-			 */
-			continue;
 		}
 
 		pgdat = NODE_DATA(nid);
 		free_area_init_node(nid);
 
-		/* Any memory on that node */
-		if (pgdat->node_present_pages)
+		/*
+		 * No sysfs hierarcy will be created via register_one_node()
+		 *for memory-less node because here it's not marked as N_MEMORY
+		 *and won't be set online later. The benefit is userspace
+		 *program won't be confused by sysfs files/directories of
+		 *memory-less node. The pgdat will get fully initialized by
+		 *hotadd_init_pgdat() when memory is hotplugged into this node.
+		 */
+		if (pgdat->node_present_pages) {
 			node_set_state(nid, N_MEMORY);
-		check_for_memory(pgdat);
+			check_for_memory(pgdat);
+		}
 	}
 
 	calc_nr_kernel_pages();
_

Patches currently in -mm which might be from bhe@redhat.com are

documentation-kdump-clean-up-the-outdated-description.patch
kexec-fix-the-unexpected-kexec_dprintk-macro.patch
crash-add-prefix-for-crash-dumping-messages.patch

