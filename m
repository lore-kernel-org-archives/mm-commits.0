Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916E614B96E
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762908589; cv=none; b=sSsPO3QPXE7iBeOuM2gKzEQzrKmADs+sX360pGC7KnS4CezPWfQWK1ABsA6BF4++NeIdLRPBBpmvfBMpbs3H3mIO5GYIWFEeaan05aDPSERf1pXaCibpeSIEwTjT4cBMa9u+lHFB9Zcc0E5NxbNh6PqScipbvAMJNkTfP+ie1wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762908589; c=relaxed/simple;
	bh=PpJxOcn2AEj3u7O11ep75gI4JLpEqQcvMNjg1XmlyK4=;
	h=Date:To:From:Subject:Message-Id; b=uEU+6FrdbKxXN42qzBfumnNtU+0PLQvr290oY+6aZ6w9wW65J6E1v2/eNqJ5hNVNJWXR0SIwlOsCAeakDkVOUrgo/fvnGp4MtoFAQffY4SobE/SdInlBGFJ3DN59Ou+vCOWaazj9zQDfztPANIJCxQ4xY3YvFb4m7WQOuggxtFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m6pXc/XE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m6pXc/XE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D205C4CEFB;
	Wed, 12 Nov 2025 00:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762908589;
	bh=PpJxOcn2AEj3u7O11ep75gI4JLpEqQcvMNjg1XmlyK4=;
	h=Date:To:From:Subject:From;
	b=m6pXc/XE2HdyiHtVz7vF3tJua4xtN9CaQBXHPd0nwLH5clkY15tZrpCAcrRtDNQ7h
	 hp6YM80iO3dUo1LGD+3iu8pkVJAFdV1urjnD6lf9iRA5MJvNm2FuREpYVNaOCYXvDf
	 FET5SOfB+/soIlFcE7rYxVDYUBjbPjpKgNhcSD44=
Date: Tue, 11 Nov 2025 16:49:48 -0800
To: mm-commits@vger.kernel.org,jgg@nvidia.com,davidgow@google.com,corbet@lwn.net,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] taint-add-reminder-about-updating-docs-and-scripts.patch removed from -mm tree
Message-Id: <20251112004949.1D205C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: taint: add reminder about updating docs and scripts
has been removed from the -mm tree.  Its filename was
     taint-add-reminder-about-updating-docs-and-scripts.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: taint: add reminder about updating docs and scripts
Date: Wed, 15 Oct 2025 15:16:26 -0700

Sometimes people update taint-related pieces of the kernel without
updating the supporting documentation or scripts.  Add a reminder to do
this.

Link: https://lkml.kernel.org/r/20251015221626.1126156-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Gow <davidgow@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/panic.c~taint-add-reminder-about-updating-docs-and-scripts
+++ a/kernel/panic.c
@@ -638,6 +638,12 @@ EXPORT_SYMBOL(panic);
 /*
  * TAINT_FORCED_RMMOD could be a per-module flag but the module
  * is being removed anyway.
+ *
+ * NOTE: if you modify the taint_flags or TAINT_FLAGS_COUNT,
+ * please also modify tools/debugging/kernel-chktaint and
+ * Documentation/admin-guide/tainted-kernels.rst, including its
+ * small shell script that prints the TAINT_FLAGS_COUNT bits of
+ * /proc/sys/kernel/tainted.
  */
 const struct taint_flag taint_flags[TAINT_FLAGS_COUNT] = {
 	TAINT_FLAG(PROPRIETARY_MODULE,		'P', 'G', true),
_

Patches currently in -mm which might be from rdunlap@infradead.org are


