From: akpm@linux-foundation.org
Subject: + audit-remove-unnecessary-if-config_audit.patch added to -mm tree
Date: Mon, 15 Apr 2013 14:00:32 -0700
Message-ID: <20130415210032.A749B31C0F7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:43940 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab3DOVAe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Apr 2013 17:00:34 -0400
Received: by mail-ve0-f201.google.com with SMTP id jz10so145881veb.2
        for <mm-commits@vger.kernel.org>; Mon, 15 Apr 2013 14:00:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gaofeng@cn.fujitsu.com, eparis@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: audit: remove unnecessary #if CONFIG_AUDIT
has been added to the -mm tree.  Its filename is
     audit-remove-unnecessary-if-config_audit.patch

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
Subject: audit: remove unnecessary #if CONFIG_AUDIT

The files which include kernel/audit.h are complied only when CONFIG_AUDIT
is set.

Just like audit_pid, there is no need to surround audit_ever_enabled with
CONFIG_AUDIT.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/audit.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN kernel/audit.h~audit-remove-unnecessary-if-config_audit kernel/audit.h
--- a/kernel/audit.h~audit-remove-unnecessary-if-config_audit
+++ a/kernel/audit.h
@@ -59,9 +59,7 @@ struct audit_entry {
 	struct audit_krule	rule;
 };
 
-#ifdef CONFIG_AUDIT
 extern int audit_ever_enabled;
-#endif
 
 extern int audit_pid;
 
_

Patches currently in -mm which might be from gaofeng@cn.fujitsu.com are

linux-next.patch
audit-dont-check-if-kauditd-is-valid-every-time.patch
audit-remove-duplicate-export-of-audit_enabled.patch
audit-remove-unnecessary-if-config_audit.patch

