From: akpm@linux-foundation.org
Subject: [folded] elf-clean-up-fill_note_info-fix.patch removed from -mm tree
Date: Wed, 23 Sep 2009 15:36:40 -0700
Message-ID: <200909232236.n8NMaeeG031573@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56455 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752066AbZIWWgn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 18:36:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, amwang@redhat.com, dhowells@redhat.com, roland@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     elf-clean-up-fill_note_info-fix
has been removed from the -mm tree.  Its filename was
     elf-clean-up-fill_note_info-fix.patch

This patch was dropped because it was folded into elf-clean-up-fill_note_info.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: elf-clean-up-fill_note_info-fix
From: Andrew Morton <akpm@linux-foundation.org>

Remove NUM_NOTES

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Amerigo Wang <amwang@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: WANG Cong <amwang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/binfmt_elf.c~elf-clean-up-fill_note_info-fix fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~elf-clean-up-fill_note_info-fix
+++ a/fs/binfmt_elf.c
@@ -1719,10 +1719,8 @@ static int elf_note_info_init(struct elf
 	memset(info, 0, sizeof(*info));
 	INIT_LIST_HEAD(&info->thread_list);
 
-#define	NUM_NOTES	6
-	info->notes = kmalloc(NUM_NOTES * sizeof(struct memelfnote),
-			      GFP_KERNEL);
-#undef NUM_NOTES
+	/* Allocate space for six ELF notes */
+	info->notes = kmalloc(6 * sizeof(struct memelfnote), GFP_KERNEL);
 	if (!info->notes)
 		return 0;
 	info->psinfo = kmalloc(sizeof(*info->psinfo), GFP_KERNEL);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
page-types-add-feature-for-walking-process-address-space.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-add-comments-explaining-memory-barriers.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memcg-improve-resource-counter-scalability.patch
exec-make-do_coredump-more-resilient-to-recursive-crashes-v9.patch
exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9.patch
elf-clean-up-fill_note_info.patch
elf-clean-up-fill_note_info-fix.patch

