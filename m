Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4296D3C5826
	for <mm-commits@vger.kernel.org>; Wed,  2 Sep 2026 20:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788382535; cv=none; b=RBZAA1+f6FvzhDaJCdTRYWnoqHcQMHdMHWzrsG8Y9zByqdAiPNnVxsjPT3mAqPOG9M2DurrY5BB64kMq1Vqf3yOBZE5qjGKcPU+/Uklps59pxVaJxh+h33SeYQHsK0QmGwUytXa/gclEgLvnkdTNPbNFKNMm2PXTSTLWxDFM6Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788382535; c=relaxed/simple;
	bh=SeHZU96MIHv4chs+a9JxRBLbxD4wieKN9jutpzV1YY8=;
	h=Date:To:From:Subject:Message-Id; b=cwxTtOpRmLxU9kJLo+T31HzX8UObsbI5rz8Ser4lF6jCF3ye5HLadRefjbdUOBbzjPXUC4FrmYSpT8b3eRZ+IAHRm60A7vAK7orxz3P3mafFfIgxSqJpcSDsilwU5BQQ4dbCCU6NsRR4cwROGmIkXaYUwa16QzI5XLHtQ70NdeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=js3KtqkN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="js3KtqkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4471F000E9;
	Wed,  2 Sep 2026 20:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788382524;
	bh=0XRYt7kjr7Cfv6TAIlFe6XGZJq8vkoSifvi7Tl7V8mA=;
	h=Date:To:From:Subject;
	b=js3KtqkNjDdmRMf3p7scXbHM/BPOlw09RSmBTvZnYzk+rjKVHyMJoOQ3H9OTqcBZs
	 es2ema9cp0tyl9s76oWaYdGQ6VP2JBSQBid1c7GqHkOVyxoHocnYycyY9822Lqv7lE
	 I8E82kX+sMOqN45Sl9ZltjwCqg8qd4Id3RwPLmf4=
Date: Wed, 02 Sep 2026 13:55:24 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,brads@mainlining.org,akpm@linux-foundation.org,feng.tang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-remove-the-unneeded-panic_print_get.patch added to mm-nonmm-unstable branch
Message-Id: <20260902205524.BB4471F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic: remove the unneeded panic_print_get()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-remove-the-unneeded-panic_print_get.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-remove-the-unneeded-panic_print_get.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Feng Tang <feng.tang@linux.alibaba.com>
Subject: panic: remove the unneeded panic_print_get()
Date: Wed, 2 Sep 2026 19:48:51 +0800

panic_print_get() was introduced in commit 2683df6539cb ("panic: add
note that 'panic_print' parameter is deprecated") to print out warning
message of the deprecation of 'panic_print' on read access.

Since commit 90f3c123247e ("panic: only warn about deprecated panic_print
on write access"), panic_print_get() wrapper is not needed anymore for
read access, so remove it and use param_get_ulong() instead.

Link: https://lore.kernel.org/20260902114851.77062-1-feng.tang@linux.alibaba.com
Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/kernel/panic.c~panic-remove-the-unneeded-panic_print_get
+++ a/kernel/panic.c
@@ -1216,14 +1216,9 @@ static int panic_print_set(const char *v
 	return  param_set_ulong(val, kp);
 }
 
-static int panic_print_get(char *val, const struct kernel_param *kp)
-{
-	return  param_get_ulong(val, kp);
-}
-
 static const struct kernel_param_ops panic_print_ops = {
 	.set	= panic_print_set,
-	.get	= panic_print_get,
+	.get	= param_get_ulong,
 };
 __core_param_cb(panic_print, &panic_print_ops, &panic_print, 0644);
 
_

Patches currently in -mm which might be from feng.tang@linux.alibaba.com are

panic-remove-the-unneeded-panic_print_get.patch

