From: akpm@linux-foundation.org
Subject: [merged] audit-remove-unnecessary-if-config_audit.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:43:24 -0700
Message-ID: <20130430184324.7E5BD31C0F7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:43204 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932649Ab3D3SnZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:43:25 -0400
Received: by mail-ve0-f201.google.com with SMTP id m1so75201ves.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:43:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gaofeng@cn.fujitsu.com, eparis@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: audit: remove unnecessary #if CONFIG_AUDIT
has been removed from the -mm tree.  Its filename was
     audit-remove-unnecessary-if-config_audit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

