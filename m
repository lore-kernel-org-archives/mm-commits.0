Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794780742;
	b=Jlnyv5Y5AXolwgY77dVOUF7AjXPEmagChKMleMK5ANCq2NGUJRipDOxBgtVZFN+ZdOms
	 nY+qWFHxV2tzJFcA8nzVJt7r44oQRDU/4mnOTcucgsdCX7LRdpvVU6HFsZG2ap+zud8ZM
	 o9wPRTHTPkuN5m8PgnTFJAIJXGi3qYguN6bYCv6CWVmC25ZNxBI/Au+a/FtTVYwsyI1us
	 n6D5hUC8n5mSE/0AY5F8WC0012N6Rl1GxSDFDxY2U/T4vUSZyE3aTPCbFmIfY25fxMGkW
	 DcQB9XabWXorBwB5YCxmwDn2M4y7Gj7GrI8wfsZqEYlF3NFWQ5g9FsFVuJeyYCCkx+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794780742;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=6fVlNmq42yEQJPqenmjOd2r5Ik3PBpzqTtDkObGh7TM=;
	b=ncGiirLmSPjF8bdgVXsFZGKYJiUIQUrC3jia9XIcxFc8IPAiacmpklNEa3PEyMEDkYy7
	 vRFx6Fop+Yq+yyZWbC22gC/xgsbf4l2Y6GzHc/t+Apc2CNFSCvh6xxPmzC4i/MmgnnOs4
	 4f/twa65UcIn5gZFD2B6v66FjcrIfarocDGFGrdsQxtCqMLeq3wJqVNBQosOYWx4ABQDR
	 jS8aXzaf+3hr7JiZSHNFFJam+aa456pGvNFoDEOK7K6ykMfS5Wi1bdDdZJSU0laIk3z9z
	 D4lCho7RP/rQMB6jVGIUF8OHVDMhzJRxfoSzTvgi9MWNMvVSbrNONziMqrevbXZyj3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=cNwfrZFK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4169F606A31F;
	Sun, 15 Nov 2026 22:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=cNwfrZFK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE771F000C5;
	Sun, 15 Nov 2026 22:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794780741;
	bh=6fVlNmq42yEQJPqenmjOd2r5Ik3PBpzqTtDkObGh7TM=;
	h=Date:To:From:Subject;
	b=cNwfrZFKBdnrGlJquGa92aU0Xh092RW0dnDIxVcubaaixSWIDZBOxP7ssu1KKXq7U
	 NPGjvNjpuveQKwmsJVfglzMT8BC7KIanRI6O4NOEixGJBjwQS2o5S4i7WwuKXotnFN
	 au+Tm8uGOko7vqY0CpAubFlvryPXBwdjLrpa3Xw0=
Date: Sun, 15 Nov 2026 14:12:21 -0800
To: mm-commits@vger.kernel.org,vasily.averin@linux.dev,stable@vger.kernel.org,
	shakeel.butt@linux.dev,mkoutny@suse.com,mhocko@suse.com,
	manfred@colorfullife.com,legion@kernel.org,hannes@cmpxchg.org,
	ebiederm@xmission.com,dave@stgolabs.net,alx@kernel.org,
	x-professor@outlook.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ipc-sem-account-dynamically-allocated-sops-arrays-to-memcg.patch added to mm-nonmm-unstable branch
Message-Id: <20261115221221.BBE771F000C5@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ipc/sem: account dynamically allocated sops arrays to memcg
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ipc-sem-account-dynamically-allocated-sops-arrays-to-memcg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ipc-sem-account-dynamically-allocated-sops-arrays-to-memcg.patch

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
Subject: ipc/sem: account dynamically allocated sops arrays to memcg
Date: Thu, 29 Oct 2026 05:03:25 +0000

Patch series "ipc/sem: account dynamic sops arrays and validate SEMOPM",
v5.

Subject: [PATCH v5 0/3] ipc/sem: account dynamic sops arrays and validate SEMOPM

An IPC namespace owner can raise SEMOPM and make semop() allocate a large
operation array.  A blocked call retains the array.  These allocations are
currently uncharged to the caller's memory cgroup, so repeated calls can
consume host memory beyond a container's limit.  In one test, a call
retained 60,936,448 bytes while a 32 MiB cgroup recorded less than 1 MiB. 
Sixteen concurrent calls retained 100,860,416 bytes while the cgroup
recorded about 1.3 MiB.

