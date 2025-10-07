Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1A6170A11;
	Tue,  7 Oct 2025 21:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759870902; cv=none; b=SCKFfI4up5ukgjGcuHQ1hPOCuLLOzL8CYzAN8Gv3o5VZnC//t/7L7BrMLlTWtmTBkpeWzDaozOsD/P60HduYAEHlsG/cLzYSa9cixGptdE0JECbFedvDcFwkR8mxp2Y/wEL974XwaYE93rTQmnL06Ub+wwJNUplsanWDCzS/VL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759870902; c=relaxed/simple;
	bh=Pa4n1uj1XQRZ/idsOah9mEXaKdyFWzFzQiSdelwinD8=;
	h=Date:To:From:Subject:Message-Id; b=S0EGtsyF41c78RXPBok9V1bU1Zjun11rq8dEyVxrSHqCIqReBZQD5rHAjJfeR5ADr+qwaN9Y/eG4OuhK/fqaKGyhFcNxRDZppH3gNZe4+7QGGymR4kjooTCjJ13dwufE8Y2ZnMifkYG9BTbkwff+PYV/pZTjwiXymRy3qr9uL9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jg5JCGD5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jg5JCGD5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6860C4CEF1;
	Tue,  7 Oct 2025 21:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759870901;
	bh=Pa4n1uj1XQRZ/idsOah9mEXaKdyFWzFzQiSdelwinD8=;
	h=Date:To:From:Subject:From;
	b=Jg5JCGD50EzTVPHu6A85KFucPSxnqDdbQV0T/EdjHW40e3bqJvyohXr7/eULKnjZ1
	 bQZhp2aTJRVTZVFw1GSRCWZpoaqPwEfSb//UZ1IPgnzUbtbfxuOHdQTiDS+dHn1F0o
	 /sgX7pas8FLmqDdGHwPQwp8hha9hizhNLqCRavwg=
Date: Tue, 07 Oct 2025 14:01:40 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,stable@vger.kernel.org,sj@kernel.org,peterx@redhat.com,miguel.ojeda.sandonis@gmail.com,david@redhat.com,chengming.zhou@linux.dev,axelrasmussen@google.com,aliceryhl@google.com,acsjakub@amazon.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-ksm-fix-flag-dropping-behavior-in-ksm_madvise.patch removed from -mm tree
Message-Id: <20251007210141.C6860C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ksm: fix flag-dropping behavior in ksm_madvise
has been removed from the -mm tree.  Its filename was
     mm-ksm-fix-flag-dropping-behavior-in-ksm_madvise.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[akpm@linux-foundation.org: rust bindgen wasn't able to handle BIT(), from Miguel]
  Link: https://lore.kernel.org/oe-kbuild-all/202510030449.VfSaAjvd-lkp@intel.com/
Link: https://lkml.kernel.org/r/20251001090353.57523-2-acsjakub@amazon.de
Fixes: 7677f7fd8be7 ("userfaultfd: add minor fault registration mode")
Signed-off-by: Jakub Acs <acsjakub@amazon.de>
Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: SeongJae Park <sj@kernel.org>
Tested-by: Alice Ryhl <aliceryhl@google.com>
Tested-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Xu Xin <xu.xin16@zte.com.cn>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h              |    2 +-
 rust/bindings/bindings_helper.h |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-ksm-fix-flag-dropping-behavior-in-ksm_madvise
+++ a/include/linux/mm.h
@@ -323,7 +323,7 @@ extern unsigned int kobjsize(const void
 #define VM_MIXEDMAP	0x10000000	/* Can contain "struct page" and pure PFN pages */
 #define VM_HUGEPAGE	0x20000000	/* MADV_HUGEPAGE marked this vma */
 #define VM_NOHUGEPAGE	0x40000000	/* MADV_NOHUGEPAGE marked this vma */
-#define VM_MERGEABLE	0x80000000	/* KSM may merge identical pages */
+#define VM_MERGEABLE	BIT(31)		/* KSM may merge identical pages */
 
 #ifdef CONFIG_ARCH_USES_HIGH_VMA_FLAGS
 #define VM_HIGH_ARCH_BIT_0	32	/* bit only usable on 64-bit architectures */
--- a/rust/bindings/bindings_helper.h~mm-ksm-fix-flag-dropping-behavior-in-ksm_madvise
+++ a/rust/bindings/bindings_helper.h
@@ -108,6 +108,7 @@ const xa_mark_t RUST_CONST_HELPER_XA_PRE
 
 const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC = XA_FLAGS_ALLOC;
 const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC1 = XA_FLAGS_ALLOC1;
+const vm_flags_t RUST_CONST_HELPER_VM_MERGEABLE = VM_MERGEABLE;
 
 #if IS_ENABLED(CONFIG_ANDROID_BINDER_IPC_RUST)
 #include "../../drivers/android/binder/rust_binder.h"
_

Patches currently in -mm which might be from acsjakub@amazon.de are

mm-redefine-vm_-flag-constants-with-bit.patch

