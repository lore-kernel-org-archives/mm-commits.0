From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged]
 =?US-ASCII?Q?kexec-do-not-verify-the-signature-without-the-lockdown-or-m?=
 =?US-ASCII?Q?andatory-signature.patch?= removed from -mm tree
Date: Fri, 26 Jun 2020 20:33:07 -0700
Message-ID: <20200627033307.PFVFpOAK-%akpm@linux-foundation.org>
References: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbgF0DdI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Jun 2020 23:33:08 -0400
In-Reply-To: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, dyoung@redhat.com, ebiederm@xmission.com, jbohac@suse.cz, jmorris@namei.org, lijiang@redhat.com, mjg59@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: do not verify the signature without the lockdown or mandatory signature
has been removed from the -mm tree.  Its filename was
     kexec-do-not-verify-the-signature-without-the-lockdown-or-mandatory-signature.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lianbo Jiang <lijiang@redhat.com>
Subject: kexec: do not verify the signature without the lockdown or mandatory signature

Signature verification is an important security feature, to protect system
from being attacked with a kernel of unknown origin.  Kexec rebooting is a
way to replace the running kernel, hence need be secured carefully.

In the current code of handling signature verification of kexec kernel,
the logic is very twisted.  It mixes signature verification, IMA signature
appraising and kexec lockdown.

If there is no KEXEC_SIG_FORCE, kexec kernel image doesn't have one of
signature, the supported crypto, and key, we don't think this is wrong,
Unless kexec lockdown is executed.  IMA is considered as another kind of
signature appraising method.

If kexec kernel image has signature/crypto/key, it has to go through the
signature verification and pass.  Otherwise it's seen as verification
failure, and won't be loaded.

Seems kexec kernel image with an unqualified signature is even worse than
those w/o signature at all, this sounds very unreasonable.  E.g.  If
people get a unsigned kernel to load, or a kernel signed with expired key,
which one is more dangerous?

So, here, let's simplify the logic to improve code readability.  If the
KEXEC_SIG_FORCE enabled or kexec lockdown enabled, signature verification
is mandated.  Otherwise, we lift the bar for any kernel image.

Link: http://lkml.kernel.org/r/20200602045952.27487-1-lijiang@redhat.com
Signed-off-by: Lianbo Jiang <lijiang@redhat.com>
Reviewed-by: Jiri Bohac <jbohac@suse.cz>
Acked-by: Dave Young <dyoung@redhat.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Matthew Garrett <mjg59@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_file.c |   36 +++++++-----------------------------
 1 file changed, 7 insertions(+), 29 deletions(-)

--- a/kernel/kexec_file.c~kexec-do-not-verify-the-signature-without-the-lockdown-or-mandatory-signature
+++ a/kernel/kexec_file.c
@@ -181,34 +181,19 @@ void kimage_file_post_load_cleanup(struc
 static int
 kimage_validate_signature(struct kimage *image)
 {
-	const char *reason;
 	int ret;
 
 	ret = arch_kexec_kernel_verify_sig(image, image->kernel_buf,
 					   image->kernel_buf_len);
-	switch (ret) {
-	case 0:
-		break;
-
-		/* Certain verification errors are non-fatal if we're not
-		 * checking errors, provided we aren't mandating that there
-		 * must be a valid signature.
-		 */
-	case -ENODATA:
-		reason = "kexec of unsigned image";
-		goto decide;
-	case -ENOPKG:
-		reason = "kexec of image with unsupported crypto";
-		goto decide;
-	case -ENOKEY:
-		reason = "kexec of image with unavailable key";
-	decide:
+	if (ret) {
+
 		if (IS_ENABLED(CONFIG_KEXEC_SIG_FORCE)) {
-			pr_notice("%s rejected\n", reason);
+			pr_notice("Enforced kernel signature verification failed (%d).\n", ret);
 			return ret;
 		}
 
-		/* If IMA is guaranteed to appraise a signature on the kexec
+		/*
+		 * If IMA is guaranteed to appraise a signature on the kexec
 		 * image, permit it even if the kernel is otherwise locked
 		 * down.
 		 */
@@ -216,17 +201,10 @@ kimage_validate_signature(struct kimage
 		    security_locked_down(LOCKDOWN_KEXEC))
 			return -EPERM;
 
-		return 0;
