Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6365633F38B
	for <mm-commits@vger.kernel.org>; Tue,  7 Apr 2026 20:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775595431; cv=none; b=ucT5eWihJnIHX/p52p7PvuxdtoJAPFmcg0h+mF2tRHqPFBfbJTacBsvJHApmtqxSyGz3gI5+64ERgEx1g2uiQ0gu5wzukfJi3xajaMsyumIRnuHXLnpBwvzsw8R8eBu5vRunaSHoU7Dx/zVqAtTTAW2zFTj+D7wd0xkn0tHpql4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775595431; c=relaxed/simple;
	bh=CfGcDRdvyHFukjkoU2pOu3extp00gSerwCGYBCHbrMo=;
	h=Date:To:From:Subject:Message-Id; b=GnXj1iMo4Tcm5CdEuMWSIoIiz6r4j0OT14KerQxSpGfvMQKQGtpOfyCjic38skSRfuk5TetpeljKP3Pn49zMkCet6U74UX+VPglZkde96fnAqIFM03lTZqN6Yom/adHSZ8yEmZC1MYfHnMb3VAx3zPrqwoRThUUcbvNUGrgtdD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Lv0YyomB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Lv0YyomB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F37D4C116C6;
	Tue,  7 Apr 2026 20:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775595431;
	bh=CfGcDRdvyHFukjkoU2pOu3extp00gSerwCGYBCHbrMo=;
	h=Date:To:From:Subject:From;
	b=Lv0YyomBUg6+Yqbbr6lXtzVCUWYjMhbQeoWSBPfRNTYztVM4rKH/d60YCJa1OUEsA
	 OC2ch0GeyKeW0dMEF+0IOcqrKX+xVdKQcKFwlO4296bAXNaLDtmNucnLHTNqfzxq2W
	 nUipgD5VVwea7UV0Grf5V8w4vs9Loi8CcpSuMFCo=
Date: Tue, 07 Apr 2026 13:57:10 -0700
To: mm-commits@vger.kernel.org,yury.khrustalev@arm.com,vbabka@kernel.org,skhan@linuxfoundation.org,rdunlap@infradead.org,mark.rutland@arm.com,ljs@kernel.org,kevin.brodsky@arm.com,david@kernel.org,dave.hansen@linux.intel.com,corbet@lwn.net,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-proc-document-protectionkey-in-smaps-fix.patch added to mm-unstable branch
Message-Id: <20260407205710.F37D4C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs-proc-document-protectionkey-in-smaps-fix
has been added to the -mm mm-unstable branch.  Its filename is
     docs-proc-document-protectionkey-in-smaps-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-proc-document-protectionkey-in-smaps-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: docs-proc-document-protectionkey-in-smaps-fix
Date: Tue Apr  7 01:55:57 PM PDT 2026

s/system/hardware/, per review discussion

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

--- a/Documentation/filesystems/proc.rst~docs-proc-document-protectionkey-in-smaps-fix
+++ a/Documentation/filesystems/proc.rst
@@ -549,7 +549,7 @@ does not take into account swapped out p
 naturally aligned THP pages of any currently enabled size. 1 if true, 0
 otherwise.
 
-If both the kernel and the system support protection keys (pkeys),
+If both the kernel and the hardware support protection keys (pkeys),
 "ProtectionKey" indicates the memory protection key associated with the
 virtual memory area.
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

docs-proc-document-protectionkey-in-smaps-fix.patch

