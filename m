Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B3015539A
	for <mm-commits@vger.kernel.org>; Thu, 19 Feb 2026 22:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771539416; cv=none; b=d1mi4gK8aUdXLYtpyCXUzEeyYJusSB8u28gCGHEFyrX8QgfYEXbcsdPnYXkbI56WIIJu/mFEaqvAD8+I1ZJ9PedKSwjr6TquTYZCxmL+DYJ8evxDbzOzf+H6ItOSd5vcclYv3g7xLp4YFW4g+5Jnd7FXcR+VwJ7wNA2LroPiOSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771539416; c=relaxed/simple;
	bh=ujARNX6NOXSPglgdu7Jf1QSNw2tA0MpoZJnU+p8nucs=;
	h=Date:To:From:Subject:Message-Id; b=GW0kJ55iG+f3Y+Lbg2Yl3uBGMtNBQi+1gqd/YPDd2YLXkiyLDRB4GC69tTOYpj3/bDOg0HUt8H5+GLep/3UyHLP55vcKnbcyr9rrtfNytWXB/J9FNhaqAj99L85gL2ApljiP6DDut13mnHqraBzzluZx/AY4fogDRS9fFpE4HfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XzwCynfA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XzwCynfA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2C0C4CEF7;
	Thu, 19 Feb 2026 22:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771539416;
	bh=ujARNX6NOXSPglgdu7Jf1QSNw2tA0MpoZJnU+p8nucs=;
	h=Date:To:From:Subject:From;
	b=XzwCynfAp/y4ubvie7dfI4BQMJGdT0THkOx6iQgxuDRwjOViXJdXCnAyZuN1LIBa1
	 Lk3t4wmPldiL2HR9AjTACJfy38IWAi7Ti0WmMP1QAZmQZj9JN65mRK9r5UsQmxCcEz
	 Es8th9qHSZrVuS/RSULvd/NB4ml0byHj7hZ2GkNc=
Date: Thu, 19 Feb 2026 14:16:55 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,rppt@kernel.org,oleg@redhat.com,neil@brown.name,mingo@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,ebiederm@xmission.com,bvanassche@acm.org,brauner@kernel.org,ethantidmore06@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-fix-pointer-error-dereference.patch added to mm-nonmm-unstable branch
Message-Id: <20260219221656.4B2C0C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: proc: fix pointer error dereference
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     proc-fix-pointer-error-dereference.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-fix-pointer-error-dereference.patch

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
From: Ethan Tidmore <ethantidmore06@gmail.com>
Subject: proc: fix pointer error dereference
Date: Thu, 19 Feb 2026 16:10:01 -0600

The function try_lookup_noperm() can return an error pointer.  Add check
for error pointer.

Detected by Smatch:
fs/proc/base.c:2148 proc_fill_cache() error:
'child' dereferencing possible ERR_PTR()

Link: https://lkml.kernel.org/r/20260219221001.1117135-1-ethantidmore06@gmail.com
Fixes: 61a28784028e6 ("proc: Remove the hard coded inode numbers")
Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Bart van Assche <bvanassche@acm.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: NeilBrown <neil@brown.name>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/proc/base.c~proc-fix-pointer-error-dereference
+++ a/fs/proc/base.c
@@ -2128,6 +2128,9 @@ bool proc_fill_cache(struct file *file,
 	ino_t ino = 1;
 
 	child = try_lookup_noperm(&qname, dir);
+	if (IS_ERR(child))
+		goto end_instantiate;
+
 	if (!child) {
 		DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wq);
 		child = d_alloc_parallel(dir, &qname, &wq);
_

Patches currently in -mm which might be from ethantidmore06@gmail.com are

proc-fix-pointer-error-dereference.patch

