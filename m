Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0F9409113
	for <mm-commits@vger.kernel.org>; Fri, 10 Jul 2026 22:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783724395; cv=none; b=pbEQsLpbm572k8hpMS1L6RxYZoIIPATSZGcnAn5FoglIC5qco9ic0/pEICmuPjeyjBw+EfV/bCzojqvgvKkwLqsIt0WDv9om10XauG1bCp8VXJpGaPv+L41Z1dppSnDvMJ9J2Gx3Q8x98fJ/KH2ptoRl22gO+scsJLThwAVU2jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783724395; c=relaxed/simple;
	bh=8G4Urv0+g3wOIFiWRl8oqqT/G+/JuTLLQ4SUHZGiaxc=;
	h=Date:To:From:Subject:Message-Id; b=ccYUnSXagmrIAth6JyLTViqG8BgALaFoDarrblbhCyrV+VuczeopIGj/8GMiU9ZVWQ01W94b8PVLABUybosaoMmSxWniyKqHDOve5WJsu78YMo/TxHWx01N2FF2Yg490671MwL8/Vf9y2y4p6cE/neIBxDdm8goK1H7PV2EoxIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OSKoY16S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OSKoY16S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A7C1F000E9;
	Fri, 10 Jul 2026 22:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783724394;
	bh=hd6VQ3PZWDhKR+i7b+0Jzkshmr5No0IW/fWtaaxW4pI=;
	h=Date:To:From:Subject;
	b=OSKoY16SVlJXkeGssc05t4Z2aDdrfjQb53RWI4NeTUTvfbw0GpyqnCJfVCC0tBz9l
	 PC1OWawg/rAGtEvXM5hXgh/inJKXqzvHum6n3mxPUfrA/QClnH3jncIGi6vqWaHkJ3
	 +VS3Ey1vZpmcYZpSB2ZqED5ppGnlZG3POuhH+f9U=
Date: Fri, 10 Jul 2026 15:59:53 -0700
To: mm-commits@vger.kernel.org,thomas.orgis@uni-hamburg.de,balbirs@nvidia.com,cyyzero16@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + taskstats-return-ebadf-when-cgroupstats-receives-an-invalid-fd.patch added to mm-nonmm-unstable branch
Message-Id: <20260710225954.31A7C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: taskstats: return -EBADF when cgroupstats receives an invalid fd
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     taskstats-return-ebadf-when-cgroupstats-receives-an-invalid-fd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/taskstats-return-ebadf-when-cgroupstats-receives-an-invalid-fd.patch

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
From: Yiyang Chen <cyyzero16@gmail.com>
Subject: taskstats: return -EBADF when cgroupstats receives an invalid fd
Date: Sat, 11 Jul 2026 04:07:36 +0800

Patch series "taskstats: fix cgroupstats invalid fd handling and add
selftests".

This series fixes an issue where cgroupstats mishandles invalid file
descriptors, and introduces a functional kselftest to prevent regressions.

When an invalid file descriptor is passed via CGROUPSTATS_CMD_ATTR_FD,
cgroupstats_user_cmd() returns 0 instead of an error code. This leads to
two broken behaviors depending on netlink flags:
- Callers without NLM_F_ACK block indefinitely on recv().
- Callers with NLM_F_ACK receive a misleading success ACK (errno == 0)
  but no actual statistics payload.

The first patch addresses this by returning -EBADF when the fd cannot be
resolved.  The second patch adds a comprehensive kselftest covering both
the valid cgroup v1 query and the invalid fd paths (with and without
NLM_F_ACK) to ensure the fixes work as intended.


This patch (of 2):

cgroupstats_user_cmd() returns 0 without sending a reply or a netlink
error when the fd passed via CGROUPSTATS_CMD_ATTR_FD does not resolve to
an open file in the caller's table.  As a result:

- clients that did not set NLM_F_ACK block on recv() indefinitely
  waiting for a CGROUPSTATS_CMD_NEW message that is never emitted;

- clients that set NLM_F_ACK receive a misleading "success" ACK (errno
  == 0) with no statistics payload.

Return -EBADF instead so the netlink layer propagates the error to
userspace as expected.

Link: https://lore.kernel.org/cover.1783713230.git.cyyzero16@gmail.com
Link: https://lore.kernel.org/b4fd9e288e4a48efebaf41b4ffcdb204b06675c4.1783713230.git.cyyzero16@gmail.com
Signed-off-by: Yiyang Chen <cyyzero16@gmail.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Dr. Thomas Orgis <thomas.orgis@uni-hamburg.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/taskstats.c~taskstats-return-ebadf-when-cgroupstats-receives-an-invalid-fd
+++ a/kernel/taskstats.c
@@ -423,7 +423,7 @@ static int cgroupstats_user_cmd(struct s
 	fd = nla_get_u32(info->attrs[CGROUPSTATS_CMD_ATTR_FD]);
 	CLASS(fd, f)(fd);
 	if (fd_empty(f))
-		return 0;
+		return -EBADF;
 
 	size = nla_total_size(sizeof(struct cgroupstats));
 
_

Patches currently in -mm which might be from cyyzero16@gmail.com are

taskstats-remove-dead-taskstats_exit_mutex-declaration.patch
taskstats-return-ebadf-when-cgroupstats-receives-an-invalid-fd.patch
selftests-acct-add-cgroupstats-functional-test.patch

