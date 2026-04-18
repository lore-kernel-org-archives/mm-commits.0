Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA407371CE1
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776499133; cv=none; b=SFfOZZVelRFfYNBxOzc1YY3sYZy4CEc9FgiqSPMlIklDWyY4SeW94G08O0RKAA+JfjIpZJVmHgKd69Xz26/mgSHk1050V6DG1leZZX+TflPocXXvh3jI8BiGFmnlJjJ1sJ9LlH8I4+mUUwQy6K8yyOgkqm0/U4I/j/rmjsd+kU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776499133; c=relaxed/simple;
	bh=YzV4MqaN94iyz+Czz4b+ZR5dqjnDM4PXuzDRUlkwe9s=;
	h=Date:To:From:Subject:Message-Id; b=bwZ0BvtCP643ma5DG0t61yHE8xSqbRNTrbUiHfY425wKvaZDjnaDrRSBHmZT5m0IR+0q9Vw2LsSyfdgCY/hlJ/hkSXqr39XhyeoSQu7bzYUa1KpbrgInRHt1GXSIyuyV2Gls/tdrKGeWH3JPh/fTWjIIt+/SAq2cODCay+VePc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1n5dbycK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1n5dbycK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6BF4C19424;
	Sat, 18 Apr 2026 07:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776499133;
	bh=YzV4MqaN94iyz+Czz4b+ZR5dqjnDM4PXuzDRUlkwe9s=;
	h=Date:To:From:Subject:From;
	b=1n5dbycKMmwHPiE54SFVg4kB8pYM5RaUZ4HDc20wIdmZZb3mTE/lsUyIn6F+lBR2n
	 CVhXMbuytGx8uRxIBrjtY8X4IPGlna/VcUokQGdZmwzRth4EmqpGFxPi0WBg1LSZXv
	 WIA13E3l/wCUQJbwZcdWQCHTsv+U1iAaAkjI5xP8=
Date: Sat, 18 Apr 2026 00:58:48 -0700
To: mm-commits@vger.kernel.org,yury.khrustalev@arm.com,vbabka@kernel.org,skhan@linuxfoundation.org,rdunlap@infradead.org,mark.rutland@arm.com,ljs@kernel.org,david@kernel.org,dave.hansen@linux.intel.com,corbet@lwn.net,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-proc-document-protectionkey-in-smaps.patch removed from -mm tree
Message-Id: <20260418075852.A6BF4C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs: proc: document ProtectionKey in smaps
has been removed from the -mm tree.  Its filename was
     docs-proc-document-protectionkey-in-smaps.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: docs: proc: document ProtectionKey in smaps
Date: Tue, 7 Apr 2026 13:51:33 +0100

The ProtectionKey entry was added in v4.9; back then it was x86-specific,
but it now lives in generic code and applies to all architectures
supporting pkeys (currently x86, power, arm64).

Time to document it: add a paragraph to proc.rst about the ProtectionKey
entry.

[akpm@linux-foundation.org: s/system/hardware/, per review discussion]
[akpm@linux-foundation.org: s/hardware/CPU/]
Link: https://lore.kernel.org/20260407125133.564182-1-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Reported-by: Yury Khrustalev <yury.khrustalev@arm.com>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    4 ++++
 1 file changed, 4 insertions(+)

--- a/Documentation/filesystems/proc.rst~docs-proc-document-protectionkey-in-smaps
+++ a/Documentation/filesystems/proc.rst
@@ -549,6 +549,10 @@ does not take into account swapped out p
 naturally aligned THP pages of any currently enabled size. 1 if true, 0
 otherwise.
 
+If both the kernel and the CPU support protection keys (pkeys),
+"ProtectionKey" indicates the memory protection key associated with the
+virtual memory area.
+
 "VmFlags" field deserves a separate description. This member represents the
 kernel flags associated with the particular virtual memory area in two letter
 encoded manner. The codes are the following:
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are


