From: akpm@linux-foundation.org
Subject: + kexec-get-rid-of-duplicate-check-for-hole_end.patch added to -mm tree
Date: Wed, 30 Jan 2013 13:18:18 -0800
Message-ID: <20130130211818.98DCF5A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:46167 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab3A3VST (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Jan 2013 16:18:19 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so204908yen.0
        for <mm-commits@vger.kernel.org>; Wed, 30 Jan 2013 13:18:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhangyanfei@cn.fujitsu.com, ebiederm@xmission.com


The patch titled
     Subject: kexec: get rid of duplicate check for hole_end
has been added to the -mm tree.  Its filename is
     kexec-get-rid-of-duplicate-check-for-hole_end.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: kexec: get rid of duplicate check for hole_end

hole_end has been checked to make sure it is <= crash_res.end in the while
condition check, so the if condition check is duplicate.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN kernel/kexec.c~kexec-get-rid-of-duplicate-check-for-hole_end kernel/kexec.c
--- a/kernel/kexec.c~kexec-get-rid-of-duplicate-check-for-hole_end
+++ a/kernel/kexec.c
@@ -497,8 +497,6 @@ static struct page *kimage_alloc_crash_c
 
 		if (hole_end > KEXEC_CRASH_CONTROL_MEMORY_LIMIT)
 			break;
-		if (hole_end > crashk_res.end)
-			break;
 		/* See if I overlap any of the segments */
 		for (i = 0; i < image->nr_segments; i++) {
 			unsigned long mstart, mend;
_

Patches currently in -mm which might be from zhangyanfei@cn.fujitsu.com are

binfmt_elf-remove-unused-argument-in-fill_elf_header.patch
kexec-get-rid-of-duplicate-check-for-hole_end.patch

