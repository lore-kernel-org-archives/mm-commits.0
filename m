Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96013171CD;
	Wed, 29 Jan 2025 04:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738124886; cv=none; b=jLtyrA5dcwFRVpX+UfbkAJ4nGcCqUNy6enTVRnT8+YzR5gXQcbNZJaLnmey0PjwVB4Xm/8V6dT4bJWwLPzzdjca8kAvQCvHRO6f5MLXxXsdckzj8AGAk6C5gnPsRS1Lq3H8QFfH4oAnpvN71OEVr3GyemWYBfPA1EXBkahvYIqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738124886; c=relaxed/simple;
	bh=ycSVABy2R70qONhrAYJLr6ebppwRB7CxtaFE0WwC5aA=;
	h=Date:To:From:Subject:Message-Id; b=H4LT7RW06BJeX6HslKt4fFl1AtGJe4WoIhxHhp7Ty62Wi1KJ3wi3AuNCjo/xaqsyZoJJVaAmcWIcclJHYuSkj7YCsAFyBminsZ15upBADehwp0nwGdAjlLtnIzIhRWMgUFmFm4P2V2BfJQOJHCKj2M9CLRYNgz3E/opCKKdonDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L7wJDfGh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L7wJDfGh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4770C4CED3;
	Wed, 29 Jan 2025 04:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738124886;
	bh=ycSVABy2R70qONhrAYJLr6ebppwRB7CxtaFE0WwC5aA=;
	h=Date:To:From:Subject:From;
	b=L7wJDfGhAh0G5XtVhnlHmw+cImARSBLUdqV4btro4+CiRDb4uCDqPXGpISoV6fXms
	 HjiGI9vsCDnQ/s5vQXQZNQ54TuwciOgL6Wu/sDPVnSzpXCDKtef4RqYrcANjpthMEQ
	 yBGdhHibXK0F87yKzMihkKVIMSKP1vDrVB3fM07E=
Date: Tue, 28 Jan 2025 20:28:05 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sourabhjain@linux.ibm.com,rientjes@google.com,pavrampu@linux.ibm.com,muchun.song@linux.dev,luizcap@redhat.com,gang.li@linux.dev,donettom@linux.ibm.com,daniel.m.jordan@oracle.com,ritesh.list@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-hugepage-allocation-for-interleaved-memory-nodes.patch added to mm-hotfixes-unstable branch
Message-Id: <20250129042805.E4770C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: fix hugepage allocation for interleaved memory nodes
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-fix-hugepage-allocation-for-interleaved-memory-nodes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-hugepage-allocation-for-interleaved-memory-nodes.patch

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
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Gang Li <gang.li@linux.dev>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: David Rientjes <rientjes@google.com>
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

mm-hugetlb-fix-hugepage-allocation-for-interleaved-memory-nodes.patch

