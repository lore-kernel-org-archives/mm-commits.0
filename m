From: akpm@linux-foundation.org
Subject: + audit-remove-duplicate-export-of-audit_enabled.patch added to -mm tree
Date: Mon, 15 Apr 2013 14:00:30 -0700
Message-ID: <20130415210030.CA4565A4243@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:35915 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab3DOVAc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Apr 2013 17:00:32 -0400
Received: by mail-qa0-f73.google.com with SMTP id p6so131049qad.0
        for <mm-commits@vger.kernel.org>; Mon, 15 Apr 2013 14:00:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gaofeng@cn.fujitsu.com, eparis@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: audit: remove duplicate export of audit_enabled
has been added to the -mm tree.  Its filename is
     audit-remove-duplicate-export-of-audit_enabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: audit: remove duplicate export of audit_enabled

audit_enabled has already been exported in include/linux/audit.h.  and
kernel/audit.h includes include/linux/audit.h, no need to export
aduit_enabled again in kernel/audit.h

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/audit.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/audit.h~audit-remove-duplicate-export-of-audit_enabled kernel/audit.h
--- a/kernel/audit.h~audit-remove-duplicate-export-of-audit_enabled
+++ a/kernel/audit.h
@@ -60,7 +60,6 @@ struct audit_entry {
 };
 
 #ifdef CONFIG_AUDIT
-extern int audit_enabled;
 extern int audit_ever_enabled;
 #endif
 
_

Patches currently in -mm which might be from gaofeng@cn.fujitsu.com are

linux-next.patch
audit-dont-check-if-kauditd-is-valid-every-time.patch
audit-remove-duplicate-export-of-audit_enabled.patch
audit-remove-unnecessary-if-config_audit.patch

