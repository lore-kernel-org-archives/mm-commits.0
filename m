Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6153428C2B1
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 21:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752184389; cv=none; b=G/YoGVofwmNUSsGXdY3l9Vw2SvSusAED8Ss/7fjGrGvwYHeXNg2Ghgfz91RkogThe50/DD+CbWX3Sff1ojDyUd+XYZ0dAdCFvzI0tIjZpCFlcBaddvo/er5uk7jiwuCIxzdwLgUpDKwsfF/Ltc/clsHos5iySid+vPlzKoxLTeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752184389; c=relaxed/simple;
	bh=MM+kYk7enBf3Jf2Lu9jrou6B9NcVMqAQsb1dgVr3Sj0=;
	h=Date:To:From:Subject:Message-Id; b=b8xFLi9nTxgz9pu1DRxbWIs40K3NkFThjkyEwC25+wjqyQwaVQJdxLKsqJdtDbF5yAoll54jxDWsjlxCYlpfrP/aAF8n+jameciEO2BQVvk1XuzZ5DYEX0QB5eu+fc5yfn4TTWQWtWfz7RSjVWIWiv/Swjb+Sum1JuwDn/voUVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UoPmHXe4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UoPmHXe4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6344C4CEE3;
	Thu, 10 Jul 2025 21:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752184388;
	bh=MM+kYk7enBf3Jf2Lu9jrou6B9NcVMqAQsb1dgVr3Sj0=;
	h=Date:To:From:Subject:From;
	b=UoPmHXe4yq+iXX07b4N8qXwkuoR3iq+UtzDrNIx372ZVqimaE18J+MPTfOUsit76n
	 Q1oQz+05MxdfXV//73B1ylzUWAYi3v1NlJzliCjpwI1LpcusMTe5PaxfZRM4SKqzum
	 11TG/nIF/6CmUT022Tlv4YkgUTKsCelZqD5vBoaU=
Date: Thu, 10 Jul 2025 14:53:08 -0700
To: mm-commits@vger.kernel.org,mario.limonciello@amd.com,dyoung@redhat.com,dwmw2@infradead.org,bhe@redhat.com,rafael.j.wysocki@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec_core-fix-error-code-path-in-the-kexec_jump-flow.patch added to mm-hotfixes-unstable branch
Message-Id: <20250710215308.C6344C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec_core: fix error code path in the KEXEC_JUMP flow
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kexec_core-fix-error-code-path-in-the-kexec_jump-flow.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec_core-fix-error-code-path-in-the-kexec_jump-flow.patch

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
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: kexec_core: fix error code path in the KEXEC_JUMP flow
Date: Thu, 10 Jul 2025 15:10:41 +0200

If dpm_suspend_start() fails, dpm_resume_end() must be called to recover
devices whose suspend callbacks have been called, but this does not happen
in the KEXEC_JUMP flow's error path due to a confused goto target label.

Address this by using the correct target label in the goto statement in
question.

Link: https://lkml.kernel.org/r/2396879.ElGaqSPkdT@rjwysocki.net
Fixes: 2965faa5e03d ("kexec: split kexec_load syscall from kexec core code")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/kexec_core.c~kexec_core-fix-error-code-path-in-the-kexec_jump-flow
+++ a/kernel/kexec_core.c
@@ -1080,7 +1080,7 @@ int kernel_kexec(void)
 		console_suspend_all();
 		error = dpm_suspend_start(PMSG_FREEZE);
 		if (error)
-			goto Resume_console;
+			goto Resume_devices;
 		/*
 		 * dpm_suspend_end() must be called after dpm_suspend_start()
 		 * to complete the transition, like in the hibernation flows
_

Patches currently in -mm which might be from rafael.j.wysocki@intel.com are

kexec_core-fix-error-code-path-in-the-kexec_jump-flow.patch

