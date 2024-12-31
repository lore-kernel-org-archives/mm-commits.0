Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394E214B942
	for <mm-commits@vger.kernel.org>; Tue, 31 Dec 2024 02:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735610409; cv=none; b=tnYbJFjtKrOVOOkTlvDKESUI7YkLIxSksRc4GUWXPh/FPNfkS8wgnF5axW2xMT/dpreNtPce8v9ZrWx9WCR1lYvHNkL2DM/CX6hGZXEyNbzegLds88KlXL/l8Z7I+os2Bwv/jv3cShz3WlAq7LCu1RnC6zHHvxbnGp2JAiyc+Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735610409; c=relaxed/simple;
	bh=hIKP1M8RDgWR892uKCoxfBLDtXHkA66CmdZaSFL+ZrI=;
	h=Date:To:From:Subject:Message-Id; b=JLmg5u2LGM6BMYVvMjoGZt9y0K7S2Q8ud2WhLTK4WjZuvId0LF+mVclVUp65QCIUI5CW7ABTNrPmZHB4htV44ebcXc3N3mlK7/BD8ciPPiPnym7Wxv2RUvj1cBWp1axZqvNhrQeWen5PPJoSAAfpvIy5Z/1nrbMJlNlDop8FroQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xGW2sswA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xGW2sswA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F1F3C4CED0;
	Tue, 31 Dec 2024 02:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735610409;
	bh=hIKP1M8RDgWR892uKCoxfBLDtXHkA66CmdZaSFL+ZrI=;
	h=Date:To:From:Subject:From;
	b=xGW2sswALbIHQ4WKg/EP3c7cjXhFWlz4QDcNpBe4moU8EhXQO7aHvC8h03eTBRGfX
	 7h4R53n4DrhVfY8RrdAc2QjaAWYZljazBhsWTwTP1HD7qItkUrUlDaA285BZ69sKOU
	 rwDxEsIIzLH5ck5TtbRu60ozYemsOM6QCbJmTLmY=
Date: Mon, 30 Dec 2024 18:00:08 -0800
To: mm-commits@vger.kernel.org,ubizjak@gmail.com,tj@kernel.org,ndesaulniers@google.com,nathan@kernel.org,morbo@google.com,justinstitt@google.com,dennis@kernel.org,cl@linux.com,gal@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] percpu-remove-intermediate-variable-in-percpu_ptr.patch removed from -mm tree
Message-Id: <20241231020009.0F1F3C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: percpu: remove intermediate variable in PERCPU_PTR()
has been removed from the -mm tree.  Its filename was
     percpu-remove-intermediate-variable-in-percpu_ptr.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gal Pressman <gal@nvidia.com>
Subject: percpu: remove intermediate variable in PERCPU_PTR()
Date: Thu, 19 Dec 2024 14:18:28 +0200

The intermediate variable in the PERCPU_PTR() macro results in a kernel
panic on boot [1] due to a compiler bug seen when compiling the kernel
(+ KASAN) with gcc 11.3.1, but not when compiling with latest gcc
(v14.2)/clang(v18.1).

To solve it, remove the intermediate variable (which is not needed) and
keep the casting that resolves the address space checks.

