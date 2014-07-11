From: akpm@linux-foundation.org
Subject: + coredump-fix-the-setting-of-pf_dumpcore.patch added to -mm tree
Date: Fri, 11 Jul 2014 14:27:50 -0700
Message-ID: <53c056d6.AXZ68uW4+xsMaiU8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:33079 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbaGKV1v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Jul 2014 17:27:51 -0400
Received: by mail-oa0-f74.google.com with SMTP id eb12so161306oac.5
        for <mm-commits@vger.kernel.org>; Fri, 11 Jul 2014 14:27:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: svellattu@mvista.com, msb@chromium.org, oleg@redhat.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: fix the setting of PF_DUMPCORE
has been added to the -mm tree.  Its filename is
     coredump-fix-the-setting-of-pf_dumpcore.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/coredump-fix-the-setting-of-pf_dumpcore.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/coredump-fix-the-setting-of-pf_dumpcore.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Silesh C V <svellattu@mvista.com>
Subject: coredump: fix the setting of PF_DUMPCORE

commit 079148b91 ("coredump: factor out the setting of PF_DUMPCORE")
cleaned up the setting of PF_DUMPCORE by removing it from all the
linux_binfmt->core_dump() and moving it to zap_threads().But this ended up
clearing all the previously set flags.  This causes issues during core
generation when tsk->flags is checked again (eg.  for PF_USED_MATH to dump
floating point registers).  Fix this.

Signed-off-by: Silesh C V <svellattu@mvista.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Mandeep Singh Baines <msb@chromium.org>
Cc: <stable@vger.kernel.org>	[3.10+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/coredump.c~coredump-fix-the-setting-of-pf_dumpcore fs/coredump.c
--- a/fs/coredump.c~coredump-fix-the-setting-of-pf_dumpcore
+++ a/fs/coredump.c
@@ -306,7 +306,7 @@ static int zap_threads(struct task_struc
 	if (unlikely(nr < 0))
 		return nr;
 
-	tsk->flags = PF_DUMPCORE;
+	tsk->flags |= PF_DUMPCORE;
 	if (atomic_read(&mm->mm_users) == nr + 1)
 		goto done;
 	/*
_

Patches currently in -mm which might be from svellattu@mvista.com are

coredump-fix-the-setting-of-pf_dumpcore.patch