The SEMOPM sysctl also accepts negative values.  Because the operation
count is unsigned, SEMOPM=-1 becomes an effective limit of UINT_MAX. 
Separately, a rejected kernel.sem write can leave earlier fields changed:
an invalid SEMMNI can return ERANGE after setting SEMOPM to zero, causing
subsequent nonempty semop() calls in that IPC namespace to fail with
E2BIG.

Patch 1 charges dynamically allocated operation arrays in the regular
semop() path to the caller's memory cgroup.  Patch 2 parses and validates
kernel.sem writes before publishing them and serializes writers within
each IPC namespace.  Patch 3 removes the obsolete warning that SEMOPM
above 1000 risks physical memory fragmentation; the operation array uses
kvmalloc().

Accounting contains the large-array case when the caller's memory cgroup
has an effective limit.  The series does not impose a maximum on positive
SEMOPM values, so a root or unlimited cgroup can still request large
allocations.

Validation included x86-64 and i386 builds, initial and user-owned IPC
namespace checks, concurrent sysctl writes, operation-count boundaries,
and allocation cleanup on success and error paths.  In a limited memory
cgroup, accounting increased median successful-call time by 2.3% to 3.2%
for 65, 500 and 1000 operations; the allocation-focused invalid semaphore
ID case increased by 5.6% to 11.9%.


This patch (of 3):

A caller can raise SEMOPM and keep large, uncharged operation arrays alive
in blocked semop() calls.  Repeating this from a memory-limited cgroup can
exhaust host memory outside that cgroup, causing reclaim, stalls, or OOM
kills of unrelated processes.  Charging the arrays lets an effective memcg
limit contain that memory use.

Commit 6a4746ba0619 ("ipc: remove memcg accounting for sops objects in
do_semtimedop()") removed accounting based on the assumption that sops
arrays would remain small, describing a maximum cost of two pages.

SEMOPM is a UAPI default that can be changed at build time and through
the per-namespace sysctl. Commit 50ec499b9a43 ("sysctl: allow change
system v ipc sysctls inside ipc namespace") made that limit tunable by
IPC namespace owners without capabilities in the initial user namespace.

do_semtimedop() keeps up to SEMOPM_FAST operations on the stack. Charge
every larger, dynamically allocated operation array to the caller's memory
cgroup. This avoids a second size threshold and prevents a configured
SEMOPM limit from expanding an unaccounted heap-allocation range.

In a 4-vCPU KVM guest, with the benchmark pinned to one vCPU in a leaf
memory cgroup, accounting raised the median time per successful semop()
call by 2.3% to 3.2% for 65, 500 and 1000 operations, compared with
unaccounted allocation. An invalid semid, which allocates and copies the
array before returning EINVAL, rose by 5.6% to 11.9%. The 64-operation
stack path changed by at most 0.9%, and successful calls in the root
cgroup by at most 2.3%. Each result used 21 samples from three boots.

Link: https://lore.kernel.org/cover.1793250194.git.x-professor@outlook.com
Link: https://lore.kernel.org/07d9034ec1fb5b6fd5eed2cf60ef3c84d5149e51.1793250194.git.x-professor@outlook.com
Fixes: 6a4746ba0619 ("ipc: remove memcg accounting for sops objects in do_semtimedop()")
Signed-off-by: Yingjie Wang <x-professor@outlook.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Link: https://lore.kernel.org/r/20261016152609.2528805-1-x-professor@outlook.com
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Alexey Gladkov <legion@kernel.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Vasily Averin <vasily.averin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Alejandro Colomar <alx@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: <stable@vger.kernel.org>

 ipc/sem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/ipc/sem.c~ipc-sem-account-dynamically-allocated-sops-arrays-to-memcg
+++ a/ipc/sem.c
@@ -2253,7 +2253,7 @@ static long do_semtimedop(int semid, str
 		return -EINVAL;
 
 	if (nsops > SEMOPM_FAST) {
-		sops = kvmalloc_objs(*sops, nsops);
+		sops = kvmalloc_objs(*sops, nsops, GFP_KERNEL_ACCOUNT);
 		if (sops == NULL)
 			return -ENOMEM;
 	}
_

Patches currently in -mm which might be from x-professor@outlook.com are

ipc-sem-account-dynamically-allocated-sops-arrays-to-memcg.patch
ipc-sem-reject-negative-semopm-values.patch
ipc-sem-remove-obsolete-semopm-fragmentation-warning.patch

