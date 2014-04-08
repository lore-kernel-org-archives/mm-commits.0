From: akpm@linux-foundation.org
Subject: [merged]
 exec-kill-the-unnecessary-mm-def_flags-setting-in-load_elf_binary.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 13:39:07 -0700
Message-ID: <53445e6b.QXpipqahR0tzhIQX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56363 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756659AbaDHUjI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 16:39:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, schwidefsky@de.ibm.com, rientjes@google.com, riel@redhat.com, peterz@infradead.org, pbonzini@redhat.com, oleg@redhat.com, mingo@kernel.org, mgorman@suse.de, kirill.shutemov@linux.intel.com, heiko.carstens@de.ibm.com, hannes@cmpxchg.org, gerald.schaefer@de.ibm.com, ebiederm@xmission.com, borntraeger@de.ibm.com, aarcange@redhat.com, athorlton@sgi.com

Subject: [merged] exec-kill-the-unnecessary-mm-def_flags-setting-in-load_elf_binary.patch removed from -mm tree
To: athorlton@sgi.com,aarcange@redhat.com,borntraeger@de.ibm.com,ebiederm@xmission.com,gerald.schaefer@de.ibm.com,hannes@cmpxchg.org,heiko.carstens@de.ibm.com,kirill.shutemov@linux.intel.com,mgorman@suse.de,mingo@kernel.org,oleg@redhat.com,pbonzini@redhat.com,peterz@infradead.org,riel@redhat.com,rientjes@google.com,schwidefsky@de.ibm.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 13:39:07 -0700


The patch titled
     Subject: exec: kill the unnecessary mm->def_flags setting in load_elf_binary()
has been removed from the -mm tree.  Its filename was
     exec-kill-the-unnecessary-mm-def_flags-setting-in-load_elf_binary.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alex Thorlton <athorlton@sgi.com>
Subject: exec: kill the unnecessary mm->def_flags setting in load_elf_binary()

load_elf_binary() sets current->mm->def_flags = def_flags and def_flags is
always zero.  Not only this looks strange, this is unnecessary because
mm_init() has already set ->def_flags = 0.

Signed-off-by: Alex Thorlton <athorlton@sgi.com>
Suggested-by: Oleg Nesterov <oleg@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN fs/binfmt_elf.c~exec-kill-the-unnecessary-mm-def_flags-setting-in-load_elf_binary fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~exec-kill-the-unnecessary-mm-def_flags-setting-in-load_elf_binary
+++ a/fs/binfmt_elf.c
@@ -584,7 +584,6 @@ static int load_elf_binary(struct linux_
 	unsigned long start_code, end_code, start_data, end_data;
 	unsigned long reloc_func_desc __maybe_unused = 0;
 	int executable_stack = EXSTACK_DEFAULT;
-	unsigned long def_flags = 0;
 	struct pt_regs *regs = current_pt_regs();
 	struct {
 		struct elfhdr elf_ex;
@@ -724,9 +723,6 @@ static int load_elf_binary(struct linux_
 	if (retval)
 		goto out_free_dentry;
 
-	/* OK, This is the point of no return */
-	current->mm->def_flags = def_flags;
