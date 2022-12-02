Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A5D9C4321E
	for <mm-commits@archiver.kernel.org>; Fri,  2 Dec 2022 19:48:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234423AbiLBTs4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Dec 2022 14:48:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234104AbiLBTsy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Dec 2022 14:48:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3487F3FA6
        for <mm-commits@vger.kernel.org>; Fri,  2 Dec 2022 11:48:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1DD2B82274
        for <mm-commits@vger.kernel.org>; Fri,  2 Dec 2022 19:48:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BFBDC433D6;
        Fri,  2 Dec 2022 19:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670010529;
        bh=7lFkqZRz2h1GDtfqsQA96SkVGip7z/IXGk+AMs3YqjQ=;
        h=Date:To:From:Subject:From;
        b=F0oC+9plwBr69syn2H7IPDPMvzPd+aeLR+ogWByHxQNCrXdjnQaYxwbHvtg4GkJST
         SC/KhGuNoe8/Qj7zJHwA0ZsoX6WwUPc+LwlcWWVKvD52MWOdPfLNG0VwHCPXhfdfiy
         ouh8+oASe25hwVx3LIWp+tJy6uFByOf1xBZ2R99g=
Date:   Fri, 02 Dec 2022 11:48:48 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, Liam.Howlett@oracle.com, jannh@google.com,
        dhowells@redhat.com, david@redhat.com, dave@stgolabs.net,
        catalin.marinas@arm.com, Jason@zx2c4.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-do-not-bug_on-missing-brk-mapping-because-userspace-can-unmap-it.patch added to mm-hotfixes-unstable branch
Message-Id: <20221202194849.8BFBDC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: do not BUG_ON missing brk mapping, because userspace can unmap it
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-do-not-bug_on-missing-brk-mapping-because-userspace-can-unmap-it.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-do-not-bug_on-missing-brk-mapping-because-userspace-can-unmap-it.patch

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
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: mm: do not BUG_ON missing brk mapping, because userspace can unmap it
Date: Fri, 2 Dec 2022 17:27:24 +0100

The following program will trigger the BUG_ON that this patch removes,
because the user can munmap() mm->brk:

  #include <sys/syscall.h>
  #include <sys/mman.h>
  #include <assert.h>
  #include <unistd.h>

  static void *brk_now(void)
  {
    return (void *)syscall(SYS_brk, 0);
  }

  static void brk_set(void *b)
  {
    assert(syscall(SYS_brk, b) != -1);
  }

  int main(int argc, char *argv[])
  {
    void *b = brk_now();
    brk_set(b + 4096);
    assert(munmap(b - 4096, 4096 * 2) == 0);
    brk_set(b);
    return 0;
  }

Compile that with musl, since glibc actually uses brk(), and then
execute it, and it'll hit this splat:

  kernel BUG at mm/mmap.c:229!
  invalid opcode: 0000 [#1] PREEMPT SMP
  CPU: 12 PID: 1379 Comm: a.out Tainted: G S   U             6.1.0-rc7+ #419
  RIP: 0010:__do_sys_brk+0x2fc/0x340
  Code: 00 00 4c 89 ef e8 04 d3 fe ff eb 9a be 01 00 00 00 4c 89 ff e8 35 e0 fe ff e9 6e ff ff ff 4d 89 a7 20>
  RSP: 0018:ffff888140bc7eb0 EFLAGS: 00010246
  RAX: 0000000000000000 RBX: 00000000007e7000 RCX: ffff8881020fe000
  RDX: ffff8881020fe001 RSI: ffff8881955c9b00 RDI: ffff8881955c9b08
  RBP: 0000000000000000 R08: ffff8881955c9b00 R09: 00007ffc77844000
  R10: 0000000000000000 R11: 0000000000000001 R12: 00000000007e8000
  R13: 00000000007e8000 R14: 00000000007e7000 R15: ffff8881020fe000
  FS:  0000000000604298(0000) GS:ffff88901f700000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000603fe0 CR3: 000000015ba9a005 CR4: 0000000000770ee0
  PKRU: 55555554
  Call Trace:
   <TASK>
   do_syscall_64+0x2b/0x50
   entry_SYSCALL_64_after_hwframe+0x46/0xb0
  RIP: 0033:0x400678
  Code: 10 4c 8d 41 08 4c 89 44 24 10 4c 8b 01 8b 4c 24 08 83 f9 2f 77 0a 4c 8d 4c 24 20 4c 01 c9 eb 05 48 8b>
  RSP: 002b:00007ffc77863890 EFLAGS: 00000212 ORIG_RAX: 000000000000000c
  RAX: ffffffffffffffda RBX: 000000000040031b RCX: 0000000000400678
  RDX: 00000000004006a1 RSI: 00000000007e6000 RDI: 00000000007e7000
  RBP: 00007ffc77863900 R08: 0000000000000000 R09: 00000000007e6000
  R10: 00007ffc77863930 R11: 0000000000000212 R12: 00007ffc77863978
  R13: 00007ffc77863988 R14: 0000000000000000 R15: 0000000000000000
   </TASK>

Instead, just return the old brk value if the original mapping has been
removed.

[akpm@linux-foundation.org: fix changelog, per Liam]
Link: https://lkml.kernel.org/r/20221202162724.2009-1-Jason@zx2c4.com
Fixes: 2e7ce7d354f2 ("mm/mmap: change do_brk_flags() to expand existing VMA and add do_brk_munmap()")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/mmap.c~mm-do-not-bug_on-missing-brk-mapping-because-userspace-can-unmap-it
+++ a/mm/mmap.c
@@ -226,8 +226,7 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 		/* Search one past newbrk */
 		mas_set(&mas, newbrk);
 		brkvma = mas_find(&mas, oldbrk);
-		BUG_ON(brkvma == NULL);
-		if (brkvma->vm_start >= oldbrk)
+		if (!brkvma || brkvma->vm_start >= oldbrk)
 			goto out; /* mapping intersects with an existing non-brk vma. */
 		/*
 		 * mm->brk must be protected by write mmap_lock.
_

Patches currently in -mm which might be from Jason@zx2c4.com are

mm-do-not-bug_on-missing-brk-mapping-because-userspace-can-unmap-it.patch

