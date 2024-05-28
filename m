Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82ABF482D3
	for <mm-commits@vger.kernel.org>; Tue, 28 May 2024 18:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716919896; cv=none; b=JAA7FD9wNu6Z+bMwtcMABjm3JNhzbbiR6yTe0vLNi+LheV+rdTwe/3PPnY5ViJyNb7POgVFm3Q4mFHa0CvjRloLoykLfhu5yn0qHiRLSMIRw6IU1nbkgv8Fzpgl7zW6nsgJdb2THrm0ymcDP0idq0a48Ciu+/VIqvA3k3GAX4yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716919896; c=relaxed/simple;
	bh=MTxpLy6VaWFKEZkbZCNSiBj/46sr8J3XsKd1lEcwq0g=;
	h=Date:To:From:Subject:Message-Id; b=eWgPkQ1DmfHOnK5MGbVV3FQer/WEH/3fhadetZD3eZ+H4PhedP2SROT4No0Mpq3bnPYVZO+V7kDPfktDHTQj6u/Jq0mL4tC9/lDleS37+E4R+V/ZdAKEhptIESOJjYjy2rgehDkKjFV4qg922TormCVcs6047RFJwbatTKjKJEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xnj8sVE8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xnj8sVE8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43AAC3277B;
	Tue, 28 May 2024 18:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716919896;
	bh=MTxpLy6VaWFKEZkbZCNSiBj/46sr8J3XsKd1lEcwq0g=;
	h=Date:To:From:Subject:From;
	b=xnj8sVE8ZoEEp1+DgY0dJ5r7LEBo1x+7anqbDtD+1o2+6+aozk7cg9GThb/+lDTtT
	 CThqXhTD1frHQRjcuN6qHJfcJX5MYHFSRZCI4exzBRwOdMM/+QwyoIuxcnFcPqVDsU
	 inooeo8xVVQ00HpGQFzcDrTRGaNyqxQcjHEFZ1QU=
Date: Tue, 28 May 2024 11:11:35 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,kent.overstreet@linux.dev,keescook@chromium.org,iamjoonsoo.kim@lge.com,gustavoars@kernel.org,cl@linux.com,42.hyeyoo@gmail.com,cascardo@igalia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + codetag-avoid-race-at-alloc_slab_obj_exts.patch added to mm-hotfixes-unstable branch
Message-Id: <20240528181135.E43AAC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: codetag: avoid race at alloc_slab_obj_exts
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     codetag-avoid-race-at-alloc_slab_obj_exts.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/codetag-avoid-race-at-alloc_slab_obj_exts.patch

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
From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: codetag: avoid race at alloc_slab_obj_exts
Date: Mon, 27 May 2024 15:30:06 -0300

When CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled, the following warning may
be noticed:

