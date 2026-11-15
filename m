Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794780748;
	b=Lm/T2VaJNs27qkS+2OcQfydnvU6mESxdSoYXmfZavREYdVyxPlVrOG2gEh9w/rXV//Jy
	 KKo6OoHt8IUkmEvdcsEeFBsbR8EGrm28vD3k4c5p4J74pgLEXXFY4m4dm4LFOgcpGGGDa
	 +MQEdSa43uDPt1+H7ayRwjKTBZAcNLXXC0hVhP96yAsa5gPRT+UBYoXllb/tPiRcYljTK
	 zGjJCN5xubWNBAr8JevM0r7rute83tegdc3X0XLikI9RFgFhcnneeF3KnTfFzBXlpoR68
	 daekf0WhgqrhQzpG1KTFVMDn6jTvOR2aV1jdXTNUqIeHhF6+MUJsSoMCguiiZQ6sktA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794780748;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=CCTE+Xs38HKVZWjd/woYGiujBnNobGez+Ij9lGwWl+Y=;
	b=Sh1VeP5tNLy56aGgRnUpjEcNYrxVYReuI7drCvU98+QG1kx2dh3hGBrwm9Nr5JFFPqHG
	 GKXpn/N2MJMPVrO19AGuEOCusoE6ElpVZ6PDD6gWCGOGX79vL3AhBBscKKgxKeQTDoArX
	 CrjDpPBxMx4A62Jtl16r/QJvBN58wIpMItuNrYg/b56MsiF8PH5ezMOB7uZcLrPBFHOyh
	 f4f9QPvKFHB0XVj+fpgy+96Zao7wMdw5YP8dv6yn8HcyygHUIKJT0MiaFlZJNPaZOnA4a
	 M5PZv9lTokkH7tNd1o9LV8i9sCW7KPiQlslfaNi8cY2gkIbepEnwsA5MDGlFuqF3wcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=wPUBMvDE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3439B606A32F
	for <mm-commits@vger.kernel.org>; Sun, 15 Nov 2026 22:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=wPUBMvDE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FBC91F000C4;
	Sun, 15 Nov 2026 22:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794780747;
	bh=CCTE+Xs38HKVZWjd/woYGiujBnNobGez+Ij9lGwWl+Y=;
	h=Date:To:From:Subject;
	b=wPUBMvDEOHAr+I4UPv2trJUnlCPpKGDdIxG3jmWD8HX8yl85lAV437hQsx2TQYRAM
	 qj6DsOuVo+GTxlF/hntypVOUTeQwX95CHPICwQmm5VmwqUDkWLwJzeBjXZEBtqoD6s
	 WTJhYT2kpe7PnQ0yljRK9HhmdwQ9onqfW8Wpe1K4=
Date: Sun, 15 Nov 2026 14:12:27 -0800
To: mm-commits@vger.kernel.org,vasily.averin@linux.dev,shakeel.butt@linux.dev,
	mkoutny@suse.com,mhocko@suse.com,manfred@colorfullife.com,legion@kernel.org,
	hannes@cmpxchg.org,ebiederm@xmission.com,dave@stgolabs.net,alx@kernel.org,
	x-professor@outlook.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ipc-sem-remove-obsolete-semopm-fragmentation-warning.patch added to mm-nonmm-unstable branch
Message-Id: <20261115221227.9FBC91F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ipc/sem: remove obsolete SEMOPM fragmentation warning
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ipc-sem-remove-obsolete-semopm-fragmentation-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ipc-sem-remove-obsolete-semopm-fragmentation-warning.patch

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
From: Yingjie Wang <x-professor@outlook.com>
Subject: ipc/sem: remove obsolete SEMOPM fragmentation warning
Date: Thu, 29 Oct 2026 05:03:28 +0000

The UAPI comment advises keeping SEMOPM at or below 1000 because a larger
operation array may fail due to physical memory fragmentation.

Commit e4243b8062c1 ("ipc/sem: play nicer with large nsops allocations")
changed the operation array to kvmalloc() specifically to support larger
configured limits, with vmalloc fallback when a physically contiguous
allocation is unavailable.

Replace the obsolete warning with a description of the compiled-in
default and the runtime sysctl.

Link: https://lore.kernel.org/6d795eecfd0beb666251e6bc03ef9fd135386362.1793250194.git.x-professor@outlook.com
Signed-off-by: Yingjie Wang <x-professor@outlook.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Alexey Gladkov <legion@kernel.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Vasily Averin <vasily.averin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Alejandro Colomar <alx@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>

 include/uapi/linux/sem.h |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/include/uapi/linux/sem.h~ipc-sem-remove-obsolete-semopm-fragmentation-warning
+++ a/include/uapi/linux/sem.h
@@ -71,16 +71,15 @@ struct  seminfo {
  * The values has been chosen to be larger than necessary for any
  * known configuration.
  *
- * SEMOPM should not be increased beyond 1000, otherwise there is the
- * risk that semop()/semtimedop() fails due to kernel memory fragmentation when
- * allocating the sop array.
+ * SEMOPM is the default maximum number of operations per semop() call. The
+ * runtime limit can be changed through /proc/sys/kernel/sem.
  */
 
 
 #define SEMMNI  32000           /* <= IPCMNI  max # of semaphore identifiers */
 #define SEMMSL  32000           /* <= INT_MAX max num of semaphores per id */
 #define SEMMNS  (SEMMNI*SEMMSL) /* <= INT_MAX max # of semaphores in system */
-#define SEMOPM  500	        /* <= 1 000 max num of ops per semop call */
+#define SEMOPM  500	        /* <= INT_MAX max num of ops per semop call */
 #define SEMVMX  32767           /* <= 32767 semaphore maximum value */
 #define SEMAEM  SEMVMX          /* adjust on exit max value */
 
_

Patches currently in -mm which might be from x-professor@outlook.com are

ipc-sem-account-dynamically-allocated-sops-arrays-to-memcg.patch
ipc-sem-reject-negative-semopm-values.patch
ipc-sem-remove-obsolete-semopm-fragmentation-warning.patch

