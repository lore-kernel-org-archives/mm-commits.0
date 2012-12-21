From: akpm@linux-foundation.org
Subject: [merged] mm-clean-up-transparent-hugepage-sysfs-error-messages.patch removed from -mm tree
Date: Fri, 21 Dec 2012 12:39:53 -0800
Message-ID: <20121221203953.A4383100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:35211 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab2LUUjy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 15:39:54 -0500
Received: by mail-ye0-f202.google.com with SMTP id l7so517266yen.3
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 12:39:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeder@redhat.com, aquini@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: clean up transparent hugepage sysfs error messages
has been removed from the -mm tree.  Its filename was
     mm-clean-up-transparent-hugepage-sysfs-error-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jeremy Eder <jeder@redhat.com>
Subject: mm: clean up transparent hugepage sysfs error messages

Clarify error messages and correct a few typos in the transparent hugepage
sysfs init code.

Signed-off-by: Jeremy Eder <jeder@redhat.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/huge_memory.c~mm-clean-up-transparent-hugepage-sysfs-error-messages mm/huge_memory.c
--- a/mm/huge_memory.c~mm-clean-up-transparent-hugepage-sysfs-error-messages
+++ a/mm/huge_memory.c
@@ -574,19 +574,19 @@ static int __init hugepage_init_sysfs(st
 
 	*hugepage_kobj = kobject_create_and_add("transparent_hugepage", mm_kobj);
 	if (unlikely(!*hugepage_kobj)) {
-		printk(KERN_ERR "hugepage: failed kobject create\n");
+		printk(KERN_ERR "hugepage: failed to create transparent hugepage kobject\n");
 		return -ENOMEM;
 	}
 
 	err = sysfs_create_group(*hugepage_kobj, &hugepage_attr_group);
 	if (err) {
-		printk(KERN_ERR "hugepage: failed register hugeage group\n");
+		printk(KERN_ERR "hugepage: failed to register transparent hugepage group\n");
 		goto delete_obj;
 	}
 
 	err = sysfs_create_group(*hugepage_kobj, &khugepaged_attr_group);
 	if (err) {
-		printk(KERN_ERR "hugepage: failed register hugeage group\n");
+		printk(KERN_ERR "hugepage: failed to register transparent hugepage group\n");
 		goto remove_hp_group;
 	}
 
_

Patches currently in -mm which might be from jeder@redhat.com are

origin.patch

