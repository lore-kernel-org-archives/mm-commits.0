From: akpm@linux-foundation.org
Subject: [merged] audit-remove-duplicate-export-of-audit_enabled.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:43:21 -0700
Message-ID: <20130430184321.7813931C2B9@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:53991 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932638Ab3D3SnW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:43:22 -0400
Received: by mail-ve0-f201.google.com with SMTP id m1so75198ves.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:43:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gaofeng@cn.fujitsu.com, eparis@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: audit: remove duplicate export of audit_enabled
has been removed from the -mm tree.  Its filename was
     audit-remove-duplicate-export-of-audit_enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

