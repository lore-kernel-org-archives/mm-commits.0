Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53645356A07
	for <mm-commits@vger.kernel.org>; Fri, 30 Jan 2026 17:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769794963; cv=none; b=qFohx2AuLFTEmV63564YBMIgBJ/a42dtJ0tCf+xES9FDaxY84BPSMTnkVTocW4WajUu+lNqtJOqaEvtgYiInHzYgwT3TtOyctgc/we5T4abEBcGd6wlmwiR5yc7thhY9W9+w1FEkgEd1OKRswgZ+iCKKT82sch+kqP1YNEaMdRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769794963; c=relaxed/simple;
	bh=QM1XlIQceJ6qW7t2ju203D1N4HxHGDT8PTdyf9Z7NAQ=;
	h=Date:To:From:Subject:Message-Id; b=XyO8qThl7X58dHrpGx6WEnkfvzpJj3U74Fq2PSN5blSSeAqDKsvGT18obXYjyhsbzflfJs7OKWZRsd2xFuU+vjhyi8uetNOHMShcD5GdQU5hooHrhH7zJCXT9f6eGWfTk89hBslvIxBcacDO2wVYwopopV1Lf6xw89uhzdplWws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dkG5NKSb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dkG5NKSb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA010C4CEF7;
	Fri, 30 Jan 2026 17:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769794962;
	bh=QM1XlIQceJ6qW7t2ju203D1N4HxHGDT8PTdyf9Z7NAQ=;
	h=Date:To:From:Subject:From;
	b=dkG5NKSbFG5bp8uPuSBubob5LEnJB6RFrDRVNZkv4MxtGi6WdByBiUA3Cf2AMlZT5
	 DOMmQOD6lyUrVy6+RGwPo6KCslTGxhryNLnKXJNLTngJSPUtU24Ism4myKvCA3WVFw
	 KVhGrGJSsFm+djfV/zvymgnZIRB4Tm0ySufOld44=
Date: Fri, 30 Jan 2026 09:42:42 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,rdunlap@infradead.org,ptyadav@amazon.de,pawan.kumar.gupta@linux.intel.com,pasha.tatashin@soleen.com,mingo@kernel.org,lirongqing@baidu.com,kees@kernel.org,fvdl@google.com,corbet@lwn.net,bp@alien8.de,arnd@arndb.de,me@linux.beauty,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-document-liveupdate-cmdline-parameter.patch added to mm-hotfixes-unstable branch
Message-Id: <20260130174242.CA010C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation: document liveupdate cmdline parameter
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     documentation-document-liveupdate-cmdline-parameter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-document-liveupdate-cmdline-parameter.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Li Chen <me@linux.beauty>
Subject: Documentation: document liveupdate cmdline parameter
Date: Fri, 30 Jan 2026 19:20:33 +0800

liveupdate is used to enable Live Update Orchestrator (LUO) early during
boot.  Add it to kernel-parameters.txt so users can discover and use it.

Link: https://lkml.kernel.org/r/20260130112036.359806-1-me@linux.beauty
Signed-off-by: Li Chen <me@linux.beauty>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <kees@kernel.org>
Cc: Li RongQing <lirongqing@baidu.com>
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Pratyush Yadav <ptyadav@amazon.de>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    5 +++++
 1 file changed, 5 insertions(+)

--- a/Documentation/admin-guide/kernel-parameters.txt~documentation-document-liveupdate-cmdline-parameter
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -3472,6 +3472,11 @@ Kernel parameters
 			If there are multiple matching configurations changing
 			the same attribute, the last one is used.
 
+	liveupdate=	[KNL,EARLY]
+			Format: <bool>
+			Enable Live Update Orchestrator (LUO).
+			Default: off.
+
 	load_ramdisk=	[RAM] [Deprecated]
 
 	lockd.nlm_grace_period=P  [NFS] Assign grace period.
_

Patches currently in -mm which might be from me@linux.beauty are

documentation-document-liveupdate-cmdline-parameter.patch
kexec-derive-purgatory-entry-from-symbol.patch
kexec-derive-purgatory-entry-from-symbol-v2.patch

