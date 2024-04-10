Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4CB168DC
	for <mm-commits@vger.kernel.org>; Wed, 10 Apr 2024 18:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712772573; cv=none; b=Rdl8VPZxxcYxUKsRo+wQBmiD19u9ErfA1If9WUJyfdiUv++hd64WbWTUbOL7p3ydvZ76FeNOKj5Tk1pokeSrMGWorh8lIIgxfGKm/4p1DW7gEzaFFdbkU22kr0ZwWMvBaBUZIDtm4ZcEPI1Dc1extRdZg+j4V8sVYrfmvAsWS6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712772573; c=relaxed/simple;
	bh=QwtGzz2ta7kTrdDdLPHR04yifDPZ4v3+X58WCkYZqZw=;
	h=Date:To:From:Subject:Message-Id; b=B2RO6QI01lYcjfPa8gEvFxdA3S41MMx5TS5rBFyQ/bNeKjPQLyr7Znsa87qYmO8/QfEdTvtXC3I3/a7k26W+DeZTemP86JzY1rL4R1Q7ceqqt+TSTXT5rvVQ7z4LJyl0qbiOVTkiZAJmjCIJTkDSt59iBuLRZZQRDabG9q68v8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tKyVfdZ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tKyVfdZ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AEADC433F1;
	Wed, 10 Apr 2024 18:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712772573;
	bh=QwtGzz2ta7kTrdDdLPHR04yifDPZ4v3+X58WCkYZqZw=;
	h=Date:To:From:Subject:From;
	b=tKyVfdZ8yzimogEywHFN53hEzlUcBC9pP9w36DD9xsN9r0y68PA+TovbWHclVYrfO
	 wApqdXBGyw96OaMzbfc0TWYFq1b7ayy8UQk3jAKmHjFb3wRsAfi/3CtOlZjntu6JIn
	 vBqxvQeA7fgcPK+66AfVKk0HWFu0cdFK7LQmc00c=
Date: Wed, 10 Apr 2024 11:09:32 -0700
To: mm-commits@vger.kernel.org,alexghiti@rivosinc.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-mm-accelerate-pagefault-when-badaccess-fix.patch added to mm-unstable branch
Message-Id: <20240410180933.5AEADC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: riscv-mm-accelerate-pagefault-when-badaccess-fix
has been added to the -mm mm-unstable branch.  Its filename is
     riscv-mm-accelerate-pagefault-when-badaccess-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-mm-accelerate-pagefault-when-badaccess-fix.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: riscv-mm-accelerate-pagefault-when-badaccess-fix
Date: Wed, 10 Apr 2024 16:07:41 +0800

use `cause' rather than SIGSEGV, per Alexandre

Link: https://lkml.kernel.org/r/ac978061-ce1a-40a4-8b0a-61883b42bea7@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Tested-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/mm/fault.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/riscv/mm/fault.c~riscv-mm-accelerate-pagefault-when-badaccess-fix
+++ a/arch/riscv/mm/fault.c
@@ -293,8 +293,8 @@ void handle_page_fault(struct pt_regs *r
 	if (unlikely(access_error(cause, vma))) {
 		vma_end_read(vma);
 		count_vm_vma_lock_event(VMA_LOCK_SUCCESS);
-		tsk->thread.bad_cause = SEGV_ACCERR;
-		bad_area_nosemaphore(regs, code, addr);
+		tsk->thread.bad_cause = cause;
+		bad_area_nosemaphore(regs, SEGV_ACCERR, addr);
 		return;
 	}
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-backing-dev-use-group-allocation-free-of-per-cpu-counters-api.patch
mm-remove-__set_page_dirty_nobuffers.patch
arm64-mm-cleanup-__do_page_fault.patch
arm64-mm-accelerate-pagefault-when-vm_fault_badaccess.patch
arm-mm-accelerate-pagefault-when-vm_fault_badaccess.patch
powerpc-mm-accelerate-pagefault-when-badaccess.patch
riscv-mm-accelerate-pagefault-when-badaccess.patch
riscv-mm-accelerate-pagefault-when-badaccess-fix.patch
s390-mm-accelerate-pagefault-when-badaccess.patch
x86-mm-accelerate-pagefault-when-badaccess.patch
arm64-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch
arm-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch

