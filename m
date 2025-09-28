Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD36B34BA4D
	for <mm-commits@vger.kernel.org>; Sun, 28 Sep 2025 18:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759085539; cv=none; b=dWaTID69qA6Fa0SAI7amJj3FEadXwtigBqtRRIqjAfq4y8wfAfW1skhOT72W7W5n5FIKy3AY9npCUfXMiB2XCBctADYSU2YnO0+fxP4yTtWEbqMSf2zmsai1oRp3yQ4//oW+JmWR6GQRXCXwoWbHrkoXdFWXyVakkownBtrF+n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759085539; c=relaxed/simple;
	bh=2rRFE/EzfjZK0LBxilt+lZL39zF6SYa9ckC2zWImnDQ=;
	h=Date:To:From:Subject:Message-Id; b=h4Dlp3e6KJmuChmUICE2DNGrwEvt6lp9pxfpwaRP6WHfn8vUwZ2i6VLtxvrv/gJWVy0mt8YEgNaAXFJeYSszYTpKnBeq+9HwFJOhYzc1pHZBdbT0ZFw4wIOlty34q9YpuPmEBfU/X1r9NH7jxLHvVMzBubWzy++rRgibn2TFhaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nsl1yDmN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nsl1yDmN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A89C4CEF0;
	Sun, 28 Sep 2025 18:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759085539;
	bh=2rRFE/EzfjZK0LBxilt+lZL39zF6SYa9ckC2zWImnDQ=;
	h=Date:To:From:Subject:From;
	b=nsl1yDmNjvh0ahVLZBsfaIeA2ats49uFCypZzXoA3JbdGdxRNsBv4a+DdD86leHy+
	 8I7rMKHWweaQ6c9T5Xc4kcGaWNgjEov6yXLg63Mv22/mFJgJjhzovFSjAd/vcUiJw8
	 92Qvs/Bvs359Mi5Rgo6EW7T8/SwahK6/Ufhra7Q4=
Date: Sun, 28 Sep 2025 11:52:18 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yury.norov@gmail.com,ritesh.list@gmail.com,osalvador@suse.de,kamezawa.hiroyu@jp.fujitsu.com,Jonathan.Cameron@huawei.com,gregkh@linuxfoundation.org,david@redhat.com,dave.jiang@intel.com,dakr@kernel.org,clm@meta.com,alison.schofield@intel.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] drivers-base-node-fix-double-free-in-register_one_node.patch removed from -mm tree
Message-Id: <20250928185219.77A89C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drivers/base/node: fix double free in register_one_node()
has been removed from the -mm tree.  Its filename was
     drivers-base-node-fix-double-free-in-register_one_node.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


