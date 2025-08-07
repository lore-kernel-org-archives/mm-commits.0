Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0EC3186A
	for <mm-commits@vger.kernel.org>; Thu,  7 Aug 2025 03:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754538271; cv=none; b=AGZ5skZi3yahdoDZesDfYW6ryXT31+9QAB8FkI606k/Nf7DnhuW2LnjOfMr/568kkc3V/tyl/SHxSGp5vm8r2bzBGi4G1Ace1fn3PYjt7vP2/yzEQ/Ce3Hv3DORBjI2RXaAhmjyiWQBseMuU8MeFA6Qdftr7MlEp8bBAmQG09rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754538271; c=relaxed/simple;
	bh=M1ugOHlD+mB4z1YkoT8lzZleXR0OaHcHxIKcJIBdYLQ=;
	h=Date:To:From:Subject:Message-Id; b=FmnyPW1e7KehLq9BhAl8r9PTytODEZj+sIKVsrS78M1S7Ai9G7k0cCd9kLX/rK2wiRGqP3c9nXpM9I/t/9CRC16qrA6SDzxRFj/KiI5dHmQXH1+1/XlYPcmzc2nrjO4dYDPwyhpQdQcJVdAvl3owb8E/ZEnMiqJwTWgtNvpg+uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W2vsP7Ow; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W2vsP7Ow"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35FF4C4CEF4;
	Thu,  7 Aug 2025 03:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754538271;
	bh=M1ugOHlD+mB4z1YkoT8lzZleXR0OaHcHxIKcJIBdYLQ=;
	h=Date:To:From:Subject:From;
	b=W2vsP7Ow0LQaXvOeFuhGThUBPU/rYlzup8F5LELoiOHBWbXUiPjAZX4TLmnvlKYKg
	 U46nWrmJYZh/cUdl9S9THLUOrVRYHIh4FDJF70sCSq0fX5GbvYbBs7MbqWo2MkD2Ed
	 oBeFhWo0zO53OvMzk6BysTsDFqUztYzh2oR0i+bA=
Date: Wed, 06 Aug 2025 20:44:30 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,sidhartha.kumar@oracle.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,paul.walmsley@sifive.com,palmer@dabbelt.com,npache@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,leon@kernel.org,jhubbard@nvidia.com,jgg@ziepe.ca,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,aou@eecs.berkeley.edu,alex@ghiti.fr,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-protection_keys-fix-dead-code.patch added to mm-new branch
Message-Id: <20250807034431.35FF4C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: protection_keys: fix dead code
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-protection_keys-fix-dead-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-protection_keys-fix-dead-code.patch

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
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests/mm: protection_keys: fix dead code
Date: Thu, 31 Jul 2025 21:01:26 +0500

The while loop doesn't execute and following warning gets generated:

protection_keys.c:561:15: warning: code will never be executed
[-Wunreachable-code]
                int rpkey = alloc_random_pkey();

Let's enable the while loop such that it gets executed nr_iterations
times. Simplify the code a bit as well.

Link: https://lkml.kernel.org/r/20250731160132.1795351-3-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/protection_keys.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/protection_keys.c~selftests-mm-protection_keys-fix-dead-code
+++ a/tools/testing/selftests/mm/protection_keys.c
@@ -557,13 +557,11 @@ int mprotect_pkey(void *ptr, size_t size
 	int nr_iterations = random() % 100;
 	int ret;
 
-	while (0) {
+	while (nr_iterations-- >= 0) {
 		int rpkey = alloc_random_pkey();
 		ret = sys_mprotect_pkey(ptr, size, orig_prot, pkey);
 		dprintf1("sys_mprotect_pkey(%p, %zx, prot=0x%lx, pkey=%ld) ret: %d\n",
 				ptr, size, orig_prot, pkey, ret);
-		if (nr_iterations-- < 0)
-			break;
 
 		dprintf1("%s()::%d, ret: %d pkey_reg: 0x%016llx"
 			" shadow: 0x%016llx\n",
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-mm-add-wunreachable-code-and-fix-warnings.patch
selftests-mm-protection_keys-fix-dead-code.patch
selftests-kselftesth-add-__unused-macro.patch
selftests-mm-add-wunused-family-of-flags.patch
selftests-mm-remove-unused-parameters.patch
selftests-mm-mark-unused-arguments-with-__unused.patch
selftests-mm-mark-unused-arguments-with-__unused-2.patch
selftests-mm-fix-unused-parameter-warnings-for-different-architectures.patch

