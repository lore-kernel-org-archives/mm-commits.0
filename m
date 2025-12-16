Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD8129BDBF
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 23:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765928851; cv=none; b=EsvsepcQMgCuUvTPIY66J/99EwgoLReKGoWw75qtC9NM9rQjs/KRRL+sU8tjpOIrvr2cL5krHPLChN8GgMAYWvY8NSDeSfbYXYO6YoS7e9P4t3QVSHbc9Pz+aH01mriB+CQM2H3f0HIrbFtNqbua0GqdT+T2N7bPIKDlVE4ljl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765928851; c=relaxed/simple;
	bh=6jAHBWd58m+t60ev+8aFBTZwIXAEwhNXj0OacPsZHpA=;
	h=Date:To:From:Subject:Message-Id; b=Kc4erZEUcOObxjw1sEaKHJw5xey3n3q8I2a41RpwiJM+/V+I5Bd3u7If52KAnTbbbimKWh20xywVdjpQPqJ7IHHeZHiC9Y6j0DMfrZbjlDK/4AaYAVM/iSS7q4yYUrPcb8F3rYUFZGaETtfBh5zbE8sNRtQ0qX6FmeQqzdV4ckU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q1ZNB8tF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q1ZNB8tF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 148B4C4CEF1;
	Tue, 16 Dec 2025 23:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765928851;
	bh=6jAHBWd58m+t60ev+8aFBTZwIXAEwhNXj0OacPsZHpA=;
	h=Date:To:From:Subject:From;
	b=Q1ZNB8tFARMNVfUJaa2vB072Z7jG8AfTnhGV2YNBItHuIYso8wcheFpQOnfzVzzKH
	 wCG+aVER9JvjQQEPMCF/aoNkFl37EHzierUtc7f/aCpq7ADIWzY2cLb6RPn9P67BhO
	 F4IZSrrUCzeCF5QjzCS28loUNr3MCnS4P4P1OEAk=
Date: Tue, 16 Dec 2025 15:47:30 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,rppt@kernel.org,mingo@kernel.org,mhiramat@kernel.org,link@vivo.com,lillian@star-ark.net,guoweikang.kernel@gmail.com,francesco@valla.it,chenhuacai@kernel.org,brauner@kernel.org,alexander.shishkin@linux.intel.com,sameekshasankpal@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + init-mark-envp_init-as-static.patch added to mm-nonmm-unstable branch
Message-Id: <20251216234731.148B4C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: init: mark envp_init as static
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     init-mark-envp_init-as-static.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-mark-envp_init-as-static.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Sameeksha Sankpal <sameekshasankpal@gmail.com>
Subject: init: mark envp_init as static
Date: Sat, 29 Nov 2025 00:46:50 +0530

Sparse reports a warning that 'envp_init' has no prior declaration:

  warning: symbol 'envp_init' was not declared. Should it be static?

The variable is only used within init/main.c and does not need external
linkage.  Mark it as static to limit its scope and fix the sparse warning.

Link: https://lkml.kernel.org/r/20251128191650.18821-1-sameekshasankpal@gmail.com
Signed-off-by: Sameeksha Sankpal <sameekshasankpal@gmail.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Francesco Valla <francesco@valla.it>
Cc: guoweikang <guoweikang.kernel@gmail.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Huan Yang <link@vivo.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Lillian Berry <lillian@star-ark.net>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/main.c~init-mark-envp_init-as-static
+++ a/init/main.c
@@ -192,7 +192,7 @@ static int __init set_reset_devices(char
 __setup("reset_devices", set_reset_devices);
 
 static const char *argv_init[MAX_INIT_ARGS+2] = { "init", NULL, };
-const char *envp_init[MAX_INIT_ENVS+2] = { "HOME=/", "TERM=linux", NULL, };
+static const char *envp_init[MAX_INIT_ENVS+2] = { "HOME=/", "TERM=linux", NULL, };
 static const char *panic_later, *panic_param;
 
 static bool __init obsolete_checksetup(char *line)
_

Patches currently in -mm which might be from sameekshasankpal@gmail.com are

init-mark-envp_init-as-static.patch

