Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A408B213E89
	for <mm-commits@vger.kernel.org>; Mon,  1 Jun 2026 18:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780338040; cv=none; b=OeMYfx1N/9o8zF9vcFJVPSJdMCP3E0CdMpEirt2DN8xpICb9BrDG1Rl2xpFS4HFIlhtxDY6kwuA+Vn+u2g0C5UnWX7zWwzbwJcGJtKio2HujxUhw8CyUANSr3Gu6Bwix0AbqpWFVqwSSLmLhMwMwaZxPLe/pTFNLE0r9+pLWuEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780338040; c=relaxed/simple;
	bh=/nEzjfRkqwQZXiDTzrhzje+tlvjd15HKCzCVMiHyn34=;
	h=Date:To:From:Subject:Message-Id; b=VRkMZTUN4FJAAgBLHsJjRiuRSbsWKfi19kztiKL0yMpyB6GMlpgu2Mx4sOw5byKATYTTBEHjKYUcUySrfaA/iZroFc3TY901g0vlr0GrkUZ+/g6fj5B1hjVJVkTmvRgU3nWrkRADI3CnVwvu6Plh2UkdPdqRshVVF/y1TxP6C38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rC/32SGw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rC/32SGw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6D71F00893;
	Mon,  1 Jun 2026 18:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780338039;
	bh=T3msYlxOBj5MkGmbhfvPO3kz377I0uIseWzx2hxx8rM=;
	h=Date:To:From:Subject;
	b=rC/32SGwPzRgZ2sppCrK0L8WfE1lSmIgOaXKJ1hPSuRfhpd+YdJbCz1pksaSUGctk
	 /vreD1lt22LCPg2j2kJDLugCsRJrkcqNTFnxh9KmR8PTvV9nWDeNFFeJowKQeRcYcJ
	 vyM8oJeMvG62Sm46OMVCjRsL6h+5wwnkY5swlzm4=
Date: Mon, 01 Jun 2026 11:20:38 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,npiggin@gmail.com,dev.jain@arm.com,zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vmalloc-fix-null-pointer-dereference-in-is_vm_area_hugepages.patch added to mm-new branch
Message-Id: <20260601182039.3D6D71F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: vmalloc: fix NULL pointer dereference in is_vm_area_hugepages()
has been added to the -mm mm-new branch.  Its filename is
     vmalloc-fix-null-pointer-dereference-in-is_vm_area_hugepages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmalloc-fix-null-pointer-dereference-in-is_vm_area_hugepages.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Hui Zhu <zhuhui@kylinos.cn>
Subject: vmalloc: fix NULL pointer dereference in is_vm_area_hugepages()
Date: Fri, 29 May 2026 09:41:30 +0800

find_vm_area() can return NULL if the given address is not a valid vmalloc
area.  Check the return value before dereferencing it to avoid a kernel
crash.

Link: https://lore.kernel.org/20260529014130.671291-1-hui.zhu@linux.dev
Fixes: 121e6f3258fe ("mm/vmalloc: hugepage vmalloc mappings")
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/include/linux/vmalloc.h~vmalloc-fix-null-pointer-dereference-in-is_vm_area_hugepages
+++ a/include/linux/vmalloc.h
@@ -265,7 +265,9 @@ static inline bool is_vm_area_hugepages(
 	 * allocated in the vmalloc layer.
 	 */
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMALLOC
-	return find_vm_area(addr)->page_order > 0;
+	struct vm_struct *area = find_vm_area(addr);
+
+	return area && area->page_order > 0;
 #else
 	return false;
 #endif
_

Patches currently in -mm which might be from zhuhui@kylinos.cn are

vmalloc-fix-null-pointer-dereference-in-is_vm_area_hugepages.patch

