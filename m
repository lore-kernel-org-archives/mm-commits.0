Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C2E2F3E
	for <mm-commits@vger.kernel.org>; Sat,  7 Jun 2025 21:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749331198; cv=none; b=Tu/n34VssBEH9Z3zfcjQDac0z9IupGJQhURVX5BggMaRaxNKSAOK5PyBLchR9qUC5lNHE3t5Tr1yCO58LX5BquX/z5pYkVkuHVNUqkuZhh8BaiJJ7kR1gdhVS200fWEkHVEeg37SHhf4w1DT0FyBDxckyVhtXuCPWfE0Jfe4v3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749331198; c=relaxed/simple;
	bh=6pciiH5lpQ2W7tQn9XH4c3nUr3QPbQW8aEjYQXHxJG8=;
	h=Date:To:From:Subject:Message-Id; b=irIPCo7xxGetMlziiLvCj1YHdFKbpYZKg+Q0ocVjHFPXf9/c81I1ypvWnITFI4BGmC/5k/tQLFNKTOEFcgYEBBBfLDsLmmDwz1+9J/ByuX0bPUlAkVcqqBiCWTMbOKZmZHXpE/biiZ7nzFshLUZJ27VJimkOkjpCN6XcJVGYn3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nYUKlVNq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nYUKlVNq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC72C4CEE4;
	Sat,  7 Jun 2025 21:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749331197;
	bh=6pciiH5lpQ2W7tQn9XH4c3nUr3QPbQW8aEjYQXHxJG8=;
	h=Date:To:From:Subject:From;
	b=nYUKlVNqK1Wzpl/40uzMX9TWHfuHPg4o+8rVjMrqz+dU/7bb4TSv6Q81ysplTbkJB
	 KUiW/HxJToWtObOPPNVlgt+euJ5q8NOnblpdCrve+iiCqM5H0dNrnFMJtnmMjS2Ps9
	 l8gjAuMIAIT+NvUUMj4FyVXk45xYsKRBlT7O4As0=
Date: Sat, 07 Jun 2025 14:19:56 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,npache@redhat.com,david@redhat.com,corbet@lwn.net,catalin.marinas@arm.com,andrii@kernel.org,wangfushuai@baidu.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-proc-update-vmflags-documentation-in-smaps.patch added to mm-hotfixes-unstable branch
Message-Id: <20250607211957.6CC72C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs: proc: update VmFlags documentation in smaps
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     docs-proc-update-vmflags-documentation-in-smaps.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-proc-update-vmflags-documentation-in-smaps.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: wangfushuai <wangfushuai@baidu.com>
Subject: docs: proc: update VmFlags documentation in smaps
Date: Sat, 7 Jun 2025 23:36:14 +0800

Remove outdated VM_DENYWRITE("dw") reference and add missing
VM_LOCKONFAULT("lf") and VM_UFFD_MINOR("ui") flags.

Link: https://lkml.kernel.org/r/20250607153614.81914-1-wangfushuai@baidu.com
Signed-off-by: wangfushuai <wangfushuai@baidu.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mariano Pache <npache@redhat.com>
Cc: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/Documentation/filesystems/proc.rst~docs-proc-update-vmflags-documentation-in-smaps
+++ a/Documentation/filesystems/proc.rst
@@ -584,7 +584,6 @@ encoded manner. The codes are the follow
     ms    may share
     gd    stack segment growns down
     pf    pure PFN range
-    dw    disabled write to the mapped file
     lo    pages are locked in memory
     io    memory mapped I/O area
     sr    sequential read advise provided
@@ -607,8 +606,10 @@ encoded manner. The codes are the follow
     mt    arm64 MTE allocation tags are enabled
     um    userfaultfd missing tracking
     uw    userfaultfd wr-protect tracking
+    ui    userfaultfd minor fault
     ss    shadow/guarded control stack page
     sl    sealed
+    lf    lock on fault pages
     ==    =======================================
 
 Note that there is no guarantee that every flag and associated mnemonic will
_

Patches currently in -mm which might be from wangfushuai@baidu.com are

docs-proc-update-vmflags-documentation-in-smaps.patch

