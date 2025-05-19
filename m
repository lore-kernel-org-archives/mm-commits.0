Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45AC42116EE;
	Mon, 19 May 2025 19:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747684649; cv=none; b=riyqN1jDMZj/kuqr/k7k+u6SBe1NX+Rerk0NyQhA1nZ2e7vCHMvMgMWY0FEYzZ21cGJcyFPo8zO3pTmE3d+EPqA/NWCYwxwv7rJwd3632hDSYWV9yD8pdZD6Ngxw5UCL+VszTlAP3Q8/s76BvczUlnAfHk9OxYvK0Em/AQabedU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747684649; c=relaxed/simple;
	bh=SVRnxTlHK0bdAL+Iyus81e9Dz38ShBQ0p8kVhhWDMeM=;
	h=Date:To:From:Subject:Message-Id; b=O6zQnNt5ID1IXWAZ7RN2iELUHdzFXs9kLjhWcAacL81TOMzRIiiHwmMk9aH9LRIgczvYNejFCfy5XM42fNdNpDWLVNmL2LrFT6Jq+BRwij8QeOdVyCiEHtGI0HTblr1x8Oii5Xppbctoo8UwsG7DMGWOSBwIy2wYI3K3rYSm/jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IImHuFex; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IImHuFex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0AB0C4CEE4;
	Mon, 19 May 2025 19:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747684649;
	bh=SVRnxTlHK0bdAL+Iyus81e9Dz38ShBQ0p8kVhhWDMeM=;
	h=Date:To:From:Subject:From;
	b=IImHuFexWn+/nbg+PGdodrg4uiJDEzl9OrTe3MdI5kpE7eSNOQ04c9q9jup5spMPw
	 f3KlOkhkUSjMOMnID41UlqJGZi0hJ5Dg/d/cPzpfN6AVkgdP1JnFuMGynElFdogspl
	 iZzydEliG1tunEDK8jCluYk+GmqUVPcMXdwCRz7o=
Date: Mon, 19 May 2025 12:57:27 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,stable@vger.kernel.org,petr.pavlu@suse.com,00107082@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + module-release-codetag-section-when-module-load-fails.patch added to mm-hotfixes-unstable branch
Message-Id: <20250519195728.F0AB0C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: module: release codetag section when module load fails
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     module-release-codetag-section-when-module-load-fails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/module-release-codetag-section-when-module-load-fails.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: David Wang <00107082@163.com>
Subject: module: release codetag section when module load fails
Date: Tue, 20 May 2025 00:38:23 +0800

When module load fails after memory for codetag section is ready, codetag
section memory will not be properly released.  This causes memory leak,
and if next module load happens to get the same module address, codetag
may pick the uninitialized section when manipulating tags during module
unload, and leads to "unable to handle page fault" BUG.

Link: https://lkml.kernel.org/r/20250519163823.7540-1-00107082@163.com
Fixes: 0db6f8d7820a ("alloc_tag: load module tags into separate contiguous memory")
Closes: https://lore.kernel.org/all/20250516131246.6244-1-00107082@163.com/
Signed-off-by: David Wang <00107082@163.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module/main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/module/main.c~module-release-codetag-section-when-module-load-fails
+++ a/kernel/module/main.c
@@ -2829,6 +2829,7 @@ static void module_deallocate(struct mod
 {
 	percpu_modfree(mod);
 	module_arch_freeing_init(mod);
+	codetag_free_module_sections(mod);
 
 	free_mod_mem(mod);
 }
_

Patches currently in -mm which might be from 00107082@163.com are

module-release-codetag-section-when-module-load-fails.patch

