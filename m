Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91CC218334;
	Thu,  7 Nov 2024 20:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731012519; cv=none; b=dqLp4EFFfuYsR83SGh3bjoCNQE3HDBg7Zzwu+BxP+ZraiqBeepgRmUu6jXhHfX/9QFVlb9X/Ps3dLrOrqlFnWSkcPQf+RFiEiFg5mSnURTfiKn+Zf84EbHRfslwOhxrK+In3eWvfY/K0COy2WBmef1+yqZfCVPzT7pC1cBbQWB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731012519; c=relaxed/simple;
	bh=nVZtg9BbWoWsgAyytlhrJBD3VWZASOUEVkjyvM2XRLk=;
	h=Date:To:From:Subject:Message-Id; b=hA34+dLUACD0dsguNPiPutVx1iVz5ZICnhuDDOr1VONpaghmOPpM2Q89gnWwzXoF1Jhg2OGjazJUQS4pRPQEQQ6z1eKlK5JYkE6nCxcrnCABnmT5tN7UV1nhCFLKpdtd6StdaFP2mrT1lhcJNxWGh/iOi/ifoq0VrKt8Gc0S6ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HwW4JI+P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HwW4JI+P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F996C4CED2;
	Thu,  7 Nov 2024 20:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731012519;
	bh=nVZtg9BbWoWsgAyytlhrJBD3VWZASOUEVkjyvM2XRLk=;
	h=Date:To:From:Subject:From;
	b=HwW4JI+PEypjBf2+J5zI2RGidLKgMijVCkEXgR2bWwP3SHkP2Cq4o3haDIdPLmd6d
	 uL+iHxZlLIQFNL+UJ3kI4S/fr990+vDrqLyWWx/4lBa0YwgGpWV/RMaABNa5UJXc9p
	 tEeM6keZkKg97t7SzQ+c2JEvs3odSin3W9mAhdv4=
Date: Thu, 07 Nov 2024 12:48:38 -0800
To: mm-commits@vger.kernel.org,Yibo.Cai@arm.com,stable@vger.kernel.org,slp@redhat.com,kirill.shutemov@linux.intel.com,justin.he@arm.com,catalin.marinas@arm.com,lina@asahilina.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-fix-__wp_page_copy_user-fallback-path-for-remote-mm.patch removed from -mm tree
Message-Id: <20241107204839.4F996C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix __wp_page_copy_user fallback path for remote mm
has been removed from the -mm tree.  Its filename was
     mm-fix-__wp_page_copy_user-fallback-path-for-remote-mm.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Asahi Lina <lina@asahilina.net>
Subject: mm: fix __wp_page_copy_user fallback path for remote mm
Date: Fri, 01 Nov 2024 21:08:02 +0900

If the source page is a PFN mapping, we copy back from userspace.
However, if this fault is a remote access, we cannot use
__copy_from_user_inatomic. Instead, use access_remote_vm() in this case.

Fixes WARN and incorrect zero-filling when writing to CoW mappings in
a remote process, such as when using gdb on a binary present on a DAX
filesystem.

