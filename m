Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D49419F127
	for <mm-commits@vger.kernel.org>; Thu,  6 Mar 2025 05:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741239446; cv=none; b=Wp1cMT1yDGHVL0iwk8vUnL0dF7b3YiJJ3ryhYnit6z4Noa1f9wgiBFE+iy45AQUdVY2hQOw9hwuNvIqG0rHCpwLvsc1YEUOD+/Owuz2SggU0mRH5pEHk5AWVVn0sgTSTSQzLCVdyZ6sDObWOholr3HWrI3ahL18wwNJiTIlmh4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741239446; c=relaxed/simple;
	bh=w4BLC1MudiHcPmGqFZSLkig/NQJeVRSokP0YSeldeNk=;
	h=Date:To:From:Subject:Message-Id; b=bHIEKCFUUzcaqRo8dEupcJHgY+lGf15YruzxkbpScG0hqLeME0kINbZZYcN65c30ps9GlOUsQISGy60ousqaxbX1O93TKbSehtjUbAEOjGf/fNwxKmfaihT4TRXeoBu0uY0q05qLNqxZcA0zd22JEvLvNDi53yIBpA+Kz6uyGKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PmoUVvJU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PmoUVvJU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E434CC4CEE4;
	Thu,  6 Mar 2025 05:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741239446;
	bh=w4BLC1MudiHcPmGqFZSLkig/NQJeVRSokP0YSeldeNk=;
	h=Date:To:From:Subject:From;
	b=PmoUVvJUjWmxDKsJMtAykH5OmyD6A6aeeXd6l5y4ayQZN/bZgtXG+uI/EtKiQ+fav
	 +ksK3JCwk+iYMcIstHjarRr9dweOJ71Bhqgvs5LLFhKYog2kZ7+cEOO+ukcHCVGpOC
	 dTTIsvH2EQhBlcFtcRHOxKrDnWTqBsJJ3dlgOqW0=
Date: Wed, 05 Mar 2025 21:37:25 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,surenb@google.com,baohua@kernel.org,gaoxu2@honor.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-possible-null-pointer-dereference-in-__swap_duplicate.patch removed from -mm tree
Message-Id: <20250306053725.E434CC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix possible NULL pointer dereference in __swap_duplicate
has been removed from the -mm tree.  Its filename was
     mm-fix-possible-null-pointer-dereference-in-__swap_duplicate.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: gao xu <gaoxu2@honor.com>
Subject: mm: fix possible NULL pointer dereference in __swap_duplicate
Date: Wed, 19 Feb 2025 01:56:28 +0000

Add a NULL check on the return value of swp_swap_info in __swap_duplicate
to prevent crashes caused by NULL pointer dereference.

The reason why swp_swap_info() returns NULL is unclear; it may be due
to CPU cache issues or DDR bit flips.  The probability of this issue is
very small - it has been observed to occur approximately 1 in 500,000
times per week.  The stack info we encountered is as follows:

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

akpm: this is probably a kernel bug, but this patch keeps the system
running and doesn't reduce that bug's debuggability.

Link: https://lkml.kernel.org/r/e223b0e6ba2f4924984b1917cc717bd5@honor.com
Signed-off-by: gao xu <gaoxu2@honor.com>
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


