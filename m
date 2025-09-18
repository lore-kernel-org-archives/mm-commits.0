Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10AE22D7A1
	for <mm-commits@vger.kernel.org>; Thu, 18 Sep 2025 20:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758227925; cv=none; b=OcDGsDWOJnS3iczy3+qQLzpKiAUAt/w36Uz72Ba3Xt0ZClArc1KZTVuWH2g47RK6PQh2oQKYO+zF7Hq7gsb5CusRCCGRkKLN3W3MVqe/cI578Qsaa00nD2qRoobxLuzjA4J01tY+MjZjLcFZOw/L/o3f8oU0RBMimz42n+KRIMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758227925; c=relaxed/simple;
	bh=1JXxoO4vYwQ4/Mggwu7m16eQT4WhjUmygkjJaLUWGV0=;
	h=Date:To:From:Subject:Message-Id; b=V4P78Bqpg3jmtK8TDP4iinwwqfCaV5X76Pza8CQY2SoKjUjmG+jklbqBGzmrxkMmIRt3r3rax5xiFBMaOH81GN6mXCXZtgrL2wHne5xdOXtOK4F+ZKKdlMrB6KjZlNH4q1WrEyN8TFhIBB6nYgvGu2bm9kMwFMrfmrRCJcOEB3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o59zaqJJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o59zaqJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A45CC4CEE7;
	Thu, 18 Sep 2025 20:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758227924;
	bh=1JXxoO4vYwQ4/Mggwu7m16eQT4WhjUmygkjJaLUWGV0=;
	h=Date:To:From:Subject:From;
	b=o59zaqJJ1u1paniDBl4Fugq61WoYMmyaWlOWOy0u5O/ggD8sYGsDYkFRtuZjq30FO
	 rXg4Df+Z5qsnjyPiI9XjkWrRgwNyPWX5CQgJ+1Su6wM1lDNhuAXk5dPaiJIcbkeqvU
	 0T1psBOIh8gwHrbA4FEEjYsjjf55aEBDwdiZPPzw=
Date: Thu, 18 Sep 2025 13:38:43 -0700
To: mm-commits@vger.kernel.org,manish1588@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-fix-typo-esecially-especially.patch added to mm-new branch
Message-Id: <20250918203844.2A45CC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory_hotplug: fix typo 'esecially' -> 'especially'
has been added to the -mm mm-new branch.  Its filename is
     mm-memory_hotplug-fix-typo-esecially-especially.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-fix-typo-esecially-especially.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Manish Kumar <manish1588@gmail.com>
Subject: mm/memory_hotplug: fix typo 'esecially' -> 'especially'
Date: Thu, 18 Sep 2025 23:15:28 +0530

Link: https://lkml.kernel.org/r/20250918174528.90879-1-manish1588@gmail.com
Signed-off-by: Manish Kumar <manish1588@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-fix-typo-esecially-especially
+++ a/mm/memory_hotplug.c
@@ -955,7 +955,7 @@ static struct zone *default_kernel_zone_
  *    effectively unused by the kernel, yet they account to "present pages".
  *    Fortunately, these allocations are comparatively small in relevant setups
  *    (e.g., fraction of system memory).
- * b) Some hotplugged memory blocks in virtualized environments, esecially
+ * b) Some hotplugged memory blocks in virtualized environments, especially
  *    hotplugged by virtio-mem, look like they are completely present, however,
  *    only parts of the memory block are actually currently usable.
  *    "present pages" is an upper limit that can get reached at runtime. As
_

Patches currently in -mm which might be from manish1588@gmail.com are

mm-show_mem-update-printk-pr_info-messages-and-replace-legacy-printkkern_cont-with-pr_cont.patch
mm-memory_hotplug-fix-typo-esecially-especially.patch

