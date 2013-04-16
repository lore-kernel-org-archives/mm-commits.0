From: akpm@linux-foundation.org
Subject: + mwave-fix-info-leak-in-mwave_ioctl.patch added to -mm tree
Date: Tue, 16 Apr 2013 14:10:42 -0700
Message-ID: <20130416211042.7E3FB31C034@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:39170 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965351Ab3DPVKn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Apr 2013 17:10:43 -0400
Received: by mail-gg0-f202.google.com with SMTP id q1so95120ggn.5
        for <mm-commits@vger.kernel.org>; Tue, 16 Apr 2013 14:10:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.carpenter@oracle.com, greg@kroah.com, jkosina@suse.cz


The patch titled
     Subject: mwave: fix info leak in mwave_ioctl()
has been added to the -mm tree.  Its filename is
     mwave-fix-info-leak-in-mwave_ioctl.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: mwave: fix info leak in mwave_ioctl()

Smatch complains that on 64 bit systems, there is a hole in the
MW_ABILITIES struct between ->component_count and ->component_list[].  It
leaks stack information from the mwave_ioctl() function.

I've added a memset() to initialize the struct to zero.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg KH <greg@kroah.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mwave/tp3780i.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/char/mwave/tp3780i.c~mwave-info-leak-in-mwave_ioctl drivers/char/mwave/tp3780i.c
--- a/drivers/char/mwave/tp3780i.c~mwave-info-leak-in-mwave_ioctl
+++ a/drivers/char/mwave/tp3780i.c
@@ -479,6 +479,7 @@ int tp3780I_QueryAbilities(THINKPAD_BD_D
 	PRINTK_2(TRACE_TP3780I,
 		"tp3780i::tp3780I_QueryAbilities entry pBDData %p\n", pBDData);
 
+	memset(pAbilities, 0, sizeof(*pAbilities));
 	/* fill out standard constant fields */
 	pAbilities->instr_per_sec = pBDData->rDspSettings.uIps;
 	pAbilities->data_size = pBDData->rDspSettings.uDStoreSize;
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

linux-next.patch
ocfs2-fix-error-handling-in-ocfs2_ioctl_move_extents.patch
ocfs2-fix-null-dereference-for-moving-extents.patch
mm-page_alloc-avoid-marking-zones-full-prematurely-after-zone_reclaim-fix.patch
i2o-check-copy_from_user-size-parameter.patch
mwave-fix-info-leak-in-mwave_ioctl.patch