[   48.299584] ------------[ cut here ]------------
[   48.300092] alloc_tag was not set
[   48.300528] WARNING: CPU: 2 PID: 1361 at include/linux/alloc_tag.h:130 alloc_tagging_slab_free_hook+0x84/0xc7
[   48.301305] Modules linked in:
[   48.301553] CPU: 2 PID: 1361 Comm: systemd-udevd Not tainted 6.10.0-rc1-00003-gac8755535862 #176
[   48.302196] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
[   48.302752] RIP: 0010:alloc_tagging_slab_free_hook+0x84/0xc7
[   48.303169] Code: 8d 1c c4 48 85 db 74 4d 48 83 3b 00 75 1e 80 3d 65 02 86 04 00 75 15 48 c7 c7 11 48 1d 85 c6 05 55 02 86 04 01 e8 64 44 a5 ff <0f> 0b 48 8b 03 48 85 c0 74 21 48 83 f8 01 74 14 48 8b 50 20 48 f7
[   48.304411] RSP: 0018:ffff8880111b7d40 EFLAGS: 00010282
[   48.304916] RAX: 0000000000000000 RBX: ffff88800fcc9008 RCX: 0000000000000000
[   48.305455] RDX: 0000000080000000 RSI: ffff888014060000 RDI: ffffed1002236f97
[   48.305979] RBP: 0000000000001100 R08: fffffbfff0aa73a1 R09: 0000000000000000
[   48.306473] R10: ffffffff814515e5 R11: 0000000000000003 R12: ffff88800fcc9000
[   48.306943] R13: ffff88800b2e5cc0 R14: ffff8880111b7d90 R15: 0000000000000000
[   48.307529] FS:  00007faf5d1908c0(0000) GS:ffff88806cf00000(0000) knlGS:0000000000000000
[   48.308223] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   48.308710] CR2: 000058fb220c9118 CR3: 00000000110cc000 CR4: 0000000000750ef0
[   48.309274] PKRU: 55555554
[   48.309804] Call Trace:
[   48.310029]  <TASK>
[   48.310290]  ? show_regs+0x84/0x8d
[   48.310722]  ? alloc_tagging_slab_free_hook+0x84/0xc7
[   48.311298]  ? __warn+0x13b/0x2ff
[   48.311580]  ? alloc_tagging_slab_free_hook+0x84/0xc7
[   48.311987]  ? report_bug+0x2ce/0x3ab
[   48.312292]  ? handle_bug+0x8c/0x107
[   48.312563]  ? exc_invalid_op+0x34/0x6f
[   48.312842]  ? asm_exc_invalid_op+0x1a/0x20
[   48.313173]  ? this_cpu_in_panic+0x1c/0x72
[   48.313503]  ? alloc_tagging_slab_free_hook+0x84/0xc7
[   48.313880]  ? putname+0x143/0x14e
[   48.314152]  kmem_cache_free+0xe9/0x214
[   48.314454]  putname+0x143/0x14e
[   48.314712]  do_unlinkat+0x413/0x45e
[   48.315001]  ? __pfx_do_unlinkat+0x10/0x10
[   48.315388]  ? __check_object_size+0x4d7/0x525
[   48.315744]  ? __sanitizer_cov_trace_pc+0x20/0x4a
[   48.316167]  ? __sanitizer_cov_trace_pc+0x20/0x4a
[   48.316757]  ? getname_flags+0x4ed/0x500
[   48.317261]  __x64_sys_unlink+0x42/0x4a
[   48.317741]  do_syscall_64+0xe2/0x149
[   48.318171]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   48.318602] RIP: 0033:0x7faf5d8850ab
[   48.318891] Code: fd ff ff e8 27 dd 01 00 0f 1f 80 00 00 00 00 f3 0f 1e fa b8 5f 00 00 00 0f 05 c3 0f 1f 40 00 f3 0f 1e fa b8 57 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 41 2d 0e 00 f7 d8
[   48.320649] RSP: 002b:00007ffc44982b38 EFLAGS: 00000246 ORIG_RAX: 0000000000000057
[   48.321182] RAX: ffffffffffffffda RBX: 00005ba344a44680 RCX: 00007faf5d8850ab
[   48.321667] RDX: 0000000000000000 RSI: 00005ba344a44430 RDI: 00007ffc44982b40
[   48.322139] RBP: 00007ffc44982c00 R08: 0000000000000000 R09: 0000000000000007
[   48.322598] R10: 00005ba344a44430 R11: 0000000000000246 R12: 0000000000000000
[   48.323071] R13: 00007ffc44982b40 R14: 0000000000000000 R15: 0000000000000000
[   48.323596]  </TASK>

This is due to a race when two objects are allocated from the same slab,
which did not have an obj_exts allocated for.

In such a case, the two threads will notice the NULL obj_exts and after one
assigns slab->obj_exts, the second one will happily do the exchange if it
reads this new assigned value.

In order to avoid that, verify that the read obj_exts does not point to an
allocated obj_exts before doing the exchange.

Link: https://lkml.kernel.org/r/20240527183007.1595037-1-cascardo@igalia.com
Fixes: 09c46563ff6d ("codetag: debug: introduce OBJEXTS_ALLOC_FAIL to mark failed slab_ext allocations")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/slub.c~codetag-avoid-race-at-alloc_slab_obj_exts
+++ a/mm/slub.c
@@ -1952,7 +1952,7 @@ int alloc_slab_obj_exts(struct slab *sla
 #ifdef CONFIG_MEMCG
 	new_exts |= MEMCG_DATA_OBJEXTS;
 #endif
-	old_exts = slab->obj_exts;
+	old_exts = READ_ONCE(slab->obj_exts);
 	handle_failed_objexts_alloc(old_exts, vec, objects);
 	if (new_slab) {
 		/*
@@ -1961,7 +1961,8 @@ int alloc_slab_obj_exts(struct slab *sla
 		 * be simply assigned.
 		 */
 		slab->obj_exts = new_exts;
-	} else if (cmpxchg(&slab->obj_exts, old_exts, new_exts) != old_exts) {
+	} else if ((old_exts & ~OBJEXTS_FLAGS_MASK) ||
+		   cmpxchg(&slab->obj_exts, old_exts, new_exts) != old_exts) {
 		/*
 		 * If the slab is already in use, somebody can allocate and
 		 * assign slabobj_exts in parallel. In this case the existing
_

Patches currently in -mm which might be from cascardo@igalia.com are

codetag-avoid-race-at-alloc_slab_obj_exts.patch

