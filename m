Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792543663;
	b=JzIfegs3qKNwCB+ODmN27BlQN+bvZk8F2SfcBJQbXiv5i7AVaiIxoNExUc3hrxlXBSCP
	 5CV3c2SatE5NunwmxGJnsWJLrzL2mbCd2z40IE4bNJw/yVH6DPWhv/X+xJEaAu11X4nfO
	 IzFIKH/zo0lL28lNGlhB0jzMJJSImD+DTKxpir+tqUbBWclH+NXp6eRlCTVEHVOeMo4Wy
	 lq2CziroKpohqyzFAuguyni+kpitg5izuaFq73AYaGF9Lei2uZfyrAShgrK8QbR2arNKf
	 c1tw2z0lIY68Ktc7iZmfHusd8K1pJmnePSG0Zyf4vTjC5DM7xgzGGnlGxtI7cHmu5DA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792543663;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=GZgn5vZTVMvPiy0L8rfNiCYYAoCUc90RirMixinlcDA=;
	b=u2mIOMXSuJ2ihrjvaTVMbatvMfaJ0GTMm6evYwNV96GVDjoJ1p+nITixJiZnDvjvEv0r
	 eT9nO/MYNLpdsLtuawwbJMKNCVtLAzGoRH1tqHGMJkywM9CNaimonBQjU7A5uEWiw5D1M
	 TKLhVgx5KSBxdQtXJ1sqnNKh0nwSV/9UHc2zPR5t50D0oc8eks4zhPrf9Edw8jq7TbxJI
	 VCoHWGSYAaF/cc0Wj4SgIOVIDw1F6MUoJtn6FeNp9NduiAHgmX/DVZjpQ9o2VFq3pxPfW
	 MTt9FA92rDtRQLR6v7Ktm9XzrcYtGwn+BPhlejSP3TjSmA7k76dmsKorp3Bj90aarnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=J1ifxfaX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6857606A31B
	for <mm-commits@vger.kernel.org>; Wed, 21 Oct 2026 00:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=J1ifxfaX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F5F1F000C9;
	Wed, 21 Oct 2026 00:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792543662;
	bh=GZgn5vZTVMvPiy0L8rfNiCYYAoCUc90RirMixinlcDA=;
	h=Date:To:From:Subject;
	b=J1ifxfaXi5+9tCq4fGn4ij0Rg6X0f6MuqWlxzv6eykg+XyA8sVoSWwzA+2W3vqWeh
	 T/I8+hf03q3P1zOV08L2ohRsQQsIw1/RCoZoDFWjcWBSYupoUh2nU8aH7QG++nF3eD
	 DzfU47Q3RzUeuW/N2KxsFd8g1vHP3lZX5HcnbT/o=
Date: Tue, 20 Oct 2026 17:47:41 -0700
To: mm-commits@vger.kernel.org,brads@mainlining.org,thnkslprpt@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + profiling-fix-sampling-step-on-64-bit-big-endian-systems.patch added to mm-nonmm-unstable branch
Message-Id: <20261021004742.30F5F1F000C9@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: profiling: fix sampling step on 64-bit big-endian systems
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     profiling-fix-sampling-step-on-64-bit-big-endian-systems.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/profiling-fix-sampling-step-on-64-bit-big-endian-systems.patch

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
From: Avi Weiss <thnkslprpt@gmail.com>
Subject: profiling: fix sampling step on 64-bit big-endian systems
Date: Tue, 20 Oct 2026 13:12:24 +0300

read_profile() stores the sampling step in an unsigned long but copies
only four bytes to userspace.  On 64-bit big-endian systems (not common
obviously), this copies the upper 32 bits and discards the rest, causing
/proc/profile to report zero for normal shift values.

Cast to unsigned int so we get the correct 4 bytes, while keeping the
shift calculation in unsigned long.

A small C reproducer under qemu-s390x reproduced this and proved the fix
works for prof_shift=2.

Link: https://lore.kernel.org/20261020101225.917959-1-thnkslprpt@gmail.com
Fixes: 2d186afd04d6 ("profiling: fix shift-out-of-bounds bugs")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Bradley Morgan <brads@mainlining.org>
---

 kernel/profile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/profile.c~profiling-fix-sampling-step-on-64-bit-big-endian-systems
+++ a/kernel/profile.c
@@ -156,7 +156,7 @@ read_profile(struct file *file, char __u
 	unsigned long p = *ppos;
 	ssize_t read;
 	char *pnt;
-	unsigned long sample_step = 1UL << prof_shift;
+	unsigned int sample_step = (unsigned int)(1UL << prof_shift);
 
 	if (p >= (prof_len+1)*sizeof(unsigned int))
 		return 0;
_

Patches currently in -mm which might be from thnkslprpt@gmail.com are

profiling-fix-sampling-step-on-64-bit-big-endian-systems.patch

