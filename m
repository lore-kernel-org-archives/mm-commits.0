Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FA418872D;
	Sat,  1 Feb 2025 11:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738410858; cv=none; b=o7//ywC8xV3PG3vW3HH6VEAFd8OmGi7yO/QtGxJ5c1fMVN6IPMGZxXyEFQ6gQxifgDLQA6awrGewlD3yinPKM9TAPDSRij9L+Tk/HEkB9qFjsyc7bI4LLdy+IA9bJf7R2jEGlLTBSpwOEVs8ot5Awv2o4EROAKuyaMBbVfMZOCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738410858; c=relaxed/simple;
	bh=irRCgbpEJT3/p97JPE65K+0ZnXK01pufY5XYS5ql3eo=;
	h=Date:To:From:Subject:Message-Id; b=is5LGh+WKIieMqXoB9I8oMuNXJjmoSLHVx7VJftdr6vRg5ioICuc0FAnlTfwUj2UExChR79TTOEUMZS6nTAcPLwq08XzvPH85ImFUC+OeDudFTlN1g0AK91aomb9Z8Yt9tyeUgtNVfNDhnnroOzr3dNIlw6JOdqgU0DVZk6KXso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kSfW4nTu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kSfW4nTu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD1B5C4CED3;
	Sat,  1 Feb 2025 11:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738410858;
	bh=irRCgbpEJT3/p97JPE65K+0ZnXK01pufY5XYS5ql3eo=;
	h=Date:To:From:Subject:From;
	b=kSfW4nTuaIUabQ4BUoOQ5q77NDfjQz/opHIOh3awJo3grSvj/Z4WoMuB4D94vXpT/
	 3t8bvwqlqfo0fQpB/FSTrHzwyoAb1e/UaY863x/nsLel6qHCUALzbil2jmeeP5WB7X
	 8xY7NY5wWoZvvoptoMC35bgBOGOBp1Bt5lNX9/6A=
Date: Sat, 01 Feb 2025 03:54:18 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sourabhjain@linux.ibm.com,rientjes@google.com,pavrampu@linux.ibm.com,muchun.song@linux.dev,luizcap@redhat.com,gang.li@linux.dev,donettom@linux.ibm.com,daniel.m.jordan@oracle.com,ritesh.list@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-fix-hugepage-allocation-for-interleaved-memory-nodes.patch removed from -mm tree
Message-Id: <20250201115418.AD1B5C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: fix hugepage allocation for interleaved memory nodes
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-hugepage-allocation-for-interleaved-memory-nodes.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: mm/hugetlb: fix hugepage allocation for interleaved memory nodes
Date: Sat, 11 Jan 2025 16:36:55 +0530

gather_bootmem_prealloc() assumes the start nid as 0 and size as
num_node_state(N_MEMORY).  That means in case if memory attached numa
nodes are interleaved, then gather_bootmem_prealloc_parallel() will fail
to scan few of these nodes.

Since memory attached numa nodes can be interleaved in any fashion, hence
ensure that the current code checks for all numa node ids
(.size = nr_node_ids). Let's still keep max_threads as N_MEMORY, so that
it can distributes all nr_node_ids among the these many no. threads.

e.g. qemu cmdline
========================
numa_cmd="-numa node,nodeid=1,memdev=mem1,cpus=2-3 -numa node,nodeid=0,cpus=0-1 -numa dist,src=0,dst=1,val=20"
mem_cmd="-object memory-backend-ram,id=mem1,size=16G"

w/o this patch for cmdline (default_hugepagesz=1GB hugepagesz=1GB hugepages=2):
==========================
~ # cat /proc/meminfo  |grep -i huge
AnonHugePages:         0 kB
ShmemHugePages:        0 kB
FileHugePages:         0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:    1048576 kB
Hugetlb:               0 kB

with this patch for cmdline (default_hugepagesz=1GB hugepagesz=1GB hugepages=2):
===========================
~ # cat /proc/meminfo |grep -i huge
AnonHugePages:         0 kB
ShmemHugePages:        0 kB
FileHugePages:         0 kB
HugePages_Total:       2
HugePages_Free:        2
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:    1048576 kB
Hugetlb:         2097152 kB

Link: https://lkml.kernel.org/r/f8d8dad3a5471d284f54185f65d575a6aaab692b.1736592534.git.ritesh.list@gmail.com
Fixes: b78b27d02930 ("hugetlb: parallelize 1G hugetlb initialization")
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reported-by: Pavithra Prakash <pavrampu@linux.ibm.com>
Suggested-by: Muchun Song <muchun.song@linux.dev>
Tested-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Reviewed-by: Luiz Capitulino <luizcap@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Gang Li <gang.li@linux.dev>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-hugepage-allocation-for-interleaved-memory-nodes
+++ a/mm/hugetlb.c
@@ -3309,7 +3309,7 @@ static void __init gather_bootmem_preall
 		.thread_fn	= gather_bootmem_prealloc_parallel,
 		.fn_arg		= NULL,
 		.start		= 0,
-		.size		= num_node_state(N_MEMORY),
+		.size		= nr_node_ids,
 		.align		= 1,
 		.min_chunk	= 1,
 		.max_threads	= num_node_state(N_MEMORY),
_

Patches currently in -mm which might be from ritesh.list@gmail.com are


