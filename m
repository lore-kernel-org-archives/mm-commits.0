Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314F43D5C0C;
	Tue, 15 Sep 2026 04:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789446795; cv=none; b=D+TnjvW8Q4u94wwrA6sl2sNl4lFUR2OoNvTIbnx0bGRS2CWinsVJ2mrGoF9j/nDhyg5e16f5S9nNkrBMqmOwnPUgN26Z6u0KIOYcRSs+VzHTHnlJ7E0mA+mWfYwDnO08pyi/8M/CfX/aotEB4PA6ZuUMH8XJHrii8CWPsvmffYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789446795; c=relaxed/simple;
	bh=Z2bBIZaY75N8/hkYF68mYXx7t+s5o0Nv7CjCT3+nCu4=;
	h=Date:To:From:Subject:Message-Id; b=CeHI2kae9ruv29eQP4eRzOc19RgQIu1qrLZXK6uHtv9k4ELvajKqn1TAVS3ZawneMU96FrV4W+jFs9b8gdDklli1Pk4ZNGobcYOhJj8Zvms8nqpTunuxm/EkGL4svOH+t7cbs6erDEH3FsPza7OA5eMhHyUvk0OleW8w/p1VNjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XFfIm8nb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XFfIm8nb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD1191F000FF;
	Tue, 15 Sep 2026 04:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789446793;
	bh=Bf4+7ek3gzgZD4A4yBakd/YWi61ea/g4FpePNopXQRA=;
	h=Date:To:From:Subject;
	b=XFfIm8nbALi3GVA4ZDL18Vu+229dKgXKj0rFq3YOWm4lNZUGGs9ekpeUMTYhg7Gtv
	 We1eG1R24W1gaGwZRHZuXFM/ZB2CcBHK71e8S9renw42TO86Jnnp1SymJ5rrshhzlF
	 CBsGkmfwjd0Ks+l3qu3J00ebeGDS33mFJ3lQ6OgI=
Date: Mon, 14 Sep 2026 21:33:13 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mporter@kernel.crashing.org,gregkh@linuxfoundation.org,dan.carpenter@linaro.org,alex.bou9@gmail.com,james010kim@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + rapidio-mport_cdev-fix-use-after-free-in-mport_mm_close.patch added to mm-nonmm-unstable branch
Message-Id: <20260915043313.BD1191F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: rapidio: mport_cdev: fix use-after-free in mport_mm_close()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     rapidio-mport_cdev-fix-use-after-free-in-mport_mm_close.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rapidio-mport_cdev-fix-use-after-free-in-mport_mm_close.patch

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

rapidio-mport_cdev-fix-use-after-free-in-mport_mm_close.patch

