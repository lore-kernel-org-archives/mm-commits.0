Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA5030CD87;
	Tue, 18 Nov 2025 22:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763504719; cv=none; b=pZdc13TJuamMmRF1tGY/2r9kjBaqMNGbI5yheE4POr/wxmQbw0oZia0NQTp+MgwLAfBhY6+Ihk+Jx9HbnV+dr+KKj3NZn8vpTm0DVlgSPRjHuJZ0WFJ0Y9nJmsBfXxN34fKtrFojs/9V6v8zK31UTWPat2griHCKWwRoptfvzx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763504719; c=relaxed/simple;
	bh=JBOjChhPpJP0JYhmtDX7Zol/35ckh2/tfHgUEtmgvMc=;
	h=Date:To:From:Subject:Message-Id; b=s++e1XrO42wbxLjenpEnuw5D5zklcpt/GjGyavXdy+HF579SAsRxrfyt3QTC2a1fm5PfE4Wo8nQftsBSmCMrkNl3AwctqRQfm37GC6bV1bzIfFb6Cq6h8j6YTr8lN7li0qo1Xh2cDrbMV++vaX/UYUIsLuVYx3JKuPcl/z9FvPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F1LBk+OG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F1LBk+OG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 715ABC2BCB1;
	Tue, 18 Nov 2025 22:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763504718;
	bh=JBOjChhPpJP0JYhmtDX7Zol/35ckh2/tfHgUEtmgvMc=;
	h=Date:To:From:Subject:From;
	b=F1LBk+OG7YdURtyON+ux5+Bg4tYxNWvxKE8SlJnf7YYhaSdOiGQsnRB/pJyeS+dWG
	 9qlMR5heG/OVDqy+5zII5AwxNOxx7WsD8GE2bK0AX3AXVwQkoJFTz1m4JmROLr3/7z
	 QLdXbtN+HRPdJytwuh9eppSYGYt4a75spq1Q7f9I=
Date: Tue, 18 Nov 2025 14:25:16 -0800
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,vbabka@suse.cz,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,legion@kernel.org,kees@kernel.org,juri.lelli@redhat.com,ebiederm@xmission.com,dietmar.eggemann@arm.com,bsegall@google.com,ptikhomirov@virtuozzo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + unshare-fix-nsproxy-leak-on-set_cred_ucounts-error-path.patch added to mm-nonmm-unstable branch
Message-Id: <20251118222518.715ABC2BCB1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: unshare: fix nsproxy leak on set_cred_ucounts() error path
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     unshare-fix-nsproxy-leak-on-set_cred_ucounts-error-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/unshare-fix-nsproxy-leak-on-set_cred_ucounts-error-path.patch

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
From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Subject: unshare: fix nsproxy leak on set_cred_ucounts() error path
Date: Tue, 18 Nov 2025 14:45:50 +0800

If unshare_nsproxy_namespaces() successfully creates the new_nsproxy, but
then set_cred_ucounts() fails, on its error path there is no cleanup for
new_nsproxy, so it is leaked.  Let's fix that by freeing new_nsproxy if
it's not NULL on this error path.

Link: https://lkml.kernel.org/r/20251118064552.936962-1-ptikhomirov@virtuozzo.com
Fixes: 905ae01c4ae2a ("Add a reference to ucounts for each cred")
Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Acked-by: Alexey Gladkov <legion@kernel.org>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Ben Segall <bsegall@google.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mel Gorman <mgorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/fork.c~unshare-fix-nsproxy-leak-on-set_cred_ucounts-error-path
+++ a/kernel/fork.c
@@ -3133,8 +3133,11 @@ int ksys_unshare(unsigned long unshare_f
 
 	if (new_cred) {
 		err = set_cred_ucounts(new_cred);
-		if (err)
+		if (err) {
+			if (new_nsproxy)
+				free_nsproxy(new_nsproxy);
 			goto bad_unshare_cleanup_cred;
+		}
 	}
 
 	if (new_fs || new_fd || do_sysvsem || new_cred || new_nsproxy) {
_

Patches currently in -mm which might be from ptikhomirov@virtuozzo.com are

unshare-fix-nsproxy-leak-on-set_cred_ucounts-error-path.patch

