Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A32131715A
	for <mm-commits@vger.kernel.org>; Mon, 29 Jun 2026 05:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782709806; cv=none; b=jQ+MEVsDkMbuNpXp4feUcNI/YG5slzuZBIovQ85hKDr5uhzhdukG/cRFKnId7rrK62iBzCkqDfrsOgZDk+zils61ErzFPYzTxDLIir5Hjbsmc/Sa1rLUd2LnL/qEB997mpLJd9fJbhtAurG+4wqK+DHNapBqx97HJlyO3tkMMzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782709806; c=relaxed/simple;
	bh=uu6kEd2025AOy2pLIIfucXXPd4C/+DafLxLQ42MRnSM=;
	h=Date:To:From:Subject:Message-Id; b=UwTDnNySgcxKCJzzguo7igDXfphPEkl+mODUzav0jDmiVDBdQcsJbDxrDuLgj4YWr9zIpNlJycKm0TSHdBUfYvrYdp7l3Q988pHODnqMqoQYoyqMcs/jDyKq/KevR3PArA7Edf83UT0cri+58yAzwlFmyBjKHbqWdNvZVc2Ax18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7571F000E9;
	Mon, 29 Jun 2026 05:10:05 +0000 (UTC)
Date: Sun, 28 Jun 2026 22:10:02 -0700
To: mm-commits@vger.kernel.org,serge@hallyn.com,paul@paul-moore.com,john.johansen@canonical.com,jmorris@namei.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] security-apparmor-apparmorfsc-conditionally-compile-get_loaddata_common_ref.patch removed from -mm tree
Message-Id: <20260629051005.0B7571F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: security/apparmor/apparmorfs.c: conditionally compile get_loaddata_common_ref()
has been removed from the -mm tree.  Its filename was
     security-apparmor-apparmorfsc-conditionally-compile-get_loaddata_common_ref.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: security/apparmor/apparmorfs.c: conditionally compile get_loaddata_common_ref()
Date: Wed Jun  3 01:30:46 PM PDT 2026

Some config did this:

security/apparmor/apparmorfs.c:177:28: warning: 'get_loaddata_common_ref' defined but not used [-Wunused-function]
  177 | static struct aa_loaddata *get_loaddata_common_ref(struct aa_common_ref *ref)

get_loaddata_common_ref() is only used if
CONFIG_SECURITY_APPARMOR_EXPORT_BINARY=y.

(Or of course move the function into that block if maintainers perfer)

Acked-by: John Johansen <john.johansen@canonical.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/apparmor/apparmorfs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/security/apparmor/apparmorfs.c~security-apparmor-apparmorfsc-conditionally-compile-get_loaddata_common_ref
+++ a/security/apparmor/apparmorfs.c
@@ -174,6 +174,7 @@ static struct aa_proxy *get_proxy_common
 	return NULL;
 }
 
+#ifdef CONFIG_SECURITY_APPARMOR_EXPORT_BINARY
 static struct aa_loaddata *get_loaddata_common_ref(struct aa_common_ref *ref)
 {
 	if (ref)
@@ -181,6 +182,7 @@ static struct aa_loaddata *get_loaddata_
 						      count));
 	return NULL;
 }
+#endif
 
 static void aa_put_common_ref(struct aa_common_ref *ref)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mincore-use-walk_page_range_vma-in-do_mincore-fix.patch
mm-page_owner-add-print_mode-filter-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

