Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C107E80C14
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104462; cv=none; b=Yw9k7Fj7wFo1wYCs+oSVPBqGaGB/TPVYH5nqXlkmYbbQnO/opTHNB3kqvTC1/I5nPd6LQPHH7ZPNxdDTdULscNZdXrIoOipubvN3Q8wiZjurfBqiYQrQnkFGrgvhxiHN/gPCOfHk0PH8v8I9Om+w83iWjQtLhJzih/wnXeYmg9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104462; c=relaxed/simple;
	bh=Ohnnnx0L3tg91UF4tIY8FT3teO8pZm0hf+x2QJVrheM=;
	h=Date:To:From:Subject:Message-Id; b=PkZFEm2tkaH2VeOmoB8CLdqOUynl5eElsYdNHsmmr2zjYJ2WJT9iQcFUqSIQfjYzGvVtOj40Lioir6OLAhC57TQRP0+S5lmqpmD2ejh/cMcLTyMI1Sl5rjlFgJ+whpNm84TX1KFP7yybSvI2E/Ws0GjSAdpvqIWG0BwULCnQ+EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wfQ9o/hD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wfQ9o/hD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 941C7C113CD;
	Fri, 26 Apr 2024 04:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104462;
	bh=Ohnnnx0L3tg91UF4tIY8FT3teO8pZm0hf+x2QJVrheM=;
	h=Date:To:From:Subject:From;
	b=wfQ9o/hDl4Zi4fpKVyoNSlWWfGhZ6mT1l+UgX1wZAdaLiSBCfDM2zUdVUc/Y/vPat
	 /7gNMtIsxP9wBJ+cdd1y6MTvKzfPr194krOPWM5jiK/U7v6Vuw07iZXi4ASse6u8dL
	 dRhvxfCIZ3oXedgHr5RQSorxibrNr+rxbY1PpvOg=
Date: Thu, 25 Apr 2024 21:07:42 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,viro@ZenIV.linux.org.uk,oleg@redhat.com,keescook@chromium.org,jack@suse.cz,ebiederm@xmission.com,Dave.Martin@arm.com,catalin.marinas@arm.com,broonie@kernel.org,brauner@kernel.org,dianders@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] regset-use-kvzalloc-for-regset_get_alloc.patch removed from -mm tree
Message-Id: <20240426040742.941C7C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: regset: use kvzalloc() for regset_get_alloc()
has been removed from the -mm tree.  Its filename was
     regset-use-kvzalloc-for-regset_get_alloc.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Douglas Anderson <dianders@chromium.org>
Subject: regset: use kvzalloc() for regset_get_alloc()
Date: Mon, 5 Feb 2024 09:26:30 -0800

While browsing through ChromeOS crash reports, I found one with an
allocation failure that looked like this:

  chrome: page allocation failure: order:7,
          mode:0x40dc0(GFP_KERNEL|__GFP_COMP|__GFP_ZERO),
	  nodemask=(null),cpuset=urgent,mems_allowed=0
  CPU: 7 PID: 3295 Comm: chrome Not tainted
          5.15.133-20574-g8044615ac35c #1 (HASH:1162 1)
  Hardware name: Google Lazor (rev3 - 8) with KB Backlight (DT)
  Call trace:
  ...
  warn_alloc+0x104/0x174
  __alloc_pages+0x5f0/0x6e4
  kmalloc_order+0x44/0x98
  kmalloc_order_trace+0x34/0x124
  __kmalloc+0x228/0x36c
  __regset_get+0x68/0xcc
  regset_get_alloc+0x1c/0x28
  elf_core_dump+0x3d8/0xd8c
  do_coredump+0xeb8/0x1378
  get_signal+0x14c/0x804
  ...

An order 7 allocation is (1 << 7) contiguous pages, or 512K. It's not
a surprise that this allocation failed on a system that's been running
for a while.

More digging showed that it was fairly easy to see the order 7
allocation by just sending a SIGQUIT to chrome (or other processes) to
generate a core dump. The actual amount being allocated was 279,584
bytes and it was for "core_note_type" NT_ARM_SVE.

There was quite a bit of discussion [1] on the mailing lists in
response to my v1 patch attempting to switch to vmalloc. The overall
conclusion was that we could likely reduce the 279,584 byte allocation
by quite a bit and Mark Brown has sent a patch to that effect [2].
However even with the 279,584 byte allocation gone there are still
65,552 byte allocations. These are just barely more than the 65,536
bytes and thus would require an order 5 allocation.

An order 5 allocation is still something to avoid unless necessary and
nothing needs the memory here to be contiguous. Change the allocation
to kvzalloc() which should still be efficient for small allocations
but doesn't force the memory subsystem to work hard (and maybe fail)
at getting a large contiguous chunk.

[1] https://lore.kernel.org/r/20240201171159.1.Id9ad163b60d21c9e56c2d686b0cc9083a8ba7924@changeid
[2] https://lore.kernel.org/r/20240203-arm64-sve-ptrace-regset-size-v1-1-2c3ba1386b9e@kernel.org

Link: https://lkml.kernel.org/r/20240205092626.v2.1.Id9ad163b60d21c9e56c2d686b0cc9083a8ba7924@changeid
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    2 +-
 kernel/regset.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/fs/binfmt_elf.c~regset-use-kvzalloc-for-regset_get_alloc
+++ a/fs/binfmt_elf.c
@@ -1928,7 +1928,7 @@ static void free_note_info(struct elf_no
 		threads = t->next;
 		WARN_ON(t->notes[0].data && t->notes[0].data != &t->prstatus);
 		for (i = 1; i < info->thread_notes; ++i)
-			kfree(t->notes[i].data);
+			kvfree(t->notes[i].data);
 		kfree(t);
 	}
 	kfree(info->psinfo.data);
--- a/kernel/regset.c~regset-use-kvzalloc-for-regset_get_alloc
+++ a/kernel/regset.c
@@ -16,14 +16,14 @@ static int __regset_get(struct task_stru
 	if (size > regset->n * regset->size)
 		size = regset->n * regset->size;
 	if (!p) {
-		to_free = p = kzalloc(size, GFP_KERNEL);
+		to_free = p = kvzalloc(size, GFP_KERNEL);
 		if (!p)
 			return -ENOMEM;
 	}
 	res = regset->regset_get(target, regset,
 			   (struct membuf){.p = p, .left = size});
 	if (res < 0) {
-		kfree(to_free);
+		kvfree(to_free);
 		return res;
 	}
 	*data = p;
@@ -71,6 +71,6 @@ int copy_regset_to_user(struct task_stru
 	ret = regset_get_alloc(target, regset, size, &buf);
 	if (ret > 0)
 		ret = copy_to_user(data, buf, ret) ? -EFAULT : 0;
-	kfree(buf);
+	kvfree(buf);
 	return ret;
 }
_

Patches currently in -mm which might be from dianders@chromium.org are


