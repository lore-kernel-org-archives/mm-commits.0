From: akpm@linux-foundation.org
Subject: + ocfs2-fix-error-return-code-in-ocfs2_info_handle_freefrag.patch added to -mm tree
Date: Mon, 08 Apr 2013 16:58:31 -0700
Message-ID: <20130408235831.85A4631C303@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ia0-f202.google.com ([209.85.210.202]:37039 "EHLO
	mail-ia0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936469Ab3DHX6d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Apr 2013 19:58:33 -0400
Received: by mail-ia0-f202.google.com with SMTP id p22so1623486iad.3
        for <mm-commits@vger.kernel.org>; Mon, 08 Apr 2013 16:58:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yongjun_wei@trendmicro.com.cn, jlbec@evilplan.org, mfasheh@suse.com


The patch titled
     Subject: ocfs2: fix error return code in ocfs2_info_handle_freefrag()
has been added to the -mm tree.  Its filename is
     ocfs2-fix-error-return-code-in-ocfs2_info_handle_freefrag.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: ocfs2: fix error return code in ocfs2_info_handle_freefrag()

Fix to return a negative error code from the error handling case instead
of 0, as returned elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/ioctl.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/ocfs2/ioctl.c~ocfs2-fix-error-return-code-in-ocfs2_info_handle_freefrag fs/ocfs2/ioctl.c
--- a/fs/ocfs2/ioctl.c~ocfs2-fix-error-return-code-in-ocfs2_info_handle_freefrag
+++ a/fs/ocfs2/ioctl.c
@@ -706,8 +706,10 @@ int ocfs2_info_handle_freefrag(struct in
 
 	o2info_set_request_filled(&oiff->iff_req);
 
-	if (o2info_to_user(*oiff, req))
+	if (o2info_to_user(*oiff, req)) {
+		status = -EFAULT;
 		goto bail;
+	}
 
 	status = 0;
 bail:
_

Patches currently in -mm which might be from yongjun_wei@trendmicro.com.cn are

linux-next.patch
ocfs2-fix-error-return-code-in-ocfs2_info_handle_freefrag.patch
rpmsg-fix-error-return-code-in-rpmsg_probe.patch
drivers-video-backlight-adp8860_blc-fix-error-return-code-in-adp8860_led_probe.patch
drivers-video-backlight-adp8870_blc-fix-error-return-code-in-adp8870_led_probe.patch

