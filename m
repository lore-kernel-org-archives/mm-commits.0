From: akpm@linux-foundation.org
Subject: + kernelh-neaten-panic-prototype.patch added to -mm tree
Date: Thu, 10 Nov 2011 14:37:32 -0800
Message-ID: <201111102237.pAAMbX3B016414@wpaz21.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:57766 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab1KJWhk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Nov 2011 17:37:40 -0500
Received: by yenr9 with SMTP id r9so309006yen.1
        for <mm-commits@vger.kernel.org>; Thu, 10 Nov 2011 14:37:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     Subject: kernel.h: neaten panic prototype
has been added to the -mm tree.  Its filename is
     kernelh-neaten-panic-prototype.patch

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
From: Joe Perches <joe@perches.com>
Subject: kernel.h: neaten panic prototype

Use __printf macro.
Convert NORET_AND to ATTRIB_NORET.
Use the normal kernel style for pointer arguments.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/kernel.h~kernelh-neaten-panic-prototype include/linux/kernel.h
--- a/include/linux/kernel.h~kernelh-neaten-panic-prototype
+++ a/include/linux/kernel.h
@@ -185,8 +185,9 @@ static inline void might_fault(void)
 
 extern struct atomic_notifier_head panic_notifier_list;
 extern long (*panic_blink)(int state);
-NORET_TYPE void panic(const char * fmt, ...)
-	__attribute__ ((NORET_AND format (printf, 1, 2))) __cold;
+NORET_TYPE __printf(1, 2)
+void panic(const char *fmt, ...)
+	ATTRIB_NORET __cold;
 extern void oops_enter(void);
 extern void oops_exit(void);
 void print_oops_end_marker(void);
_
Subject: Subject: kernel.h: neaten panic prototype

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
maintainers-staging-cx25821-add-l-linux-media.patch
kernelh-neaten-panic-prototype.patch
linkage-remove-unused-noret_and-macro.patch
treewide-remove-useless-noret_type-macro-and-uses.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn.patch
linkage-remove-unused-attrib_noret-macro.patch
checkpatch-update-signature-might-be-better-as-warning.patch

