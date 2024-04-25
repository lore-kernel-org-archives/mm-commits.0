Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA271400A;
	Thu, 25 Apr 2024 02:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714012526; cv=none; b=ar4fKfgH5ch5g8lihO0AeM/Sn01XJMr4cFKUdFplpd/xWbT//DBKmsWTF9M6nadCjo3kknbi8DQtJOyAwC8jB3+wYFF0nYU2hF3PgreKhfzFbT1vXKGlyb/lD/Aw6k022ViXuxLh16KewNF0CWzAdwoB3YrsjztDnryJJY8MrDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714012526; c=relaxed/simple;
	bh=7lWADWcRgdHS+lyZ5MMspI5vBoDi81coBp1/2ibNtgM=;
	h=Date:To:From:Subject:Message-Id; b=Zc3xWPhm4fCgeF/f+/M5ki+A1j8PszpY7lWq0dmr0LHaEfybSNKtlweSje1kpwrJOSqGS0W6VNyxgaMTQ+6emBPCcnmgvM15sGlaTdvrsIQN0CC6R06L9kp3BkIIZw7JIwjawc8mvNFCfJZlft99vRJGcOZRLsdq/rwygOj83Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GQhXoGOA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GQhXoGOA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABB13C113CD;
	Thu, 25 Apr 2024 02:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714012525;
	bh=7lWADWcRgdHS+lyZ5MMspI5vBoDi81coBp1/2ibNtgM=;
	h=Date:To:From:Subject:From;
	b=GQhXoGOAoi+cUlAWz1AX/OJJnnca7DLbHBldKThCFwTAhnd/beWsME8J2o76GR/Na
	 2/UYun2RVdgUBXtpK6IPCozIhNCfa9FQvgJCcOxbYSeT/igYRP1QCkiijlhyFLyD3o
	 f6DK9KoV9/kGAqg16w2As2gkgra+gd4yn/MzBVds=
Date: Wed, 24 Apr 2024 19:35:25 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,tglx@linutronix.de,stable@vger.kernel.org,sfr@canb.auug.org.au,rppt@kernel.org,ndesaulniers@google.com,mingo@kernel.org,mcgrof@kernel.org,kjlx@templeofstupid.com,geert+renesas@glider.be,christophe.leroy@csgroup.eu,changbin.du@huawei.com,bjorn@kernel.org,arnd@arndb.de,adilger@dilger.ca,namcao@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] init-fix-allocated-page-overlapping-with-ptr_err.patch removed from -mm tree
Message-Id: <20240425023525.ABB13C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: init: fix allocated page overlapping with PTR_ERR
has been removed from the -mm tree.  Its filename was
     init-fix-allocated-page-overlapping-with-ptr_err.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


