Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793739102;
	b=1u/cnoGJ3Cv83dIOPFBXE09aAOwBgJ0Ltf0VlvMnjdmkWbXVLa2akg62O8rN2wevGhdk
	 TiAgeoJvnlVSRHsgFJflvjh7qLDJtzb75+TE91GKn1mmlPIB0xrYBFA6Mh67ihU2eZFdf
	 1SZf+8ZwW2w3dX/9TIRO61KHCxK4l4rjOl8AiGJe748UlSj1Tlb9Ae1yPyde3ZJwVlntT
	 hQC6/a2r7wurHPMAx4l4ji7QDmlnpbTRjEktB5LpryUGA/ryAsaEMcgKwOqBIq/QYz5+c
	 IRGTlnJBNbkusbQ608gyUhZ3axLfg0tsK1zcWQiPAalI8+Lz0yF23g1SXb3k+aA7UOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793739102;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=6NGeNh5fz/pFGaFmw4s1ZTzzWaOX0keujKuA4b7sixw=;
	b=vF/RrJqlOzQ2ED435LBKaDQQPeKL+gur6yzUUd5MADQYtwW8f9sW52QktEHkegWLYmFg
	 CoLQKfNJc+kPXymepxElh5mcvDItjUh0MKxLCYB/ZaFDoE1h3juRJbLqYNQPm5wI+yhkj
	 7k+PFkKxagFwlNPvRJuHdRlWUJXTySQ4mR6oHDNS75sdrzEqXdP3l/MQVbmSVY5QGaTIV
	 c9DwO3IqGVZlGLYfiZc7JB6Prxd++ag85HHmnrgNn/Or/aLYV4J6TrqOLQiY/phCnlmO6
	 n6V3Ehe/ddAzoSRSGnquwJ07WXUDAPetKTc30EyB4tbiq4pGuPM3GLJwE+FoIZJT/Ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=MqAezRZ5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AE6606A328
	for <mm-commits@vger.kernel.org>; Tue,  3 Nov 2026 20:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=MqAezRZ5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2D01F00919;
	Tue,  3 Nov 2026 20:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793739101;
	bh=6NGeNh5fz/pFGaFmw4s1ZTzzWaOX0keujKuA4b7sixw=;
	h=Date:To:From:Subject;
	b=MqAezRZ5dEBoVjCKb1HlvjF1OAEScZY/kxWOf7N0yYwnUuYdD6nKmlAuYJIZlNCz+
	 6+LBJFTRn+2TAdFgeS6jaqpaOsZdmuTMBjtHdrJlF/5weiHG968A7E60oRZ3k3J/Wc
	 kbrH9jkJXzlneVeuGER1hI2lNu3ALe23nHIcg/20=
Date: Tue, 03 Nov 2026 12:51:40 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,shuah@kernel.org,
	akpm@linux-foundation.org,sashal@kernel.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-proc-cast-the-procmap_query-address-through-uintptr_t.patch added to mm-new branch
Message-Id: <20261103205141.5D2D01F00919@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/proc: cast the PROCMAP_QUERY address through uintptr_t
has been added to the -mm mm-new branch.  Its filename is
     selftests-proc-cast-the-procmap_query-address-through-uintptr_t.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-proc-cast-the-procmap_query-address-through-uintptr_t.patch

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
From: Sasha Levin <sashal@kernel.org>
Subject: selftests/proc: cast the PROCMAP_QUERY address through uintptr_t
Date: Tue,  3 Nov 2026 11:39:15 -0500

proc-maps-race puts a pointer into the 64-bit query_addr field of struct
procmap_query with a plain cast, which warns on 32-bit architectures:

  proc-maps-race.c:626:24: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]

Cast through uintptr_t.

Link: https://lore.kernel.org/20261103163915.640990-1-sashal@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
---

 tools/testing/selftests/proc/proc-maps-race.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/proc/proc-maps-race.c~selftests-proc-cast-the-procmap_query-address-through-uintptr_t
+++ a/tools/testing/selftests/proc/proc-maps-race.c
@@ -623,7 +623,7 @@ static bool query_addr_at(int maps_fd, v
 	memset(&q, 0, sizeof(q));
 	q.size = sizeof(q);
 	/* Find the VMA at the split address */
-	q.query_addr = (unsigned long long)addr;
+	q.query_addr = (unsigned long long)(uintptr_t)addr;
 	q.query_flags = 0;
 	if (ioctl(maps_fd, PROCMAP_QUERY, &q))
 		return false;
_

Patches currently in -mm which might be from sashal@kernel.org are

selftests-proc-cast-the-procmap_query-address-through-uintptr_t.patch

