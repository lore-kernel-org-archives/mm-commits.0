Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE7C3A1CE9
	for <mm-commits@vger.kernel.org>; Tue, 12 May 2026 23:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778627337; cv=none; b=UPevpxFL51LIfqxhkvaEIAZGIX3SgYJQ487EyuAtouxv5ViTUrqlEUqE6GBV33MvxNP2+pgit0io6atFOG4J+wAz3aKjUD3sH26GUqnhVvpFj6YNjTJfiMFNNYgNPUPTirr8IiL6OolwFaf77s/GDoW1jHtfMx6+IS0PPrEuTDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778627337; c=relaxed/simple;
	bh=wtoc4hF5W05gW5hLgubCm0VTRC+FleAtg3//Fzerjp4=;
	h=Date:To:From:Subject:Message-Id; b=hPWT4SS+4MjoeNXJAodo7C9UjujxVbxdVWfhlSabAay9Cvj1tlfxzCid0ZeuU7Ckv5lBTaA7E1tVnOoXima64b3kbcq2V5vF3w3o4BIjqrPB/ag2wrD3/xwKlxnSn1mTRvef5YBL5sBz8FnoSOnvqrsq9bDfVXZIcubsRXPCr1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KNTs8esz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KNTs8esz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C71EC2BCB0;
	Tue, 12 May 2026 23:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778627337;
	bh=wtoc4hF5W05gW5hLgubCm0VTRC+FleAtg3//Fzerjp4=;
	h=Date:To:From:Subject:From;
	b=KNTs8esz+Ncci3y1+k9tQubHTgo6qJhpcvNOLdgFBx+4HkV9hayvhzaoWkXnUSckP
	 I+fkdnmIw/PMVaX2Z/gR2Kf9XXsYo3FznD5fYqGsy6JECYd9Yt3D6vV4OWqhvoSPus
	 XOU1Fha1czn7xf5Fe+rUWym5K3edYYY5EJVY7d64=
Date: Tue, 12 May 2026 16:08:56 -0700
To: mm-commits@vger.kernel.org,rafael@kernel.org,gregkh@linuxfoundation.org,david@kernel.org,dakr@kernel.org,hao.ge@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-meminfo-expose-per-node-balloon-pages-in-node-meminfo.patch added to mm-unstable branch
Message-Id: <20260512230857.1C71EC2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: proc/meminfo: expose per-node balloon pages in node meminfo
has been added to the -mm mm-unstable branch.  Its filename is
     proc-meminfo-expose-per-node-balloon-pages-in-node-meminfo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-meminfo-expose-per-node-balloon-pages-in-node-meminfo.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Hao Ge <hao.ge@linux.dev>
Subject: proc/meminfo: expose per-node balloon pages in node meminfo
Date: Sat, 9 May 2026 08:56:31 +0800

Commit 835de37603ef ("meminfo: add a per node counter for balloon
drivers") added NR_BALLOON_PAGES and exposed it in /proc/meminfo. 
However, the per-node view at /sys/devices/system/node/nodeX/meminfo was
not updated, even though the counter is already tracked per-node.

Add it to node_read_meminfo() so users can see balloon usage per NUMA node
without having to parse the raw vmstat file.

Link: https://lore.kernel.org/20260509005631.17183-1-hao.ge@linux.dev
Signed-off-by: Hao Ge <hao.ge@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/base/node.c~proc-meminfo-expose-per-node-balloon-pages-in-node-meminfo
+++ a/drivers/base/node.c
@@ -523,6 +523,7 @@ static ssize_t node_read_meminfo(struct
 #ifdef CONFIG_UNACCEPTED_MEMORY
 			     "Node %d Unaccepted:     %8lu kB\n"
 #endif
+			     "Node %d Balloon:        %8lu kB\n"
 			     "Node %d GPUActive:      %8lu kB\n"
 			     "Node %d GPUReclaim:     %8lu kB\n"
 			     ,
@@ -559,6 +560,7 @@ static ssize_t node_read_meminfo(struct
 			     nid, K(sum_zone_node_page_state(nid, NR_UNACCEPTED))
 #endif
 			     ,
+			     nid, K(node_page_state(pgdat, NR_BALLOON_PAGES)),
 			     nid, K(node_page_state(pgdat, NR_GPU_ACTIVE)),
 			     nid, K(node_page_state(pgdat, NR_GPU_RECLAIM))
 			    );
_

Patches currently in -mm which might be from hao.ge@linux.dev are

mm-alloc_tag-replace-fixed-size-early-pfn-array-with-dynamic-linked-list.patch
proc-meminfo-expose-per-node-balloon-pages-in-node-meminfo.patch

