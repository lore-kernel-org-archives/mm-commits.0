Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F815399342
	for <mm-commits@vger.kernel.org>; Sat, 10 Oct 2026 22:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791672088; cv=none; b=Q5lbE5ChB0l+3BSufWXDflC4Qkma2NZTmxwDaVKc3JyIs9JdVL/GqFC6qFbiOnJPXqSOcWjX9/NnCgM9B5F4C980TNi4X2BbFqc4ExrBU+6Dg8jn5/Sgbux0x1ludlcpVXTVf4DGJbebFbRcc8lsK5t0jekZdylhYK2ag9xR1j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791672088; c=relaxed/simple;
	bh=fLEmylSTc8AE582kpgAPMRlaQ4hW/8LBlkrW+fv+g7Q=;
	h=Date:To:From:Subject:Message-Id; b=uIF9WBubFGRirjo5FU5iCtWToYVeKVFMvbtuzUy2AdwaGNfgo9+bW6yTAzN153TAxTOj9Y+tHXDUSoPVNcqJDEMkUKfMyXZPlM/cuoWNaoaPtHhqqFXtcQHf6dl89fRf3fjPhR58ZpLE6rMlzX9nmMdr4XMFq4KDBQVyO6xsnRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OwxVIoON; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OwxVIoON"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A951F000FF;
	Sat, 10 Oct 2026 22:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791672085;
	bh=0ViEeBPr/rUKhzuCRV1cqfxV5WBBLdt4MMrJCWHeW9s=;
	h=Date:To:From:Subject;
	b=OwxVIoON8Fjmarrsb9PVyji9nM8yEl9xLT8ZeDn5Q3iDknqtiO1RwDtOzmUlNcaSI
	 n+52XMTjJeeggwl7B98IAgmVeUFGC68Ed8b8EZs+RHHefaDVFVRud1sxiROiisw1uW
	 3t8YpXkieY+IRVP/oIZQI/0s+Umk6Oby0brzkYag=
Date: Sat, 10 Oct 2026 15:41:25 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,enze.li@gmx.com,david@kernel.org,lienze@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-move-hugetlb_sysfs_initialized-into-hugetlb_register_all_nodes.patch added to mm-new branch
Message-Id: <20261010224125.A9A951F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: move hugetlb_sysfs_initialized into hugetlb_register_all_nodes()
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-move-hugetlb_sysfs_initialized-into-hugetlb_register_all_nodes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-move-hugetlb_sysfs_initialized-into-hugetlb_register_all_nodes.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Enze Li <lienze@kylinos.cn>
Subject: mm/hugetlb: move hugetlb_sysfs_initialized into hugetlb_register_all_nodes()
Date: Fri,  9 Oct 2026 22:20:10 +0800

hugetlb_sysfs_init() guards the "hugetlb_sysfs_initialized = true"
assignment with an #ifdef CONFIG_NUMA block, while the following
hugetlb_register_all_nodes() call is left unguarded and relies on the
empty !CONFIG_NUMA stub.

Move the assignment into the NUMA version of hugetlb_register_all_nodes(),
before it registers the online nodes, so the #ifdef in
hugetlb_sysfs_init() can go away.  Keep the !CONFIG_NUMA stub, so the call
site is unconditional in both configurations.

No functional change; this is an #ifdef cleanup.

Link: https://lore.kernel.org/20261009142010.552614-1-lienze@kylinos.cn
Signed-off-by: Enze Li <lienze@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Muchun Song <muchun.song@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Enze Li <enze.li@gmx.com>
---

 mm/hugetlb_sysfs.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/hugetlb_sysfs.c~mm-hugetlb-move-hugetlb_sysfs_initialized-into-hugetlb_register_all_nodes
+++ a/mm/hugetlb_sysfs.c
@@ -462,6 +462,8 @@ static void __init hugetlb_register_all_
 {
 	int nid;
 
+	hugetlb_sysfs_initialized = true;
+
 	for_each_online_node(nid)
 		hugetlb_register_node(node_devices[nid]);
 }
@@ -495,8 +497,5 @@ void __init hugetlb_sysfs_init(void)
 			pr_err("HugeTLB: Unable to add hstate %s\n", h->name);
 	}
 
-#ifdef CONFIG_NUMA
-	hugetlb_sysfs_initialized = true;
-#endif
 	hugetlb_register_all_nodes();
 }
_

Patches currently in -mm which might be from lienze@kylinos.cn are

maintainers-cover-all-hugetlb-headers-under-hugetlb-subsystem.patch
mm-hugetlb_cgroup-add-trailing-endif-comment-for-include-guard.patch
docs-hugetlbpagerst-fix-typo-in-per-node-attribute-description.patch
mm-hugetlb-prefix-log-messages-via-pr_fmt.patch
mm-hugetlb-move-hugetlb_sysfs_initialized-into-hugetlb_register_all_nodes.patch

