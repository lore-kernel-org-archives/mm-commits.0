Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5ADD246782
	for <mm-commits@vger.kernel.org>; Tue, 30 Dec 2025 20:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767126837; cv=none; b=Z7TSVYoDasP6xiTsTyP5G75fyI+s8Z1al+ik6BRFQLv57aWbID7pUnJph1hOEwDOwm70JFXpTkLj2xihN92J5IydzVQklf4BKrkmiunmWv8ZCf2ipqLx/iSfvAWOJ0yp0+TaT6n0alBaIVt+RHATn9gf9hP0pK/Q0994QP5DFWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767126837; c=relaxed/simple;
	bh=P6GqwN+udlmwm9M6HAxnS+KhDMSLTVClOZPP08UHr+g=;
	h=Date:To:From:Subject:Message-Id; b=BbafRfo+q9DXvVGeLKXSOvrYPcRmzkCD4aFjiutHFTGp7IOthj4xug53sbrfSomMMdPa9d5v8p6os8zxgSdbk939svjUBRN2hCODDNFRRi/ZI7MRqsEJu4jVtUnRnwmcTh66E8yw0VIpJ/Uti0zCjx0saoQhgO9uaI/M8i+v2Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xWfBHBRi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xWfBHBRi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641C9C113D0;
	Tue, 30 Dec 2025 20:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767126837;
	bh=P6GqwN+udlmwm9M6HAxnS+KhDMSLTVClOZPP08UHr+g=;
	h=Date:To:From:Subject:From;
	b=xWfBHBRijK/5v3gbbKMNLcEhrMVkTQdL0yF4o8m/6xVXYZc5VzXxa+R61PvxWR65I
	 uiH0JSyauM5luz/7kyGfxcWsdPfAVK4GzJnAIX6sMyKO0/DvfEJ6JMtKK5NIioPBz/
	 wUPHnMJBOcyBQxsVgYdyYieUby6C9JwBEUswVBVk=
Date: Tue, 30 Dec 2025 12:33:56 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,rientjes@google.com,mhocko@suse.com,kdipendra88@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] mm-oom_kill-remove-unnecessary-integer-promotion-in-format-string.patch removed from -mm tree
Message-Id: <20251230203357.641C9C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/oom_kill: remove unnecessary integer promotion in format string
has been removed from the -mm tree.  Its filename was
     mm-oom_kill-remove-unnecessary-integer-promotion-in-format-string.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Dipendra Khadka <kdipendra88@gmail.com>
Subject: mm/oom_kill: remove unnecessary integer promotion in format string
Date: Sun, 28 Dec 2025 15:44:55 +0000

The 'h' length modifier in '%hd' is unnecessary as short integers are
promoted to int in variadic functions.  Use '%d' instead.

Link: https://lkml.kernel.org/r/20251228154456.2386-1-kdipendra88@gmail.com
Signed-off-by: Dipendra Khadka <kdipendra88@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/oom_kill.c~mm-oom_kill-remove-unnecessary-integer-promotion-in-format-string
+++ a/mm/oom_kill.c
@@ -458,7 +458,7 @@ static void dump_oom_victim(struct oom_c
 
 static void dump_header(struct oom_control *oc)
 {
-	pr_warn("%s invoked oom-killer: gfp_mask=%#x(%pGg), order=%d, oom_score_adj=%hd\n",
+	pr_warn("%s invoked oom-killer: gfp_mask=%#x(%pGg), order=%d, oom_score_adj=%d\n",
 		current->comm, oc->gfp_mask, &oc->gfp_mask, oc->order,
 			current->signal->oom_score_adj);
 	if (!IS_ENABLED(CONFIG_COMPACTION) && oc->order)
@@ -958,7 +958,7 @@ static void __oom_kill_process(struct ta
 	 */
 	do_send_sig_info(SIGKILL, SEND_SIG_PRIV, victim, PIDTYPE_TGID);
 	mark_oom_victim(victim);
-	pr_err("%s: Killed process %d (%s) total-vm:%lukB, anon-rss:%lukB, file-rss:%lukB, shmem-rss:%lukB, UID:%u pgtables:%lukB oom_score_adj:%hd\n",
+	pr_err("%s: Killed process %d (%s) total-vm:%lukB, anon-rss:%lukB, file-rss:%lukB, shmem-rss:%lukB, UID:%u pgtables:%lukB oom_score_adj:%d\n",
 		message, task_pid_nr(victim), victim->comm, K(mm->total_vm),
 		K(get_mm_counter(mm, MM_ANONPAGES)),
 		K(get_mm_counter(mm, MM_FILEPAGES)),
_

Patches currently in -mm which might be from kdipendra88@gmail.com are