[1]
  Oops: general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] SMP KASAN
  KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
  CPU: 0 UID: 0 PID: 547 Comm: iptables Not tainted 6.13.0-rc1_external_tested-master #1
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
  RIP: 0010:nf_ct_netns_do_get+0x139/0x540
  Code: 03 00 00 48 81 c4 88 00 00 00 5b 5d 41 5c 41 5d 41 5e 41 5f c3 4d 8d 75 08 48 b8 00 00 00 00 00 fc ff df 4c 89 f2 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e 27 03 00 00 41 8b 45 08 83 c0
  RSP: 0018:ffff888116df75e8 EFLAGS: 00010207
  RAX: dffffc0000000000 RBX: 1ffff11022dbeebe RCX: ffffffff839a2382
  RDX: 0000000000000003 RSI: 0000000000000008 RDI: ffff88842ec46d10
  RBP: 0000000000000002 R08: 0000000000000000 R09: fffffbfff0b0860c
  R10: ffff888116df75e8 R11: 0000000000000001 R12: ffffffff879d6a80
  R13: 0000000000000016 R14: 000000000000001e R15: ffff888116df7908
  FS:  00007fba01646740(0000) GS:ffff88842ec00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 000055bd901800d8 CR3: 00000001205f0003 CR4: 0000000000172eb0
  Call Trace:
   <TASK>
   ? die_addr+0x3d/0xa0
   ? exc_general_protection+0x144/0x220
   ? asm_exc_general_protection+0x22/0x30
   ? __mutex_lock+0x2c2/0x1d70
   ? nf_ct_netns_do_get+0x139/0x540
   ? nf_ct_netns_do_get+0xb5/0x540
   ? net_generic+0x1f0/0x1f0
   ? __create_object+0x5e/0x80
   xt_check_target+0x1f0/0x930
   ? textify_hooks.constprop.0+0x110/0x110
   ? pcpu_alloc_noprof+0x7cd/0xcf0
   ? xt_find_target+0x148/0x1e0
   find_check_entry.constprop.0+0x6c0/0x920
   ? get_info+0x380/0x380
   ? __virt_addr_valid+0x1df/0x3b0
   ? kasan_quarantine_put+0xe3/0x200
   ? kfree+0x13e/0x3d0
   ? translate_table+0xaf5/0x1750
   translate_table+0xbd8/0x1750
   ? ipt_unregister_table_exit+0x30/0x30
   ? __might_fault+0xbb/0x170
   do_ipt_set_ctl+0x408/0x1340
   ? nf_sockopt_find.constprop.0+0x17b/0x1f0
   ? lock_downgrade+0x680/0x680
   ? lockdep_hardirqs_on_prepare+0x284/0x400
   ? ipt_register_table+0x440/0x440
   ? bit_wait_timeout+0x160/0x160
   nf_setsockopt+0x6f/0xd0
   raw_setsockopt+0x7e/0x200
   ? raw_bind+0x590/0x590
   ? do_user_addr_fault+0x812/0xd20
   do_sock_setsockopt+0x1e2/0x3f0
   ? move_addr_to_user+0x90/0x90
   ? lock_downgrade+0x680/0x680
   __sys_setsockopt+0x9e/0x100
   __x64_sys_setsockopt+0xb9/0x150
   ? do_syscall_64+0x33/0x140
   do_syscall_64+0x6d/0x140
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
  RIP: 0033:0x7fba015134ce
  Code: 0f 1f 40 00 48 8b 15 59 69 0e 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b1 0f 1f 00 f3 0f 1e fa 49 89 ca b8 36 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 0a c3 66 0f 1f 84 00 00 00 00 00 48 8b 15 21
  RSP: 002b:00007ffd9de6f388 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
  RAX: ffffffffffffffda RBX: 000055bd9017f490 RCX: 00007fba015134ce
  RDX: 0000000000000040 RSI: 0000000000000000 RDI: 0000000000000004
  RBP: 0000000000000500 R08: 0000000000000560 R09: 0000000000000052
  R10: 000055bd901800e0 R11: 0000000000000246 R12: 000055bd90180140
  R13: 000055bd901800e0 R14: 000055bd9017f498 R15: 000055bd9017ff10
   </TASK>
  Modules linked in: xt_MASQUERADE nf_conntrack_netlink nfnetlink xt_addrtype iptable_nat nf_nat br_netfilter rpcsec_gss_krb5 auth_rpcgss oid_registry overlay zram zsmalloc mlx4_ib mlx4_en mlx4_core rpcrdma rdma_ucm ib_uverbs ib_iser libiscsi scsi_transport_iscsi fuse ib_umad rdma_cm ib_ipoib iw_cm ib_cm ib_core
  ---[ end trace 0000000000000000 ]---

[akpm@linux-foundation.org: simplification, per Uros]
Link: https://lkml.kernel.org/r/20241219121828.2120780-1-gal@nvidia.com
Fixes: dabddd687c9e ("percpu: cast percpu pointer in PERCPU_PTR() via unsigned long")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Closes: https://lore.kernel.org/all/7590f546-4021-4602-9252-0d525de35b52@nvidia.com
Cc: Uros Bizjak <ubizjak@gmail.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu-defs.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/include/linux/percpu-defs.h~percpu-remove-intermediate-variable-in-percpu_ptr
+++ a/include/linux/percpu-defs.h
@@ -221,10 +221,7 @@ do {									\
 } while (0)
 
 #define PERCPU_PTR(__p)							\
-({									\
-	unsigned long __pcpu_ptr = (__force unsigned long)(__p);	\
-	(typeof(*(__p)) __force __kernel *)(__pcpu_ptr);		\
-})
+	(typeof(*(__p)) __force __kernel *)((__force unsigned long)(__p))
 
 #ifdef CONFIG_SMP
 
_

Patches currently in -mm which might be from gal@nvidia.com are


