Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C451311BE
	for <mm-commits@vger.kernel.org>; Thu, 28 Mar 2024 18:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711650432; cv=none; b=nex8430usz2WNVpHDF4tEtrjpzgSQUJi2C1QQIS8qOYzTiFdc4w37JikizIjnVzPE/wJQ8f6Ueijg7Txt2kJ7zqWnAxgRmRc3l26CnkZ+KMIS1pqSSIBTw7Pp0WcYxJ5CR2tJJTthFWssXpXPJT5ZZRxUVKbW+kE+IAl+cX5VSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711650432; c=relaxed/simple;
	bh=o45mDf+T0bEB5SVKFh+uz+265ITH3YDYLlJ2JqXNVAA=;
	h=Date:To:From:Subject:Message-Id; b=ey0umbwL7bKqlPue34WnT9qNQGXDkAVIJVscyAlW6fV/pYH6gMWYJ8HpgR1i612WGuSxPnaZR0hvPrVap1/b8tNqzJHTMIE/S2DGbiUeHcVW2m67XCjotQyQ41nU3r+7NE7PRk7vPjLuATTvi0UcJ2ybTP9ntylZ/CgArGlSr6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bBfQWyU6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bBfQWyU6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2F8C43399;
	Thu, 28 Mar 2024 18:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711650431;
	bh=o45mDf+T0bEB5SVKFh+uz+265ITH3YDYLlJ2JqXNVAA=;
	h=Date:To:From:Subject:From;
	b=bBfQWyU67y98CVz4N4SrxoUKJY5rLKnJMg/djwGBLn3RM0q/5FvEKe50RmD0r0AA9
	 UlIMBrZpE2YmetF3OMAidZ73Bgw297rapuPzwZ1O34CkBcFRxE5vd1jIc/zkuKfXZL
	 aiQXhht63C8QuZFvFK3yAyaNitxAHl0ty4bs7uW0=
Date: Thu, 28 Mar 2024 11:27:11 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,viro@ZenIV.linux.org.uk,oleg@redhat.com,keescook@chromium.org,jack@suse.cz,ebiederm@xmission.com,Dave.Martin@arm.com,catalin.marinas@arm.com,broonie@kernel.org,brauner@kernel.org,dianders@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + regset-use-kvzalloc-for-regset_get_alloc.patch added to mm-nonmm-unstable branch
Message-Id: <20240328182711.DA2F8C43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: regset: use kvzalloc() for regset_get_alloc()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     regset-use-kvzalloc-for-regset_get_alloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/regset-use-kvzalloc-for-regset_get_alloc.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

regset-use-kvzalloc-for-regset_get_alloc.patch

