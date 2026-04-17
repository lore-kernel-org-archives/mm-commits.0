Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4D03264D0
	for <mm-commits@vger.kernel.org>; Fri, 17 Apr 2026 05:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776405170; cv=none; b=V2Z8OcWFR/eMBBDDyeIzGmu4rQuLzyve/5s+Wc3twm7DMRNH6xDCQyTT75Y0x3F7qBT7LGDVUZ1EHSZf6ds/axurz+sj40EMdKMYp7NejKFcFfZeoiYRvOGTYtDoFF20bICh4jL6j554C8ZweG8DsJcbsx37NOervrC8JBdk2IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776405170; c=relaxed/simple;
	bh=oZ0dDIRszqzBG6hbYFRJ0gmdQ151huDVwBVC+lN9ZO8=;
	h=Date:To:From:Subject:Message-Id; b=STsz1MQIFhQiJW8FMxXawb65pH2v4Jr9aZMH4VOCUVPCE9f+rkeiPA39PFfYg5VjgsuqYdPLRHz6qDD5X4JnIu8Acd8bn9ngktP/c9tENWdM23If24j/RPKZCyBAEdya1qELlPC6b4essRfc5UF7FphpteExWScOayQKotLxA58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zMtLpAvE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zMtLpAvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0ADC19425;
	Fri, 17 Apr 2026 05:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776405169;
	bh=oZ0dDIRszqzBG6hbYFRJ0gmdQ151huDVwBVC+lN9ZO8=;
	h=Date:To:From:Subject:From;
	b=zMtLpAvECVJoN5P1UjtB6LMeexBaZDCj8wXofQ5IQ74DtMvj7HhJbsd3RxDy39/F0
	 OM8GISLhf36yuuSVv8MNqkbJC/EKId9aoqPsGf8arb7hvTZn+CpbwcRKJqkmtYNv4k
	 xSWmwwZirym0sVHYn8MLmMKKu37S2WL6oOFGDygc=
Date: Thu, 16 Apr 2026 22:52:46 -0700
To: mm-commits@vger.kernel.org,yury.khrustalev@arm.com,vbabka@kernel.org,skhan@linuxfoundation.org,rdunlap@infradead.org,mark.rutland@arm.com,ljs@kernel.org,kevin.brodsky@arm.com,david@kernel.org,dave.hansen@linux.intel.com,corbet@lwn.net,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] docs-proc-document-protectionkey-in-smaps-fix-fix.patch removed from -mm tree
Message-Id: <20260417055249.3E0ADC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs-proc-document-protectionkey-in-smaps-fix-fix
has been removed from the -mm tree.  Its filename was
     docs-proc-document-protectionkey-in-smaps-fix-fix.patch

This patch was dropped because it was folded into docs-proc-document-protectionkey-in-smaps.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: docs-proc-document-protectionkey-in-smaps-fix-fix
Date: Wed Apr  8 08:06:49 AM PDT 2026

s/hardware/CPU/

Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Yury Khrustalev <yury.khrustalev@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/filesystems/proc.rst~docs-proc-document-protectionkey-in-smaps-fix-fix
+++ a/Documentation/filesystems/proc.rst
@@ -549,7 +549,7 @@ does not take into account swapped out p
 naturally aligned THP pages of any currently enabled size. 1 if true, 0
 otherwise.
 
-If both the kernel and the hardware support protection keys (pkeys),
+If both the kernel and the CPU support protection keys (pkeys),
 "ProtectionKey" indicates the memory protection key associated with the
 virtual memory area.
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

docs-proc-document-protectionkey-in-smaps.patch
maintainers-add-page-cache-reviewer-fix.patch

