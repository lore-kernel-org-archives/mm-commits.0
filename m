From: akpm@linux-foundation.org
Subject: [merged] lkdtm-avoid-calling-lkdtm_do_action-with-spin-lock-held.patch removed from -mm tree
Date: Mon, 06 Feb 2012 12:31:27 -0800
Message-ID: <20120206203127.66ED8A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:36504 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530Ab2BFUb2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2012 15:31:28 -0500
Received: by ghrr17 with SMTP id r17so616238ghr.1
        for <mm-commits@vger.kernel.org>; Mon, 06 Feb 2012 12:31:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, arnd@arndb.de, dyoung@redhat.com, greg@kroah.com, prarit@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lkdtm: avoid calling lkdtm_do_action() with spinlock held
has been removed from the -mm tree.  Its filename was
     lkdtm-avoid-calling-lkdtm_do_action-with-spin-lock-held.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: lkdtm: avoid calling lkdtm_do_action() with spinlock held

lkdtm_do_action() may call sleeping functions like kmalloc(), so do not
call it with spin lock held.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Reviewed-by: Dave Young <dyoung@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/lkdtm.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/misc/lkdtm.c~lkdtm-avoid-calling-lkdtm_do_action-with-spin-lock-held drivers/misc/lkdtm.c
--- a/drivers/misc/lkdtm.c~lkdtm-avoid-calling-lkdtm_do_action-with-spin-lock-held
+++ a/drivers/misc/lkdtm.c
@@ -354,6 +354,7 @@ static void lkdtm_do_action(enum ctype w
 static void lkdtm_handler(void)
 {
 	unsigned long flags;
+	bool do_it = false;
 
 	spin_lock_irqsave(&count_lock, flags);
 	count--;
@@ -361,10 +362,13 @@ static void lkdtm_handler(void)
 			cp_name_to_str(cpoint), cp_type_to_str(cptype), count);
 
 	if (count == 0) {
-		lkdtm_do_action(cptype);
+		do_it = true;
 		count = cpoint_count;
 	}
 	spin_unlock_irqrestore(&count_lock, flags);
+
+	if (do_it)
+		lkdtm_do_action(cptype);
 }
 
 static int lkdtm_register_cpoint(enum cname which)
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch
linux-next.patch
x86-mm-fix-the-size-calculation-of-mapping-tables.patch
nmi-watchdog-do-not-use-cpp-symbol-in-kconfig.patch
kcore-make-get_sparsemem_vmemmap_info-static.patch
proc-clean-up-proc-pid-environ-handling.patch

