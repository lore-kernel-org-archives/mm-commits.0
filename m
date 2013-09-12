From: akpm@linux-foundation.org
Subject: [merged]
 mm-backing-devc-check-user-buffer-length-before-copying-data-to-the-related-user-buffer.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:45:11 -0700
Message-ID: <523219c7.sNHTlBcBCixa/Kz+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58548 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756151Ab3ILTpM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:45:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, jmoyer@redhat.com, jack@suse.cz, gang.chen@asianux.com

Subject: [merged] mm-backing-devc-check-user-buffer-length-before-copying-data-to-the-related-user-buffer.patch removed from -mm tree
To: gang.chen@asianux.com,jack@suse.cz,jmoyer@redhat.com,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:45:11 -0700


The patch titled
     Subject: mm/backing-dev.c: check user buffer length before copying data to the related user buffer
has been removed from the -mm tree.  Its filename was
     mm-backing-devc-check-user-buffer-length-before-copying-data-to-the-related-user-buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chen Gang <gang.chen@asianux.com>
Subject: mm/backing-dev.c: check user buffer length before copying data to the related user buffer

'*lenp' may be less than "sizeof(kbuf)" so we must check this before the
next copy_to_user().

pdflush_proc_obsolete() is called by sysctl which 'procname' is
"nr_pdflush_threads", if the user passes buffer length less than
"sizeof(kbuf)", it will cause issue.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/backing-dev.c~mm-backing-devc-check-user-buffer-length-before-copying-data-to-the-related-user-buffer mm/backing-dev.c
--- a/mm/backing-dev.c~mm-backing-devc-check-user-buffer-length-before-copying-data-to-the-related-user-buffer
+++ a/mm/backing-dev.c
@@ -652,7 +652,7 @@ int pdflush_proc_obsolete(struct ctl_tab
 {
 	char kbuf[] = "0\n";
 
-	if (*ppos) {
+	if (*ppos || *lenp < sizeof(kbuf)) {
 		*lenp = 0;
 		return 0;
 	}
_

Patches currently in -mm which might be from gang.chen@asianux.com are

origin.patch
sh64-kernel-use-usp-instead-of-fn.patch
sh64-kernel-remove-useless-variable-regs.patch
include-linux-interrupth-add-dummy-irq_set_irq_wake-for-generic_hardirqs.patch
h8300-kernel-timer-timer8c-add-missing-semicolon.patch
mm-kconfig-add-mmu-dependency-for-migration.patch

