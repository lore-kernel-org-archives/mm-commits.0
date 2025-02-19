Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD1118BB8E
	for <mm-commits@vger.kernel.org>; Wed, 19 Feb 2025 04:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739937860; cv=none; b=hTzj22m7PF2uI3FijcYt0wIK72Qz8UoyzNvhTGmdjaA26/ljHBjiVRmjRye13zUW3QciLzJ1Znlz/LYwcpnQZGzSIMduWB3pFi7vcQiwL/aDSOYzshwlBL4hmoaLSZpnTsobzcdOOYa7rPG2+ucWi5JQG0HjenR2GM+VjF4c7fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739937860; c=relaxed/simple;
	bh=gmHa0NcPYTHrnxGfdq5fXvYqsTW5QlHSKYkBjTCmS+w=;
	h=Date:To:From:Subject:Message-Id; b=Z/OEUIxwcU3FlxlYSJ8phqOoY+MO3H2d4bNADvkAPBQQgh7XAsoor9SZxh+MJq4/LS0gItET42PzazVFQqthfPp89tQQb0CdaDLTd+b3NIRMIHewzTZ4vyIekxI1G7yyKGJxLR5xKSW42Vo02bRJiOXaTDCvsOM3ebkSzwJhfew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UliMUTOZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UliMUTOZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77632C4CED1;
	Wed, 19 Feb 2025 04:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739937859;
	bh=gmHa0NcPYTHrnxGfdq5fXvYqsTW5QlHSKYkBjTCmS+w=;
	h=Date:To:From:Subject:From;
	b=UliMUTOZI+L0Lk3IkoBCL3p3IxMTF0WV5JM4L4DgDarjXPfeSVYNbwS5qWvhdAj5q
	 dEOJbUhhQX5iJVezKtQZOKdZvsVFf9/Vopmf9VpgjlK3nqDhukr9M1H2kEJ49+zpsr
	 5MnB/3XUJA/f79q2gVDI9yO5m0yL1RgFtfgNGoUs=
Date: Tue, 18 Feb 2025 20:04:18 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,surenb@google.com,baohua@kernel.org,gaoxu2@honor.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-possible-null-pointer-dereference-in-__swap_duplicate.patch added to mm-hotfixes-unstable branch
Message-Id: <20250219040419.77632C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix possible NULL pointer dereference in __swap_duplicate
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-possible-null-pointer-dereference-in-__swap_duplicate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-possible-null-pointer-dereference-in-__swap_duplicate.patch

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
From: gaoxu <gaoxu2@honor.com>
Subject: mm: fix possible NULL pointer dereference in __swap_duplicate
Date: Wed, 19 Feb 2025 01:56:28 +0000

Add a NULL check on the return value of swp_swap_info in __swap_duplicate
to prevent crashes caused by NULL pointer dereference.

The reason why swp_swap_info() returns NULL is unclear; it may be due to
CPU cache issues or DDR bit flips.  The probability of this issue is very
small, and the stack info we encountered is as follows:

Unable to handle kernel NULL pointer dereference at virtual address
0000000000000058
[RB/E]rb_sreason_str_set: sreason_str set null_pointer
Mem abort info:
  ESR = 0x0000000096000005
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x05: level 1 translation fault
Data abort info:
  ISV = 0, ISS = 0x00000005, ISS2 = 0x00000000
  CM = 0, WnR = 0, TnD = 0, TagAccess = 0
  GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
user pgtable: 4k pages, 39-bit VAs, pgdp=00000008a80e5000
[0000000000000058] pgd=0000000000000000, p4d=0000000000000000,
pud=0000000000000000
Internal error: Oops: 0000000096000005 [#1] PREEMPT SMP
Skip md ftrace buffer dump for: 0x1609e0
...
pc : swap_duplicate+0x44/0x164
lr : copy_page_range+0x508/0x1e78
sp : ffffffc0f2a699e0
x29: ffffffc0f2a699e0 x28: ffffff8a5b28d388 x27: ffffff8b06603388
x26: ffffffdf7291fe70 x25: 0000000000000006 x24: 0000000000100073
x23: 00000000002d2d2f x22: 0000000000000008 x21: 0000000000000000
x20: 00000000002d2d2f x19: 18000000002d2d2f x18: ffffffdf726faec0
x17: 0000000000000000 x16: 0010000000000001 x15: 0040000000000001
x14: 0400000000000001 x13: ff7ffffffffffb7f x12: ffeffffffffffbff
x11: ffffff8a5c7e1898 x10: 0000000000000018 x9 : 0000000000000006
x8 : 1800000000000000 x7 : 0000000000000000 x6 : ffffff8057c01f10
x5 : 000000000000a318 x4 : 0000000000000000 x3 : 0000000000000000
x2 : 0000006daf200000 x1 : 0000000000000001 x0 : 18000000002d2d2f
Call trace:
 swap_duplicate+0x44/0x164
 copy_page_range+0x508/0x1e78
 copy_process+0x1278/0x21cc
 kernel_clone+0x90/0x438
 __arm64_sys_clone+0x5c/0x8c
 invoke_syscall+0x58/0x110
 do_el0_svc+0x8c/0xe0
 el0_svc+0x38/0x9c
 el0t_64_sync_handler+0x44/0xec
 el0t_64_sync+0x1a8/0x1ac
Code: 9139c35a 71006f3f 54000568 f8797b55 (f9402ea8)
---[ end trace 0000000000000000 ]---
Kernel panic - not syncing: Oops: Fatal exception
SMP: stopping secondary CPUs

The patch seems to only provide a workaround, but there are no more
effective software solutions to handle the bit flips problem.  This path
will change the issue from a system crash to a process exception, thereby
reducing the impact on the entire machine.

Signed-off-by: gao xu <gaoxu2@honor.com>

Link: https://lkml.kernel.org/r/e223b0e6ba2f4924984b1917cc717bd5@honor.com
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/swapfile.c~mm-fix-possible-null-pointer-dereference-in-__swap_duplicate
+++ a/mm/swapfile.c
@@ -3542,6 +3542,10 @@ static int __swap_duplicate(swp_entry_t
 	int err, i;
 
 	si = swp_swap_info(entry);
+	if (WARN_ON_ONCE(!si)) {
+		pr_err("%s%08lx\n", Bad_file, entry.val);
+		return -EINVAL;
+	}
 
 	offset = swp_offset(entry);
 	VM_WARN_ON(nr > SWAPFILE_CLUSTER - offset % SWAPFILE_CLUSTER);
_

Patches currently in -mm which might be from gaoxu2@honor.com are

mm-fix-possible-null-pointer-dereference-in-__swap_duplicate.patch

