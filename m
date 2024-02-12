Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D334DA19;
	Mon, 12 Feb 2024 22:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707777046; cv=none; b=jmMFj8d1LESInJTsg7YbIQ1Kp9RlCPAEHvaUTNhjrpllMALn6vG1zEDdZwiUWojHi9W7dVLXJQt9XFdhV9RyfeZjKOKOgEo8v+WVMydzuu9WAPRMD6fsVkyN0pvCyvX0wXyk/R+R7N4ysQzJ0Am45L2mJBAifsx6RbngQ49n0kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707777046; c=relaxed/simple;
	bh=Rf4+ZBnxgy52I3FfEljtMwZJ+a6HZnEz/pEGuAXdo2k=;
	h=Date:To:From:Subject:Message-Id; b=HuzHHMeQfcYVFgsKX7Awvr36JafBWYlNoq3x/2YoSmiE614Ip1r6Wy9QEqfLGlgEDk6FmHL97AWnzyJDFUVbshJsP2/teIk3oLTTAoM19BxqHuctBVSBEB8n5p2Id6v3KzgYZigZuaX96F5Jwq8DGi6my8qJuzLVGFfXLUgJGHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DDKVZ35f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DDKVZ35f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72E6C433F1;
	Mon, 12 Feb 2024 22:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707777045;
	bh=Rf4+ZBnxgy52I3FfEljtMwZJ+a6HZnEz/pEGuAXdo2k=;
	h=Date:To:From:Subject:From;
	b=DDKVZ35fbh7vlmFFb2B9c5usSoZkkm8Tfh7qkMYfQi+HOnhhm3h7p6B0ydhLJwUyv
	 Hhwd0BE4NGBjJpMA+jKG7MAQCNqI6HntF4vW8cw8W2RST9gobepUL03rUaKNK7nxVf
	 02WXhxP2QEJxEgoOXVWtCca43gx3JqgY/2WZJzLg=
Date: Mon, 12 Feb 2024 14:30:45 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.l.verma@intel.com,torvalds@linux-foundation.org,snitzer@kernel.org,mpatocka@redhat.com,linux@armlinux.org.uk,dm-devel@lists.linux.dev,david@fromorbit.com,dave.jiang@intel.com,dan.j.williams@intel.com,arnd@arndb.de,agk@redhat.com,mathieu.desnoyers@efficios.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dax-check-for-data-cache-aliasing-at-runtime.patch added to mm-unstable branch
Message-Id: <20240212223045.B72E6C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: dax: check for data cache aliasing at runtime
has been added to the -mm mm-unstable branch.  Its filename is
     dax-check-for-data-cache-aliasing-at-runtime.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dax-check-for-data-cache-aliasing-at-runtime.patch

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
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: dax: check for data cache aliasing at runtime
Date: Mon, 12 Feb 2024 11:30:59 -0500

Replace the following fs/Kconfig:FS_DAX dependency:

  depends on !(ARM || MIPS || SPARC)

By a runtime check within alloc_dax().  This runtime check returns
ERR_PTR(-EOPNOTSUPP) if the @ops parameter is non-NULL (which means the
kernel is using an aliased mapping) on an architecture which has data
cache aliasing.

Change the return value from NULL to PTR_ERR(-EOPNOTSUPP) for CONFIG_DAX=n
for consistency.

This is done in preparation for using cpu_dcache_is_aliasing() in a
following change which will properly support architectures which detect
data cache aliasing at runtime.

Link: https://lkml.kernel.org/r/20240212163101.19614-7-mathieu.desnoyers@efficios.com
Fixes: d92576f1167c ("dax: does not work correctly with virtual aliasing caches")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Michael Sclafani <dm-devel@lists.linux.dev>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/super.c |   10 ++++++++++
 fs/Kconfig          |    1 -
 2 files changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/dax/super.c~dax-check-for-data-cache-aliasing-at-runtime
+++ a/drivers/dax/super.c
@@ -451,6 +451,16 @@ struct dax_device *alloc_dax(void *priva
 	dev_t devt;
 	int minor;
 
+	/*
+	 * Unavailable on architectures with virtually aliased data caches,
+	 * except for device-dax (NULL operations pointer), which does
+	 * not use aliased mappings from the kernel.
+	 */
+	if (ops && (IS_ENABLED(CONFIG_ARM) ||
+	    IS_ENABLED(CONFIG_MIPS) ||
+	    IS_ENABLED(CONFIG_SPARC)))
+		return ERR_PTR(-EOPNOTSUPP);
+
 	if (WARN_ON_ONCE(ops && !ops->zero_page_range))
 		return ERR_PTR(-EINVAL);
 
--- a/fs/Kconfig~dax-check-for-data-cache-aliasing-at-runtime
+++ a/fs/Kconfig
@@ -60,7 +60,6 @@ endif # BLOCK
 config FS_DAX
 	bool "File system based Direct Access (DAX) support"
 	depends on MMU
-	depends on !(ARM || MIPS || SPARC)
 	depends on ZONE_DEVICE || FS_DAX_LIMITED
 	select FS_IOMAP
 	select DAX
_

Patches currently in -mm which might be from mathieu.desnoyers@efficios.com are

nvdimm-pmem-fix-leak-on-dax_add_host-failure.patch
dax-alloc_dax-return-err_ptr-eopnotsupp-for-config_dax=n.patch
nvdimm-pmem-treat-alloc_dax-eopnotsupp-failure-as-non-fatal.patch
dm-treat-alloc_dax-eopnotsupp-failure-as-non-fatal.patch
dcssblk-handle-alloc_dax-eopnotsupp-failure.patch
virtio-treat-alloc_dax-eopnotsupp-failure-as-non-fatal.patch
dax-check-for-data-cache-aliasing-at-runtime.patch
introduce-cpu_dcache_is_aliasing-across-all-architectures.patch
dax-fix-incorrect-list-of-data-cache-aliasing-architectures.patch

