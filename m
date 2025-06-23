Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAA7223DE1;
	Mon, 23 Jun 2025 21:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715729; cv=none; b=PxfJd8oC5DcLSYmovuzA4Rz45soAJC7ILyCFbOFL7RSeKcUaVR8wZTnEpBUYN9PsA2Cocuk7tJfHfIZcAiIGqQcahfoa8V+k5yimFfHGkASmdKqrytbTDwpZGf3YxfUYe9ftV0hHcwWhrCpaEoTocXWnf/7x24QtT8EQXU8ltkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715729; c=relaxed/simple;
	bh=xdzu341h8GkT4jxEg5OWLElkfaUlrG4GSd3PwlLkfxA=;
	h=Date:To:From:Subject:Message-Id; b=gxMltuHT84/d85aTB1oQgJgWdf4BJS5n5qYh111uQz7dvGB0KF5rwYNkNvFX1EO7VhQwJGpt8+/1SSq5yqyhmSCyyVnKK/SlC0BNsTwTHfC/eOLmcteMakTP9reHggQGKf85Q8zt6UNkDFnttUCzM6vEDYlwbreGvyTVr9M1mgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J8FvuXuM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J8FvuXuM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5998C4CEEA;
	Mon, 23 Jun 2025 21:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750715728;
	bh=xdzu341h8GkT4jxEg5OWLElkfaUlrG4GSd3PwlLkfxA=;
	h=Date:To:From:Subject:From;
	b=J8FvuXuMNPLgXdU0A56K29KWk4Jkv+z4RwPl6pg3huLIvvVbHRuKm1CFqxbGKGhZy
	 sWHyccnfMk752GztmbzGodiCCtQeG0SVFDQieUyH6ZBMesSBpTmmwziEuSArrjjMhv
	 iirI7lKO2blTh3FtrP+lu0RArhsG/yatwVq04xhk=
Date: Mon, 23 Jun 2025 14:55:28 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kbingham@kernel.org,jan.kiszka@siemens.com,florian.fainelli@broadcom.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-fix-interrupts-display-after-mcp-on-x86.patch added to mm-hotfixes-unstable branch
Message-Id: <20250623215528.D5998C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/gdb: fix interrupts display after MCP on x86
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     scripts-gdb-fix-interrupts-display-after-mcp-on-x86.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-fix-interrupts-display-after-mcp-on-x86.patch

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

scripts-gdb-fix-dentry_name-lookup.patch
scripts-gdb-fix-interrupts-display-after-mcp-on-x86.patch

