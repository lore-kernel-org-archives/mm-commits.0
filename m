Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E61515D5B8
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 16:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714667354; cv=none; b=He/Ve6FtdNwPcEEutheUOREYhydozw/a7GC2lCcFg24by52xXunsgaT9wMnvMBS7zYI3nd1Nupw//Losbo8BUHyaMMaHdtb44HLaSNHLHqvT12y7zBtavs0v2SzgjGiHRrDOeIFZ+6zn2AdfTbpEBMtuYKpeL5sP4KLIwqZ2OxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714667354; c=relaxed/simple;
	bh=qu7M138pt30LWwtE8KsEb3iM0BBHiQhMQSDORcSMyes=;
	h=Date:To:From:Subject:Message-Id; b=Ymxhvw+9WQpHSfJzoT+9ghSnxQhBASXp0eN37jozVfWjbKxvcgj51LE8Y4gwtSoVN55cHM1s1IZlVs3fPiIxD2xYgRpJCpgKM7nj4IRgFFPE+ykijz0ZhOwOSmunjeh30G1sUN4giMhdM4io0Dfc7FVHKWtlaR1/QgBaIxGtvSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jdHRZ2wW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jdHRZ2wW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DC14C113CC;
	Thu,  2 May 2024 16:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714667353;
	bh=qu7M138pt30LWwtE8KsEb3iM0BBHiQhMQSDORcSMyes=;
	h=Date:To:From:Subject:From;
	b=jdHRZ2wWBZesX0x6W8ZcYF4D2QDZxKJ2PwSigXGVIZjim7KGbQgocnHilV2BbfWcz
	 0psWbHm5NEOdf14JQe5CRACQzyy7LCJlGL8XF3bEU4fdMURvUX9EwgFxaYghPoN6GW
	 AnbljrWc/yNeyZCPbOcxyk9aQ78K0VKhTkI4PuZU=
Date: Thu, 02 May 2024 09:29:12 -0700
To: mm-commits@vger.kernel.org,dave.jiang@intel.com,dan.j.williams@intel.com,alison.schofield@intel.com,vishal.l.verma@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dax-busc-use-the-right-locking-mode-read-vs-write-in-size_show.patch added to mm-unstable branch
Message-Id: <20240502162913.6DC14C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: dax/bus.c: use the right locking mode (read vs write) in size_show
has been added to the -mm mm-unstable branch.  Its filename is
     dax-busc-use-the-right-locking-mode-read-vs-write-in-size_show.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dax-busc-use-the-right-locking-mode-read-vs-write-in-size_show.patch

This patch will later appear in the mm-unstable branch at
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
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: dax/bus.c: use the right locking mode (read vs write) in size_show
Date: Tue, 30 Apr 2024 11:44:26 -0600

In size_show(), the dax_dev_rwsem only needs a read lock, but was
acquiring a write lock.  Change it to down_read_interruptible() so it
doesn't unnecessarily hold a write lock.

Link: https://lkml.kernel.org/r/20240430-vv-dax_abi_fixes-v3-4-e3dcd755774c@intel.com
Fixes: c05ae9d85b47 ("dax/bus.c: replace driver-core lock usage by a local rwsem")
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/bus.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/dax/bus.c~dax-busc-use-the-right-locking-mode-read-vs-write-in-size_show
+++ a/drivers/dax/bus.c
@@ -937,11 +937,11 @@ static ssize_t size_show(struct device *
 	unsigned long long size;
 	int rc;
 
-	rc = down_write_killable(&dax_dev_rwsem);
+	rc = down_read_interruptible(&dax_dev_rwsem);
 	if (rc)
 		return rc;
 	size = dev_dax_size(dev_dax);
-	up_write(&dax_dev_rwsem);
+	up_read(&dax_dev_rwsem);
 
 	return sysfs_emit(buf, "%llu\n", size);
 }
_

Patches currently in -mm which might be from vishal.l.verma@intel.com are

dax-busc-replace-warn_on_once-with-lockdep-asserts.patch
dax-busc-fix-locking-for-unregister_dax_dev-unregister_dax_mapping-paths.patch
dax-busc-dont-use-down_write_killable-for-non-user-processes.patch
dax-busc-use-the-right-locking-mode-read-vs-write-in-size_show.patch

