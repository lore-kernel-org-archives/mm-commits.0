Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBCEE226861
	for <mm-commits@vger.kernel.org>; Tue, 23 Dec 2025 01:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766454170; cv=none; b=d3U06j4dlAVu99gu5CIbEy/EbSLzqKQ3vd0PvtAK2J68V7QPyNEs5JSPRchXxy4DuZ0z6FEXAcxDAx72E8ik7LMHC/4aOnxz8BN9xXc0c4DEUGzkTs4HJHT/AOmc1Sh3bw4DEnrIbWvPCFWHVbJthM9ch0dnzvsxbhb1KtjIeBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766454170; c=relaxed/simple;
	bh=5K6JSa4nGF9UXRlNS/bTcdXnQl6uDKv8odWKBZkuWHo=;
	h=Date:To:From:Subject:Message-Id; b=PkPQz9DBC0soE8FgBs85YSQcLvJel/tsJUK5cV8UVstIbUs0bslkyGNjjOJ8OPF7dgyTwncbjcibP4sMKLMa9pO27twwxEohkxNkErA6YkxwfA5GCUswLsDB595PNxqhIhCaF1O9I4dXf3YFDJkfxETou7eQjg9dKucY/0XHf0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TqQ1g0DC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TqQ1g0DC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2EEC4CEF1;
	Tue, 23 Dec 2025 01:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766454169;
	bh=5K6JSa4nGF9UXRlNS/bTcdXnQl6uDKv8odWKBZkuWHo=;
	h=Date:To:From:Subject:From;
	b=TqQ1g0DCDfz25gNdCag9Gu0a1b6NHdsuEvRLoQrIJCep8QHZcXNck7BbXeSnmoi7N
	 9gedEb+fp3GxGi+RWTHYuML57FKnIW/REwUCgEphaa2cyuXIXQ0kh8Z+UQ0AlFHEFp
	 Ns1LRV+9a49vTv4DqKpLfyugqAOSU9x2DXLcwHjo=
Date: Mon, 22 Dec 2025 17:42:48 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rientjes@google.com,mhocko@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hannes@cmpxchg.org,david@kernel.org,axelrasmussen@google.com,akinobu.mita@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-numa_emu-add-document-for-numa-emulation.patch added to mm-new branch
Message-Id: <20251223014249.5E2EEC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: numa_emu: add document for NUMA emulation
has been added to the -mm mm-new branch.  Its filename is
     mm-numa_emu-add-document-for-numa-emulation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-numa_emu-add-document-for-numa-emulation.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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

mm-damon-vaddr-fix-missing-pte_unmap_unlock-in-damos_va_migrate_pmd_entry.patch
mm-memory-tiers-numa_emu-enable-to-create-memory-tiers-using-fake-numa-nodes.patch
mm-numa_emu-add-document-for-numa-emulation.patch
mm-vmscan-dont-demote-if-there-is-not-enough-free-memory-in-the-lower-memory-tier.patch

