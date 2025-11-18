Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807A331ED71
	for <mm-commits@vger.kernel.org>; Tue, 18 Nov 2025 17:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763486667; cv=none; b=fJ/yVp7EX0BoWHDja9R0x7Qmtk1Mhh0RAWyVdlsDx3MBixcl5ZMhR2huEAWvKT+l9db7DPjawKPwUq7yinO6ma7tfMWpUM1Qy85z/SdxKvIZKJEwosgrT4P3PHU5O6SdPjB8FrMxiWdW7wXKS/yfuWoTD9W+AmGXzqU42CeFlvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763486667; c=relaxed/simple;
	bh=iD3iUPtBTG2mATfoqnLhzlxgg2wNn8X5oTTsycFj8XM=;
	h=Date:To:From:Subject:Message-Id; b=Qt+31/DLeyFPTw89I6Wwjb12+Kp6MMrLb8Uempb0jQQNelUamNdSqTMwd3EiwTPpsuNkhXwKVwP2yRq7xUjJd57F+pIcQybFTrpb2SbsNK3Aaf9A+TxSSH6zriRyZY7NsvE7qLlw36yi66ynU6WPAy7R7S7oLljqHUBV1FXUO0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k8CftbhE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k8CftbhE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3115C4AF0B;
	Tue, 18 Nov 2025 17:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763486667;
	bh=iD3iUPtBTG2mATfoqnLhzlxgg2wNn8X5oTTsycFj8XM=;
	h=Date:To:From:Subject:From;
	b=k8CftbhEuo6PPiAamipZlcAQR4319qPOfDmGAymK6Va83FgF8OWIXKFSu4ukjHPe8
	 r9aZm6AanxC91NcD94GbXuU1L4YD+LhmTzsdWU3sENZOpWRg1I4AcfHeCrxc6/y6Vh
	 ltWIai5ZNkYS14F+iR0HYjwedOtZdbzhe7s0NuV8=
Date: Tue, 18 Nov 2025 09:24:25 -0800
To: mm-commits@vger.kernel.org,andriy.shevchenko@intel.com,409411716@gms.tku.edu.tw,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-base64-optimize-base64_decode-with-reverse-lookup-tables-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20251118172426.D3115C4AF0B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib-base64-optimize-base64_decode-with-reverse-lookup-tables-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-base64-optimize-base64_decode-with-reverse-lookup-tables-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-base64-optimize-base64_decode-with-reverse-lookup-tables-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-base64-optimize-base64_decode-with-reverse-lookup-tables-fix
Date: Tue Nov 18 09:22:32 AM PST 2025

fix kernedoc

Reported-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Closes: https://lkml.kernel.org/r/aRxMtmatG7wbqJKL@black.igk.intel.com
Cc: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/base64.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/lib/base64.c~lib-base64-optimize-base64_decode-with-reverse-lookup-tables-fix
+++ a/lib/base64.c
@@ -21,7 +21,7 @@ static const char base64_tables[][65] =
 	[BASE64_IMAP] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+,",
 };
 
-/**
+/*
  * Initialize the base64 reverse mapping for a single character
  * This macro maps a character to its corresponding base64 value,
  * returning -1 if the character is invalid.
@@ -33,7 +33,8 @@ static const char base64_tables[][65] =
 		: (v) >= 'a' && (v) <= 'z' ? (v) - 'a' + 26 \
 		: (v) >= '0' && (v) <= '9' ? (v) - '0' + 52 \
 		: (v) == (ch_62) ? 62 : (v) == (ch_63) ? 63 : -1
-/**
+
+/*
  * Recursive macros to generate multiple Base64 reverse mapping table entries.
  * Each macro generates a sequence of entries in the lookup table:
  * INIT_2 generates 2 entries, INIT_4 generates 4, INIT_8 generates 8, and so on up to INIT_32.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch
mm-huge_memory-introduce-enum-split_type-for-clarity-fix.patch
mm-implement-sticky-vma-flags-fix-2.patch
mm-set-the-vm_maybe_guard-flag-on-guard-region-install-fix-fix.patch
panic-sys_info-factor-out-read-and-write-handlers-checkpatch-fixes.patch
memblock-unpreserve-memory-in-case-of-error-fix.patch
lib-base64-optimize-base64_decode-with-reverse-lookup-tables-fix.patch
lib-base64-rework-encode-decode-for-speed-and-stricter-validation-fix.patch

