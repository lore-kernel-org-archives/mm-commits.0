Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DFAE136E3F;
	Thu, 20 Nov 2025 00:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763599833; cv=none; b=VWEMJoKiLLKqivJKQlGd3fzpL4stk0mL/OoBd889yC+4bVSjFA5MybLWJ679jp0qrpao7Fny3/Edq1XephjQIjEVNYHRJoozrv9dojCexAMgvII3ormIFu5zBLOys2KJTx7rKOhlSYGhz5k2Rh6ZucVnvgbbsU3goRWxxVbXwYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763599833; c=relaxed/simple;
	bh=lXRXJlvVqgIXdaPCnQBIW5mBZezdkXEccYsE3MSM1g4=;
	h=Date:To:From:Subject:Message-Id; b=QiMeEFsJrrxgOjt6nLm0B/l10j7IEJ1imb6AyB43UMhmOVzFfKM7mEGUVKe6CaU/EuatnKZMiuUhkQwQHoDAxUc5Xprm2jMvC6GQ2sChkuCFrfEZ8416Gl1T0GdRm5TV8peU0fWe3BzRIlMzP6OZ+u+7BLEc6vkVBRv4l5vr820=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wuGsV9EC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wuGsV9EC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D2D8C4CEF5;
	Thu, 20 Nov 2025 00:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763599832;
	bh=lXRXJlvVqgIXdaPCnQBIW5mBZezdkXEccYsE3MSM1g4=;
	h=Date:To:From:Subject:From;
	b=wuGsV9ECVKAeHpc2ElSZDyliIU+JFShh0MJSHi0RDU/6O4qha1MKO41UV0dQyh63R
	 6ZUw+Kq9oxpcv1O2zaYiZ8E4JcQoQl/Erbfafreq2kj+e8ol2pxnGzFs7KYsOGsAgL
	 d76S6wWspmJ1Sa4BqXzCqY61dMzMvAdzzs2FcE5c=
Date: Wed, 19 Nov 2025 16:50:31 -0800
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,vbabka@suse.cz,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,mhocko@suse.com,mgorman@suse.de,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,legion@kernel.org,kees@kernel.org,juri.lelli@redhat.com,ebiederm@xmission.com,dietmar.eggemann@arm.com,bsegall@google.com,brauner@kernel.org,ptikhomirov@virtuozzo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] unshare-fix-nsproxy-leak-on-set_cred_ucounts-error-path.patch removed from -mm tree
Message-Id: <20251120005032.7D2D8C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: unshare: fix nsproxy leak on set_cred_ucounts() error path
has been removed from the -mm tree.  Its filename was
     unshare-fix-nsproxy-leak-on-set_cred_ucounts-error-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Subject: unshare: fix nsproxy leak on set_cred_ucounts() error path
Date: Tue, 18 Nov 2025 14:45:50 +0800

If unshare_nsproxy_namespaces() successfully creates the new_nsproxy, but
then set_cred_ucounts() fails, on its error path there is no cleanup for
new_nsproxy, so it is leaked.  Let's fix that by freeing new_nsproxy if
it's not NULL on this error path.

Link: https://lkml.kernel.org/r/20251118064552.936962-1-ptikhomirov@virtuozzo.com
Fixes: 905ae01c4ae2 ("Add a reference to ucounts for each cred")
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
Cc: Christian Brauner <brauner@kernel.org>
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


