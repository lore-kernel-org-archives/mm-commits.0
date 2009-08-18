From: akpm@linux-foundation.org
Subject: [wrecked] percpu-use-the-right-flag-for-get_vm_area.patch removed from -mm tree
Date: Tue, 18 Aug 2009 13:17:18 -0700
Message-ID: <200908182017.n7IKHI6s019893@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751826AbZHRUTT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Aug 2009 16:19:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amwang@redhat.com, mingo@elte.hu, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     percpu: use the right flag for get_vm_area()
has been removed from the -mm tree.  Its filename was
     percpu-use-the-right-flag-for-get_vm_area.patch

This patch was dropped because other changes were merged, which wrecked this patch

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
@@ -749,7 +749,7 @@ static struct pcpu_chunk *alloc_pcpu_chu
 	chunk->map[chunk->map_used++] = pcpu_unit_size;
 	chunk->page = chunk->page_ar;
 
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

