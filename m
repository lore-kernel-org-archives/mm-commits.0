From: akpm@linux-foundation.org
Subject: + mremap-should-return-enomem-when-__vm_enough_memory-fail.patch
 added to -mm tree
Date: Tue, 24 Mar 2015 15:25:04 -0700
Message-ID: <5511e440.aYyTiAFT5ZsA+A0X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38060 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbbCXWZF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Mar 2015 18:25:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: denc716@gmail.com, crquan@ymail.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mremap should return -ENOMEM when __vm_enough_memory fail
has been added to the -mm tree.  Its filename is
     mremap-should-return-enomem-when-__vm_enough_memory-fail.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mremap-should-return-enomem-when-__vm_enough_memory-fail.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mremap-should-return-enomem-when-__vm_enough_memory-fail.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Derek <denc716@gmail.com>
Subject: mremap should return -ENOMEM when __vm_enough_memory fail

Recently I straced bash behavior in this dd zero pipe to read test, in
part of testing under vm.overcommit_memory=2 (OVERCOMMIT_NEVER mode):

    # dd if=/dev/zero | read x

The bash sub shell is calling mremap to reallocate more and more memory
untill it finally failed -ENOMEM (I expect), or to be killed by system OOM
killer (which should not happen under OVERCOMMIT_NEVER mode); But the
mremap system call actually failed of -EFAULT, which is a surprise to me,
I think it's supposed to be -ENOMEM?  then I wrote this piece of C code
testing confirmed it: https://gist.github.com/crquan/326bde37e1ddda8effe5

    $ ./remap
    allocated one page @0x7f686bf71000, (PAGE_SIZE: 4096)
    grabbed 7680512000 bytes of memory (1875125 pages) @ 00007f6690993000.
    mremap failed Bad address (14).

The -EFAULT comes from the branch of security_vm_enough_memory_mm failure,
underlyingly it calls __vm_enough_memory which returns only 0 for success
or -ENOMEM; So why vma_to_resize needs to return -EFAULT in this case? 
this sounds like a mistake to me.

Some more digging into git history:

1) Before commit 119f657c7 ("RLIMIT_AS checking fix") in May 1 2005
   (pre 2.6.12 days) it was returning -ENOMEM for this failure;

2) but commit 119f657c7 ("untangling do_mremap(), part 1") changed it
   accidentally, to what ever is preserved in local ret, which happened to
   be -EFAULT, in a previous assignment;

3) then in commit 54f5de709 code refactoring, it's explicitly returning
   -EFAULT, should be wrong.

Signed-off-by: Derek Che <crquan@ymail.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mremap.c~mremap-should-return-enomem-when-__vm_enough_memory-fail mm/mremap.c
--- a/mm/mremap.c~mremap-should-return-enomem-when-__vm_enough_memory-fail
+++ a/mm/mremap.c
@@ -375,7 +375,7 @@ static struct vm_area_struct *vma_to_res
 	if (vma->vm_flags & VM_ACCOUNT) {
 		unsigned long charged = (new_len - old_len) >> PAGE_SHIFT;
 		if (security_vm_enough_memory_mm(mm, charged))
-			goto Efault;
+			goto Enomem;
 		*p = charged;
 	}
 
_

Patches currently in -mm which might be from denc716@gmail.com are

mremap-should-return-enomem-when-__vm_enough_memory-fail.patch

