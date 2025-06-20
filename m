Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC9A2F2F
	for <mm-commits@vger.kernel.org>; Fri, 20 Jun 2025 00:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750381073; cv=none; b=XL1c5iUB4Q9tl4JKniBdBnTh2pNx22jNDR4NplCl/jMt6u9ypGmiTg/CTd1xscTgfGRJvxxr4UhKVEQd1U6ySw2NLamzkxcrUuDeNc0u6Pb+u9+2lnnudCHz1xtv9bGJr44wCVgemPhmkk6BbhamA1RHUJKdz2wwp6repKAbDz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750381073; c=relaxed/simple;
	bh=IoY2ZGcf2QZ3BctfZjVeNXc1IWj+0nN1zRB51MAtFQw=;
	h=Date:To:From:Subject:Message-Id; b=VjsZiW4RApOfLYDapbemIgPEhZbp0NX3GzeEAcEQIo2HF3DZAtDBYlz8hrIEekSLUVd4JCMP+klRpbeClVSWjNOgASU5n1iHLIaIZnMh++mCOCqqja5TxYZPdKbhqvg9Tya7LtChJhvEgLxJXifI03HEzqFV63aXlCPLNPeUHQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HA8o6Jcv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HA8o6Jcv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8AB7C4CEEA;
	Fri, 20 Jun 2025 00:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750381073;
	bh=IoY2ZGcf2QZ3BctfZjVeNXc1IWj+0nN1zRB51MAtFQw=;
	h=Date:To:From:Subject:From;
	b=HA8o6Jcv/y9+4Xq4KGknsjMO0NFqeq/xb04SCgGDZHLIExtGtVu22IZlX4DpQCkIL
	 cllSdOmPr3c3qrn31CkrVuL5roFnm5GoXKn8vc9R6HvP1+qFoaKf/LNSkQrmWUnjAS
	 r218rtnDcsl6hIUyMF0D2ld33Xu7f3BnKeGZ0daI=
Date: Thu, 19 Jun 2025 17:57:52 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,oliver.sang@intel.com,kent.overstreet@linux.dev,cachen@purestorage.com,00107082@163.com,harry.yoo@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-alloc_tag-do-not-acquire-nonexistent-lock-when-mem-profiling-is-disabled.patch added to mm-hotfixes-unstable branch
Message-Id: <20250620005752.E8AB7C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/alloc_tag: do not acquire nonexistent lock when mem profiling is disabled
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     lib-alloc_tag-do-not-acquire-nonexistent-lock-when-mem-profiling-is-disabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-alloc_tag-do-not-acquire-nonexistent-lock-when-mem-profiling-is-disabled.patch

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
From: Harry Yoo <harry.yoo@oracle.com>
Subject: lib/alloc_tag: do not acquire nonexistent lock when mem profiling is disabled
Date: Fri, 20 Jun 2025 09:40:32 +0900

alloc_tag_top_users() attempts to acquire alloc_tag_ctype->mod_lock even
when memory allocation profiling feature is disabled at runtime.  If the
feature is compiled in but not enabled at boot, alloc_tag_init() does not
properly allocate and initialize the alloc_tag_cttype variable.

This leads to a crash on memory allocation failure by attempting to
acquire a semaphore that does not exist:

  Oops: general protection fault, probably for non-canonical address 0xdffffc000000001b: 0000 [#3] SMP KASAN NOPTI
  KASAN: null-ptr-deref in range [0x00000000000000d8-0x00000000000000df]
  CPU: 2 UID: 0 PID: 1 Comm: systemd Tainted: G      D             6.16.0-rc2 #1 VOLUNTARY
  Tainted: [D]=DIE
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
  RIP: 0010:down_read_trylock+0xaa/0x3b0
  Code: d0 7c 08 84 d2 0f 85 a0 02 00 00 8b 0d df 31 dd 04 85 c9 75 29 48 b8 00 00 00 00 00 fc ff df 48 8d 6b 68 48 89 ea 48 c1 ea 03 <80> 3c 02 00 0f 85 88 02 00 00 48 3b 5b 68 0f 85 53 01 00 00 65 ff
  RSP: 0000:ffff8881002ce9b8 EFLAGS: 00010016
  RAX: dffffc0000000000 RBX: 0000000000000070 RCX: 0000000000000000
  RDX: 000000000000001b RSI: 000000000000000a RDI: 0000000000000070
  RBP: 00000000000000d8 R08: 0000000000000001 R09: ffffed107dde49d1
  R10: ffff8883eef24e8b R11: ffff8881002cec20 R12: 1ffff11020059d37
  R13: 00000000003fff7b R14: ffff8881002cec20 R15: dffffc0000000000
  FS:  00007f963f21d940(0000) GS:ffff888458ca6000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007f963f5edf71 CR3: 000000010672c000 CR4: 0000000000350ef0
  Call Trace:
   <TASK>
   codetag_trylock_module_list+0xd/0x20
   alloc_tag_top_users+0x369/0x4b0
   __show_mem+0x1cd/0x6e0
   warn_alloc+0x2b1/0x390
   __alloc_frozen_pages_noprof+0x12b9/0x21a0
   alloc_pages_mpol+0x135/0x3e0
   alloc_slab_page+0x82/0xe0
   new_slab+0x212/0x240
   ___slab_alloc+0x82a/0xe00
   </TASK>

As David Wang points out, this issue was introduced by commit 780138b12381
("alloc_tag: check mem_profiling_support in alloc_tag_init").  Before the
commit, alloc tagging subsystem unconditionally allocates the semaphore.

After the commit, alloc_tag_top_users() must check whether it was actually
initialized.  Fix it by adding the appropriate check in
alloc_tag_top_users().

Link: https://lkml.kernel.org/r/20250620004032.771289-1-harry.yoo@oracle.com
Fixes: 780138b12381 ("alloc_tag: check mem_profiling_support in alloc_tag_init")
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202506181351.bba867dd-lkp@intel.com
Closes: https://lore.kernel.org/oe-lkp/202505071555.e757f1e0-lkp@intel.com
Cc: Casey Chen <cachen@purestorage.com>
Cc: David Wang <00107082@163.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/alloc_tag.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/lib/alloc_tag.c~lib-alloc_tag-do-not-acquire-nonexistent-lock-when-mem-profiling-is-disabled
+++ a/lib/alloc_tag.c
@@ -135,7 +135,9 @@ size_t alloc_tag_top_users(struct codeta
 	struct codetag_bytes n;
 	unsigned int i, nr = 0;
 
-	if (can_sleep)
+	if (!mem_profiling_support)
+		return 0;
+	else if (can_sleep)
 		codetag_lock_module_list(alloc_tag_cttype, true);
 	else if (!codetag_trylock_module_list(alloc_tag_cttype))
 		return 0;
_

Patches currently in -mm which might be from harry.yoo@oracle.com are

lib-alloc_tag-do-not-acquire-nonexistent-lock-when-mem-profiling-is-disabled.patch

