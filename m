Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793405972;
	b=s60T+Ciw+MRDk53J7EkVR6yKK2UQadF01UGOohTqvwnh2yCkyCC2cY5/rq/PJosxk46A
	 yyQgt7oFXAXKzRWgY10e2HbCfqNnzyMDloQ4srUvhsa0jh822W+lZSXL9P/4ijwp15vMq
	 R0awMZNEWgCercl1g0GKd+8uRyIdzdXBp/K9rGNI6IOKh0Nh3MXoGL1mMx8Qfj25MjZnz
	 G8yoYahbaCLlnSB+1oQTGwCmnYI0A6LLBWFDTqHk0Ko6YswZSSmoC4QJfhq85sM98NZ7X
	 ZkrtcQ9O4kS3cO9mwtwPz/zv+rVZLUcwLrl24rhhjbHEeoqD5CrJ4Yrd6SzUMifsWeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793405972;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=YXUv2WWVVOwLZXMsG5T9NonoQuwG6BuaZhQz00/r70I=;
	b=Hw2Ch+GRNJW7gTMt92OBX8FvDSxsX0Kw6n6Sqqlwc+zeN3kUWjnm7WEecqFcrrhoaNpi
	 4C92ZpQyFHUrcIpa7SrQMczLS+2ME1jvJDO2ILDmbpxuH07OBv9GjMDtdSoqiEZrGpEAo
	 5Y4+q3t4TgquFpqnhsONNxNb4lw7Cid0PzVQqg6eRNpvirJhQLwf27ihjF5sluQ7GvEg1
	 +hmk6y2NBPuP3ISN1ETgWl0d74qP4eyQBjnpRIYgwiYr5z2taOnBPfxPaZ0BfiVliWYJi
	 Z1/xJavp3GMaXtTAzseLeOc+WIoGybTBof/b/6AGC6Va8sdrfBP57QvguH0n0/MLAyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="kti/AieQ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4039F606A320
	for <mm-commits@vger.kernel.org>; Sat, 31 Oct 2026 00:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=kti/AieQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC27A1F000C1;
	Sat, 31 Oct 2026 00:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793405971;
	bh=YXUv2WWVVOwLZXMsG5T9NonoQuwG6BuaZhQz00/r70I=;
	h=Date:To:From:Subject;
	b=kti/AieQPDxOaTKqiZrYgpw83znI7PjX54NTFNqjLWjsLyojwdy+rzHE9iiRndgyl
	 wQEvC1DaToGPwTcW1CSjoEPAf87Pk2LLWlNfmiu+07PjuzEEpsyaV6Pgo9XMVoGaEh
	 tfSy4ETDe9BBs6x+KqJhPjRedZiXWr4hwypfBgpQ=
Date: Fri, 30 Oct 2026 17:19:31 -0700
To: mm-commits@vger.kernel.org,rafael@kernel.org,pavel@kernel.org,
	lenb@kernel.org,glider@google.com,elver@google.com,dvyukov@google.com,
	david@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hibernation-ensure-secretmem-pages-dont-reach-a-snapshot.patch added to mm-nonmm-unstable branch
Message-Id: <20261031001931.CC27A1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: hibernation: ensure secretmem pages don't reach a snapshot
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     hibernation-ensure-secretmem-pages-dont-reach-a-snapshot.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hibernation-ensure-secretmem-pages-dont-reach-a-snapshot.patch

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: hibernation: ensure secretmem pages don't reach a snapshot
Date: Sat, 26 Sep 2026 12:26:31 +0300

hibernation_available() checks for active secretmem users, but a secretmem
file can be created after this check and its pages may get into the
hibernation snapshot although they should not.

Recheck that hibernation_available() after userspace is frozen and abort
hibernation if it is not.

Link: https://lore.kernel.org/20260926-hibernation-v2-2-235f69f3ab2a@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Rafael J. Wysocki <rafael@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Pavel Machek <pavel@kernel.org>
---

 kernel/power/hibernate.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/power/hibernate.c~hibernation-ensure-secretmem-pages-dont-reach-a-snapshot
+++ a/kernel/power/hibernate.c
@@ -427,6 +427,11 @@ int hibernation_snapshot(int platform_mo
 	if (error)
 		goto Cleanup;
 
+	if (!hibernation_available()) {
+		error = -EBUSY;
+		goto Thaw;
+	}
+
 	if (hibernation_test(TEST_FREEZER)) {
 
 		/*
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-cma-accept-memory-of-multi-range-cma-areas.patch
mm-cma-accept-memory-of-cma-areas-reserved-at-a-fixed-address.patch
hibernation-make-swsusp_page-helpers-static.patch
hibernation-ensure-secretmem-pages-dont-reach-a-snapshot.patch
hibernate-handle-potential-errors-in-hibernate_mapunmap_page.patch
hibernation-kfence-explicitly-map-unmap-kfence-pages.patch
hibernation-make-hibernation-unavailable-when-debug_pagealloc-is-on.patch

