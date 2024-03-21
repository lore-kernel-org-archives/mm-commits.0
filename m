Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C54134730
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 20:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711052115; cv=none; b=sd400oj7/syPW1/q9QIWTZdGhRcSjzGG06P1NVrOhnfUlr/sm+x/ssBzBbiF/Ksi80JzLqtwMyiOpjo4B5cVbGabhc80hM3LtuLMbgqt4gqEv7ubLq/lux6hIVUHyyZGILhkNNLm8WfJrmMP/oF3IKbVT/FCuZQGh1fjfZ/oMo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711052115; c=relaxed/simple;
	bh=Hb4mKCT3sXj0Qg+3bLQvDUr4IjshbERd4KhGZWOMj+M=;
	h=Date:To:From:Subject:Message-Id; b=cSgn0XtBl3FjtUhZEQePzZ8KAC3cpZ1Kwhr3Yvp0wt6fLlegoZkJMwdv6w4aM+b3RnYyF5kpBcTyPnKYYsmFEcpL9JRfn6YB6Iad61pl5a/92lmm0Cr1PlREQhdW6flUOMVSzW5czta/TbOBDiqawRXq8OolJsi116+CsWPsLQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xTA2NK7S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xTA2NK7S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6D8C433C7;
	Thu, 21 Mar 2024 20:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711052115;
	bh=Hb4mKCT3sXj0Qg+3bLQvDUr4IjshbERd4KhGZWOMj+M=;
	h=Date:To:From:Subject:From;
	b=xTA2NK7S1qdrG62S4o/FHiszDGHFFwJoA5Ohybmx+BtBtXowKZPCqlw6dArqIgitS
	 N0OAFbkFxHpytTO3a8JFUDgswEHle0Jo4ywrD64pcTIYxY2F4XNF/OUT/9qJAaWFNR
	 w+qVUW6P/WJwSRzblE2yqvQNjaYiUgHx1OILBgfA=
Date: Thu, 21 Mar 2024 13:15:14 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,dennis@kernel.org,cl@linux.com,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + percpu-clean-up-all-mappings-when-pcpu_map_pages-fails.patch added to mm-unstable branch
Message-Id: <20240321201515.3D6D8C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: percpu: clean up all mappings when pcpu_map_pages() fails
has been added to the -mm mm-unstable branch.  Its filename is
     percpu-clean-up-all-mappings-when-pcpu_map_pages-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/percpu-clean-up-all-mappings-when-pcpu_map_pages-fails.patch

This patch will later appear in the mm-unstable branch at
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
From: Yosry Ahmed <yosryahmed@google.com>
Subject: percpu: clean up all mappings when pcpu_map_pages() fails
Date: Mon, 11 Mar 2024 19:43:46 +0000

In pcpu_map_pages(), if __pcpu_map_pages() fails on a CPU, we call
__pcpu_unmap_pages() to clean up mappings on all CPUs where mappings were
created, but not on the CPU where __pcpu_map_pages() fails.

__pcpu_map_pages() and __pcpu_unmap_pages() are wrappers around
vmap_pages_range_noflush() and vunmap_range_noflush().  All other callers
of vmap_pages_range_noflush() call vunmap_range_noflush() when mapping
fails, except pcpu_map_pages().  The reason could be that partial mappings
may be left behind from a failed mapping attempt.

Call __pcpu_unmap_pages() for the failed CPU as well in pcpu_map_pages().

This was found by code inspection, no failures or bugs were observed.

Link: https://lkml.kernel.org/r/20240311194346.2291333-1-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Dennis Zhou <dennis@kernel.org>
Cc: Christoph Lameter (Ampere) <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu-vm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/percpu-vm.c~percpu-clean-up-all-mappings-when-pcpu_map_pages-fails
+++ a/mm/percpu-vm.c
@@ -231,10 +231,10 @@ static int pcpu_map_pages(struct pcpu_ch
 	return 0;
 err:
 	for_each_possible_cpu(tcpu) {
-		if (tcpu == cpu)
-			break;
 		__pcpu_unmap_pages(pcpu_chunk_addr(chunk, tcpu, page_start),
 				   page_end - page_start);
+		if (tcpu == cpu)
+			break;
 	}
 	pcpu_post_unmap_tlb_flush(chunk, page_start, page_end);
 	return err;
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-memcg-add-null-check-to-obj_cgroup_put.patch
mm-zswap-remove-unnecessary-check-in-zswap_find_zpool.patch
percpu-clean-up-all-mappings-when-pcpu_map_pages-fails.patch

