From: akpm@linux-foundation.org
Subject: + kobject-temporarily-save-k_name-on-cleanup-for-debug-message.patch added to -mm tree
Date: Thu, 20 Sep 2007 22:10:57 -0700
Message-ID: <200709210510.l8L5Avr4019950@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36907 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901AbXIUFLE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 01:11:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: huckc@de.ibm.com, cornelia.huck@de.ibm.com


The patch titled
     kobject: temporarily save k_name on cleanup for debug message.
has been added to the -mm tree.  Its filename is
     kobject-temporarily-save-k_name-on-cleanup-for-debug-message.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kobject: temporarily save k_name on cleanup for debug message.
From: Cornelia Huck <huckc@de.ibm.com>

On Wed, 19 Sep 2007 20:02:05 +0200,
Cornelia Huck <cornelia.huck@de.ibm.com> wrote:

> > kobject drivers: cleaning up
> > kobject '<NULL>' does not have a release() function, if this is not a directory kobject, it is broken and must be fixed.
>
> <Unrelated side note: We should probably save the kobject's name for
> printing this debug message, it looks a bit odd :)>

kobject: Temporarily save k_name on cleanup for debug message.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kobject.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/kobject.c~kobject-temporarily-save-k_name-on-cleanup-for-debug-message lib/kobject.c
--- a/lib/kobject.c~kobject-temporarily-save-k_name-on-cleanup-for-debug-message
+++ a/lib/kobject.c
@@ -498,9 +498,9 @@ void kobject_cleanup(struct kobject * ko
 	struct kobj_type * t = get_ktype(kobj);
 	struct kset * s = kobj->kset;
 	struct kobject * parent = kobj->parent;
+	const char *k_name = kobj->k_name;
 
 	pr_debug("kobject %s: cleaning up\n",kobject_name(kobj));
-	kfree(kobj->k_name);
 	kobj->k_name = NULL;
 	if (t && t->release)
 		t->release(kobj);
@@ -508,8 +508,8 @@ void kobject_cleanup(struct kobject * ko
 		pr_debug("kobject '%s' does not have a release() function, "
 			"if this is not a directory kobject, it is broken "
 			"and must be fixed.\n",
-			kobject_name(kobj));
-
+			k_name);
+	kfree(k_name);
 	if (s)
 		kset_put(s);
 	kobject_put(parent);
_

Patches currently in -mm which might be from huckc@de.ibm.com are

kobject-temporarily-save-k_name-on-cleanup-for-debug-message.patch
