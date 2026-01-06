Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA4B347BBB
	for <mm-commits@vger.kernel.org>; Tue,  6 Jan 2026 19:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767728211; cv=none; b=IYaTQ8BGqZWJayKhIbRWbLahvgUOX17PjRCDp5Rl4siZ+MWklFSj4uSJRHgmTAPE8+yIH9h8Fo8hdLwNKRnjd9oXeSOCsbT1Rft8Xd9YPYMSd3dXFlLBSYMtmdrxNhZ9oeul1LmrepiT51T2/LM6syk6gqD/0pDmolfLCn60ISU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767728211; c=relaxed/simple;
	bh=VU/aGuwbZDkic3BQUCfCxSgXGNkzo76ef9ChLtkDRYs=;
	h=Date:To:From:Subject:Message-Id; b=ZxGRrohS2KrKtV7rgX9h8MbXPd1+c/ewbXDOw73YOnieAfySaPvFeHFmGLMFUy6qCzI0I8dA6gGk2kDIbGpcK0MNY8zVku07H93fP+nrrpkioz9ebDv/vz3EERrUvGG5C/wezRIgrImIDz9m5Bsrqj78whwH3XxrROWH2+YjC3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VFWysdni; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VFWysdni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83390C116C6;
	Tue,  6 Jan 2026 19:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767728210;
	bh=VU/aGuwbZDkic3BQUCfCxSgXGNkzo76ef9ChLtkDRYs=;
	h=Date:To:From:Subject:From;
	b=VFWysdnipwf+C4BekHb/YK62BX2edn04DUGCPvG9I5D2zsea+xcXaTdg3sHtbdQ3D
	 5tAdeM2IvHAqc4THGadea6X7ZQ71iTevPsSkjyegDNRqdhMZYSPrLCvWNJrPyGv0De
	 YxRL+IJgV3MtpOUoYyv4Kn6sHBrxWwfd468mALdU=
Date: Tue, 06 Jan 2026 11:36:50 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rientjes@google.com,mhocko@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hannes@cmpxchg.org,david@kernel.org,bingjiao@google.com,axelrasmussen@google.com,akinobu.mita@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-numa_emu-add-document-for-numa-emulation.patch removed from -mm tree
Message-Id: <20260106193650.83390C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: numa_emu: add document for NUMA emulation
has been removed from the -mm tree.  Its filename was
     mm-numa_emu-add-document-for-numa-emulation.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: mm: numa_emu: add document for NUMA emulation
Date: Mon, 22 Dec 2025 09:48:33 +0900

Add a document with a brief explanation of numa emulation and how to use
the newly added "numa_emulation.adistance=" kernel cmdline parameter.

Link: https://lkml.kernel.org/r/20251222004834.10539-3-akinobu.mita@gmail.com
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/index.rst          |    1 
 Documentation/mm/numa_emulation.rst |   30 ++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

--- a/Documentation/mm/index.rst~mm-numa_emu-add-document-for-numa-emulation
+++ a/Documentation/mm/index.rst
@@ -24,6 +24,7 @@ see the :doc:`admin guide <../admin-guid
    page_cache
    shmfs
    oom
+   numa_emulation
 
 Unsorted Documentation
 ======================
diff --git a/Documentation/mm/numa_emulation.rst a/Documentation/mm/numa_emulation.rst
new file mode 100644
--- /dev/null
+++ a/Documentation/mm/numa_emulation.rst
@@ -0,0 +1,30 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==============
+NUMA emulation
+==============
+
+If CONFIG_NUMA_EMU is enabled, you can create fake NUMA nodes with
+``numa=fake=`` kernel cmdline option.
+See Documentation/admin-guide/kernel-parameters.txt and
+Documentation/arch/x86/x86_64/fake-numa-for-cpusets.rst for more information.
+
+
+Multiple Memory Tiers Creation
+==============================
+
+The "numa_emulation.adistance=" kernel cmdline option allows you to set
+the abstract distance for each NUMA node.
+
+For example, you can create two fake nodes, each in a different memory
+tier by booting with "numa=fake=2 numa_emulation.adistance=576,704".
+Here, the abstract distances of node0 and node1 are set to 576 and 706,
+respectively.
+
+Each memory tier covers an abstract distance chunk size of 128. Thus,
+nodes with abstract distances between 512 and 639 are classified into the
+same memory tier, and nodes with abstract distances between 640 and 767
+are classified into the next slower memory tier.
+
+The abstract distance of fake nodes not specified in the parameter will
+be the default DRAM abstract distance of 576.
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

mm-vmscan-dont-demote-if-there-is-not-enough-free-memory-in-the-lower-memory-tier.patch

