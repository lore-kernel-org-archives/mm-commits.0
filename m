Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699F8219E0
	for <mm-commits@vger.kernel.org>; Tue, 24 Jun 2025 23:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750809235; cv=none; b=hKA7vkdtBhVIEXqRy268NHye4ASx/jSF0m5JrANXE5DwinaCSJsUGLT7OhZKlAGR0K/xmcvfpQC7kSCaiXNRdQVlqe5vop9qTFCobCar0cAszKEusCAGeO2+UYFedi410/YeqemGBQ8ePDREuJLcn97xxyEip8XuVA5AirpvNis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750809235; c=relaxed/simple;
	bh=EiJ8mOCJzG5Ui0FXtArMeRjUqdx5ehhQf2yJUJz/Ua0=;
	h=Date:To:From:Subject:Message-Id; b=owg0ibY8k3EhUbYYb1ho7QWRlifgy+xxcjZD0D6C0tesYbbuDY8Uq5KT17LwK+eG3aY8Dx7tVDw2Zm7946Xqn0pQwIMQSnMyquScuIqNFxm2zuMaDrXrk5u6abompCuRKjSBKx5xeM4f6FVspb51tywy36DHlVThFB1nPyZa6E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h3WEGwob; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h3WEGwob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A3BEC4CEF0;
	Tue, 24 Jun 2025 23:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750809235;
	bh=EiJ8mOCJzG5Ui0FXtArMeRjUqdx5ehhQf2yJUJz/Ua0=;
	h=Date:To:From:Subject:From;
	b=h3WEGwob45rletHNY/yTU6bFCl1LwhKM804uquyQbHwFZzvWI0E3tKlv8D1w9jzXs
	 y/D+5TR6Kcz6Js5djtAwrjy/pgZ0cHaetKpWL/WjWaTZj11DnyqRt978jQweLEWF5H
	 4o0l6LzqMt0Q1+vJjrxU69JpjtGuXptm1dmBith4=
Date: Tue, 24 Jun 2025 16:53:54 -0700
To: mm-commits@vger.kernel.org,kbingham@kernel.org,jan.kiszka@siemens.com,florian.fainelli@broadcom.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-de-reference-per-cpu-mce-interrupts.patch added to mm-hotfixes-unstable branch
Message-Id: <20250624235355.3A3BEC4CEF0@smtp.kernel.org>
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
de-referenced before printing.

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

