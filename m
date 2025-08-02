Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F681A8412
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 19:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754161346; cv=none; b=c+G6cgB52fUJQ2zFL97tJJJQSaWg/tAxvE6dh/iMxzXD1yEaUshlPN4JKv5hsb+ZQvl4qki/j6xl+kRA8GgXESJirLj3taIxKiW9PNINha1uQMRxgtfC30SDL0SdkXF19X5vLxDYvvDnaSXmiG4QsET3nhVPrkrAZxa+V3MERPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754161346; c=relaxed/simple;
	bh=y4RPp0K00eK2O7lbR3N2eiS7hjPc9fVUGnYxADLbW3Y=;
	h=Date:To:From:Subject:Message-Id; b=mU+0BavBRTXkhgR30FaBGYWobS4mYUDg7Bmf2TR2IXGWw02cBG6ai0nF3fQ/2n0+2wabaPQ6zVJPtTWNYZ5m/B6wpBL6dG8kGYCKXF/avG+N31J7cC8rJqZIebAPsCZtojRjFpd42CvPGLsVbI2JW6CuIiGGb8obk+0Zq/u7NR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wbwUSe2M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wbwUSe2M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C406FC4CEEF;
	Sat,  2 Aug 2025 19:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754161345;
	bh=y4RPp0K00eK2O7lbR3N2eiS7hjPc9fVUGnYxADLbW3Y=;
	h=Date:To:From:Subject:From;
	b=wbwUSe2Muy2FtVArzWTt8MlocdCyr6P+xd6fmi7DMKp2nFm60WGu1B+LtXrpyGCHD
	 LD/ZshX6ZfHEerO0MAyuQzJ/m7OzAcxZKNTnETHkXHEmxXtLQhb71e0rwZ1uYbLb1i
	 LjG2BJV29Vj83lNQcDrSqq1r+HUJKJfzSIFInzh4=
Date: Sat, 02 Aug 2025 12:02:25 -0700
To: mm-commits@vger.kernel.org,thomas.hellstrom@linux.intel.com,wangyuli@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] drm-xe-fix-typo-notifer.patch removed from -mm tree
Message-Id: <20250802190225.C406FC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drm/xe: fix typo "notifer"
has been removed from the -mm tree.  Its filename was
     drm-xe-fix-typo-notifer.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: WangYuli <wangyuli@uniontech.com>
Subject: drm/xe: fix typo "notifer"
Date: Tue, 22 Jul 2025 15:34:26 +0800

There is a spelling mistake of 'notifer' in the comment which
should be 'notifier'.

Link: https://lkml.kernel.org/r/94190C5F54A19F3E+20250722073431.21983-3-wangyuli@uniontech.com
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/xe/xe_vm_types.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_vm_types.h~drm-xe-fix-typo-notifer
+++ a/drivers/gpu/drm/xe/xe_vm_types.h
@@ -259,7 +259,7 @@ struct xe_vm {
 		 * up for revalidation. Protected from access with the
 		 * @invalidated_lock. Removing items from the list
 		 * additionally requires @lock in write mode, and adding
-		 * items to the list requires either the @userptr.notifer_lock in
+		 * items to the list requires either the @userptr.notifier_lock in
 		 * write mode, OR @lock in write mode.
 		 */
 		struct list_head invalidated;
_

Patches currently in -mm which might be from wangyuli@uniontech.com are


