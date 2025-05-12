Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 013972EB10
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011370; cv=none; b=JAAPlWDfgcBNhqQNf/nDckiv8h/ngRiT5JVZvlY37t23DtYdOzx2NUFqXjsfd2NXD6SBG1QCoQ4EmN8df7/rkt6qpYZBzDG4hUtCMRTdFN0Ewc0CiXHg+/go9N8Z26gWl36XHci/YkKczlrLt7h3SQmISbKiB2zzE2yJkpUEvKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011370; c=relaxed/simple;
	bh=yDhUDriiBg7yCPrev50Ya1ZFDVAUCWfS81To0WSb23I=;
	h=Date:To:From:Subject:Message-Id; b=GDZX6O9+ecBFdEFSjq7lMdL3AUPjJTyP/zvdoWZNBb6raqIj7Ei4ZbzQ4P80wmWymUFlOlfzOg/IYWz8Fs1Z1aEOjIwe+MMJ1X5HdHbk+6YiDrLCReLlYAkgq0LGSMVmd1+eGpvjleuwidLbuRbWGX5S5qlQSErmr+4zdJC8qoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t5bHE7Pp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t5bHE7Pp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C90D5C4CEE4;
	Mon, 12 May 2025 00:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011369;
	bh=yDhUDriiBg7yCPrev50Ya1ZFDVAUCWfS81To0WSb23I=;
	h=Date:To:From:Subject:From;
	b=t5bHE7Ppn+5notFUm7a+lBtYfUpxSVx078x+4WwlDmieJRsNJlmelyU/Yod6vmivk
	 7z/6m+8kQCNDYa8vaOlGONhd0wGS7xOeLLtAkgh2OfS2PHfrnWo+ChiM0dNsCI3u6R
	 IhDL4lM7MQyT3t6aTbwztL3VUrlXceokrfCKz4Q0=
Date: Sun, 11 May 2025 17:56:09 -0700
To: mm-commits@vger.kernel.org,wangyuli@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] treewide-fix-typo-previlege.patch removed from -mm tree
Message-Id: <20250512005609.C90D5C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: treewide: fix typo "previlege"
has been removed from the -mm tree.  Its filename was
     treewide-fix-typo-previlege.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: WangYuli <wangyuli@uniontech.com>
Subject: treewide: fix typo "previlege"
Date: Mon, 21 Apr 2025 15:49:10 +0800

There are some spelling mistakes of 'previlege' in comments which
should be 'privilege'.

Fix them and add it to scripts/spelling.txt.

The typo in arch/loongarch/kvm/main.c was corrected by a different
patch [1] and is therefore not included in this submission.

[1]. https://lore.kernel.org/all/20250420142208.2252280-1-wheatfox17@icloud.com/

Link: https://lkml.kernel.org/r/46AD404E411A4BAC+20250421074910.66988-1-wangyuli@uniontech.com
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/char/vmlogrdr.c          |    4 ++--
 include/linux/habanalabs/hl_boot_if.h |    2 +-
 scripts/spelling.txt                  |    2 ++
 3 files changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/s390/char/vmlogrdr.c~treewide-fix-typo-previlege
+++ a/drivers/s390/char/vmlogrdr.c
@@ -255,7 +255,7 @@ static int vmlogrdr_recording(struct vml
 
 	/*
 	 * The recording commands needs to be called with option QID
-	 * for guests that have previlege classes A or B.
+	 * for guests that have privilege classes A or B.
 	 * Purging has to be done as separate step, because recording
 	 * can't be switched on as long as records are on the queue.
 	 * Doing both at the same time doesn't work.
@@ -557,7 +557,7 @@ static ssize_t vmlogrdr_purge_store(stru
 
         /*
 	 * The recording command needs to be called with option QID
-	 * for guests that have previlege classes A or B.
+	 * for guests that have privilege classes A or B.
 	 * Other guests will not recognize the command and we have to
 	 * issue the same command without the QID parameter.
 	 */
--- a/include/linux/habanalabs/hl_boot_if.h~treewide-fix-typo-previlege
+++ a/include/linux/habanalabs/hl_boot_if.h
@@ -295,7 +295,7 @@ enum cpu_boot_dev_sts {
  *					Initialized in: linux
  *
  * CPU_BOOT_DEV_STS0_GIC_PRIVILEGED_EN	GIC access permission only from
- *					previleged entity. FW sets this status
+ *					privileged entity. FW sets this status
  *					bit for host. If this bit is set then
  *					GIC can not be accessed from host.
  *					Initialized in: linux
--- a/scripts/spelling.txt~treewide-fix-typo-previlege
+++ a/scripts/spelling.txt
@@ -1240,6 +1240,8 @@ prefered||preferred
 prefferably||preferably
 prefitler||prefilter
 preform||perform
+previleged||privileged
+previlege||privilege
 premption||preemption
 prepaired||prepared
 prepate||prepare
_

Patches currently in -mm which might be from wangyuli@uniontech.com are


