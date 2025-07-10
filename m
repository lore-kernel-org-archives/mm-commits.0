Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4D72836A0;
	Thu, 10 Jul 2025 04:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752120548; cv=none; b=GZ2UNsnWs7JSpmhsEYZnX6u3wRi3Trho7yVqqASvX03RIZ4WdTcLrUwj/+KmkGKmSw0FeOkt68px5JdxURTYXWqsx7nrGZcJy9qOfb084VODAluIcAACmpeCldVlQMSxkR3br07RgvzncoBsfoRAQyOKyRRzgQP0Zeaefe5wrP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752120548; c=relaxed/simple;
	bh=uLX7lC4/ue0H3nznYLFArzgpueaOoYMFS+iSEBseBSg=;
	h=Date:To:From:Subject:Message-Id; b=lfHYWJQyX5QgjmUBZNrd9+Y8oH/mHzh6SmS8hzR8RSC4gckD3R0e6Lpse8tPMehk2+2O96KytMtd4W98nGaqB3Yk9Y9X9J0iAEJKXsi3ZlbVRfJIgB6LEaBggnx6mKNWS2mh3g4hA8WnSMtokjkO1fJrs7wIxxNf4h/r01abahU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0BJsgS56; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0BJsgS56"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6350C4CEE3;
	Thu, 10 Jul 2025 04:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752120547;
	bh=uLX7lC4/ue0H3nznYLFArzgpueaOoYMFS+iSEBseBSg=;
	h=Date:To:From:Subject:From;
	b=0BJsgS56Cadceya4ZBwr5OHKetwVFdm87xJH27jQrvglElf9yoP8Y3RCk5YkiP3GS
	 QmGNCM+FPyf13ES+pS+hgL5AcbNZVjjZQVXuO36aqRqvbmL9RorbIM3iK2iqCBHc+F
	 kmqOMCgacl2GDYKKoLWFAYbZPLpVQq14Ojb9DXaI=
Date: Wed, 09 Jul 2025 21:09:07 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kbingham@kernel.org,jan.kiszka@siemens.com,florian.fainelli@broadcom.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] scripts-gdb-de-reference-per-cpu-mce-interrupts.patch removed from -mm tree
Message-Id: <20250710040907.A6350C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/gdb: de-reference per-CPU MCE interrupts
has been removed from the -mm tree.  Its filename was
     scripts-gdb-de-reference-per-cpu-mce-interrupts.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: <stable@vger.kernel.org>
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


