Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793508943;
	b=AGbgx/7ruYxx0Gw9+c+YmBqIBYxC+VDY2c/GOCx6WgjxJ59aOHxk5X4umwoXK2DwKu7/
	 H0XQJSMhkT1dzAEkVSML5MkRVzPW1ziUvL3g7+qWcE+eHnj34CTxnIbssb/8YPletKgSb
	 g5VpH21UYpjvDUvqJGLkmtaP3+q0qmPcUMV5xStr+fy4xxsq7Jd58yuYG6OgXtXJep+yG
	 VKfJ209I0dUUHh71oNeKLnqtaM7OMajGHyFUGspk5q/AO5YSZ8MSf0PAiHY5ds9cmjo/I
	 25NL7MK4AkyN9gc0IwUPTd/G+dzf101YAIKY9a8OKbhi96AGbVC/edesVzPQlw3cnUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793508943;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=VdKulzOV/Fr2zNPCgGSP1+ECDHmF/JgBj/VDvDdi1mw=;
	b=1k8PzvEa3DLSq9ZTxeUDO6uuHnFxp+tp+FI0Zz0+r411HSMZunawG6AIONjPOQk0gx53
	 ghOBZE2i17BfFsWJDPkyLMfHWF7SXreftopyEnSVcT42D2ArSVcQFt5ZELryjgsWvyPGh
	 AFO2408vUkuwBdOzBEQAyI/Di4GkbOxTDorOddnHdsuS/rM5mv/85NJ0xBLFpvRmw2w8q
	 sptsP3tefq2nZxVK5PwSW1oe1LNIgyrUJfyKdYhCl8uRtZdE/CLUC0njxaTVYxDfQghA2
	 bjR1Nh20M+3YDs9hNKInQrhdQuhkT+6r7lHNbqE5JAiwjU36n585CghnbhozfL/c0Rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=a6KalLao;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8FFE606A324
	for <mm-commits@vger.kernel.org>; Sun,  1 Nov 2026 04:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=a6KalLao
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207321F000C1;
	Sun,  1 Nov 2026 04:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793508942;
	bh=VdKulzOV/Fr2zNPCgGSP1+ECDHmF/JgBj/VDvDdi1mw=;
	h=Date:To:From:Subject;
	b=a6KalLaos38w3T3sQWpNcUaCc349FSm0QcFg6ix7Lv1RD9/eGVZinw3bp4zerVIod
	 +dVc38t1Go6Rp8rpLU57XOPCSVnMQjCZLXFLktkH9B10uT/sEzBoaVofyW9RmoldjG
	 1f/VA3zEh9Z9wbDJKwdj5K73JDkBMr2pSTawgquQ=
Date: Sat, 31 Oct 2026 21:55:41 -0700
To: mm-commits@vger.kernel.org,med08elkadiri@gmail.com,hughd@google.com,
	danielzgtg.opensource@gmail.com,baolin.wang@linux.alibaba.com,
	krisman@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-report-casefold-setting-in-mount-options.patch added to mm-new branch
Message-Id: <20261101045542.207321F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: shmem: report casefold setting in mount options
has been added to the -mm mm-new branch.  Its filename is
     shmem-report-casefold-setting-in-mount-options.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-report-casefold-setting-in-mount-options.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Gabriel Krisman Bertazi <krisman@suse.de>
Subject: shmem: report casefold setting in mount options
Date: Mon, 19 Oct 2026 23:59:17 -0400

For shmem, casefolding is a mount option.  Report the current encoding and
casefolding flags in /proc/mounts, so userspace can easily check if
casefolding is supported withour relying on parsing dmesg or trying to set
+F.

Link: https://lore.kernel.org/20261020035917.693478-1-krisman@suse.de
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Daniel Tang <danielzgtg.opensource@gmail.com>
Closes: https://lore.kernel.org/linux-fsdevel/5193732.31r3eYUQgx@daniel-desktop3/#R
Tested-by: Mohammed EL Kadiri <med08elkadiri@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
---

 mm/shmem.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/shmem.c~shmem-report-casefold-setting-in-mount-options
+++ a/mm/shmem.c
@@ -5137,6 +5137,17 @@ static int shmem_show_options(struct seq
 		seq_printf(seq, ",grpquota_inode_hardlimit=%lld",
 			   sbinfo->qlimits.grpquota_ihardlimit);
 #endif
+#if IS_ENABLED(CONFIG_UNICODE)
+	if (root->d_sb->s_encoding) {
+		unsigned int version = root->d_sb->s_encoding->version;
+
+		seq_printf(seq, ",casefold=utf8-%u.%u.%u",
+			   unicode_major(version), unicode_minor(version),
+			   unicode_rev(version));
+		if (sb_has_strict_encoding(root->d_sb))
+			seq_puts(seq, ",strict_encoding");
+	}
+#endif
 	return 0;
 }
 
_

Patches currently in -mm which might be from krisman@suse.de are

shmem-report-casefold-setting-in-mount-options.patch

