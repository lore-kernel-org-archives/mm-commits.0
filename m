Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE3B1A2C11
	for <mm-commits@vger.kernel.org>; Thu, 16 Oct 2025 21:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760649500; cv=none; b=aneoZPYmPBgZrmXS0vZp6g9IqvbosfRhGQhIY4xmMfmPROjw4bV0Gk8Ry+vL3Sv+mKOK8sXZCUBlk9CBwGgzkt7gAB8KD+W/5QIn0/ynV44urGHEhOrAQ6RCZOL1HQyVdg+BzOW0e+qc00a3mUhMuEYQIrPAVrdBYYKxrHIM9m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760649500; c=relaxed/simple;
	bh=KrDzH1hCOoyq+M2yUqo/tAelxq/Eg3IUBb4X84/33ug=;
	h=Date:To:From:Subject:Message-Id; b=J6aWYFm8V+MU2ZNdsonLxAFLmAS956ginyIwdN8ZQanxhNdeE0dulx46FQtiK6y7TvwuXIY5fSroRqBQfWennelxR2VYQw3Tj//aRMlIL+o74+tkWUx44Jnay3hTdsqhz4mw2hAAqjOXmuxQftxaBbbhNP+3oxrK6T4LlA8Qvo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OrvWBjY/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OrvWBjY/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DF0C4CEF1;
	Thu, 16 Oct 2025 21:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760649499;
	bh=KrDzH1hCOoyq+M2yUqo/tAelxq/Eg3IUBb4X84/33ug=;
	h=Date:To:From:Subject:From;
	b=OrvWBjY/DsUY9A4BVJi+myafdf+ffw/xypaaOfYydqLW99hxpVd7IvKZX0C6LyS5n
	 RBAlzNgf6gb4bftb2AF4oKhuSaEY0SQPEMq8V3d+2Vqxyzuj5lLxW1L59z0qAJBTQY
	 V51KvmEQ93b6SwW5OL7ZzHRqikgAmDaADrJzerc0=
Date: Thu, 16 Oct 2025 14:18:19 -0700
To: mm-commits@vger.kernel.org,jgg@nvidia.com,davidgow@google.com,corbet@lwn.net,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + taint-add-reminder-about-updating-docs-and-scripts.patch added to mm-nonmm-unstable branch
Message-Id: <20251016211819.B2DF0C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: taint: add reminder about updating docs and scripts
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     taint-add-reminder-about-updating-docs-and-scripts.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/taint-add-reminder-about-updating-docs-and-scripts.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

taint-add-reminder-about-updating-docs-and-scripts.patch

