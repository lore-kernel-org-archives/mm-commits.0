Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33B92D7D42
	for <mm-commits@vger.kernel.org>; Thu, 18 Sep 2025 21:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758231832; cv=none; b=amvSW86dcmglhRNm4fXyBo5WonmQwjotCiwDjcqCPZPNxUw/MCqpODOFCekMJVcmOwRGVmTxo1F6CjsymkH5PklxdDGWgSwIQr9tatpRfjJ+qbkFDzIR7F31nOcS01mSd8WZ48NljlxVq4y8PThg9h03cPtf3Bb0SdagSnTg5d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758231832; c=relaxed/simple;
	bh=sZzv39/dGb3stLnrGk7wXx6lY/PmkZ1HwxPZ92pTVfI=;
	h=Date:To:From:Subject:Message-Id; b=ZdDJm4VSPW2K7oS8VE+BSbg7XnJ8KLo/gPKe+bjkwM9T72p/beydi2ITyp278r15OmjaG/Jr1JaJP76jnagYXqG/q5VfJSpQYp8siyHsb+XNRgnCToGzQHlASMHr9K0Zn4U23RC9QbS1xSqz0R5C6FDI1mEkRFQ4DO4M+kH2u84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vKv7Y5em; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vKv7Y5em"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CFB0C4CEE7;
	Thu, 18 Sep 2025 21:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758231831;
	bh=sZzv39/dGb3stLnrGk7wXx6lY/PmkZ1HwxPZ92pTVfI=;
	h=Date:To:From:Subject:From;
	b=vKv7Y5emC0rNmhJD1akviXdFXb3nhrtaBgwKnJ3iqmivi26Uwo8ThGA5KkLP58LA3
	 xhmXRYnwfeoHjN8HI16pxRh7ImzJKOG556fJF8IcJcnqlEnchQJ19qEW943LSQzjC2
	 PTGaSQgcYdv4Rhb+jxt74c6Ov0iqLpvewm56ybNE=
Date: Thu, 18 Sep 2025 14:43:50 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yury.norov@gmail.com,ritesh.list@gmail.com,osalvador@suse.de,kamezawa.hiroyu@jp.fujitsu.com,Jonathan.Cameron@huawei.com,gregkh@linuxfoundation.org,david@redhat.com,dave.jiang@intel.com,dakr@kernel.org,clm@meta.com,alison.schofield@intel.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drivers-base-node-fix-double-free-in-register_one_node.patch added to mm-new branch
Message-Id: <20250918214351.5CFB0C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drivers/base/node: fix double free in register_one_node()
has been added to the -mm mm-new branch.  Its filename is
     drivers-base-node-fix-double-free-in-register_one_node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drivers-base-node-fix-double-free-in-register_one_node.patch

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
From: Donet Tom <donettom@linux.ibm.com>
Subject: drivers/base/node: fix double free in register_one_node()
Date: Thu, 18 Sep 2025 11:11:44 +0530

When device_register() fails in register_node(), it calls
put_device(&node->dev).  This triggers node_device_release(), which calls
kfree(to_node(dev)), thereby freeing the entire node structure.

As a result, when register_node() returns an error, the node memory has
already been freed.  Calling kfree(node) again in register_one_node()
leads to a double free.

This patch removes the redundant kfree(node) from register_one_node() to
prevent the double free.

Link: https://lkml.kernel.org/r/20250918054144.58980-1-donettom@linux.ibm.com
Fixes: 786eb990cfb7 ("drivers/base/node: handle error properly in register_one_node()")
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Chris Mason <clm@meta.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/base/node.c~drivers-base-node-fix-double-free-in-register_one_node
+++ a/drivers/base/node.c
@@ -887,7 +887,6 @@ int register_one_node(int nid)
 	error = register_node(node_devices[nid], nid);
 	if (error) {
 		node_devices[nid] = NULL;
-		kfree(node);
 		return error;
 	}
 
_

Patches currently in -mm which might be from donettom@linux.ibm.com are

mm-ksm-fix-incorrect-ksm-counter-handling-in-mm_struct-during-fork.patch
selftests-mm-added-fork-inheritance-test-for-ksm_merging_pages-counter.patch
selftests-mm-added-fork-test-to-verify-global-ksm_zero_pages-counter-behavior.patch
drivers-base-node-fix-double-free-in-register_one_node.patch

