Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE711E52D
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 18:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742237922; cv=none; b=RjICso2K0LjfQHuNcmShXLS/enc21mTlLQgXHz7DCQwvdD+xWflhwxhf2BF/M5kenKc6EOaUdPgpwl47BeXM1szFDEwVieOoWIn4bPvvcIX1YdkkmNvpiIV/fy6xKOm7yD/bY4SRVRU6KvM47y9Yh5nIVfw2L41Mmc5I+0oG3HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742237922; c=relaxed/simple;
	bh=UhCcHCWRhv6FPl9Btd7KS3+Zv1/2YxKNy/Tx5N7BWtg=;
	h=Date:To:From:Subject:Message-Id; b=AVak1vDTgKYWqoPq5PbmKR1Zf2+4pqC9ALjg1U0G6zLXIEIaG874sDw70koXyMzFmiLxRd0CSmShoM+y6nR3f6mAnc2lSI2mQJG999XZYORn/AJ3X74rO+3eTcxRaZThR2URrKwm9Agxo0r77mCA7enHB9ODtq/qWgHupiRyf38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UecGXIxH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UecGXIxH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8B6C4CEE3;
	Mon, 17 Mar 2025 18:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742237921;
	bh=UhCcHCWRhv6FPl9Btd7KS3+Zv1/2YxKNy/Tx5N7BWtg=;
	h=Date:To:From:Subject:From;
	b=UecGXIxHoLVD0vT7Z/LHpCjERTpJ5XlZ9l+bxsGuQx24NtO5vSx7tgAI/Z2YC1FKK
	 JDTEQpksIyxwV91WPXPOYFVshHGJaWLe5UOHf1RNrEJDf2IjDyN5BOs8HkuEspT376
	 D2+c5UQj4M88hkVL3GwnHNfPkHSaA/R/CaX4kcgM=
Date: Mon, 17 Mar 2025 11:58:41 -0700
To: mm-commits@vger.kernel.org,ilpo.jarvinen@linux.intel.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + resource-replace-open-coded-variants-of-define_res__named.patch added to mm-nonmm-unstable branch
Message-Id: <20250317185841.9C8B6C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: resource: replace open coded variants of DEFINE_RES_*_NAMED()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     resource-replace-open-coded-variants-of-define_res__named.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/resource-replace-open-coded-variants-of-define_res__named.patch

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
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: resource: replace open coded variants of DEFINE_RES_*_NAMED()
Date: Mon, 17 Mar 2025 20:11:12 +0200

Replace open coded variants of DEFINE_RES_*_NAMED().

Link: https://lkml.kernel.org/r/20250317181412.1560630-4-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/kernel/resource.c~resource-replace-open-coded-variants-of-define_res__named
+++ a/kernel/resource.c
@@ -1714,18 +1714,13 @@ static int __init reserve_setup(char *st
 			 * I/O port space; otherwise assume it's memory.
 			 */
 			if (io_start < 0x10000) {
-				res->flags = IORESOURCE_IO;
+				*res = DEFINE_RES_IO_NAMED(io_start, io_num, "reserved");
 				parent = &ioport_resource;
 			} else {
-				res->flags = IORESOURCE_MEM;
+				*res = DEFINE_RES_MEM_NAMED(io_start, io_num, "reserved");
 				parent = &iomem_resource;
 			}
-			res->name = "reserved";
-			res->start = io_start;
-			res->end = io_start + io_num - 1;
 			res->flags |= IORESOURCE_BUSY;
-			res->desc = IORES_DESC_NONE;
-			res->child = NULL;
 			if (request_resource(parent, res) == 0)
 				reserved = x+1;
 		}
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

resource-split-define_res_named_desc-out-of-define_res_named.patch
resource-replace-open-coded-variant-of-define_res_named_desc.patch
resource-replace-open-coded-variants-of-define_res__named.patch
resource-replace-open-coded-variant-of-define_res.patch

