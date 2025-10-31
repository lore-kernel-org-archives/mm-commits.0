Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5FFE2D0C8B
	for <mm-commits@vger.kernel.org>; Fri, 31 Oct 2025 03:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761880379; cv=none; b=BSYCIVXMo7YjYLpnvoQZ6gDloKSvOk7Ym9JBOUhLlh9TFEPNDTtHLQ8ak9QoLbdQl0K4R6LE1F++ynZeBK5wpYgLSSA7jUY8fPPn6y91nEkTWn4J/Mw8YuPz5/OCions2vRGQAhb/+2heIf53CcICkd14ExsLlr94oNlhVt1cdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761880379; c=relaxed/simple;
	bh=VlBNtfRgTnjdC9ckmXCX3RnkHJafE9S7mJBSUpcBJig=;
	h=Date:To:From:Subject:Message-Id; b=mzgibJbvheqIzrTolT16pwRY+iB75vqkLI71kZDR1bZlOr3oKVltgcDKHy2B4wM+qrReZsW1E7E850m4RG+ncMaR320KBZP1LLAQV9bATGuP5XjElf6I833pI3f4FKyAUYSl1yQjip+aqjdodDnKC0upiIRDER8V85AB33wMJuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iYJ4/ASC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iYJ4/ASC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E71EC113D0;
	Fri, 31 Oct 2025 03:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761880379;
	bh=VlBNtfRgTnjdC9ckmXCX3RnkHJafE9S7mJBSUpcBJig=;
	h=Date:To:From:Subject:From;
	b=iYJ4/ASCPzyD9JBYzE2hmjB4WRYi/oPooo/A32tOfciliF1KysXHy1dUTVYk1HuRv
	 CpaZdXHG5pRDH7M2qPqUje9HOPxioH55m4nZ/Omq4uIBnhjEwr46ElPDGMP9ni41zg
	 Hu/5X8MBgVV4WSq3AaZhJKttlWC0xeH6TtT+WZyo=
Date: Thu, 30 Oct 2025 20:12:58 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,feng.tang@linux.alibaba.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-sys_info-deduplicate-local-variable-table-assignments.patch added to mm-nonmm-unstable branch
Message-Id: <20251031031259.1E71EC113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic: sys_info: deduplicate local variable 'table; assignments
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-sys_info-deduplicate-local-variable-table-assignments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-sys_info-deduplicate-local-variable-table-assignments.patch

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
Subject: panic: sys_info: deduplicate local variable 'table; assignments
Date: Thu, 30 Oct 2025 12:44:21 +0100

The both handlers use the local 'table' variable and assign the same data
to it, deduplicate that.

Link: https://lkml.kernel.org/r/20251030132007.3742368-6-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Feng Tang <feng.tang@linux.alibaba.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/sys_info.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/lib/sys_info.c~panic-sys_info-deduplicate-local-variable-table-assignments
+++ a/lib/sys_info.c
@@ -63,12 +63,13 @@ int sysctl_sys_info_handler(const struct
 	if (!names)
 		return -ENOMEM;
 
+	table = *ro_table;
+	table.data = names;
+	table.maxlen = maxlen;
+
 	if (write) {
 		int ret;
 
-		table = *ro_table;
-		table.data = names;
-		table.maxlen = maxlen;
 		ret = proc_dostring(&table, write, buffer, lenp, ppos);
 		if (ret)
 			return ret;
@@ -93,9 +94,6 @@ int sysctl_sys_info_handler(const struct
 			}
 		}
 
-		table = *ro_table;
-		table.data = names;
-		table.maxlen = maxlen;
 		return proc_dostring(&table, write, buffer, lenp, ppos);
 	}
 }
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

panic-sys_info-capture-si_bits_global-before-iterating-over-it.patch
panic-sys_info-align-constant-definition-names-with-parameters.patch
panic-sys_info-replace-struct-sys_info_name-with-plain-array-of-strings.patch
panic-sys_info-rewrite-a-fix-for-a-compilation-error-make-w=1.patch
panic-sys_info-deduplicate-local-variable-table-assignments.patch
panic-sys_info-factor-out-read-and-write-handlers.patch

