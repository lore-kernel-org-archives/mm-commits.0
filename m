Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A6F4C8E
	for <mm-commits@vger.kernel.org>; Sun,  8 Jun 2025 00:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749343652; cv=none; b=NCK2O6UawxzRj4+ak8shu9FoHdlafuijCUJcuA5Z+4Bbrlz4sxXrBT5afpCNpRgrm1cho/T8pngvAFdLQCV2yZHeuekJGNUe61sXiMRed2/suRRUNdPshG0bkCebBniXCXLALeXWJ5FWbihyQFdGD9gx8vkACOBjV3u2v3aCx+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749343652; c=relaxed/simple;
	bh=/qhLLYev+4CUNpqwum0qyGyQrRFweTPSsK7tWsm7XGY=;
	h=Date:To:From:Subject:Message-Id; b=g/bPCqRmjGNTsmfZ5RPILbX+4TuGwHtyMT2OnnMicPczPlFoF+oNC3QZrxedRLF4SrbjpEHlO2uPseP80O/xYQt6gz4JisYNhbaOHIgOLywOeNDbibjvgQG92bhPMaXq28RQfeO6dDLbnGLKdkAPSay3dRdlY0v4FKQ7YAo5d30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uEMx+uoL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uEMx+uoL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD23C4CEE4;
	Sun,  8 Jun 2025 00:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749343652;
	bh=/qhLLYev+4CUNpqwum0qyGyQrRFweTPSsK7tWsm7XGY=;
	h=Date:To:From:Subject:From;
	b=uEMx+uoLVBQd6ltl0r5rIR8l09rqSry6NwJj5HD+hKbc1dQmMbaUfUoPbMa2koOIn
	 TdMwWfBNcqyOmRlO/6349lxwiFcW4ZgIw9XeRObQKHKNpMHI850axx1hqXDjLk2C9v
	 jt8Bofx/ZfXYpGDwWRPuQkm3ULjhssAmcW0nGT/0=
Date: Sat, 07 Jun 2025 17:47:31 -0700
To: mm-commits@vger.kernel.org,torvalds@linuxfoundation.org,mporter@kernel.crashing.org,maherazz04@gmail.com,alex.bou9@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drivers-rapidio-rio_cmc-prevent-possible-used-uninitialized.patch added to mm-hotfixes-unstable branch
Message-Id: <20250608004732.0AD23C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drivers/rapidio/rio_cm.c: prevent possible used-uninitialized
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     drivers-rapidio-rio_cmc-prevent-possible-used-uninitialized.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drivers-rapidio-rio_cmc-prevent-possible-used-uninitialized.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/rapidio/rio_cm.c: prevent possible used-uninitialized
Date: Sat Jun  7 05:43:18 PM PDT 2025

In

riocm_cdev_ioctl(RIO_CM_CHAN_SEND)
   -> cm_chan_msg_send()
      -> riocm_ch_send()

cm_chan_msg_send() checks that userspace didn't send too much data but
riocm_ch_send() failed to check that userspace sent sufficient data.  The
result is that riocm_ch_send() can access fields in the rio_ch_chan_hdr
which were never copied in from userspace.

Address this by teaching riocm_ch_send() to check that the entire
rio_ch_chan_hdr was copied in from userspace.

Reported-by: maher azz <maherazz04@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio_cm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/rapidio/rio_cm.c~drivers-rapidio-rio_cmc-prevent-possible-used-uninitialized
+++ a/drivers/rapidio/rio_cm.c
@@ -783,6 +783,9 @@ static int riocm_ch_send(u16 ch_id, void
 	if (buf == NULL || ch_id == 0 || len == 0 || len > RIO_MAX_MSG_SIZE)
 		return -EINVAL;
 
+	if (len < sizeof(struct rio_ch_chan_hdr))
+		return -EINVAL;		/* insufficient data from user */
+
 	ch = riocm_get_channel(ch_id);
 	if (!ch) {
 		riocm_error("%s(%d) ch_%d not found", current->comm,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

docs-proc-update-vmflags-documentation-in-smaps-fix.patch
fs-proc-task_mmu-add-vm_shadow_stack-for-arm64-when-support-gcs-fix.patch
drivers-rapidio-rio_cmc-prevent-possible-used-uninitialized.patch
mm-add-zblock-allocator-fix.patch
mm-add-zblock-allocator-fix-2.patch
mm-add-zblock-allocator-fix-2-fix.patch
mm-add-zblock-allocator-fix-3.patch
mm-zblock-avoid-failing-the-build-fix.patch

