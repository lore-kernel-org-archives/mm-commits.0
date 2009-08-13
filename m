From: akpm@linux-foundation.org
Subject: + percpu-use-the-right-flag-for-get_vm_area.patch added to -mm tree
Date: Thu, 13 Aug 2009 15:16:50 -0700
Message-ID: <200908132216.n7DMGotU028139@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36806 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753462AbZHMWSQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Aug 2009 18:18:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amwang@redhat.com, mingo@elte.hu, tj@kernel.org


The patch titled
     percpu: use the right flag for get_vm_area()
has been added to the -mm tree.  Its filename is
     percpu-use-the-right-flag-for-get_vm_area.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: percpu: use the right flag for get_vm_area()
From: Amerigo Wang <amwang@redhat.com>

get_vm_area() only accepts VM_* flags, not GFP_*.

And according to the doc of get_vm_area(), here should be VM_ALLOC.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/percpu.c~percpu-use-the-right-flag-for-get_vm_area mm/percpu.c
--- a/mm/percpu.c~percpu-use-the-right-flag-for-get_vm_area
+++ a/mm/percpu.c
@@ -1004,7 +1004,7 @@ static struct pcpu_chunk *alloc_pcpu_chu
 	chunk->map_alloc = PCPU_DFL_MAP_ALLOC;
 	chunk->map[chunk->map_used++] = pcpu_unit_size;
 
-	chunk->vm = get_vm_area(pcpu_chunk_size, GFP_KERNEL);
+	chunk->vm = get_vm_area(pcpu_chunk_size, VM_ALLOC);
 	if (!chunk->vm) {
 		free_pcpu_chunk(chunk);
 		return NULL;
_

Patches currently in -mm which might be from amwang@redhat.com are

linux-next.patch
vfs-allow-file-truncations-when-both-suid-and-write-permissions-set.patch
xtensa-use-generic-sys_pipe.patch
percpu-use-the-right-flag-for-get_vm_area.patch
kcore-fix-proc-kcores-statst_size.patch
elf-clean-up-fill_note_info.patch
elf-clean-up-fill_note_info-fix.patch

