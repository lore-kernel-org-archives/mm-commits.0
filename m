Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B211345EDB;
	Wed,  7 Oct 2026 02:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338710; cv=none; b=s04V2Bh9+tzLCnAjHZdqZe7Onh7D75cJOUXI3lKA2vaRU7yZwHESu2xyNfVDDYoPUmpPML92Jbc4VBYtHPuEpvMgLCUjPv09SQyeZkKtvecZ/Gqix6tMsEHEAr/oMZQet2c4me2ktZ04G0q/DtEyD2KFoNaBFfWKmaiHd8Fipfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338710; c=relaxed/simple;
	bh=1Z/0uUNvVDWUrUtVqZUV+8ilxp2LjPAqnoLyxqWjRt8=;
	h=Date:To:From:Subject:Message-Id; b=CVl44iRSCbqvegBpuyzSTeRmT46RpI+kTkrFiM0q3nT/epV94LlnD2DEUwVN6WJ1T5AKzV6F5HgHjfNUOOUatSis2PUUGcrt7FzM+IzCcWAH5f9C1tpF90rso+9w5bgdEH+U+bfTGu0D88ld7a+w4BvXx7Vdyq66ydPoyPKsAxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=krouSewm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="krouSewm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E4E1F0089C;
	Wed,  7 Oct 2026 02:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338709;
	bh=ALJt2HPffSH5ykRhBIV48aF6Lyj1CB3QuWAGsX4Qv3s=;
	h=Date:To:From:Subject;
	b=krouSewmWWDoaqppplk1QmnGuiIsgFKCHq1YJkrMpJcrzqRbawDTALxc9iXhXLY4Q
	 /yqFhk8Un1YBe6K/XsWxynLUf5EUzcaiNfXUJCJDn6prYWaInHnAs07YUrZVqJE7QY
	 O+d86kv3vsPbwoiN1oZ6wAU5oCZ88S5Fxxx0PIr0=
Date: Tue, 06 Oct 2026 19:05:08 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mporter@kernel.crashing.org,gregkh@linuxfoundation.org,dan.carpenter@linaro.org,alex.bou9@gmail.com,james010kim@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] rapidio-mport_cdev-fix-use-after-free-in-mport_mm_close.patch removed from -mm tree
Message-Id: <20261007020508.F2E4E1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: rapidio: mport_cdev: fix use-after-free in mport_mm_close()
has been removed from the -mm tree.  Its filename was
     rapidio-mport_cdev-fix-use-after-free-in-mport_mm_close.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: James Kim <james010kim@gmail.com>
Subject: rapidio: mport_cdev: fix use-after-free in mport_mm_close()
Date: Mon, 14 Sep 2026 13:23:27 +0900

A use-after-free vulnerability was identified in mport_mm_close() in
drivers/rapidio/devices/rio_mport_cdev.c, identical to the pattern
previously addressed in dma_req_free().

This is observable from userspace when an application creates an mmap
mapping via the RapidIO character device and subsequently unmaps it (or
terminates, triggering exit_mmap()).  During munmap, mport_mm_close() is
invoked and drops the mapping reference via kref_put().

If kref_put() drops the last reference, mport_release_mapping() is called,
which frees the underlying rio_mport_mapping structure.  The subsequent
mutex_unlock() then dereferences map->md to unlock buf_mutex, leading to a
use-after-free:

   mport_mm_close()
     -> mutex_lock(&map->md->buf_mutex);
     ...
     -> kref_put(&map->ref, mport_release_mapping); /* map is freed */
     -> mutex_unlock(&map->md->buf_mutex);          /* UAF: map used */

Fix this by caching map->md before kref_put() and using the cached pointer
for mutex unlocking, ensuring that freed memory is not accessed.

Link: https://lore.kernel.org/20260914042327.49798-1-james010kim@gmail.com
Fixes: e8de370188d0 ("rapidio: add mport char device driver")
Signed-off-by: James Kim <james010kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: <stable@vger.kernel.org>
---

 drivers/rapidio/devices/rio_mport_cdev.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/rapidio/devices/rio_mport_cdev.c~rapidio-mport_cdev-fix-use-after-free-in-mport_mm_close
+++ a/drivers/rapidio/devices/rio_mport_cdev.c
@@ -2167,11 +2167,12 @@ static void mport_mm_open(struct vm_area
 static void mport_mm_close(struct vm_area_struct *vma)
 {
 	struct rio_mport_mapping *map = vma->vm_private_data;
+	struct mport_dev *md = map->md;
 
 	rmcd_debug(MMAP, "%pad", &map->phys_addr);
-	mutex_lock(&map->md->buf_mutex);
+	mutex_lock(&md->buf_mutex);
 	kref_put(&map->ref, mport_release_mapping);
-	mutex_unlock(&map->md->buf_mutex);
+	mutex_unlock(&md->buf_mutex);
 }
 
 static const struct vm_operations_struct vm_ops = {
_

Patches currently in -mm which might be from james010kim@gmail.com are


