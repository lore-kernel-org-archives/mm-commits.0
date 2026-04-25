Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A00A372689
	for <mm-commits@vger.kernel.org>; Sat, 25 Apr 2026 18:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777142087; cv=none; b=luY3BqtQmK48bwHG70APJ84IHmPfoHoDD0ExCth2Wr0F3qqMUKlsZmU/6c9foOyfH/7AY2sKPlGs9SYQzwaL8w2Tji92bElUugnnRryku8ykcQnuZmA0uZOIBRAsc9iZv9u5Syxj3z5Ju8IDdVLnkkeFGtZ6unXGCmoS4rHsiAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777142087; c=relaxed/simple;
	bh=+nOKhyh7bWcLp+rTLjOPaV5jvazPHuym/oR6DAgfGkw=;
	h=Date:To:From:Subject:Message-Id; b=IEhFIYBd+TNAU49sTw1BPtoAmSX/dVqQXUP/0ciduUaAh4tmmIYb0Vahk3d+TXeI5eqiSfAUyTm8zrXwxOGhZrHC3RyB4OjzKd525/6rOgck4YfmF6ijvK9emvouW9T+JSK30GVFFPBdLJHLZKqf/fJGQ4PQnKJuyftjB4kZAtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oLrGwNTx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oLrGwNTx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03797C2BCB0;
	Sat, 25 Apr 2026 18:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777142087;
	bh=+nOKhyh7bWcLp+rTLjOPaV5jvazPHuym/oR6DAgfGkw=;
	h=Date:To:From:Subject:From;
	b=oLrGwNTx6Dsxxkmsv5U1N7bQTARrheGZWK9RqcZwJqwt/4pPBu/iH4Zn8pwzINOT5
	 BPZoNkkfaxjcbnNgFX1l5EbOboJhzvGsEM7AD+g94iNTX610l674UBiL3kVRulvRLv
	 G0zklRKU0HyX5Eo74YcjJK0lboPfyWK7gvB8W6o0=
Date: Sat, 25 Apr 2026 11:34:46 -0700
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,jonathan.cameron@huawei.com,dave.jiang@intel.com,dan.j.williams@intel.com,benjamin.cheatham@amd.com,alison.schofield@intel.com,dave@stgolabs.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dax-kmem-account-for-partial-dis-contiguous-resource-upon-removal.patch added to mm-new branch
Message-Id: <20260425183447.03797C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: dax/kmem: account for partial discontiguous resource upon removal
has been added to the -mm mm-new branch.  Its filename is
     dax-kmem-account-for-partial-dis-contiguous-resource-upon-removal.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dax-kmem-account-for-partial-dis-contiguous-resource-upon-removal.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: dax/kmem: account for partial discontiguous resource upon removal
Date: Mon, 23 Feb 2026 12:15:16 -0800

When dev_dax_kmem_probe() partially succeeds (at least one range is
mapped) but a subsequent range fails request_mem_region() or
add_memory_driver_managed(), the probe silently continues, ultimately
returning success, but with the corresponding range resource NULL'ed out.

dev_dax_kmem_remove() iterates over all dax_device ranges regardless of if
the underlying resource exists.  When remove_memory() is called later, it
returns 0 because the memory was never added which causes
dev_dax_kmem_remove() to incorrectly assume the (nonexistent) resource can
be removed and attempts cleanup on a NULL pointer.

Fix this by skipping these ranges altogether, noting that these cases are
considered success, such that the cleanup is still reached when all
actually-added ranges are successfully removed.

Link: https://lore.kernel.org/20260223201516.1517657-1-dave@stgolabs.net
Fixes: 60e93dc097f7 ("device-dax: add dis-contiguous resource support")
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Ben Cheatham <benjamin.cheatham@amd.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/kmem.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/dax/kmem.c~dax-kmem-account-for-partial-dis-contiguous-resource-upon-removal
+++ a/drivers/dax/kmem.c
@@ -227,6 +227,12 @@ static void dev_dax_kmem_remove(struct d
 		if (rc)
 			continue;
 
+		/* range was never added during probe */
+		if (!data->res[i]) {
+			success++;
+			continue;
+		}
+
 		rc = remove_memory(range.start, range_len(&range));
 		if (rc == 0) {
 			remove_resource(data->res[i]);
_

Patches currently in -mm which might be from dave@stgolabs.net are

dax-kmem-account-for-partial-dis-contiguous-resource-upon-removal.patch

