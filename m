Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666BB33C0
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293226; cv=none; b=I+9VffpUSzSiqn+iavRnE5jQfhb2vxCfN8z0XaJr3jiFvarLq0X4P8jzUzgbx0wM1LDZhrJU5xClhdqNpUyMxDJFTFmdEk2fvSbYrr6FJpw7mAdz7MgE8r48k4Ky1Kzdo/vu1u2EKepiVcKEGN+lcLkikyMaELdFto+LBCnx3d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293226; c=relaxed/simple;
	bh=B4qsdcVTrjXV1DA5tyuEv085ONkuT1Rq/2KSEQEevGk=;
	h=Date:To:From:Subject:Message-Id; b=fQkZNMQNbHMjpbxuYoRKXPvBB5nsu1xDaCc9rZn99qq+vsmJh5prcrrQYnsz1Q4NHU6qX4+4rKXl78f1pUGnj6Ct69d/P+QhqH235hjxRiGFyT4CwDNs26OMLd2dijdRLm2mNUgFqM2KREPsXWd8dxpVIch5Tbl12Q8/KzGYB8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=juBYcvAD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="juBYcvAD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B92EC32789;
	Tue, 25 Jun 2024 05:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293226;
	bh=B4qsdcVTrjXV1DA5tyuEv085ONkuT1Rq/2KSEQEevGk=;
	h=Date:To:From:Subject:From;
	b=juBYcvAD0ltcCfoxj5xKJiOJZOzyiwv29hR/Jmx0bFTWGNMwaMVaQj7y02BMaZ534
	 KLWip2Si3IavSzqzgVrCy+CR/fGVG+KhwkO3ONL8GULJryIgt+MfaJPWGBrxThPsJZ
	 xH3ny+E5wAJev4tEZ2SuEYu5+wvUM5Pzd1+tFG+4=
Date: Mon, 24 Jun 2024 22:27:05 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-dump_stack-report-process-uid-in-dump_stack_print_info.patch removed from -mm tree
Message-Id: <20240625052706.3B92EC32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/dump_stack: report process UID in dump_stack_print_info()
has been removed from the -mm tree.  Its filename was
     lib-dump_stack-report-process-uid-in-dump_stack_print_info.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: lib/dump_stack: report process UID in dump_stack_print_info()
Date: Fri, 14 Jun 2024 21:13:58 -0700

To make it easier to identify the crashing process, report effective UID
when dumping the stack.

Link: https://lkml.kernel.org/r/20240615041358.103791-1-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dump_stack.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/lib/dump_stack.c~lib-dump_stack-report-process-uid-in-dump_stack_print_info
+++ a/lib/dump_stack.c
@@ -54,8 +54,10 @@ void __init dump_stack_set_arch_desc(con
  */
 void dump_stack_print_info(const char *log_lvl)
 {
-	printk("%sCPU: %d PID: %d Comm: %.20s %s%s %s %.*s" BUILD_ID_FMT "\n",
-	       log_lvl, raw_smp_processor_id(), current->pid, current->comm,
+	printk("%sCPU: %d UID: %u PID: %d Comm: %.20s %s%s %s %.*s" BUILD_ID_FMT "\n",
+	       log_lvl, raw_smp_processor_id(),
+	       __kuid_val(current_real_cred()->euid),
+	       current->pid, current->comm,
 	       kexec_crash_loaded() ? "Kdump: loaded " : "",
 	       print_tainted(),
 	       init_utsname()->release,
_

Patches currently in -mm which might be from surenb@google.com are


