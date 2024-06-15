Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0A2168C4
	for <mm-commits@vger.kernel.org>; Sat, 15 Jun 2024 17:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718473059; cv=none; b=RVPmgQaZ4in66Kj0xn5gDcOBza80XhjKw7Bgv/1Lymr5XyPgowGoT46eCMLcDHbUmj+WL6iiV+EQLxB41/gT16ICfuIZUGvAGUXN/GZ7XOXn6hUiir2YpdNjHaRhw0mxvPkLLvzzxFrSUqGNZ5aRzaUazNZG3o+nuSXiD0vwHGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718473059; c=relaxed/simple;
	bh=ZnU01qrddMqElVL7OARp8ccI6Rpe552JcgBfCc4Bm/w=;
	h=Date:To:From:Subject:Message-Id; b=XvEUcOJkImBfg3xrcI7uRkVoNoLH3NhCpQpEHyx7uc5+m4XHeq+TwlK15cm72YTvV71ZVF/Rcx4Bi/P8ZggtUYHnIKX6BS+sJqidrWrIYonQhW3dOfBm+pXW3nUl/71U1YXQzjZI5rShp98nC6XxVhIkwyHrW/rlzelA/2t0ubI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vl687BWC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vl687BWC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1893C116B1;
	Sat, 15 Jun 2024 17:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718473058;
	bh=ZnU01qrddMqElVL7OARp8ccI6Rpe552JcgBfCc4Bm/w=;
	h=Date:To:From:Subject:From;
	b=vl687BWCLp7pxP+VHUV8dvIXsrdD5q5Crj7jXG3X6XQByPcvX23k8YzrXGlj1r/dy
	 E6LTc/palBmXavPESTjNthKvYuyEXkvE/uToV96lfqh1enlhvUj5Yte3eorvWDqNrF
	 7jGwl4E540pGPVUczr9ZSWsn/hq7VTG0KVYfoXuA=
Date: Sat, 15 Jun 2024 10:37:38 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,jeffxu@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec-v3.patch removed from -mm tree
Message-Id: <20240615173738.D1893C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec-v3
has been removed from the -mm tree.  Its filename was
     mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec-v3.patch

This patch was dropped because it was folded into mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec.patch

------------------------------------------------------
From: Jeff Xu <jeffxu@chromium.org>
Subject: mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec-v3
Date: Tue, 11 Jun 2024 23:14:08 +0000

Link: https://lkml.kernel.org/r/20240611231409.3899809-2-jeffxu@chromium.org
Signed-off-by: Jeff Xu <jeffxu@chromium.org>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/userspace-api/mfd_noexec.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/userspace-api/mfd_noexec.rst~mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec-v3
+++ a/Documentation/userspace-api/mfd_noexec.rst
@@ -1,7 +1,7 @@
 .. SPDX-License-Identifier: GPL-2.0
 
 ==================================
-Introduction of non executable mfd
+Introduction of non-executable mfd
 ==================================
 :Author:
     Daniel Verkamp <dverkamp@chromium.org>
@@ -30,7 +30,7 @@ use of executable memfds and an attacker
 To address those above:
  - Let memfd_create() set X bit at creation time.
  - Let memfd be sealed for modifying X bit when NX is set.
- - Add a new pid namespace sysctl: vm.memfd_noexec to help applications to
+ - Add a new pid namespace sysctl: vm.memfd_noexec to help applications in
    migrating and enforcing non-executable MFD.
 
 User API
_

Patches currently in -mm which might be from jeffxu@chromium.org are

mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec.patch
proc-pid-smaps-add-mseal-info-for-vma.patch

