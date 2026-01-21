Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F09A40759A
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 20:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769027968; cv=none; b=ekK6CETRGYnc5nLTOjjRZCUXAU4WUl76HjaDP3KXArV86W1HlKyykQSDwfkG0txGiw2zZLfkLEfdoUWTW8Ch3iGpu66a6jri6q6Vx0CrBNrFuWdwbtYK4M/YanlyOo1alKoigV7e3L3q8On7qa6EHkzR9cp6sCYJgm1zrbK38K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769027968; c=relaxed/simple;
	bh=Ox2Szb4OW50vOdCG/m50fjT4mDBLnOLf3P6qFYrh88w=;
	h=Date:To:From:Subject:Message-Id; b=sd+uYMLpXEp6IP6YcihSMZ50l0xppauOzgU5/2/t0y/eGA+8HwnqLyEBRvEVxUrdcRhDby8RRwSKTXB7Q9nq4cP3mmEuOybmC4jiFcLyIlWDbeWyBNkm0QLMIcO+f2OP5yHZQhlRQfddlwqMEk4G6zKCoKj9fSu8hv3JO7LLqwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=th03Ktte; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="th03Ktte"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82415C4CEF1;
	Wed, 21 Jan 2026 20:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769027967;
	bh=Ox2Szb4OW50vOdCG/m50fjT4mDBLnOLf3P6qFYrh88w=;
	h=Date:To:From:Subject:From;
	b=th03KtterA+iXkW+t/4MMRfQs7c17wIHdPqjtY+oTb17URN0QYQ51SqkuKOMU76JY
	 +9do4PE+OGITlw/zjtMJmT3V2c+7y7a1+W9Z9kE2C8YW4PupXzBGpVanzpae8Kstgq
	 HifJjCoHy3FzwmG7q8vZ3lX5wIG0Yz4WtiauNbrY=
Date: Wed, 21 Jan 2026 12:39:26 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,lkp@intel.com,jgg@nvidia.com,graf@amazon.com,dan.carpenter@linaro.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-kho_preserve_vmalloc-dont-return-0-when-enomem.patch added to mm-nonmm-unstable branch
Message-Id: <20260121203927.82415C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: kho_preserve_vmalloc(): don't return 0 when ENOMEM
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-kho_preserve_vmalloc-dont-return-0-when-enomem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-kho_preserve_vmalloc-dont-return-0-when-enomem.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kho: kho_preserve_vmalloc(): don't return 0 when ENOMEM
Date: Wed Jan 21 12:36:17 PM PST 2026

kho_preserve_vmalloc() should return -ENOMEM when new_vmalloc_chunk()
fails.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202601211636.IRaejjdw-lkp@intel.com/
Cc: Alexander Graf <graf@amazon.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-kho_preserve_vmalloc-dont-return-0-when-enomem
+++ a/kernel/liveupdate/kexec_handover.c
@@ -1011,8 +1011,10 @@ int kho_preserve_vmalloc(void *ptr, stru
 		chunk->phys[idx++] = phys;
 		if (idx == ARRAY_SIZE(chunk->phys)) {
 			chunk = new_vmalloc_chunk(chunk);
-			if (!chunk)
+			if (!chunk) {
+				err = -ENOMEM;
 				goto err_free;
+			}
 			idx = 0;
 		}
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix-fix.patch
mm-relocate-the-page-table-ceiling-and-floor-definitions-fix.patch
mm-add-wq_percpu-to-alloc_workqueue-users-fix.patch
sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests-fix.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch
mm-pagewalk-use-min-to-simplify-the-code-fix.patch
vmcoreinfo-make-hwerr_data-visible-for-debugging-fix.patch
kho-kho_preserve_vmalloc-dont-return-0-when-enomem.patch

