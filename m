Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E394175A5
	for <mm-commits@vger.kernel.org>; Sat, 23 Aug 2025 00:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755909304; cv=none; b=WidTsFkUPT/1YXboqItT7kq79TxGlRsPK3GFf8NqCyTtdCdGPD8q61w5MT36Rb3P7lvgFlC67RAWCt2Pxkg+Ml/8Q9rG4qusGnoI9aSvVyEb6PopPckwxg1AMAZp1spDxcjgGMtNS/ost1HkkMu/QPn65hEDlv0Kk+yNc37seeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755909304; c=relaxed/simple;
	bh=29b4PZSq6H5tW6TLiaZLeqI5xK2QxSoM4BaQK+zrj24=;
	h=Date:To:From:Subject:Message-Id; b=CZMFn8fyJcMAwhoRKCT70Hq8gv93b7ZHGiPTFYemDtdTo0+JrNs+Sl6El8GoWmDpMigNE8Gxz80fOlH2X0ks9PAuUwM+1aXNXASB9QujAy1EDuLSRE7Mzn2ceXVowvuknYCKRRNcRHhXSeGftkAeahe29FL68wkVTo/eQMfbCAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ENEaFvhe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ENEaFvhe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D671C4CEED;
	Sat, 23 Aug 2025 00:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755909303;
	bh=29b4PZSq6H5tW6TLiaZLeqI5xK2QxSoM4BaQK+zrj24=;
	h=Date:To:From:Subject:From;
	b=ENEaFvheKspJBA4k2Tz065m9CNmB7xp5gmCK9Ukc8SWGa/l0j/QdFXHetOvJ1YxeF
	 Lb2pzmIHrrGtXr3WsOcyPQIVGyu/GlIeXXwiDLQcKtq0/NPQlxdLIeGXQmD246apCf
	 4eFKlXaieLKpANFGcskAMY3mHdmcIVMCpvs5MKwI=
Date: Fri, 22 Aug 2025 17:35:02 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yury.norov@gmail.com,ritesh.list@gmail.com,osalvador@suse.de,kamezawa.hiroyu@jp.fujitsu.com,Jonathan.Cameron@huawei.com,gregkh@linuxfoundation.org,david@redhat.com,dave.jiang@intel.com,dakr@kernel.org,alison.schofield@intel.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drivers-base-node-handle-error-properly-in-register_one_node.patch added to mm-new branch
Message-Id: <20250823003503.7D671C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drivers/base/node: Handle error properly in register_one_node()
has been added to the -mm mm-new branch.  Its filename is
     drivers-base-node-handle-error-properly-in-register_one_node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drivers-base-node-handle-error-properly-in-register_one_node.patch

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
Subject: drivers/base/node: Handle error properly in register_one_node()
Date: Fri, 22 Aug 2025 14:18:45 +0530

If register_node() returns an error, it is not handled correctly.
The function will proceed further and try to register CPUs under the
node, which is not correct.

So, in this patch, if register_node() returns an error, we return
immediately from the function.

Link: https://lkml.kernel.org/r/20250822084845.19219-1-donettom@linux.ibm.com
Fixes: 76b67ed9dce6 ("[PATCH] node hotplug: register cpu: remove node struct")
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/base/node.c~drivers-base-node-handle-error-properly-in-register_one_node
+++ a/drivers/base/node.c
@@ -885,6 +885,11 @@ int register_one_node(int nid)
 	node_devices[nid] = node;
 
 	error = register_node(node_devices[nid], nid);
+	if (error) {
+		node_devices[nid] = NULL;
+		kfree(node);
+		return error;
+	}
 
 	/* link cpu under this node */
 	for_each_present_cpu(cpu) {
_

Patches currently in -mm which might be from donettom@linux.ibm.com are

mm-selftests-fix-incorrect-pointer-being-passed-to-mark_range.patch
selftests-mm-add-support-to-test-4pb-va-on-ppc64.patch
selftest-mm-fix-ksm_funtional_test-failures.patch
mm-selftests-fix-split_huge_page_test-failure-on-systems-with-64kb-page-size.patch
drivers-base-node-handle-error-properly-in-register_one_node.patch

