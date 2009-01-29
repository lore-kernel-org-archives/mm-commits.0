From: akpm@linux-foundation.org
Subject: + migration-migrate_vmas-should-check-vma.patch added to -mm tree
Date: Thu, 29 Jan 2009 00:19:04 -0800
Message-ID: <200901290819.n0T8J42h005012@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49572 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753465AbZA2ITL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Jan 2009 03:19:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, cl@linux-foundation.org, hannes@cmpxchg.org


The patch titled
     migration: migrate_vmas should check "vma"
has been added to the -mm tree.  Its filename is
     migration-migrate_vmas-should-check-vma.patch

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
Subject: migration: migrate_vmas should check "vma"
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

migrate_vmas() should check "vma" not "vma->vm_next" for for-loop condition.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/migrate.c~migration-migrate_vmas-should-check-vma mm/migrate.c
--- a/mm/migrate.c~migration-migrate_vmas-should-check-vma
+++ a/mm/migrate.c
@@ -1129,7 +1129,7 @@ int migrate_vmas(struct mm_struct *mm, c
  	struct vm_area_struct *vma;
  	int err = 0;
 
- 	for(vma = mm->mmap; vma->vm_next && !err; vma = vma->vm_next) {
+	for (vma = mm->mmap; vma && !err; vma = vma->vm_next) {
  		if (vma->vm_ops && vma->vm_ops->migrate) {
  			err = vma->vm_ops->migrate(vma, to, from, flags);
  			if (err)
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

memcg-get-put-parents-at-create-free.patch
memcg-get-put-parents-at-create-free-fix.patch
memcg-fix-refcnt-handling-at-swapoff.patch
memcg-update-document-to-mention-swapoff-should-be-test.patch
memcg-null-pointer-dereference-at-rmdir-on-some-numa-systems-v2.patch
migration-migrate_vmas-should-check-vma.patch

