Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C169045942
	for <mm-commits@vger.kernel.org>; Mon,  4 Mar 2024 17:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709573852; cv=none; b=SqGvSodXvZImiKqOejLT4Kct+EaXpw1flw+R17Vo022UKKi7f6l3UmVxrR0Hu6mrpNFXgFCmHRzCUohj+1T0hUK1QoGkXUImxbuMm5wdHY1EBRT55o4hHg2C0YDOR79VfxWC3V08axUP+AYizFgZg0RtEMSIL31tWNmgU+hDqLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709573852; c=relaxed/simple;
	bh=vLn1IxLPaWTg3nReqeXEcTjZ6/P20gId4/K4sZHBpuQ=;
	h=Date:To:From:Subject:Message-Id; b=kMgPBGvaM/0bUFpDfQv4I3h9dbFKfSSxdXVvUHesEqyLNaCyDy0ewsjimiq05AXih44S6qhzGsN9NXos7sY63xK78RnLBLUpIu9dRz7Y0Tkuq5LsOvIgEM3RRfGLP1vwfhTT8r+k6RbyGw2A7CLfwJ0NhnP8wBkHjS+/jyenqcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cbBgPTiC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cbBgPTiC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FAD4C433C7;
	Mon,  4 Mar 2024 17:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709573852;
	bh=vLn1IxLPaWTg3nReqeXEcTjZ6/P20gId4/K4sZHBpuQ=;
	h=Date:To:From:Subject:From;
	b=cbBgPTiCytZpU92+/kI/kpwsvpzuuRtar5smruwpI0NJBvGfusBzv12MdhUpfVY2G
	 Cm8pDWadLRRnqygUOIl1beRAhF5e4xeDwy9h7aSEsdGu/vi5QDeXImK65dxHsjuhOF
	 tupmKTLF2SjpPArI5tjABvRyQCGYcQYsyWjN7Tag=
Date: Mon, 04 Mar 2024 09:37:31 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,p.raghav@samsung.com,mcgrof@kernel.org,Kuan-Ying.Lee@mediatek.com,koudai@google.com,kbingham@kernel.org,jan.kiszka@siemens.com,andrewjballance@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-symbols-fix-invalid-escape-sequence-warning.patch added to mm-hotfixes-unstable branch
Message-Id: <20240304173732.2FAD4C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/gdb/symbols: fix invalid escape sequence warning
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     scripts-gdb-symbols-fix-invalid-escape-sequence-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-symbols-fix-invalid-escape-sequence-warning.patch

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
From: Andrew Ballance <andrewjballance@gmail.com>
Subject: scripts/gdb/symbols: fix invalid escape sequence warning
Date: Sun, 3 Mar 2024 19:25:07 -0600

With python 3.12, '\.' results in this warning
    SyntaxWarning: invalid escape sequence '\.'

Link: https://lkml.kernel.org/r/20240304012507.240380-1-andrewjballance@gmail.com
Signed-off-by: Andrew Ballance <andrewjballance@gmail.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Koudai Iwahori <koudai@google.com>
Cc: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/symbols.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/gdb/linux/symbols.py~scripts-gdb-symbols-fix-invalid-escape-sequence-warning
+++ a/scripts/gdb/linux/symbols.py
@@ -82,7 +82,7 @@ lx-symbols command."""
         self.module_files_updated = True
 
     def _get_module_file(self, module_name):
-        module_pattern = ".*/{0}\.ko(?:.debug)?$".format(
+        module_pattern = r".*/{0}\.ko(?:.debug)?$".format(
             module_name.replace("_", r"[_\-]"))
         for name in self.module_files:
             if re.match(module_pattern, name) and os.path.exists(name):
_

Patches currently in -mm which might be from andrewjballance@gmail.com are

scripts-gdb-symbols-fix-invalid-escape-sequence-warning.patch

