From: akpm@linux-foundation.org
Subject: + mm-clean-up-transparent-hugepage-sysfs-error-messages.patch added to -mm tree
Date: Wed, 19 Dec 2012 14:13:33 -0800
Message-ID: <20121219221333.95DA082004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:45688 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab2LSWNe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 17:13:34 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so291977yen.2
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 14:13:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeder@redhat.com, aquini@redhat.com


The patch titled
     Subject: mm: clean up transparent hugepage sysfs error messages
has been added to the -mm tree.  Its filename is
     mm-clean-up-transparent-hugepage-sysfs-error-messages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jeremy Eder <jeder@redhat.com>
Subject: mm: clean up transparent hugepage sysfs error messages

Clarify error messages and correct a few typos in the transparent hugepage
sysfs init code.

Signed-off-by: Jeremy Eder <jeder@redhat.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
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

mm-clean-up-transparent-hugepage-sysfs-error-messages.patch

