Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5431030B519
	for <mm-commits@vger.kernel.org>; Thu, 22 Jan 2026 15:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769095902; cv=none; b=Ldh9a4lf6ncSKYDLsBEFUrESsmP6ngyPo58oXA1QRgdjeGkhBv8wMj3enpYYa7hwvKPb1X0nKvCczigF6eYGvuYuLdENaADTnj8kZ8/qApgkBy4QzZQ7keYge7JkjWQKUy0/q8J3KiZA7R/L6cE6fuA4+TxUdpOUDiNaEuIXte0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769095902; c=relaxed/simple;
	bh=wetiyrGdDFYpSGQjfPSvBmKsr2XLPdjS8kubQIRoQ6w=;
	h=Date:To:From:Subject:Message-Id; b=a9UEzPcktT+dB137GPQaah15kps0M2JDRxgpSzU0xYe2liZO6WHBzrlZGZ8N7V3IQmHfuKX/ejg0OC/kKAeVWqmCQ4XZHS8pPqqFeHu2nqebxDLISOr8+fua95N0YmuYOK/zlrUE0dyLVflf91SFQ56kWTAIrl1yjumuCU+wTCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dlA/pkVZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dlA/pkVZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6121C116C6;
	Thu, 22 Jan 2026 15:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769095902;
	bh=wetiyrGdDFYpSGQjfPSvBmKsr2XLPdjS8kubQIRoQ6w=;
	h=Date:To:From:Subject:From;
	b=dlA/pkVZSQUaaHWZIpZ39UGtDCN42IgQVQ8U/nZ0grRlci5ksoojZZVOmfJNBXPyC
	 UsNPVzMHfsiGgNjpIlqTErN9liFp4baL98VOlUaonajwtJh8bSVL6DG/BtZBm44z+8
	 yCVCa1lR+c/Lvr7PRQewLyRRdrXfRoraR7IPh4IA=
Date: Thu, 22 Jan 2026 07:31:41 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,hughd@google.com,baolin.wang@linux.alibaba.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memfd_luo-restore-and-free-memfd_luo_ser-on-failure.patch added to mm-hotfixes-unstable branch
Message-Id: <20260122153141.E6121C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memfd_luo: restore and free memfd_luo_ser on failure
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memfd_luo-restore-and-free-memfd_luo_ser-on-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memfd_luo-restore-and-free-memfd_luo_ser-on-failure.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
Subject: mm: memfd_luo: restore and free memfd_luo_ser on failure
Date: Thu, 22 Jan 2026 16:18:41 +0100

memfd_luo_ser has the serialization metadata.  It is of no use once
restoration fails.  Free it on failure.

Link: https://lkml.kernel.org/r/20260122151842.4069702-4-pratyush@kernel.org
Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd_luo.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/memfd_luo.c~mm-memfd_luo-restore-and-free-memfd_luo_ser-on-failure
+++ a/mm/memfd_luo.c
@@ -447,7 +447,8 @@ static int memfd_luo_retrieve(struct liv
 	file = memfd_alloc_file("", 0);
 	if (IS_ERR(file)) {
 		pr_err("failed to setup file: %pe\n", file);
-		return PTR_ERR(file);
+		err = PTR_ERR(file);
+		goto free_ser;
 	}
 
 	vfs_setpos(file, ser->pos, MAX_LFS_FILESIZE);
@@ -473,7 +474,8 @@ static int memfd_luo_retrieve(struct liv
 
 put_file:
 	fput(file);
-
+free_ser:
+	kho_restore_free(ser);
 	return err;
 }
 
_

Patches currently in -mm which might be from pratyush@kernel.org are

memfd-export-alloc_file.patch
mm-memfd_luo-use-memfd_alloc_file-instead-of-shmem_file_setup.patch
mm-memfd_luo-restore-and-free-memfd_luo_ser-on-failure.patch
kho-use-unsigned-long-for-nr_pages.patch
kho-simplify-page-initialization-in-kho_restore_page.patch

