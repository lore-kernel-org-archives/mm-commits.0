Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B981119992E
	for <mm-commits@vger.kernel.org>; Mon, 27 Jan 2025 20:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738010360; cv=none; b=QkLC4+FeF4OqCaYfT1voEvD70M5qo83Bbbvwv2qdOsdxbfhXe75ZQB/ClO7zOCuBdefMhJYCoJfqkJAjTyp9UQyIBGogrZ/Qr+WOIRAX+i+Fc2V9ya3sWuy2V9OeJCRBjoVxTdIn8csJnk8V/EHhWMKGsR4p4uOGvhTs04isJHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738010360; c=relaxed/simple;
	bh=kJICa3Rf1lrtP3vQOygpSJrCV2IObDZMIuh2kemiGD0=;
	h=Date:To:From:Subject:Message-Id; b=C02+/sFBasU1s8rf4schy72Ji0XmLLfT0CFc74Xmu8LepL6iLQ3Ep0rSD/Bq8WO5nyh6BakDgGIqpDdXkkuX/N/i6SGcPiLikcffDKvRrbLx+WNf2eO6WiARAwUUBSz4LF2X2JUoRL9BPCg8dURttiVjJN4aQuZA5jSqIUSvwvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hoqs41Lz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hoqs41Lz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18550C4CED2;
	Mon, 27 Jan 2025 20:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738010360;
	bh=kJICa3Rf1lrtP3vQOygpSJrCV2IObDZMIuh2kemiGD0=;
	h=Date:To:From:Subject:From;
	b=hoqs41LzXn7i9TZibjlmeXBxg7lJnsDHDkczQRNqbu3KPLvFi1gn9he5ff7vrU+sm
	 iND/bKxQTMPFgI5LJzQh+qL5i8vpVKAALfokbiQg89eVoXuNliy/tjZH5IdDWeQuYh
	 5TlK7lBF5tuUH6+XRcDgfVP4JAjBL2vRyEL5ZE2k=
Date: Mon, 27 Jan 2025 12:39:19 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,rppt@kernel.org,rafael@kernel.org,lenb@kernel.org,jhubbard@nvidia.com,hyeonggon.yoo@sk.com,david@redhat.com,bfaccini@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fake-numa-handle-cases-with-no-srat-info.patch added to mm-hotfixes-unstable branch
Message-Id: <20250127203920.18550C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/fake-numa: handle cases with no SRAT info
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fake-numa-handle-cases-with-no-srat-info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fake-numa-handle-cases-with-no-srat-info.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Bruno Faccini <bfaccini@nvidia.com>
Subject: mm/fake-numa: handle cases with no SRAT info
Date: Mon, 27 Jan 2025 09:16:23 -0800

Handle more gracefully cases where no SRAT information is available, like
in VMs with no Numa support, and allow fake-numa configuration to complete
successfully in these cases

Link: https://lkml.kernel.org/r/20250127171623.1523171-1-bfaccini@nvidia.com
Fixes: 63db8170bf34 (“mm/fake-numa: allow later numa node hotplug”)
Signed-off-by: Bruno Faccini <bfaccini@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hyeonggon Yoo <hyeonggon.yoo@sk.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/numa/srat.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/acpi/numa/srat.c~mm-fake-numa-handle-cases-with-no-srat-info
+++ a/drivers/acpi/numa/srat.c
@@ -95,9 +95,13 @@ int __init fix_pxm_node_maps(int max_nid
 	int i, j, index = -1, count = 0;
 	nodemask_t nodes_to_enable;
 
-	if (numa_off || srat_disabled())
+	if (numa_off)
 		return -1;
 
+	/* no or incomplete node/PXM mapping set, nothing to do */
+	if (srat_disabled())
+		return 0;
+
 	/* find fake nodes PXM mapping */
 	for (i = 0; i < MAX_NUMNODES; i++) {
 		if (node_to_pxm_map[i] != PXM_INVAL) {
@@ -117,6 +121,11 @@ int __init fix_pxm_node_maps(int max_nid
 			}
 		}
 	}
+	if (index == -1) {
+		pr_debug("No node/PXM mapping has been set\n");
+		/* nothing more to be done */
+		return 0;
+	}
 	if (WARN(index != max_nid, "%d max nid  when expected %d\n",
 		      index, max_nid))
 		return -1;
_

Patches currently in -mm which might be from bfaccini@nvidia.com are

mm-fake-numa-handle-cases-with-no-srat-info.patch

