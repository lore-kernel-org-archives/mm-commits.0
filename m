From: akpm@linux-foundation.org
Subject: - kobject-temporarily-save-k_name-on-cleanup-for-debug-message.patch removed from -mm tree
Date: Wed, 26 Sep 2007 18:43:18 -0700
Message-ID: <200709270143.l8R1hIjW013945@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33881 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752515AbXI0BnZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 21:43:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: huckc@de.ibm.com, cornelia.huck@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     kobject: temporarily save k_name on cleanup for debug message.
has been removed from the -mm tree.  Its filename was
     kobject-temporarily-save-k_name-on-cleanup-for-debug-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 lib/kobject.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN lib/kobject.c~kobject-temporarily-save-k_name-on-cleanup-for-debug-message lib/kobject.c
--- a/lib/kobject.c~kobject-temporarily-save-k_name-on-cleanup-for-debug-message
+++ a/lib/kobject.c
@@ -493,23 +493,23 @@ struct kobject * kobject_get(struct kobj
  *	@kobj:	object.
  */
 
-void kobject_cleanup(struct kobject * kobj)
+void kobject_cleanup(struct kobject *kobj)
 {
-	struct kobj_type * t = get_ktype(kobj);
-	struct kset * s = kobj->kset;
-	struct kobject * parent = kobj->parent;
+	struct kobj_type *t = get_ktype(kobj);
+	struct kset *s = kobj->kset;
+	struct kobject *parent = kobj->parent;
+	const char *k_name = kobj->k_name;
 
 	pr_debug("kobject %s: cleaning up\n",kobject_name(kobj));
 	if (t && t->release) {
 		t->release(kobj);
-		kfree(kobj->k_name);
 		kobj->k_name = NULL;
 	} else
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
