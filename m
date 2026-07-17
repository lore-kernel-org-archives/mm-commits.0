Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C0B175A7F
	for <mm-commits@vger.kernel.org>; Fri, 17 Jul 2026 18:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784313937; cv=none; b=p1e+ifS8if+iF72GuR3pHeSx+Il2gEGf+la5tVnDtV/clDC7a1ZFKhv3DPkfgQY0BpFoaYgg/2xgONRPyYO2aNv9dCMFY2KgFctn0/QCR5iHAbYo0dIk67UTM5mDwi0xHnLzgnzFVHKW7Udt79i4F9pSJr1rcocygEsremf+0/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784313937; c=relaxed/simple;
	bh=/ZTnqYtEN+imLV6TnyeIyJi8T28rZx+YfO9bAA21trI=;
	h=Date:To:From:Subject:Message-Id; b=tWa3/4jFOx4kdXZdhY7+G9T19LVgE0roKxZ1c0HcSuRcH21EwQqeereXQdG+e8UY/vEnZN7c03joi0J/OWj3215CLQTJdzu4X7otcxi/dG+GL7N2jB+DAne5sZtGFAOSh4nZ/eAjsZme27ZeiiU8Oln48BsoZ0a/S4tRXVQiLUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sarT7kM9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sarT7kM9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D25ED1F000E9;
	Fri, 17 Jul 2026 18:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784313935;
	bh=+b33KO7ZLWFjsW59m4YbzdrbuE9D7d0AYeX/JpNant0=;
	h=Date:To:From:Subject;
	b=sarT7kM9yYNzS0vnyLrDnh8NAe4CcEwWt1GRQvA2q5sQFIVapobX7pYaYi1UNv5MD
	 B2MiDKbIrw4ykjhd6QnMI+JQfP3yW/gnacL5XZMa8sYNnrlvVTKFqybZv3XLSdRnHx
	 jatj81s6cF6cUIOILfSAwC9Bk1gcT1XprvMqWAo8=
Date: Fri, 17 Jul 2026 11:45:35 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,akpm@linux-foundation.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-secretmem-dont-allow-highmem-folios.patch added to mm-unstable branch
Message-Id: <20260717184535.D25ED1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/secretmem: don't allow highmem folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-secretmem-dont-allow-highmem-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-secretmem-dont-allow-highmem-folios.patch

This patch will later appear in the mm-unstable branch at
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
From: Brendan Jackman <jackmanb@google.com>
Subject: mm/secretmem: don't allow highmem folios
Date: Fri, 17 Jul 2026 09:48:59 +0000

secretmem_fault() allocates a folio with GFP_HIGHUSER and then calls
set_direct_map_invalid_noflush() without checking folio_test_highmem(). 
This causes a warning and process crash (vibe-coded reproducer in Link
below):

Su[   30.071284] ------------[ cut here ]------------
ccessfully allocated and mapped 2097152000 bytes at 0x3a449000
Populating memor[   30.074614] CPA: called for zero pte. vaddr =3D 0 cpa->v=
addr =3D 0
y...
[   30.078636] WARNING: arch/x86/mm/pat/set_memory.c:1840 at __cpa_process_=
fault+0x34d/0x360, CPU#5: allocate_secret/570
[   30.084789] CPU: 5 UID: 0 PID: 570 Comm: allocate_secret Not tainted 7.1=
.0-14063-g4edcdefd4083-dirty #10 PREEMPTLAZY
[   30.090937] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
[   30.097543] EIP: __cpa_process_fault+0x34d/0x360
[   30.100514] Code: ff ff 85 c0 0f 89 7d fe ff ff e9 3d fe ff ff 8b 03 8b =
00 c7 04 24 c8 ff 64 c1 89 44 24 08 8b 45 e8 89 44 24 04 e8 53 7
a 00 00 <0f> 0b c7 45 f0 f2 ff ff ff e9 fc fc ff ff 90 8d 74 26 00 55 25 00
[   30.110829] EAX: 00000000 EBX: f64afe98 ECX: 00000000 EDX: 00000000
[   30.114799] ESI: 00000000 EDI: f64afe98 EBP: f64afe04 ESP: f64afdcc
[   30.118785] DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068 EFLAGS: 0001024=
6
[   30.123020] CR0: 80050033 CR2: 46c48ffc CR3: 038c8000 CR4: 00000690
[   30.127010] Call Trace:
[   30.129078]  __change_page_attr_set_clr+0x5e7/0x870
[   30.132275]  ? console_unlock+0x99/0x130
[   30.135069]  ? irq_work_queue+0x36/0x70
[   30.137853]  ? page_address+0xd3/0xf0
[   30.140421]  set_direct_map_invalid_noflush+0x52/0x60
[   30.143782]  secretmem_fault+0x128/0x210
[   30.146560]  __do_fault+0x25/0x90
[   30.149053]  handle_mm_fault+0x6d1/0xcb0
[   30.151759]  exc_page_fault+0x135/0x3b0
[   30.154487]  ? doublefault_shim+0x150/0x150
[   30.157416]  handle_exception+0x130/0x130
[   30.160137] EIP: 0x804d29f
[   30.162307] Code: 89 54 08 e1 89 54 08 e5 89 54 08 e9 89 54 08 ed c3 0f =
b6 44 24 08 89 7c 24 0c 69 c0 01 01 01 01 8b 7c 24 04 f7 c7 0f 0
0 00 00 <89> 44 0f fc 75 0e c1 e9 02 f3 ab 8b 44 24 04 8b 7c 24 0c c3 31 d2
[   30.172936] EAX: 5a5a5a5a EBX: 00000000 ECX: 0c800000 EDX: 3a449000
[   30.176927] ESI: 00000000 EDI: 3a449000 EBP: bfbbae18 ESP: bfbbadac
[   30.180897] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 0001024=
6
[   30.185161]  ? doublefault_shim+0x150/0x150
[   30.187979] ---[ end trace 0000000000000000 ]---
Bus error                  (core dumped) ./allocate_secret_i686 2000M

