From: akpm@linux-foundation.org
Subject: + params-fix-the-maximum-length-in-param_get_string.patch added
 to -mm tree
Date: Thu, 28 Sep 2017 13:46:49 -0700
Message-ID: <59cd5fb9.r40Tuul7B7jGA1sR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45840 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751490AbdI1Uqu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Sep 2017 16:46:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdelvare@suse.de, bhe@redhat.com, mhocko@suse.com, mingo@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/params.c: fix the maximum length in param_get_string
has been added to the -mm tree.  Its filename is
     params-fix-the-maximum-length-in-param_get_string.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/params-fix-the-maximum-length-in-param_get_string.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/params-fix-the-maximum-length-in-param_get_string.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jean Delvare <jdelvare@suse.de>
Subject: kernel/params.c: fix the maximum length in param_get_string

The length parameter of strlcpy() is supposed to reflect the size of the
target buffer, not of the source string.  Harmless in this case as the
buffer is PAGE_SIZE long and the source string is always much shorter than
this, but conceptually wrong, so let's fix it.

Link: http://lkml.kernel.org/r/20170928162515.24846b4f@endymion
Signed-off-by: Jean Delvare <jdelvare@suse.de>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/params.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/params.c~params-fix-the-maximum-length-in-param_get_string kernel/params.c
--- a/kernel/params.c~params-fix-the-maximum-length-in-param_get_string
+++ a/kernel/params.c
@@ -507,7 +507,7 @@ EXPORT_SYMBOL(param_set_copystring);
 int param_get_string(char *buffer, const struct kernel_param *kp)
 {
 	const struct kparam_string *kps = kp->str;
-	return strlcpy(buffer, kps->string, kps->maxlen);
+	return strlcpy(buffer, kps->string, PAGE_SIZE);
 }
 EXPORT_SYMBOL(param_get_string);
 
_

Patches currently in -mm which might be from jdelvare@suse.de are

params-align-add_sysfs_param-documentation-with-code.patch
params-fix-the-maximum-length-in-param_get_string.patch
params-fix-an-overflow-in-param_attr_show.patch
params-improve-standard_param_def-readability.patch

