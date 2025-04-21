Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B6213C918
	for <mm-commits@vger.kernel.org>; Mon, 21 Apr 2025 19:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745262954; cv=none; b=MB/yID8ypTGhTqjQPa6B8gMzP8QNy7CwmW/lSft8saNxNvpuHzbwlWh5JLKoVD9cNDkJfiIm7TfHLMnuUBNlPEvaFEbykQQfEotp7eRvcGfrGstlnyJQ0a0r92hGc9U37FXBibz9tnckW9Gxs4Zbgq8a0cr/MSe7dKMvDLcEL6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745262954; c=relaxed/simple;
	bh=JjMs+eBYQaVQ7H0BbVGjnnoHqHU2xAgp97Dy+6bpFeQ=;
	h=Date:To:From:Subject:Message-Id; b=uFZU/0lA+dHegEirHCGjjaEip2RRz5NKIkZzfGPmhpYLJ3Xq6syVbIwzwpyJMCeRt4mURxomPjoTPTBT/ag2FG5NkECeXLXkf5tCsKkn+jnacdRia8dtG0mHkNHg2duyopYqNooaerMHjBWKlN3lI+LTWNVpZtsXQjw8yeqnOls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=emqkLp2H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="emqkLp2H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C45ECC4CEE4;
	Mon, 21 Apr 2025 19:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745262953;
	bh=JjMs+eBYQaVQ7H0BbVGjnnoHqHU2xAgp97Dy+6bpFeQ=;
	h=Date:To:From:Subject:From;
	b=emqkLp2HxLVAYwJhxtN58EGSBjrFHaZPNIuvsNaRCeV9jIVqq+5RKYZRxV5Ty/C4u
	 t7H32elPxWDnaqPmZroQvbBRmTjUYQLw6UR08qBreeRMo4PZsVELsvNRDlYH9F729I
	 tOY3EjPIiODNEFzQO3gukAQA1mJU53kK0R31Ekz4=
Date: Mon, 21 Apr 2025 12:15:53 -0700
To: mm-commits@vger.kernel.org,wangyuli@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + treewide-fix-typo-previlege.patch added to mm-nonmm-unstable branch
Message-Id: <20250421191553.C45ECC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: treewide: fix typo "previlege"
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     treewide-fix-typo-previlege.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/treewide-fix-typo-previlege.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

ocfs2-o2net_idle_timer-rename-del_timer_sync-in-comment.patch
treewide-fix-typo-previlege.patch

