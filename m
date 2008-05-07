From: akpm@linux-foundation.org
Subject: + example-use-of-warn.patch added to -mm tree
Date: Wed, 07 May 2008 14:47:40 -0700
Message-ID: <200805072147.m47Llea1018077@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35818 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765035AbYEGVsM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 17:48:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com, greg@kroah.com


The patch titled
     Example use of WARN()
has been added to the -mm tree.  Its filename is
     example-use-of-warn.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Example use of WARN()
From: Arjan van de Ven <arjan@linux.intel.com>

Now that WARN() exists, we can fold some of the printk's into it.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kobject.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN lib/kobject.c~example-use-of-warn lib/kobject.c
--- a/lib/kobject.c~example-use-of-warn
+++ a/lib/kobject.c
@@ -215,9 +215,8 @@ static int kobject_add_internal(struct k
 		return -ENOENT;
 
 	if (!kobj->name || !kobj->name[0]) {
-		pr_debug("kobject: (%p): attempted to be registered with empty "
+		WARN(1, "kobject: (%p): attempted to be registered with empty "
 			 "name!\n", kobj);
-		WARN_ON(1);
 		return -EINVAL;
 	}
 
@@ -629,12 +628,10 @@ static void kobject_release(struct kref 
 void kobject_put(struct kobject *kobj)
 {
 	if (kobj) {
-		if (!kobj->state_initialized) {
-			printk(KERN_WARNING "kobject: '%s' (%p): is not "
+		if (!kobj->state_initialized)
+			WARN(1, KERN_WARNING "kobject: '%s' (%p): is not "
 			       "initialized, yet kobject_put() is being "
 			       "called.\n", kobject_name(kobj), kobj);
-			WARN_ON(1);
-		}
 		kref_put(&kobj->kref, kobject_release);
 	}
 }
_

Patches currently in -mm which might be from arjan@linux.intel.com are

origin.patch
linux-next.patch
rename-warn-to-warning-to-clear-the-namespace.patch
add-a-warn-macro-this-is-warn_on-printk-arguments.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix-checkpatch-fixes.patch
example-use-of-warn.patch

