Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305DF3D62;
	Thu, 18 Apr 2024 20:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713470590; cv=none; b=eQLZ4A4FVM6s1tDVZLtkoLHMeXwTEedhvLBTeOQhlEFj7eWJn+3bBY25z18HwEV4ZkzQCWrN5SGNKEmGbwtmp0Tb2l1IrHA0Z/uQYf2U7uV50WAEKAQYtcUxcfkmb3ZvkVz6VrElhI1Z5NgWdcO+H03W2VcDr6ntCqPsOfj2w7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713470590; c=relaxed/simple;
	bh=swxBHLx04q7zzE0dJIjK8VJkkGccJMLgfmxihuOcs6E=;
	h=Date:To:From:Subject:Message-Id; b=aKomWoezSy8bL1I0J/tUoYb2Pq4SoZ9y+PsSMow6R4OzlJ1txCq2kk6v/pAV93tXGuGpzG8wMQ6bVK2LAuG0GkVuDk78wpW3mlSRpS9hbzN2eyK+oToA/OYGjWVCcnSYBmbCLb890yjP7BFmzpyUtW9TG+EgOPaPQZnyxRj8Fqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vZU6Qzwa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vZU6Qzwa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05A6C113CC;
	Thu, 18 Apr 2024 20:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713470589;
	bh=swxBHLx04q7zzE0dJIjK8VJkkGccJMLgfmxihuOcs6E=;
	h=Date:To:From:Subject:From;
	b=vZU6QzwaJIu3D6dVxVT4BW3IFkfkai+sUUKPiH1PMhPxlGQ/qxeJkANgfv93W5m4p
	 FKtldM2CYrPdmqowJ+1oKSsz+lkhgVi8GkrM/C7GL02qtu/67+6bKjaolo0uNW6Bwo
	 UB9jNmU+rlVIOr71t+MfMa1SBcCsAwnO3jrk0TUI=
Date: Thu, 18 Apr 2024 13:03:09 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,tglx@linutronix.de,stable@vger.kernel.org,sfr@canb.auug.org.au,rppt@kernel.org,ndesaulniers@google.com,mingo@kernel.org,mcgrof@kernel.org,kjlx@templeofstupid.com,geert+renesas@glider.be,christophe.leroy@csgroup.eu,changbin.du@huawei.com,bjorn@kernel.org,arnd@arndb.de,adilger@dilger.ca,namcao@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + init-fix-allocated-page-overlapping-with-ptr_err.patch added to mm-hotfixes-unstable branch
Message-Id: <20240418200309.A05A6C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: init: fix allocated page overlapping with PTR_ERR
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     init-fix-allocated-page-overlapping-with-ptr_err.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-fix-allocated-page-overlapping-with-ptr_err.patch

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
From: Nam Cao <namcao@linutronix.de>
Subject: init: fix allocated page overlapping with PTR_ERR
Date: Thu, 18 Apr 2024 12:29:43 +0200

There is nothing preventing kernel memory allocators from allocating a
page that overlaps with PTR_ERR(), except for architecture-specific code
that setup memblock.

It was discovered that RISCV architecture doesn't setup memblock corectly,
leading to a page overlapping with PTR_ERR() being allocated, and
subsequently crashing the kernel (link in Close: )

The reported crash has nothing to do with PTR_ERR(): the last page (at
address 0xfffff000) being allocated leads to an unexpected arithmetic
overflow in ext4; but still, this page shouldn't be allocated in the first
place.

Because PTR_ERR() is an architecture-independent thing, we shouldn't ask
every single architecture to set this up.  There may be other
architectures beside RISCV that have the same problem.

Fix this once and for all by reserving the physical memory page that may
be mapped to the last virtual memory page as part of low memory.

Unfortunately, this means if there is actual memory at this reserved
location, that memory will become inaccessible.  However, if this page is
not reserved, it can only be accessed as high memory, so this doesn't
matter if high memory is not supported.  Even if high memory is supported,
it is still only one page.

Closes: https://lore.kernel.org/linux-riscv/878r1ibpdn.fsf@all.your.base.are.belong.to.us
Link: https://lkml.kernel.org/r/20240418102943.180510-1-namcao@linutronix.de
Signed-off-by: Nam Cao <namcao@linutronix.de>
Reported-by: Björn Töpel <bjorn@kernel.org>
Tested-by: Björn Töpel <bjorn@kernel.org>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Andreas Dilger <adilger@dilger.ca>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Changbin Du <changbin.du@huawei.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Krister Johansen <kjlx@templeofstupid.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/init/main.c~init-fix-allocated-page-overlapping-with-ptr_err
+++ a/init/main.c
@@ -900,6 +900,7 @@ void start_kernel(void)
 	page_address_init();
 	pr_notice("%s", linux_banner);
 	early_security_init();
+	memblock_reserve(__pa(-PAGE_SIZE), PAGE_SIZE); /* reserve last page for ERR_PTR */
 	setup_arch(&command_line);
 	setup_boot_config();
 	setup_command_line(command_line);
_

Patches currently in -mm which might be from namcao@linutronix.de are

init-fix-allocated-page-overlapping-with-ptr_err.patch

