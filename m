Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A1017583
	for <mm-commits@vger.kernel.org>; Sun, 23 Feb 2025 03:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740279633; cv=none; b=aB3jVhqLlRNrk5L6sBH9J+wb1ME8nSyN2zVSvZnhkUfAnsewcJIYfvcFIdZTj8I53XAUCOf4Mu6ccJQqaBSjYctRuks3qQFMghWZ+AtGCN9GFW9+7+M2AsRNyYK0tmOgNnG4fIDQdVnjs94jDO8TikPY472sO9kJIF6L17mrptc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740279633; c=relaxed/simple;
	bh=m71wA6JwvU77nkftmybqGeYvQK1uVcssHaRZEZDsUM4=;
	h=Date:To:From:Subject:Message-Id; b=J4Co+iB0k6RaW+pfzMhIAHCj44mvjdrF5581d80O/msy0/vQYpWumaV+VyesG0yYwTL2O25ney8iBW1Z3ct2PNH1aDvpM82QY10bK8d/TQ4/+s9uLOjcihFAhZg5DukEozPS2v/Lsx9RwkKX7/lWBgyk4avMCxxkv9rvZsRub98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GXZvI03y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GXZvI03y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FFF3C4CEE4;
	Sun, 23 Feb 2025 03:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740279632;
	bh=m71wA6JwvU77nkftmybqGeYvQK1uVcssHaRZEZDsUM4=;
	h=Date:To:From:Subject:From;
	b=GXZvI03y+MWjZF8jIingUl5Dmyz2kiDYsOwgZOenAqYHnJUmhE+ISjDyfH2fXl390
	 Db/dMqgQpUSmB6tltp3WVY/oAXzzeSZIIfvH6th3wPQoeAICI/sMlyYhxM2u9Lwdxg
	 Cwu67XVexoVmNME3b3Xifq/s1Ae8upe9NzTIlUSA=
Date: Sat, 22 Feb 2025 19:00:31 -0800
To: mm-commits@vger.kernel.org,quic_zijuhu@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + cpu-remove-needless-return-in-void-api-suspend_enable_secondary_cpus.patch added to mm-nonmm-unstable branch
Message-Id: <20250223030032.6FFF3C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: cpu: remove needless return in void API suspend_enable_secondary_cpus()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     cpu-remove-needless-return-in-void-api-suspend_enable_secondary_cpus.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cpu-remove-needless-return-in-void-api-suspend_enable_secondary_cpus.patch

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
From: Zijun Hu <quic_zijuhu@quicinc.com>
Subject: cpu: remove needless return in void API suspend_enable_secondary_cpus()
Date: Fri, 21 Feb 2025 05:02:07 -0800

Remove needless 'return' in void API suspend_enable_secondary_cpus() since
both the API and thaw_secondary_cpus() are void functions.

Link: https://lkml.kernel.org/r/20250221-rmv_return-v1-2-cc8dff275827@quicinc.com
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpu.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/cpu.h~cpu-remove-needless-return-in-void-api-suspend_enable_secondary_cpus
+++ a/include/linux/cpu.h
@@ -148,7 +148,7 @@ static inline int suspend_disable_second
 }
 static inline void suspend_enable_secondary_cpus(void)
 {
-	return thaw_secondary_cpus();
+	thaw_secondary_cpus();
 }
 
 #else /* !CONFIG_PM_SLEEP_SMP */
_

Patches currently in -mm which might be from quic_zijuhu@quicinc.com are

rhashtable-remove-needless-return-in-three-void-apis.patch
cpu-remove-needless-return-in-void-api-suspend_enable_secondary_cpus.patch
mm-mmu_gather-remove-needless-return-in-void-api-tlb_remove_page.patch

