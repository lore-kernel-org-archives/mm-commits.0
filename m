From: akpm@linux-foundation.org
Subject: - kobject-kobj-k_name-verification-fix.patch removed from -mm tree
Date: Fri, 09 Feb 2007 21:23:51 -0800
Message-ID: <200702100523.l1A5Np7F004554@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36675 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668AbXBJFYL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 00:24:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mstoilov@odesys.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     kobject: kobj->k_name verification fix
has been removed from the -mm tree.  Its filename was
     kobject-kobj-k_name-verification-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kobject: kobj->k_name verification fix
From: Martin Stoilov <mstoilov@odesys.com>

The function 'kobject_add' tries to verify the name of
a new kobject instance is properly set before continuing.
    if (!kobj->k_name)
        kobj->k_name = kobj->name;
    if (!kobj->k_name) {
        pr_debug("kobject attempted to be registered with no name!\n");
        WARN_ON(1);
        return -EINVAL;
    }
The statement:
    if (!kobj->k_name) {
        pr_debug("kobject attempted to be registered with no name!\n");
        WARN_ON(1);
        return -EINVAL;
    }
is useless the way it is right now, because it can never be true. I
think the
code was intended to be:
    if (!kobj->k_name)
        kobj->k_name = kobj->name;
    if (!*kobj->k_name) {
        pr_debug("kobject attempted to be registered with no name!\n");
        WARN_ON(1);
        return -EINVAL;
    }
because this would make sure the kobj->name buffer has something in it.
So the missing '*' is just a typo. Although, I would much prefer
expression like:
    if (*kobj->k_name == '\0') {
        pr_debug("kobject attempted to be registered with no name!\n");
        WARN_ON(1);
        return -EINVAL;
    }

because this would've made the intention clear, in this patch I just restore
the missing '*' without changing the coding style of the function.

Signed-off-by: Martin Stoilov <mstoilov@odesys.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kobject.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/kobject.c~kobject-kobj-k_name-verification-fix lib/kobject.c
--- a/lib/kobject.c~kobject-kobj-k_name-verification-fix
+++ a/lib/kobject.c
@@ -214,7 +214,7 @@ int kobject_shadow_add(struct kobject * 
 		return -ENOENT;
 	if (!kobj->k_name)
 		kobj->k_name = kobj->name;
-	if (!kobj->k_name) {
+	if (!*kobj->k_name) {
 		pr_debug("kobject attempted to be registered with no name!\n");
 		WARN_ON(1);
 		return -EINVAL;
_

Patches currently in -mm which might be from mstoilov@odesys.com are
