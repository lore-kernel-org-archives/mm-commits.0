Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F0F848D
	for <mm-commits@vger.kernel.org>; Fri,  1 Mar 2024 17:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709315021; cv=none; b=YahKNqak3mdFmZFRCDvh7Myj5odYsTcxOuwu+3araRtPE60Zb68ZxLSgb8Y795cOwEuzcdpW9QAsOqKxEuixLe4okfKvCR6p38f1glWpVdXfZR/bkx09SrG7VmY3Gmat1GotkjXD7yCdWk1aOE/BsMZWmLO8//0x5MBjR6c6DGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709315021; c=relaxed/simple;
	bh=500zXiiskSWGTmwHdjLvAdmZI3Kv/uAnX//1gFqYHkM=;
	h=Date:To:From:Subject:Message-Id; b=r0SWvoiIeoijayxrFtUIhsI8MRbwWF8yc3MUCjKhJ3GslcaeOfcKK5qxOGKTquOCCt55wf4aWSFkFcOVna7/DLUUCSLLBgCZAI89Glc9rbwt8vHjXTzVvOMQRs0yjrV/FkWr5wF7NkZO9nNX3dHnThnDo79TnENROrmdyqyuXrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YwhpriBw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YwhpriBw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 642BEC433C7;
	Fri,  1 Mar 2024 17:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709315020;
	bh=500zXiiskSWGTmwHdjLvAdmZI3Kv/uAnX//1gFqYHkM=;
	h=Date:To:From:Subject:From;
	b=YwhpriBwGkw+i/fMKMyjRrG0mFZcuSLzBbjaS0Y/GdV7k1n+5NUk7cocE6pnzOtGt
	 fTvVSwcfweTmSviHoA86P1i/clnD2Zp3ipXGh28PasPI+MBENUYkF+SHpDsMfBnROA
	 Hu+xkggZoXrTp68K+3Hbj1zCuHV+Y8sSbxksIcnI=
Date: Fri, 01 Mar 2024 09:43:39 -0800
To: mm-commits@vger.kernel.org,bhe@redhat.com,yang.zhang@hexintek.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-copy-only-happens-before-uchunk-goes-to-zero.patch added to mm-nonmm-unstable branch
Message-Id: <20240301174340.642BEC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec: copy only happens before uchunk goes to zero
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec-copy-only-happens-before-uchunk-goes-to-zero.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-copy-only-happens-before-uchunk-goes-to-zero.patch

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
From: "yang.zhang" <yang.zhang@hexintek.com>
Subject: kexec: copy only happens before uchunk goes to zero
Date: Thu, 22 Feb 2024 17:21:19 +0800

When loading segments, ubytes is <= mbytes.  When ubytes is exhausted,
there could be remaining mbytes.  Then in the while loop, the buf pointer
advancing with mchunk will causing meaningless reading even though it
doesn't harm.

So let's change to make sure that all of the copying and the rest only
happens before uchunk goes to zero.

Link: https://lkml.kernel.org/r/20240222092119.5602-1-gaoshanliukou@163.com
Signed-off-by: yang.zhang <yang.zhang@hexintek.com>
Acked-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |   44 ++++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 20 deletions(-)

--- a/kernel/kexec_core.c~kexec-copy-only-happens-before-uchunk-goes-to-zero
+++ a/kernel/kexec_core.c
@@ -750,22 +750,24 @@ static int kimage_load_normal_segment(st
 				PAGE_SIZE - (maddr & ~PAGE_MASK));
 		uchunk = min(ubytes, mchunk);
 
-		/* For file based kexec, source pages are in kernel memory */
-		if (image->file_mode)
-			memcpy(ptr, kbuf, uchunk);
-		else
-			result = copy_from_user(ptr, buf, uchunk);
+		if (uchunk) {
+			/* For file based kexec, source pages are in kernel memory */
+			if (image->file_mode)
+				memcpy(ptr, kbuf, uchunk);
+			else
+				result = copy_from_user(ptr, buf, uchunk);
+			ubytes -= uchunk;
+			if (image->file_mode)
+				kbuf += uchunk;
+			else
+				buf += uchunk;
+		}
 		kunmap_local(ptr);
 		if (result) {
 			result = -EFAULT;
 			goto out;
 		}
-		ubytes -= uchunk;
 		maddr  += mchunk;
-		if (image->file_mode)
-			kbuf += mchunk;
-		else
-			buf += mchunk;
 		mbytes -= mchunk;
 
 		cond_resched();
@@ -817,11 +819,18 @@ static int kimage_load_crash_segment(str
 			memset(ptr + uchunk, 0, mchunk - uchunk);
 		}
 
-		/* For file based kexec, source pages are in kernel memory */
-		if (image->file_mode)
-			memcpy(ptr, kbuf, uchunk);
-		else
-			result = copy_from_user(ptr, buf, uchunk);
+		if (uchunk) {
+			/* For file based kexec, source pages are in kernel memory */
+			if (image->file_mode)
+				memcpy(ptr, kbuf, uchunk);
+			else
+				result = copy_from_user(ptr, buf, uchunk);
+			ubytes -= uchunk;
+			if (image->file_mode)
+				kbuf += uchunk;
+			else
+				buf += uchunk;
+		}
 		kexec_flush_icache_page(page);
 		kunmap_local(ptr);
 		arch_kexec_pre_free_pages(page_address(page), 1);
@@ -829,12 +838,7 @@ static int kimage_load_crash_segment(str
 			result = -EFAULT;
 			goto out;
 		}
-		ubytes -= uchunk;
 		maddr  += mchunk;
-		if (image->file_mode)
-			kbuf += mchunk;
-		else
-			buf += mchunk;
 		mbytes -= mchunk;
 
 		cond_resched();
_

Patches currently in -mm which might be from yang.zhang@hexintek.com are

kexec-copy-only-happens-before-uchunk-goes-to-zero.patch

