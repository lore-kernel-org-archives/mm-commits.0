From: akpm@osdl.org
Subject: + kobject-kobj-k_name-verification-fix.patch added to -mm tree
Date: Tue, 02 Jan 2007 13:28:10 -0800
Message-ID: <200701022128.l02LSAx8030240@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:33636 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754932AbXABV2X (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 16:28:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mstoilov@odesys.com, greg@kroah.com


The patch titled
     kobject: kobj->k_name verification fix
has been added to the -mm tree.  Its filename is
     kobject-kobj-k_name-verification-fix.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 lib/kobject.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/kobject.c~kobject-kobj-k_name-verification-fix lib/kobject.c
--- a/lib/kobject.c~kobject-kobj-k_name-verification-fix
+++ a/lib/kobject.c
@@ -211,7 +211,7 @@ int kobject_add(struct kobject * kobj)
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

kobject-kobj-k_name-verification-fix.patch
