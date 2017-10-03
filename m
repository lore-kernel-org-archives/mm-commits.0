From: akpm@linux-foundation.org
Subject: [patch 45/51] kernel/params.c: fix the maximum length in
 param_get_string
Date: Tue, 03 Oct 2017 16:16:35 -0700
Message-ID: <59d41a53.xFj0N0qbsoxwmvss%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58890 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdJCXQg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 19:16:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jdelvare@suse.de, bhe@redhat.com, mhocko@suse.com, mingo@kernel.org

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
