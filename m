From: akpm@linux-foundation.org
Subject: + kobject-use-kvasprintf_const-for-formatting-name.patch added to -mm tree
Date: Tue, 15 Sep 2015 12:44:02 -0700
Message-ID: <55f87502.j5d7ewNPqWkSOmcJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34792 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbbIOToD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Sep 2015 15:44:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/kobject.c: use kvasprintf_const for formatting ->name
has been added to the -mm tree.  Its filename is
     kobject-use-kvasprintf_const-for-formatting-name.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kobject-use-kvasprintf_const-for-formatting-name.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kobject-use-kvasprintf_const-for-formatting-name.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/kobject.c: use kvasprintf_const for formatting ->name

Sometimes kobject_set_name_vargs is called with a format string conaining
no %, or a format string of precisely "%s", where the single vararg
happens to point to .rodata.  kvasprintf_const detects these cases for us
and returns a copy of that pointer instead of duplicating the string, thus
saving some run-time memory.  Otherwise, it falls back to kvasprintf.  We
just need to always deallocate ->name using kfree_const.

Unfortunately, the dance we need to do to perform the '/' -> '!'
sanitization makes the resulting code rather ugly.

I instrumented kstrdup_const to provide some statistics on the memory
saved, and for me this gave an additional ~14KB after boot (306KB was
already saved; this patch bumped that to 320KB).  I have
KMALLOC_SHIFT_LOW==3, and since 80% of the kvasprintf_const hits were
satisfied by an 8-byte allocation, the 14K would roughly be quadrupled
when KMALLOC_SHIFT_LOW==5.  Whether these numbers are sufficient to
justify the ugliness I'll leave to others to decide.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kobject.c |   30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff -puN lib/kobject.c~kobject-use-kvasprintf_const-for-formatting-name lib/kobject.c
--- a/lib/kobject.c~kobject-use-kvasprintf_const-for-formatting-name
+++ a/lib/kobject.c
@@ -257,18 +257,32 @@ static int kobject_add_internal(struct k
 int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
 				  va_list vargs)
 {
-	char *s;
+	const char *s;
 
 	if (kobj->name && !fmt)
 		return 0;
 
-	s = kvasprintf(GFP_KERNEL, fmt, vargs);
+	s = kvasprintf_const(GFP_KERNEL, fmt, vargs);
 	if (!s)
 		return -ENOMEM;
 
-	/* ewww... some of these buggers have '/' in the name ... */
-	strreplace(s, '/', '!');
-	kfree(kobj->name);
+	/*
+	 * ewww... some of these buggers have '/' in the name ... If
+	 * that's the case, we need to make sure we have an actual
+	 * allocated copy to modify, since kvasprintf_const may have
+	 * returned something from .rodata.
+	 */
+	if (strchr(s, '/')) {
+		char *t;
+
+		t = kstrdup(s, GFP_KERNEL);
+		kfree_const(s);
+		if (!t)
+			return -ENOMEM;
+		strreplace(t, '/', '!');
+		s = t;
+	}
+	kfree_const(kobj->name);
 	kobj->name = s;
 
 	return 0;
@@ -466,7 +480,7 @@ int kobject_rename(struct kobject *kobj,
 	envp[0] = devpath_string;
 	envp[1] = NULL;
 
-	name = dup_name = kstrdup(new_name, GFP_KERNEL);
+	name = dup_name = kstrdup_const(new_name, GFP_KERNEL);
 	if (!name) {
 		error = -ENOMEM;
 		goto out;
@@ -486,7 +500,7 @@ int kobject_rename(struct kobject *kobj,
 	kobject_uevent_env(kobj, KOBJ_MOVE, envp);
 
 out:
-	kfree(dup_name);
+	kfree_const(dup_name);
 	kfree(devpath_string);
 	kfree(devpath);
 	kobject_put(kobj);
@@ -632,7 +646,7 @@ static void kobject_cleanup(struct kobje
 	/* free name if we allocated it */
 	if (name) {
 		pr_debug("kobject: '%s': free name\n", name);
-		kfree(name);
+		kfree_const(name);
 	}
 }
 
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

lib-dynamic_debugc-use-kstrdup_const.patch
lib-introduce-kvasprintf_const.patch
kobject-use-kvasprintf_const-for-formatting-name.patch

