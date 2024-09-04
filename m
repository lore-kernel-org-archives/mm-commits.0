Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF4C770E5
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423511; cv=none; b=s/cNrlkRXLZjfPmPDxtmBq3QVBKsS5G183TVjEmLvPb0dHMSG3/OM2Qxqi+ZgsMQHLTGgGwaJJ6Qpm/Uc02y8lt0ZH0jdncOFf+P8zz3Wa7pBgtMWVy35R+ILEfsvSAIaL3a8bw7fiNPg5+WYqKPV+iqZMc/Ww4I0ubM9P260+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423511; c=relaxed/simple;
	bh=Kgseq5p13LmOK6jaeE9+T3frhgRptFwRZ3+jvnQF5Rc=;
	h=Date:To:From:Subject:Message-Id; b=UHuo3wIG6kq+ysKRxrq7GY82Sjvj5pwhDB9P+UpQkg7wPY7CWbCTO0doPxkMdkngsBbw0OaIRoszG6TFuFRA17xelaoOoTSfeM2nlwTLF7inKUFegqj3gTZA3X+TNuDRwL3PC+enx/XiV6okDAG3zqU/daET50BxpYxFVZYIO+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fcL+Kcuz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fcL+Kcuz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B439FC4CEC2;
	Wed,  4 Sep 2024 04:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423511;
	bh=Kgseq5p13LmOK6jaeE9+T3frhgRptFwRZ3+jvnQF5Rc=;
	h=Date:To:From:Subject:From;
	b=fcL+KcuzPBULah9OQU99TNaM/YKET08TiT8Sms0f7sJq43Z4tcQ+U8vfZCgxRSwHR
	 9C0fJot8vvm/MCuwmcsWiIXnoYStoqGR/uLRzS140GVhygfiIcss+G8b/aHJ7nHhFm
	 T4ttrk239ABkZef5z2ToOJGLbd9NQ7RuX9p2o3lo=
Date: Tue, 03 Sep 2024 21:18:31 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,shuah@kernel.org,mpe@ellerman.id.au,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,kees@kernel.org,jeffxu@chromium.org,pedro.falcato@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mprotect-replace-can_modify_mm-with-can_modify_vma.patch removed from -mm tree
Message-Id: <20240904041831.B439FC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mprotect: replace can_modify_mm with can_modify_vma
has been removed from the -mm tree.  Its filename was
     mm-mprotect-replace-can_modify_mm-with-can_modify_vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pedro Falcato <pedro.falcato@gmail.com>
Subject: mm/mprotect: replace can_modify_mm with can_modify_vma
Date: Sat, 17 Aug 2024 01:18:30 +0100

Avoid taking an extra trip down the mmap tree by checking the vmas
directly.  mprotect (per POSIX) tolerates partial failure.

Link: https://lkml.kernel.org/r/20240817-mseal-depessimize-v3-3-d8d2e037df30@gmail.com
Signed-off-by: Pedro Falcato <pedro.falcato@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/mm/mprotect.c~mm-mprotect-replace-can_modify_mm-with-can_modify_vma
+++ a/mm/mprotect.c
@@ -611,6 +611,9 @@ mprotect_fixup(struct vma_iterator *vmi,
 	unsigned long charged = 0;
 	int error;
 
+	if (!can_modify_vma(vma))
+		return -EPERM;
+
 	if (newflags == oldflags) {
 		*pprev = vma;
 		return 0;
@@ -769,15 +772,6 @@ static int do_mprotect_pkey(unsigned lon
 		}
 	}
 
-	/*
-	 * checking if memory is sealed.
-	 * can_modify_mm assumes we have acquired the lock on MM.
-	 */
-	if (unlikely(!can_modify_mm(current->mm, start, end))) {
-		error = -EPERM;
-		goto out;
-	}
-
 	prev = vma_prev(&vmi);
 	if (start > vma->vm_start)
 		prev = vma;
_

Patches currently in -mm which might be from pedro.falcato@gmail.com are


