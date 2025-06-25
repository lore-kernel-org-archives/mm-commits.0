Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3413212B18
	for <mm-commits@vger.kernel.org>; Wed, 25 Jun 2025 21:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750886441; cv=none; b=YTs0SbMiHCd8ru5Vg5gy4h3cqDzHVO8dTmtJ7TpZcjcHTDi6AYix/RdS7CHVOOZx/MkDCXrTzZmJ1vpQ6QFOGrBtBE8uoZ+J3ix5g17zg39rRDczbk6mp1oJODbHgEm4ILjZJbns+BODO0N7yFT53PCUCRMWxgf/rT/x9s9p4gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750886441; c=relaxed/simple;
	bh=TYe6/We4tFNn8h+Wn8nB8rdv8+tFI8Ma9l0BeScBOj0=;
	h=Date:To:From:Subject:Message-Id; b=OVBIsrPDFVlAvAeLzBJj+RwqfcWyGKDLkDML0oSv7mMCWSQHfO0MU6Qjh0UERp1F87T86EYsBcFKQFUsHe1ALHcsmLfPkIQR6qxBV8CR+fXoQowb7Gdyo3rI236PlJXv6SeLve/nivFzaK2BMxnhh35a1o7KSFklzgmIGIxc/a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o7sBPr43; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o7sBPr43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D33C4CEEA;
	Wed, 25 Jun 2025 21:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750886441;
	bh=TYe6/We4tFNn8h+Wn8nB8rdv8+tFI8Ma9l0BeScBOj0=;
	h=Date:To:From:Subject:From;
	b=o7sBPr43jj0vfOkgUn0zIX+FIO8lGoQqNOi5M5uPHfZ7nfOjjxwwRSISJLe+dBP+z
	 FTywpHjTcB0BJK7roKGnZwpg9P6njVnwL5mobWI6tsS4mnlQcl1J1OBETQl07zCmo4
	 +f+rkKH3kMoyjpgTUOm0tMCUojVY16rnd+4X+XT4=
Date: Wed, 25 Jun 2025 14:20:40 -0700
To: mm-commits@vger.kernel.org,kbingham@kernel.org,jan.kiszka@siemens.com,florian.fainelli@broadcom.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-de-reference-per-cpu-mce-interrupts.patch added to mm-hotfixes-unstable branch
Message-Id: <20250625212041.59D33C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/gdb: de-reference per-CPU MCE interrupts
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     scripts-gdb-de-reference-per-cpu-mce-interrupts.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-de-reference-per-cpu-mce-interrupts.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Florian Fainelli <florian.fainelli@broadcom.com>
Subject: scripts/gdb: de-reference per-CPU MCE interrupts
Date: Mon, 23 Jun 2025 20:00:19 -0700

The per-CPU MCE interrupts are looked up by reference and need to be
de-referenced before printing, otherwise we print the addresses of the
variables instead of their contents:

MCE: 18379471554386948492   Machine check exceptions
MCP: 18379471554386948488   Machine check polls

The corrected output looks like this instead now:

MCE:          0   Machine check exceptions
MCP:          1   Machine check polls

Link: https://lkml.kernel.org/r/20250625021109.1057046-1-florian.fainelli@broadcom.com
Link: https://lkml.kernel.org/r/20250624030020.882472-1-florian.fainelli@broadcom.com
Fixes: b0969d7687a7 ("scripts/gdb: print interrupts")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/interrupts.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/gdb/linux/interrupts.py~scripts-gdb-de-reference-per-cpu-mce-interrupts
+++ a/scripts/gdb/linux/interrupts.py
@@ -110,7 +110,7 @@ def x86_show_mce(prec, var, pfx, desc):
     pvar = gdb.parse_and_eval(var)
     text = "%*s: " % (prec, pfx)
     for cpu in cpus.each_online_cpu():
-        text += "%10u " % (cpus.per_cpu(pvar, cpu))
+        text += "%10u " % (cpus.per_cpu(pvar, cpu).dereference())
     text += "  %s\n" % (desc)
     return text
 
_

Patches currently in -mm which might be from florian.fainelli@broadcom.com are

scripts-gdb-fix-dentry_name-lookup.patch
scripts-gdb-fix-interrupts-display-after-mcp-on-x86.patch
scripts-gdb-fix-interruptspy-after-maple-tree-conversion.patch
scripts-gdb-de-reference-per-cpu-mce-interrupts.patch

