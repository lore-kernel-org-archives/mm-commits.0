Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466EE10A05
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 20:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708634354; cv=none; b=V2usYEESk1YeSFpEaOKAWhciEbK//m5UE+GUgar8PIrOMPDEWnjbrLHClqxGwAX56TazroN8QDJjK08cLBCNOXjYQlNM1N353Q8oAiOQTwTJK9THcTP5Xv3qacn+Vyu9tBYGDZV/ZG+e//VCnVkrOgwfatKG+WFYHsT6SuIq6Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708634354; c=relaxed/simple;
	bh=dlMjzowh+Di2TOlQvW4oiIYyn9J7pbrElHgqYf/O/3M=;
	h=Date:To:From:Subject:Message-Id; b=dzFLVrZAGKPXlKUSX5yhQ5j8ba/5+W0nsI4xN5hJRf35KEZylOr+azf6jwjhj1+J/4oYN2fywrhbixeGfhaq/zMN+vpkHoDbzaGCAfSdW/oLHGF7FNaR1uel4fvkRmPm1juuDiYOAFYZofwKy7at4BARc7w8+z3stNHLmJ7hQa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZES+I4gp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZES+I4gp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DA5C433F1;
	Thu, 22 Feb 2024 20:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708634353;
	bh=dlMjzowh+Di2TOlQvW4oiIYyn9J7pbrElHgqYf/O/3M=;
	h=Date:To:From:Subject:From;
	b=ZES+I4gpWtHwyQme5nDrmGJISH5h69dPgjiYWR/ZWU7dd6gEKOuPgdiFA1x1/s0Vh
	 h08beJAjuVol6FjrsedfiPlplbM9soXInfdCYxgVPiicoGVilD6ELF/8GrIbUQboJ9
	 8uqCd2daFkR8ns1NpoUdI4gyKOdSyKPYO4jI4+/8=
Date: Thu, 22 Feb 2024 12:39:13 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,mcassell411@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-utilc-added-byte-count-to-__vm_enough_memory-failure-warning.patch added to mm-unstable branch
Message-Id: <20240222203913.B8DA5C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/util.c: add byte count to __vm_enough_memory failure warning
has been added to the -mm mm-unstable branch.  Its filename is
     mm-utilc-added-byte-count-to-__vm_enough_memory-failure-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-utilc-added-byte-count-to-__vm_enough_memory-failure-warning.patch

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
From: Matthew Cassell <mcassell411@gmail.com>
Subject: mm/util.c: add byte count to __vm_enough_memory failure warning
Date: Thu, 22 Feb 2024 19:46:17 +0000

Commit 44b414c8715c5dcf53288 ("mm/util.c: add warning if
__vm_enough_memory fails") adds debug information which gives the process
id and executable name should __vm_enough_memory() fail.  Adding the
number of pages to the failure message would benefit application
developers and system administrators in debugging overambitious memory
requests by providing a point of reference to the amount of memory causing
__vm_enough_memory() to fail.

1. Set appropriate kernel tunable to reach code path for failure
   message:

	# echo 2 > /proc/sys/vm/overcommit_memory

2. Test program to generate failure - requests 1 gibibyte per
   iteration:

	#include <stdlib.h>
	#include <stdio.h>

	int main(int argc, char **argv) {
		for(;;) {
			if(malloc(1<<30) == NULL)
				break;

			printf("allocated 1 GiB\n");
		}

		return 0;
	}

3. Output:

	Before:

	__vm_enough_memory: pid: 1218, comm: a.out, not enough memory
for the allocation

	After:

	__vm_enough_memory: pid: 1137, comm: a.out, bytes: 1073741824,
not enough memory for the allocation

Link: https://lkml.kernel.org/r/20240222194617.1255-1-mcassell411@gmail.com
Signed-off-by: Matthew Cassell <mcassell411@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/util.c~mm-utilc-added-byte-count-to-__vm_enough_memory-failure-warning
+++ a/mm/util.c
@@ -942,6 +942,7 @@ EXPORT_SYMBOL_GPL(vm_memory_committed);
 int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
 {
 	long allowed;
+	unsigned long bytes_failed;
 
 	vm_acct_memory(pages);
 
@@ -976,8 +977,9 @@ int __vm_enough_memory(struct mm_struct
 	if (percpu_counter_read_positive(&vm_committed_as) < allowed)
 		return 0;
 error:
-	pr_warn_ratelimited("%s: pid: %d, comm: %s, not enough memory for the allocation\n",
-			    __func__, current->pid, current->comm);
+	bytes_failed = pages << PAGE_SHIFT;
+	pr_warn_ratelimited("%s: pid: %d, comm: %s, bytes: %lu not enough memory for the allocation\n",
+			    __func__, current->pid, current->comm, bytes_failed);
 	vm_unacct_memory(pages);
 
 	return -ENOMEM;
_

Patches currently in -mm which might be from mcassell411@gmail.com are

mm-utilc-added-byte-count-to-__vm_enough_memory-failure-warning.patch

