Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A4C33F38B
	for <mm-commits@vger.kernel.org>; Tue,  7 Apr 2026 20:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775595429; cv=none; b=PoXUe9reY2lzqjwgmtKNzgrdTiI8YUE0YjwS969G/+Tf61PHHxgSiB+GMPfk+BFpboW9Jr052RqkLZw04Sh3pV6Tfmlc7WoDEelrMn9LEpErXvzyc057uLulAFtIrh74KlhkNx4QYE1OKgIrSjiMjSNEVbbyvYfnqVQVsDbosYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775595429; c=relaxed/simple;
	bh=nvdgMWp+nWoGHh4rjcNgpufzsgbXjCZ2QtsIVYiE0+Y=;
	h=Date:To:From:Subject:Message-Id; b=mMBGEib8HQHwHIgvtlDaT6xxoT6mI9e85Uui6K4cBIykzgzJf4SnJj9oLNkBlSv03qj2ImDE8LF+lwRrZMB+QeW44SbrysNv8SfEAG6Y3IL3TJdLFPGFubsu4eK//ohzadjSjBDqd8FvXPYIqxQuE5Qdw+h9kWXnZGvk2tWQkHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NrurizAd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NrurizAd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD18C116C6;
	Tue,  7 Apr 2026 20:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775595429;
	bh=nvdgMWp+nWoGHh4rjcNgpufzsgbXjCZ2QtsIVYiE0+Y=;
	h=Date:To:From:Subject:From;
	b=NrurizAdT6AF5zN9bp9IBC2QB2WXJbukjHbKINu+C6sO32ryaX4wiN4O7DvCrYY/3
	 t62oME7xiYupVHBIUmyQCPYXSOwdgJIe1X31ja3G+JyMKQ+Or8FwGy6Ma27GnE15bR
	 RtMi4Muy+02aUSIgzaIJ+MjKGkK8lwj3LhM30M30=
Date: Tue, 07 Apr 2026 13:57:08 -0700
To: mm-commits@vger.kernel.org,yury.khrustalev@arm.com,vbabka@kernel.org,skhan@linuxfoundation.org,rdunlap@infradead.org,mark.rutland@arm.com,ljs@kernel.org,david@kernel.org,dave.hansen@linux.intel.com,corbet@lwn.net,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-proc-document-protectionkey-in-smaps.patch added to mm-unstable branch
Message-Id: <20260407205708.EAD18C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs: proc: document ProtectionKey in smaps
has been added to the -mm mm-unstable branch.  Its filename is
     docs-proc-document-protectionkey-in-smaps.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-proc-document-protectionkey-in-smaps.patch

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
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: docs: proc: document ProtectionKey in smaps
Date: Tue, 7 Apr 2026 13:51:33 +0100

The ProtectionKey entry was added in v4.9; back then it was x86-specific,
but it now lives in generic code and applies to all architectures
supporting pkeys (currently x86, power, arm64).

Time to document it: add a paragraph to proc.rst about the ProtectionKey
entry.

Link: https://lkml.kernel.org/r/20260407125133.564182-1-kevin.brodsky@arm.com
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
 
+If both the kernel and the system support protection keys (pkeys),
+"ProtectionKey" indicates the memory protection key associated with the
+virtual memory area.
+
 "VmFlags" field deserves a separate description. This member represents the
 kernel flags associated with the particular virtual memory area in two letter
 encoded manner. The codes are the following:
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are

docs-proc-document-protectionkey-in-smaps.patch

