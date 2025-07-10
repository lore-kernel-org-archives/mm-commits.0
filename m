Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6E21A285;
	Thu, 10 Jul 2025 04:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752120543; cv=none; b=DSZJ8a5MeUZpnQNxRfxecaYhNjsdlDkb9nxP7AHzXcdt0uJMizcwWVSIjasjWOrbfNiEEEHHfGUDlTJgY55WkEz4TGkaRKj5peOBMHRshAmEEBLOYvsUA5p4xXrURlmr61e7Awf4dHEssi2MIlcQqiNUh294u85MNh3wXPjyH20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752120543; c=relaxed/simple;
	bh=BxFYviZ7q/DtDjC0z8zhZVdnb5NKLsH7FwBz2glSSWI=;
	h=Date:To:From:Subject:Message-Id; b=Su6v7IivSMRn4+4rfmOAmS6RYO/BC7M27ZNS1Dy1dywWL6S4W9D0NNJU6EhdLKAFyfRG7aDYeYOC9M64yE8IcoLTJjxFLvRP3/E3WD/a9QZTnSf2eGuyOy/L1/b7Ghsc3c3nNw2gto/jl5pwAfn107N0y50dSGXJhgAW2CuLL0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wwKvATkN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wwKvATkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 692ACC4CEE3;
	Thu, 10 Jul 2025 04:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752120542;
	bh=BxFYviZ7q/DtDjC0z8zhZVdnb5NKLsH7FwBz2glSSWI=;
	h=Date:To:From:Subject:From;
	b=wwKvATkNo1OyVlwC+L69XwqP+t0KSECfNJMH+M4Fout9aPSQH+1PG+dpVC5p/qJ1P
	 RcpJTK35XZlUx6pAHfMw5D8AGQD6GLznLi7szUtVyRr93IjtfaT6SFXkguY1ZTSh1C
	 yzCO5/PO8ozNT4oJTHRF23SQG5NdcpKVWZaM56+E=
Date: Wed, 09 Jul 2025 21:09:01 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kbingham@kernel.org,jan.kiszka@siemens.com,florian.fainelli@broadcom.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] scripts-gdb-fix-interrupts-display-after-mcp-on-x86.patch removed from -mm tree
Message-Id: <20250710040902.692ACC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/gdb: fix interrupts display after MCP on x86
has been removed from the -mm tree.  Its filename was
     scripts-gdb-fix-interrupts-display-after-mcp-on-x86.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Florian Fainelli <florian.fainelli@broadcom.com>
Subject: scripts/gdb: fix interrupts display after MCP on x86
Date: Mon, 23 Jun 2025 09:41:52 -0700

The text line would not be appended to as it should have, it should have
been a '+=' but ended up being a '==', fix that.

Link: https://lkml.kernel.org/r/20250623164153.746359-1-florian.fainelli@broadcom.com
Fixes: b0969d7687a7 ("scripts/gdb: print interrupts")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/interrupts.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/gdb/linux/interrupts.py~scripts-gdb-fix-interrupts-display-after-mcp-on-x86
+++ a/scripts/gdb/linux/interrupts.py
@@ -142,7 +142,7 @@ def x86_show_interupts(prec):
 
     if constants.LX_CONFIG_X86_MCE:
         text += x86_show_mce(prec, "&mce_exception_count", "MCE", "Machine check exceptions")
-        text == x86_show_mce(prec, "&mce_poll_count", "MCP", "Machine check polls")
+        text += x86_show_mce(prec, "&mce_poll_count", "MCP", "Machine check polls")
 
     text += show_irq_err_count(prec)
 
_

Patches currently in -mm which might be from florian.fainelli@broadcom.com are


