From: akpm@linux-foundation.org
Subject: [merged] lib-kobjectc-use-strreplace.patch removed from -mm tree
Date: Mon, 29 Jun 2015 13:48:11 -0700
Message-ID: <5591af0b.BSZIL3g72NURNn8t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50889 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876AbbF2UsL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:48:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/kobject.c: use strreplace()
has been removed from the -mm tree.  Its filename was
     lib-kobjectc-use-strreplace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/kobject.c: use strreplace()

There's probably not many slashes in the name, but starting over when
we see one feels wrong.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kobject.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN lib/kobject.c~lib-kobjectc-use-strreplace lib/kobject.c
--- a/lib/kobject.c~lib-kobjectc-use-strreplace
+++ a/lib/kobject.c
@@ -257,23 +257,20 @@ static int kobject_add_internal(struct k
 int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
 				  va_list vargs)
 {
-	const char *old_name = kobj->name;
 	char *s;
 
 	if (kobj->name && !fmt)
 		return 0;
 
-	kobj->name = kvasprintf(GFP_KERNEL, fmt, vargs);
-	if (!kobj->name) {
-		kobj->name = old_name;
+	s = kvasprintf(GFP_KERNEL, fmt, vargs);
+	if (!s)
 		return -ENOMEM;
-	}
 
 	/* ewww... some of these buggers have '/' in the name ... */
-	while ((s = strchr(kobj->name, '/')))
-		s[0] = '!';
+	strreplace(s, '/', '!');
+	kfree(kobj->name);
+	kobj->name = s;
 
-	kfree(old_name);
 	return 0;
 }
 
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch

