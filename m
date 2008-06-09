From: akpm@linux-foundation.org
Subject: + selinux-change-handling-of-invalid-classes.patch added to -mm tree
Date: Mon, 09 Jun 2008 15:16:46 -0700
Message-ID: <200806092216.m59MGkKm011053@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45621 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752283AbYFIWSG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2008 18:18:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sds@tycho.nsa.gov, eparis@redhat.com, jmorris@namei.org


The patch titled
     selinux: change handling of invalid classes
has been added to the -mm tree.  Its filename is
     selinux-change-handling-of-invalid-classes.patch

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
Subject: selinux: change handling of invalid classes
From: Stephen Smalley <sds@tycho.nsa.gov>

On Mon, 2008-06-09 at 01:24 -0700, Andrew Morton wrote:
> Getting a few of these with FC5:
>
> SELinux: context_struct_compute_av:  unrecognized class 69
> SELinux: context_struct_compute_av:  unrecognized class 69
>
> one came out when I logged in.
>
> No other symptoms, yet.

Change handling of invalid classes by SELinux, reporting class values
unknown to the kernel as errors (w/ ratelimit applied) and handling
class values unknown to policy as normal denials.

Signed-off-by: Stephen Smalley <sds@tycho.nsa.gov>
Acked-by: Eric Paris <eparis@redhat.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/selinux/ss/services.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff -puN security/selinux/ss/services.c~selinux-change-handling-of-invalid-classes security/selinux/ss/services.c
--- a/security/selinux/ss/services.c~selinux-change-handling-of-invalid-classes
+++ a/security/selinux/ss/services.c
@@ -415,9 +415,19 @@ static int context_struct_compute_av(str
 	return 0;
 
 inval_class:
-	printk(KERN_ERR "SELinux: %s:  unrecognized class %d\n", __func__,
-		tclass);
-	return -EINVAL;
+	if (!tclass || tclass > kdefs->cts_len ||
+	    !kdefs->class_to_string[tclass]) {
+		if (printk_ratelimit())
+			printk(KERN_ERR "SELinux: %s:  unrecognized class %d\n",
+			       __func__, tclass);
+		return -EINVAL;
+	}
+
+	/*
+	 * Known to the kernel, but not to the policy.
+	 * Handle as a denial (allowed is 0).
+	 */
+	return 0;
 }
 
 /*
_

Patches currently in -mm which might be from sds@tycho.nsa.gov are

origin.patch
linux-next.patch
selinux-change-handling-of-invalid-classes.patch
git-unionfs.patch

