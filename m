From: akpm@linux-foundation.org
Subject: [merged]
 params-fix-the-maximum-length-in-param_get_string.patch removed from -mm
 tree
Date: Wed, 04 Oct 2017 12:42:04 -0700
Message-ID: <20171004194204.rMSZSkg7i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33758 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbdJDTmF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2017 15:42:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, jdelvare@suse.de, mhocko@suse.com, mingo@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/params.c: fix the maximum length in param_get_string
has been removed from the -mm tree.  Its filename was
     params-fix-the-maximum-length-in-param_get_string.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


