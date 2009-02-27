From: akpm@linux-foundation.org
Subject: + introduce-pr_cont-macro.patch added to -mm tree
Date: Fri, 27 Feb 2009 12:37:43 -0800
Message-ID: <200902272037.n1RKbhCa032278@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760829AbZB0UiB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Feb 2009 15:38:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, gorcunov@openvz.org, harvey.harrison@gmail.com, hpa@zytor.com, mingo@elte.hu


The patch titled
     introduce pr_cont() macro
has been added to the -mm tree.  Its filename is
     introduce-pr_cont-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: introduce pr_cont() macro
From: Cyrill Gorcunov <gorcunov@gmail.com>

We cover all log-levels by pr_...  macros except KERN_CONT one.  Add it
for convenience.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/kernel.h~introduce-pr_cont-macro include/linux/kernel.h
--- a/include/linux/kernel.h~introduce-pr_cont-macro
+++ a/include/linux/kernel.h
@@ -370,6 +370,8 @@ static inline char *pack_hex_byte(char *
         printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_info(fmt, ...) \
         printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_cont(fmt, ...) \
+	printk(KERN_CONT fmt, ##__VA_ARGS__)
 
 /* If you are writing a driver, please use dev_dbg instead */
 #if defined(DEBUG)
_

Patches currently in -mm which might be from gorcunov@gmail.com are

linux-next.patch
mm-mminit_validate_memmodel_limits-get-rid-of-redundant-test.patch
oom_kill-dont-call-for-int_sqrt0.patch
introduce-pr_cont-macro.patch

