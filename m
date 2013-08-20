From: akpm@linux-foundation.org
Subject: +
 mm-backing-devc-check-user-buffer-length-before-copying-data-to-the-related-user-buffer.patch added to -mm tree
Date: Tue, 20 Aug 2013 16:29:13 -0700
Message-ID: <5213fbc9.PGSEbMSEyrZS353I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38779 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab3HTX3O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Aug 2013 19:29:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, jmoyer@redhat.com, jack@suse.cz, gang.chen@asianux.com

Subject: + mm-backing-devc-check-user-buffer-length-before-copying-data-to-the-related-user-buffer.patch added to -mm tree
To: gang.chen@asianux.com,jack@suse.cz,jmoyer@redhat.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 20 Aug 2013 16:29:13 -0700


The patch titled
     Subject: mm/backing-dev.c: check user buffer length before copying data to the related user buffer
has been added to the -mm tree.  Its filename is
     mm-backing-devc-check-user-buffer-length-before-copying-data-to-the-related-user-buffer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-backing-devc-check-user-buffer-length-before-copying-data-to-the-related-user-buffer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-backing-devc-check-user-buffer-length-before-copying-data-to-the-related-user-buffer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Gang <gang.chen@asianux.com>
Subject: mm/backing-dev.c: check user buffer length before copying data to the related user buffer

'*lenp' may be less than "sizeof(kbuf)" so we must check this before the
next copy_to_user().

pdflush_proc_obsolete() is called by sysctl which 'procname' is
"nr_pdflush_threads", if the user passes buffer length less than
"sizeof(kbuf)", it will cause issue.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/backing-dev.c~mm-backing-devc-check-user-buffer-length-before-copying-data-to-the-related-user-buffer mm/backing-dev.c
--- a/mm/backing-dev.c~mm-backing-devc-check-user-buffer-length-before-copying-data-to-the-related-user-buffer
+++ a/mm/backing-dev.c
@@ -649,7 +649,7 @@ int pdflush_proc_obsolete(struct ctl_tab
 {
 	char kbuf[] = "0\n";
 
-	if (*ppos) {
+	if (*ppos || *lenp < sizeof(kbuf)) {
 		*lenp = 0;
 		return 0;
 	}
_

Patches currently in -mm which might be from gang.chen@asianux.com are

sh64-kernel-use-usp-instead-of-fn.patch
sh64-kernel-remove-useless-variable-regs.patch
include-linux-interrupth-add-dummy-irq_set_irq_wake-for-generic_hardirqs.patch
mm-page_allocc-use-__paginginit-instead-of-__init.patch
mm-mremapc-call-pud_free-after-fail-calling-pmd_alloc.patch
mm-backing-devc-check-user-buffer-length-before-copying-data-to-the-related-user-buffer.patch
kernel-smpc-free-related-resources-when-failure-occurs-in-hotplug_cfd.patch
linux-next.patch
mm-kconfig-add-mmu-dependency-for-migration.patch

