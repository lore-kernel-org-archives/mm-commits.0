From: akpm@linux-foundation.org
Subject: [merged]
 fs-pstore-ram_corec-replace-countsize-kmalloc-by-kmalloc_array.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:40:54 -0700
Message-ID: <53ea6dc6.K3BnSD5kAtL6jOiG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:54151 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970AbaHLTkz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:40:55 -0400
Received: by mail-ob0-f202.google.com with SMTP id wp18so1917500obc.1
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:40:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, anton@enomsg.org, ccross@android.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/pstore/ram_core.c: replace count*size kmalloc by kmalloc_array
has been removed from the -mm tree.  Its filename was
     fs-pstore-ram_corec-replace-countsize-kmalloc-by-kmalloc_array.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/pstore/ram_core.c: replace count*size kmalloc by kmalloc_array

kmalloc_array manages count*sizeof overflow.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Colin Cross <ccross@android.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pstore/ram_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/pstore/ram_core.c~fs-pstore-ram_corec-replace-countsize-kmalloc-by-kmalloc_array fs/pstore/ram_core.c
--- a/fs/pstore/ram_core.c~fs-pstore-ram_corec-replace-countsize-kmalloc-by-kmalloc_array
+++ a/fs/pstore/ram_core.c
@@ -394,7 +394,7 @@ static void *persistent_ram_vmap(phys_ad
 
 	prot = pgprot_noncached(PAGE_KERNEL);
 
-	pages = kmalloc(sizeof(struct page *) * page_count, GFP_KERNEL);
+	pages = kmalloc_array(page_count, sizeof(struct page *), GFP_KERNEL);
 	if (!pages) {
 		pr_err("%s: Failed to allocate array for %u pages\n",
 		       __func__, page_count);
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
fs-isofs-logging-clean-up-fix.patch
linux-next.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

