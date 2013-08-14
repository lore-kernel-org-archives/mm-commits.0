From: akpm@linux-foundation.org
Subject: [merged]
 x86-get_unmapped_area-use-proper-mmap-base-for-bottom-up-direction.patch
 removed from -mm tree
Date: Wed, 14 Aug 2013 12:35:44 -0700
Message-ID: <520bdc10.KKMJgfdNm+NvqB5g%akpm__31288.8545020998$1376508968$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54236 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933078Ab3HNTfp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Aug 2013 15:35:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, stable@vger.kernel.org, riel@redhat.com, oleg@redhat.com, molecula2788@gmail.com, mingo@kernel.org, sinaelgl@gmail.com

Subject: [merged] x86-get_unmapped_area-use-proper-mmap-base-for-bottom-up-direction.patch removed from -mm tree
To: sinaelgl@gmail.com,mingo@kernel.org,molecula2788@gmail.com,oleg@redhat.com,riel@redhat.com,stable@vger.kernel.org,walken@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 14 Aug 2013 12:35:44 -0700


The patch titled
     Subject: x86 get_unmapped_area(): use proper mmap base for bottom-up direction
has been removed from the -mm tree.  Its filename was
     x86-get_unmapped_area-use-proper-mmap-base-for-bottom-up-direction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Radu Caragea <sinaelgl@gmail.com>
Subject: x86 get_unmapped_area(): use proper mmap base for bottom-up direction

When the stack is set to unlimited, the bottomup direction is used for
mmap-ings but the mmap_base is not used and thus effectively renders ASLR
for mmapings along with PIE useless.

Cc: Michel Lespinasse <walken@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Adrian Sendroiu <molecula2788@gmail.com>  
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/sys_x86_64.c |    2 +-
 arch/x86/mm/mmap.c           |    2 +-
 include/linux/sched.h        |    1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff -puN arch/x86/kernel/sys_x86_64.c~x86-get_unmapped_area-use-proper-mmap-base-for-bottom-up-direction arch/x86/kernel/sys_x86_64.c
--- a/arch/x86/kernel/sys_x86_64.c~x86-get_unmapped_area-use-proper-mmap-base-for-bottom-up-direction
+++ a/arch/x86/kernel/sys_x86_64.c
@@ -101,7 +101,7 @@ static void find_start_end(unsigned long
 				*begin = new_begin;
 		}
 	} else {
-		*begin = TASK_UNMAPPED_BASE;
+		*begin = mmap_legacy_base();
 		*end = TASK_SIZE;
 	}
 }
diff -puN arch/x86/mm/mmap.c~x86-get_unmapped_area-use-proper-mmap-base-for-bottom-up-direction arch/x86/mm/mmap.c
--- a/arch/x86/mm/mmap.c~x86-get_unmapped_area-use-proper-mmap-base-for-bottom-up-direction
+++ a/arch/x86/mm/mmap.c
@@ -98,7 +98,7 @@ static unsigned long mmap_base(void)
  * Bottom-up (legacy) layout on X86_32 did not support randomization, X86_64
  * does, but not when emulating X86_32
  */
-static unsigned long mmap_legacy_base(void)
+unsigned long mmap_legacy_base(void)
 {
 	if (mmap_is_ia32())
 		return TASK_UNMAPPED_BASE;
diff -puN include/linux/sched.h~x86-get_unmapped_area-use-proper-mmap-base-for-bottom-up-direction include/linux/sched.h
--- a/include/linux/sched.h~x86-get_unmapped_area-use-proper-mmap-base-for-bottom-up-direction
+++ a/include/linux/sched.h
@@ -314,6 +314,7 @@ struct nsproxy;
 struct user_namespace;
 
 #ifdef CONFIG_MMU
+extern unsigned long mmap_legacy_base(void);
 extern void arch_pick_mmap_layout(struct mm_struct *mm);
 extern unsigned long
 arch_get_unmapped_area(struct file *, unsigned long, unsigned long,
_

Patches currently in -mm which might be from sinaelgl@gmail.com are

origin.patch

