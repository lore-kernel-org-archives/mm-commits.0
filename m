Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22711A6829
	for <mm-commits@vger.kernel.org>; Sun,  5 Jul 2026 02:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783218386; cv=none; b=GH9MnmlzA9pEzH3O+kVcybRE603koPd3fqPxRbkYOlt59nFWJ45dqEQWjXVrzIorAUPpszoc7rGdwgRjZ5HpvgNNiwBEaDJ/D6Mym16r3j0/V5ma6/qkksXSq5H7Hc85RNnailwzY3TuWypQijRvjur8yb06fsy0SjP+3C/Lc2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783218386; c=relaxed/simple;
	bh=pW+sNO3UzO1wkPRbA8HONrMI3wCZK1rPVUT7p1eqAKc=;
	h=Date:To:From:Subject:Message-Id; b=alJ7olXngCLaEYx5CkJcBTM+MoSv1yJsaaHyIl3KVYjAQ7kGALngOr31POIaG7kMy3Aq5vll/OmxowdQzi7gyMwySpKiKzyEAkTpPtM/oioZvoHbKZm/rAcu6JbOB1tgSR6bx1BA7hV89cGLeUd4dmPZLYGipKXIid7LxHmpKdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C5uPIgst; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C5uPIgst"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714FA1F000E9;
	Sun,  5 Jul 2026 02:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783218384;
	bh=3elzxcjJwW9czeh1DBh8aDWQlcTgCGJCxxh7qBsxnJA=;
	h=Date:To:From:Subject;
	b=C5uPIgstekpcCLK0feRQFBJJS0c+qIsSq0JGNrpcCy8McUeSjAi0Urt80Eh3HPgr/
	 XpEd9vWxsJ+T/FmAMiIb58J74CGpA0xbjfC/UItoDFw4ILr9WjLiyJfB8w2VFsphWE
	 VMUqmvJ4UnHP8X8i3j3vKbrdwpwUs7FG8uHwU+JI=
Date: Sat, 04 Jul 2026 19:26:24 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-secretmem-disable-under-highmem.patch added to mm-new branch
Message-Id: <20260705022624.714FA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/secretmem: disable under HIGHMEM
has been added to the -mm mm-new branch.  Its filename is
     mm-secretmem-disable-under-highmem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-secretmem-disable-under-highmem.patch

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
From: Brendan Jackman <jackmanb@google.com>
Subject: mm/secretmem: disable under HIGHMEM
Date: Fri, 03 Jul 2026 14:48:26 +0000

secretmem_fault() allocates a folio with GFP_HIGHUSER and then calls
set_direct_map_valid_noflush() without checking folio_test_highmem(). 
This causes a warning and process crash (vibe-coded reproducer in Link
below):

Su[   30.071284] ------------[ cut here ]------------
ccessfully allocated and mapped 2097152000 bytes at 0x3a449000
Populating memor[   30.074614] CPA: called for zero pte. vaddr = 0 cpa->vaddr = 0
y...
[   30.078636] WARNING: arch/x86/mm/pat/set_memory.c:1840 at __cpa_process_fault+0x34d/0x360, CPU#5: allocate_secret/570
[   30.084789] CPU: 5 UID: 0 PID: 570 Comm: allocate_secret Not tainted 7.1.0-14063-g4edcdefd4083-dirty #10 PREEMPTLAZY
[   30.090937] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
[   30.097543] EIP: __cpa_process_fault+0x34d/0x360
[   30.100514] Code: ff ff 85 c0 0f 89 7d fe ff ff e9 3d fe ff ff 8b 03 8b 00 c7 04 24 c8 ff 64 c1 89 44 24 08 8b 45 e8 89 44 24 04 e8 53 7
a 00 00 <0f> 0b c7 45 f0 f2 ff ff ff e9 fc fc ff ff 90 8d 74 26 00 55 25 00
[   30.110829] EAX: 00000000 EBX: f64afe98 ECX: 00000000 EDX: 00000000
[   30.114799] ESI: 00000000 EDI: f64afe98 EBP: f64afe04 ESP: f64afdcc
[   30.118785] DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068 EFLAGS: 00010246
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
[   30.162307] Code: 89 54 08 e1 89 54 08 e5 89 54 08 e9 89 54 08 ed c3 0f b6 44 24 08 89 7c 24 0c 69 c0 01 01 01 01 8b 7c 24 04 f7 c7 0f 0
0 00 00 <89> 44 0f fc 75 0e c1 e9 02 f3 ab 8b 44 24 04 8b 7c 24 0c c3 31 d2
[   30.172936] EAX: 5a5a5a5a EBX: 00000000 ECX: 0c800000 EDX: 3a449000
[   30.176927] ESI: 00000000 EDI: 3a449000 EBP: bfbbae18 ESP: bfbbadac
[   30.180897] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00010246
[   30.185161]  ? doublefault_shim+0x150/0x150
[   30.187979] ---[ end trace 0000000000000000 ]---
Bus error                  (core dumped) ./allocate_secret_i686 2000M

The equivalent bug was pointed out by a local Sashiko instance on
https://lore.kernel.org/all/20260410151746.61150-3-kalyazin@amazon.com/

This hasn't been reproduced on older kernel versions but from code
inspection the bug seems to go back to the original introduction in commit
1507f51255c9f ("mm: introduce memfd_secret system call to create "secret"
memory areas").  If this configuration has always been broken, dropping
support is not really a regression, so do that.

Link: https://github.com/bjackman/limmat-kernel-nix/commit/7b2acba2d3a5ef01400d493a155beb1d135b6bb5
Link: https://lore.kernel.org/20260703-secretmem-highmem-v1-1-30d5ff944664@google.com
Fixes: 1507f51255c9f ("mm: introduce memfd_secret system call to create "secret" memory areas")
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/Kconfig~mm-secretmem-disable-under-highmem
+++ a/mm/Kconfig
@@ -1356,7 +1356,7 @@ config MEMFD_CREATE
 config SECRETMEM
 	default y
 	bool "Enable memfd_secret() system call" if EXPERT
-	depends on ARCH_HAS_SET_DIRECT_MAP
+	depends on ARCH_HAS_SET_DIRECT_MAP && !HIGHMEM
 	help
 	  Enable the memfd_secret() system call with the ability to create
 	  memory areas visible only in the context of the owning process and
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-page_alloc-drop-flag-conversion-optimisation.patch
mm-secretmem-disable-under-highmem.patch