The equivalent bug was pointed out by a local Sashiko instance on
https://lore.kernel.org/all/20260410151746.61150-3-kalyazin@amazon.com/

This hasn't been reproduced it on older kernel versions but from code
inspection the bug seems to go back to the original introduction in commit
1507f51255c9f ("mm: introduce memfd_secret system call to create "secret"
memory areas").  If this configuration has always been broken, there's no
need to worry too much about feature regression here.

Nonetheless, instead of just completely disabling secretmem under
!HIGHMEM, just drop __GFP_HIGHMEM.  This means that now where you
previously got a crash, instead you'll just see the secretmem process OOM.

Could secretmem just support highmem by saying "this isn't in the direct
map anyway" and bailing out before the set_direct_map_invalid_noflush()? 
Maybe.  That depends on requirements that are not well-defined (e.g.  is
it OK that kmap_local_page() is not a NOP for those pages?), and would
require some research and deep thinking.  Let's "defer" that until an
actual usecase arises.

Link: https://github.com/bjackman/limmat-kernel-nix/commit/7b2acba2d3a5ef01=
400d493a155beb1d135b6bb5
Link: https://lore.kernel.org/20260717-secretmem-highmem-v2-1-1f1a961ca91e@google.com
Link: https://lore.kernel.org/all/20260704192603.40aa80cf9242b77aa75e8d8d@l=
inux-foundation.org/
Fixes: 1507f51255c9f ("mm: introduce memfd_secret system call to create "se=
cret" memory areas")
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/secretmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/secretmem.c~mm-secretmem-dont-allow-highmem-folios
+++ a/mm/secretmem.c
@@ -202,7 +202,7 @@ static struct file *secretmem_file_creat
 	if (IS_ERR(file))
 		goto err_free_inode;
 
-	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
+	mapping_set_gfp_mask(inode->i_mapping, GFP_USER);
 	mapping_set_unevictable(inode->i_mapping);
 
 	inode->i_op = &secretmem_iops;
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-page_alloc-drop-flag-conversion-optimisation.patch
mm-page_alloc-rename-alloc_trylock-alloc_nolock.patch
mm-page_alloc-some-renames-to-clarify-alloc_flags-scopes.patch
mm-name-some-args-in-a-function-declaration.patch
mm-split-out-internal-page_alloch.patch
mm-page_alloc-unify-__alloc_frozen_pages_noprof.patch
mm-page_alloc-relax-gfp-warn-in-nolock-allocs.patch
mm-move-some-stuff-to-mm-page_alloch.patch
perf-x86-intel-use-higher-level-allocator-api.patch
kvm-vmx-use-higher-level-allocator-api.patch
x86-virt-use-higher-level-allocator-api.patch
sgi-xp-use-higher-level-allocator-api.patch
net-funeth-switch-to-higher-level-allocator-api.patch
mm-remove-__alloc_pages_node.patch
mm-move-__alloc_pages-to-mm-page_alloch.patch
mm-replace-__gfp_no_codetag-with-alloc_no_codetag.patch
mm-page_alloc-drop-alloc_flags-arg-from-alloc_flags_cma.patch
mm-factor-out-can_spin_trylock.patch
mm-secretmem-dont-allow-highmem-folios.patch
mm-page_alloc-dont-spin_trylock-in-nmi-on-up.patch
mm-page_alloc-dont-spin_trylock-when-disallowed-in-free_one_page.patch
mm-page_alloc-rename-fpi_trylock-fpi_nolock.patch
cgroup-cpuset-update-some-comments-about-the-page-allocator.patch
mm-page_alloc-fixup-alloc_pages_nolock_noprof-comment.patch
mm-page_alloc-remove-a-couple-of-vm_bug_onst.patch

