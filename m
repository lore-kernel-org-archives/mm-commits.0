From: akpm@linux-foundation.org
Subject: - lguest-remove-pv_info-dependency.patch removed from -mm tree
Date: Fri, 01 Feb 2008 14:30:48 -0800
Message-ID: <200802012230.m11MUmni001937@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36948 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755238AbYBAWlC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2008 17:41:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gcosta@redhat.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     lguest: remove pv_info dependency
has been removed from the -mm tree.  Its filename was
     lguest-remove-pv_info-dependency.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lguest: remove pv_info dependency
From: Glauber de Oliveira Costa <gcosta@redhat.com>

Currently, lguest module can't be compiled without the PARAVIRT flag being
on.  This is a fake dependency, since the module itself shouldn't need any
paravirt override.  Reason for that is the reference to pv_info structure
in initial loading tests.

This patch removes it in favour of a more generic error message.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/lguest/core.c~lguest-remove-pv_info-dependency drivers/lguest/core.c
--- a/drivers/lguest/core.c~lguest-remove-pv_info-dependency
+++ a/drivers/lguest/core.c
@@ -253,7 +253,7 @@ static int __init init(void)
 
 	/* Lguest can't run under Xen, VMI or itself.  It does Tricky Stuff. */
 	if (paravirt_enabled()) {
-		printk("lguest is afraid of %s\n", pv_info.name);
+		printk("lguest is afraid of being a guest\n");
 		return -EPERM;
 	}
 
_

Patches currently in -mm which might be from gcosta@redhat.com are

origin.patch
git-kvm.patch
