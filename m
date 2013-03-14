From: akpm@linux-foundation.org
Subject: + ipc-refactor-msg-list-search-into-separate-function-fix.patch added to -mm tree
Date: Thu, 14 Mar 2013 14:40:11 -0700
Message-ID: <20130314214011.729255A41B0@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:50158 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab3CNVkN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Mar 2013 17:40:13 -0400
Received: by mail-ve0-f201.google.com with SMTP id 14so277027vea.2
        for <mm-commits@vger.kernel.org>; Thu, 14 Mar 2013 14:40:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, hannes@cmpxchg.org, peter@hurleysoftware.com


The patch titled
     Subject: ipc: find_msg can be static
has been added to the -mm tree.  Its filename is
     ipc-refactor-msg-list-search-into-separate-function-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: ipc: find_msg can be static

Fixes sparse warning identified by Fengguang's test robot:
   ipc/msg.c:810:16: sparse: symbol 'find_msg' was not declared. Should it be static?

Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN ipc/msg.c~ipc-refactor-msg-list-search-into-separate-function-fix ipc/msg.c
--- a/ipc/msg.c~ipc-refactor-msg-list-search-into-separate-function-fix
+++ a/ipc/msg.c
@@ -807,7 +807,7 @@ static inline void free_copy(struct msg_
 }
 #endif
 
-struct msg_msg *find_msg(struct msg_queue *msq, long *msgtyp, int mode)
+static struct msg_msg *find_msg(struct msg_queue *msq, long *msgtyp, int mode)
 {
 	struct msg_msg *msg;
 	long count = 0;
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
hwpoison-check-dirty-flag-to-match-against-clean-page.patch
smp-give-warning-when-calling-smp_call_function_many-single-in-serving-irq.patch
ipc-refactor-msg-list-search-into-separate-function-fix.patch
aio-dont-include-aioh-in-schedh-fix-3-fix.patch
aio-dont-include-aioh-in-schedh-fix-3-fix-fix.patch
aio-kill-ki_retry-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
debugging-keep-track-of-page-owner-now-depends-on-stacktrace_support.patch