[  143.683782] ------------[ cut here ]------------
[  143.683784] WARNING: CPU: 1 PID: 350 at mm/memory.c:2904 __wp_page_copy_user+0x120/0x2bc
[  143.683793] CPU: 1 PID: 350 Comm: gdb Not tainted 6.6.52 #1
[  143.683794] Hardware name: linux,dummy-virt (DT)
[  143.683795] pstate: 61400005 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
[  143.683796] pc : __wp_page_copy_user+0x120/0x2bc
[  143.683798] lr : __wp_page_copy_user+0x254/0x2bc
[  143.683799] sp : ffff80008272b8b0
[  143.683799] x29: ffff80008272b8b0 x28: 0000000000000000 x27: ffff000083bad580
[  143.683801] x26: 0000000000000000 x25: 0000fffff7fd5000 x24: ffff000081db04c0
[  143.683802] x23: ffff00014f24b000 x22: fffffc00053c92c0 x21: ffff000083502150
[  143.683803] x20: 0000fffff7fd5000 x19: ffff80008272b9d0 x18: 0000000000000000
[  143.683804] x17: ffff000081db0500 x16: ffff800080fe52a0 x15: 0000fffff7fd5000
[  143.683804] x14: 0000000000bb1845 x13: 0000000000000080 x12: ffff80008272b880
[  143.683805] x11: ffff000081d13600 x10: ffff000081d13608 x9 : ffff000081d1360c
[  143.683806] x8 : ffff000083a16f00 x7 : 0000000000000010 x6 : ffff00014f24b000
[  143.683807] x5 : ffff00014f24c000 x4 : 0000000000000000 x3 : ffff000083582000
[  143.683807] x2 : 0000000000000f80 x1 : 0000fffff7fd5000 x0 : 0000000000001000
[  143.683808] Call trace:
[  143.683809]  __wp_page_copy_user+0x120/0x2bc
[  143.683810]  wp_page_copy+0x98/0x5c0
[  143.683813]  do_wp_page+0x250/0x530
[  143.683814]  __handle_mm_fault+0x278/0x284
[  143.683817]  handle_mm_fault+0x64/0x1e8
[  143.683819]  faultin_page+0x5c/0x110
[  143.683820]  __get_user_pages+0xc8/0x2f4
[  143.683821]  get_user_pages_remote+0xac/0x30c
[  143.683823]  __access_remote_vm+0xb4/0x368
[  143.683824]  access_remote_vm+0x10/0x1c
[  143.683826]  mem_rw.isra.0+0xc4/0x218
[  143.683831]  mem_write+0x18/0x24
[  143.683831]  vfs_write+0xa0/0x37c
[  143.683834]  ksys_pwrite64+0x7c/0xc0
[  143.683834]  __arm64_sys_pwrite64+0x20/0x2c
[  143.683835]  invoke_syscall+0x48/0x10c
[  143.683837]  el0_svc_common.constprop.0+0x40/0xe0
[  143.683839]  do_el0_svc+0x1c/0x28
[  143.683841]  el0_svc+0x3c/0xdc
[  143.683846]  el0t_64_sync_handler+0x120/0x12c
[  143.683848]  el0t_64_sync+0x194/0x198
[  143.683849] ---[ end trace 0000000000000000 ]---

[akpm@linux-foundation.org: coding style tweaks]
Link: https://lkml.kernel.org/r/20241101-mm-remote-pfn-v1-1-080b609270b7@asahilina.net
Fixes: 3565fce3a659 ("mm, x86: get_user_pages() for dax mappings")
Signed-off-by: Asahi Lina <lina@asahilina.net>
Cc: Jia He <justin.he@arm.com>
Cc: Yibo Cai <Yibo.Cai@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Asahi Lina <lina@asahilina.net>
Cc: Sergio Lopez Pascual <slp@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/mm/memory.c~mm-fix-__wp_page_copy_user-fallback-path-for-remote-mm
+++ a/mm/memory.c
@@ -3082,12 +3082,19 @@ static inline int __wp_page_copy_user(st
 	}
 
 	/*
-	 * This really shouldn't fail, because the page is there
-	 * in the page tables. But it might just be unreadable,
-	 * in which case we just give up and fill the result with
-	 * zeroes.
+	 * If the mm is a remote mm, copy in the page using access_remote_vm()
 	 */
-	if (__copy_from_user_inatomic(kaddr, uaddr, PAGE_SIZE)) {
+	if (current->mm != mm) {
+		if (access_remote_vm(mm, (unsigned long)uaddr, kaddr,
+				     PAGE_SIZE, 0) != PAGE_SIZE)
+			goto warn;
+	} else if (__copy_from_user_inatomic(kaddr, uaddr, PAGE_SIZE)) {
+		/*
+		 * This really shouldn't fail, because the page is there
+		 * in the page tables. But it might just be unreadable,
+		 * in which case we just give up and fill the result with
+		 * zeroes.
+		 */
 		if (vmf->pte)
 			goto warn;
 
_

Patches currently in -mm which might be from lina@asahilina.net are


