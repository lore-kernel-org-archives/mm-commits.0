Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C1435337A;
	Tue, 19 Aug 2025 23:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755646588; cv=none; b=EMMVNk4hp8OrY5oZypiesn/CxYqaNFRZnsN7R423CWLyd91eJEMvZyPWGrGaoPSEv+NMjr6qIsYNdAGNNy5LOeBb+zCeRYpRrQe8vWfYkSDrIyejyAxcYBZku7+2ySky8LdFstxhNqEQk/dID8PanxkfSG/yyjIhpzr9xjf4KdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755646588; c=relaxed/simple;
	bh=iIad4y36X7tpa0MFvZXnz6u7sPH00pRAq5+xw7mgFjU=;
	h=Date:To:From:Subject:Message-Id; b=POexw13np2BohONOdG6HAOtBcBdEtsVKdqdVIcK/84awnIoWzmM/+zWC9FR0Ne8MYjcvuyO/x97NaEjoc3IqrkgFWdlztqnM54yX+bZHyZRi3N9N6Y4dXaqX0DZGAJO0BCjJecj8hQDaHiYpQeOav9jQVVgfD5F/6vNtLkdPXMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jwAURsQ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jwAURsQ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92EB1C113CF;
	Tue, 19 Aug 2025 23:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755646587;
	bh=iIad4y36X7tpa0MFvZXnz6u7sPH00pRAq5+xw7mgFjU=;
	h=Date:To:From:Subject:From;
	b=jwAURsQ1T2zDWo56kxrerL38R5tOiBnvt1uzEpzN+wmeQBz3Iu6UATpfw0xyuKlYd
	 BvJ7J+VoNc+zGijcD4trFtQlRM3MHiqn6xNo/NMNAb2xIn1UxTReYJ56tzMBkzgUq5
	 wobFdGOydx8CsOG3XQtydEZZnoVV5j/HCTY3h0ic=
Date: Tue, 19 Aug 2025 16:36:27 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,kees@kernel.org,graf@amazon.com,ebiggers@google.com,dave@vasilevsky.ca,coxu@redhat.com,changyuanl@google.com,bhe@redhat.com,arnd@arndb.de,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kho-mm-dont-allow-deferred-struct-page-with-kho.patch removed from -mm tree
Message-Id: <20250819233627.92EB1C113CF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: mm: don't allow deferred struct page with KHO
has been removed from the -mm tree.  Its filename was
     kho-mm-dont-allow-deferred-struct-page-with-kho.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: kho: mm: don't allow deferred struct page with KHO
Date: Fri, 8 Aug 2025 20:18:03 +0000

KHO uses struct pages for the preserved memory early in boot, however,
with deferred struct page initialization, only a small portion of memory
has properly initialized struct pages.

This problem was detected where vmemmap is poisoned, and illegal flag
combinations are detected.

Don't allow them to be enabled together, and later we will have to teach
KHO to work properly with deferred struct page init kernel feature.

Link: https://lkml.kernel.org/r/20250808201804.772010-3-pasha.tatashin@soleen.com
Fixes: 4e1d010e3bda ("kexec: add config option for KHO")
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Coiby Xu <coxu@redhat.com>
Cc: Dave Vasilevsky <dave@vasilevsky.ca>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/Kconfig.kexec |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/Kconfig.kexec~kho-mm-dont-allow-deferred-struct-page-with-kho
+++ a/kernel/Kconfig.kexec
@@ -97,6 +97,7 @@ config KEXEC_JUMP
 config KEXEC_HANDOVER
 	bool "kexec handover"
 	depends on ARCH_SUPPORTS_KEXEC_HANDOVER && ARCH_SUPPORTS_KEXEC_FILE
+	depends on !DEFERRED_STRUCT_PAGE_INIT
 	select MEMBLOCK_KHO_SCRATCH
 	select KEXEC_FILE
 	select DEBUG_FS
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are


