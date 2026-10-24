Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832510;
	b=uYpnXGaG0NNTiBRe0Qy89LrCl1uEzwExDDvzwZO+4xeuEicRjKGZim/ssxVYKDG6cQZO
	 kLhen944PAB1kjS0IQ4NoxNnOsjr1/vL+jPWabPkhjUOwPbJUhqcaM7pg4nHyy3NgvY/N
	 uxtIed1WKzagNq3/cVDzdJRNMtUKPeaFU+ZH/MxdxdfrKBnQv3cYDrf2u9T8+512ZBd92
	 sokXzAKJWaB/dJjOouN+Y5o3d62QLCJm9ISQBENyMCncVZ9IDlTzb/+nI/TsUkfEO9ENE
	 r3O2nqHX6yQ8P1dXxgoJ6IB/zGtOkUzyMn5FG+G+xYEEI5+NsRjSkm7ZagwEO0543Pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832510;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=+3qLI0JlZOFrPS3R3sQt7cKGacFLUmrNj/sFKXleqc8=;
	b=Xsqu/fVgnwet6vhuDM7cuka1CbKw2UthJRHVxYNBryuoSk3ueDI89TOCeohSinWp1iQd
	 0Uar5FbOB3Ehm4GgnuQITQSWQllSBxL1FDz2zmXK9a8Jaw/xahJaX9Pcxe3H4JZkSx8pL
	 tJrQLnqCIFn3BW0rGybqA47kuCBqzbtZismWPsYShK6qst00OVjDCUqiYN9+9wgw2dNO4
	 LC6TUGvjkwkWBlxCgwC5AJuSHwoKc9hPqAio5h86YNKuZnTPgG/T55Hr3p3apn3+fsqOY
	 A4iUIU+8AhpyzPLep+Vqc1AdCTEm4t1VmKO2+5+vZW1QWj7fK+ttYi3bwWAmtKo6I0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GqegRfMQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F9B606A322
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=GqegRfMQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC3E1F01829;
	Sat, 24 Oct 2026 09:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832510;
	bh=+3qLI0JlZOFrPS3R3sQt7cKGacFLUmrNj/sFKXleqc8=;
	h=Date:To:From:Subject;
	b=GqegRfMQmcBE9b4RNvWVngybx4AOimSjfjQxEdWUEj386akEUgcMOM9tbXGLwHlsE
	 CA4q75vV7h4l+CqiUA8ekPVRQEYLtAEXJWiVS7QDCLT4dScbAMao4+mMvtstfceNQ1
	 cevQhcPyEzVkScEEI/7VTnTFr69SanSO9PPreY2k=
Date: Sat, 24 Oct 2026 02:01:49 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,skhan@linuxfoundation.org,sj@kernel.org,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,vbabka@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-exclude-damon-docs-from-memory-management-misc.patch removed from -mm tree
Message-Id: <20261024090150.5BC3E1F01829@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: MAINTAINERS: exclude DAMON docs from MEMORY MANAGEMENT - MISC
has been removed from the -mm tree.  Its filename was
     maintainers-exclude-damon-docs-from-memory-management-misc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: MAINTAINERS: exclude DAMON docs from MEMORY MANAGEMENT - MISC
Date: Thu, 15 Oct 2026 18:31:46 +0200

MEMORY MANAGEMENT - MISC is a list of misc mm sources and also acts as
catch-all for the mm Documentation subdirectories. Documentation for
DAMON is well maintained within its own subsystem and also actively
updated, so there's no need to Cc all MISC maintainers for them as well.
Thus add exclusion entries for them.

Link: https://lore.kernel.org/20261015-maint-mm-core-x-doc-damon-v1-1-226decb5cd0d@kernel.org
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: SJ Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-exclude-damon-docs-from-memory-management-misc
+++ a/MAINTAINERS
@@ -17273,6 +17273,8 @@ F:	Documentation/admin-guide/mm/
 F:	Documentation/core-api/memory-allocation.rst
 F:	Documentation/core-api/mm-api.rst
 F:	Documentation/mm/
+X:	Documentation/admin-guide/mm/damon/
+X:	Documentation/mm/damon/
 F:	mm/char-mem.c
 F:	include/linux/cma.h
 F:	include/linux/dmapool.h
_

Patches currently in -mm which might be from vbabka@kernel.org are


