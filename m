From: akpm@linux-foundation.org
Subject: + lguest-remove-pv_info-dependency.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:18:19 -0800
Message-ID: <200801270518.m0R5IGji031189@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33933 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751321AbYA0FSz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:18:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gcosta@redhat.com, rusty@rustcorp.com.au


The patch titled
     lguest: remove pv_info dependency
has been added to the -mm tree.  Its filename is
     lguest-remove-pv_info-dependency.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-kvm.patch
git-x86.patch
fix-drivers-lguest-makefile-entry.patch
lguest-remove-pv_info-dependency.patch
