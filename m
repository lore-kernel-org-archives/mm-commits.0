Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F70302768;
	Wed,  1 Oct 2025 20:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759351966; cv=none; b=UoPchMISurHqf2k+20xEeXF09s1Bj8bXFvcKXmqKNeFmjubwvL7fb4zOAQhu3WzZylsKfa7rh5ljA8gmaidM62ViM2XcCfs0YOnCpTB3M+odgAbcY0iRZRm95aY6A2pM1UHulXgTj9jH7H3hqQNItSjS923nuIgxK/rpMN8fd+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759351966; c=relaxed/simple;
	bh=nuggKT4B+/cwdFthBZZHXFM/gZ5aXtLjPy9a5wkLf9A=;
	h=Date:To:From:Subject:Message-Id; b=HxOgmyecskc4vAd0yaWcaRztL6BHGboPvMD2qzlwcdaIx3LgUC1sw1d443smUVytYxoWBMEp31558nFylNVrjsH5LPC53fCD5DHm3HfDw32kCy3CwayQtWZQCKj70d5qKVhkY4qa1RIrf/j8hLrmRUsVMM2axd97p2IvcWPFjTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zyybq6Pt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zyybq6Pt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30014C4CEF4;
	Wed,  1 Oct 2025 20:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759351966;
	bh=nuggKT4B+/cwdFthBZZHXFM/gZ5aXtLjPy9a5wkLf9A=;
	h=Date:To:From:Subject:From;
	b=zyybq6Ptc4wn29wkV9AGwrjGxCxwTxZ/KcP6tPaKEWwjv71eE9lY1Vy2ogb+iGlZL
	 PwTa7POjVHBUOBALY3qAnSRAw03NGXYmBBH+db2uemhCwlW4qqN1VxQJq9/I1e5MeC
	 VGmopQ/KhGK5Zln+B85pG/70szfKcFaDqsJ81GAU=
Date: Wed, 01 Oct 2025 13:52:45 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,stable@vger.kernel.org,sj@kernel.org,peterx@redhat.com,david@redhat.com,chengming.zhou@linux.dev,axelrasmussen@google.com,acsjakub@amazon.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-fix-flag-dropping-behavior-in-ksm_madvise.patch added to mm-hotfixes-unstable branch
Message-Id: <20251001205246.30014C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/ksm: fix flag-dropping behavior in ksm_madvise
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-ksm-fix-flag-dropping-behavior-in-ksm_madvise.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-fix-flag-dropping-behavior-in-ksm_madvise.patch

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
From: Jakub Acs <acsjakub@amazon.de>
Subject: mm/ksm: fix flag-dropping behavior in ksm_madvise
Date: Wed, 1 Oct 2025 09:03:52 +0000

syzkaller discovered the following crash: (kernel BUG)

[   44.607039] ------------[ cut here ]------------
[   44.607422] kernel BUG at mm/userfaultfd.c:2067!
[   44.608148] Oops: invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN NOPTI
[   44.608814] CPU: 1 UID: 0 PID: 2475 Comm: reproducer Not tainted 6.16.0-rc6 #1 PREEMPT(none)
[   44.609635] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
[   44.610695] RIP: 0010:userfaultfd_release_all+0x3a8/0x460

<snip other registers, drop unreliable trace>

[   44.617726] Call Trace:
[   44.617926]  <TASK>
[   44.619284]  userfaultfd_release+0xef/0x1b0
[   44.620976]  __fput+0x3f9/0xb60
[   44.621240]  fput_close_sync+0x110/0x210
[   44.622222]  __x64_sys_close+0x8f/0x120
[   44.622530]  do_syscall_64+0x5b/0x2f0
[   44.622840]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   44.623244] RIP: 0033:0x7f365bb3f227

Kernel panics because it detects UFFD inconsistency during
userfaultfd_release_all().  Specifically, a VMA which has a valid pointer
to vma->vm_userfaultfd_ctx, but no UFFD flags in vma->vm_flags.

The inconsistency is caused in ksm_madvise(): when user calls madvise()
with MADV_UNMEARGEABLE on a VMA that is registered for UFFD in MINOR mode,
it accidentally clears all flags stored in the upper 32 bits of
vma->vm_flags.

Assuming x86_64 kernel build, unsigned long is 64-bit and unsigned int and
int are 32-bit wide.  This setup causes the following mishap during the &=
~VM_MERGEABLE assignment.

VM_MERGEABLE is a 32-bit constant of type unsigned int, 0x8000'0000. 
After ~ is applied, it becomes 0x7fff'ffff unsigned int, which is then
promoted to unsigned long before the & operation.  This promotion fills
upper 32 bits with leading 0s, as we're doing unsigned conversion (and
even for a signed conversion, this wouldn't help as the leading bit is 0).
& operation thus ends up AND-ing vm_flags with 0x0000'0000'7fff'ffff
instead of intended 0xffff'ffff'7fff'ffff and hence accidentally clears
the upper 32-bits of its value.

Fix it by changing `VM_MERGEABLE` constant to unsigned long, using the
BIT() macro.

Note: other VM_* flags are not affected: This only happens to the
VM_MERGEABLE flag, as the other VM_* flags are all constants of type int
and after ~ operation, they end up with leading 1 and are thus converted
to unsigned long with leading 1s.

Note 2:
After commit 31defc3b01d9 ("userfaultfd: remove (VM_)BUG_ON()s"), this is
no longer a kernel BUG, but a WARNING at the same place:

[   45.595973] WARNING: CPU: 1 PID: 2474 at mm/userfaultfd.c:2067

but the root-cause (flag-drop) remains the same.

Link: https://lkml.kernel.org/r/20251001090353.57523-2-acsjakub@amazon.de
Fixes: 7677f7fd8be7 ("userfaultfd: add minor fault registration mode")
Signed-off-by: Jakub Acs <acsjakub@amazon.de>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: SeongJae Park <sj@kernel.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-ksm-fix-flag-dropping-behavior-in-ksm_madvise
+++ a/include/linux/mm.h
@@ -296,7 +296,7 @@ extern unsigned int kobjsize(const void
 #define VM_MIXEDMAP	0x10000000	/* Can contain "struct page" and pure PFN pages */
 #define VM_HUGEPAGE	0x20000000	/* MADV_HUGEPAGE marked this vma */
 #define VM_NOHUGEPAGE	0x40000000	/* MADV_NOHUGEPAGE marked this vma */
-#define VM_MERGEABLE	0x80000000	/* KSM may merge identical pages */
+#define VM_MERGEABLE	BIT(31)		/* KSM may merge identical pages */
 
 #ifdef CONFIG_ARCH_USES_HIGH_VMA_FLAGS
 #define VM_HIGH_ARCH_BIT_0	32	/* bit only usable on 64-bit architectures */
_

Patches currently in -mm which might be from acsjakub@amazon.de are

mm-ksm-fix-flag-dropping-behavior-in-ksm_madvise.patch

