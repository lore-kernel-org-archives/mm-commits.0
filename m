Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFDF8C07
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600521; cv=none; b=FUlPoUrgTlRbGTZ92gDvxxeEecUISKsICPxOE2W5hGDqsYWFrWUan7Y0STYTeZTVNeX6/s3kH4tiFn0ewQhalGDJELS6eriUPK3kJc+Vk7yTFjRCyFvG2cGLvtB79llk2VwqKlK1XeRxdsxF1c9k3i2NniSZj8dWky888Js/j9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600521; c=relaxed/simple;
	bh=81Ae2jC9U2FAvTgmSeJlHLf9gW2kfmQVDPGVZAu3HFo=;
	h=Date:To:From:Subject:Message-Id; b=Lz6o0x/gnhEijcxe+ghGvkU3ufjjxkDdGYYj6sqRtp+jXz2CygRRBuEKky3g08oJaWs1pLdDunhUxkLZDdMIr9Lwe/Y2IvqGVQZ2I8Bt7txgcfWOEHRHozhMYm2b+WU/7A4vqFAYgd/Pkr8PdOOIjLdpy466UAu94tNwoXT8yfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EQVENY73; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EQVENY73"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E3DC433C7;
	Tue,  5 Mar 2024 01:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600520;
	bh=81Ae2jC9U2FAvTgmSeJlHLf9gW2kfmQVDPGVZAu3HFo=;
	h=Date:To:From:Subject:From;
	b=EQVENY73v7mNecBcfEEFvmwUzO3Nf52prOysCS0lSfcrSawzFkrW2fKjJ23lRIN5t
	 id3zxuXkbmSqFT8Q1jMO+3N1xkSE5j76sgeqTYaCloE7P7TKrEunA3VSlZSp6dk7g2
	 xVZo2mCsT/qAkUMIbPfXzWfq4dvOVmnGxOtNUDIo=
Date: Mon, 04 Mar 2024 17:01:59 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,mcassell411@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-utilc-added-byte-count-to-__vm_enough_memory-failure-warning.patch removed from -mm tree
Message-Id: <20240305010200.62E3DC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/util.c: add byte count to __vm_enough_memory failure warning
has been removed from the -mm tree.  Its filename was
     mm-utilc-added-byte-count-to-__vm_enough_memory-failure-warning.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


