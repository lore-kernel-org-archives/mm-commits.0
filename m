Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFD633E354
	for <mm-commits@vger.kernel.org>; Wed, 26 Nov 2025 17:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764179015; cv=none; b=uMGjkn7GI8lpK58vroKNHLgMjmjIQKXAKdhRXcbkVsI5W6rWYRmHA+QXeycC/EoMuvMD+MYPSRc9XuLbyUAJIKtczFzqPhIeIWPC06N5ZPE9m3jptumQcQHVG2rosbI5JS3zd2ehrTRO+L+3l5KqgUS19y46UChce6FtAvNVgdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764179015; c=relaxed/simple;
	bh=liwECvWh2UMUD6E9jkfBWebpW8rK0ERu+r7sfYkuKLg=;
	h=Date:To:From:Subject:Message-Id; b=UZ589Nx5PM2eUmgdJXnhdME3uSOYVcT3kwOmowbP8QaEq1xZessx6a6XhomO2RBnS41UVI9P/p3KY24MThtbjDW+P42hrIC/sAhL84k49UthlPUMOQtZjgQZZEb6jE1CDehkgiekMmn9CGjf6mKjDyBUf+BWhlpFZX06421WTwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jd/2CDin; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jd/2CDin"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4128DC4CEF7;
	Wed, 26 Nov 2025 17:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764179015;
	bh=liwECvWh2UMUD6E9jkfBWebpW8rK0ERu+r7sfYkuKLg=;
	h=Date:To:From:Subject:From;
	b=jd/2CDinL7o/WqDvhcYRd5lBgLxM9zTajzkfaabOJT2Mndo1UimP308UnZh2MY0vT
	 HWmOTVE9FMi9SwQ4O0E0chVlXqK3fQwu2ch58pLtSLvlyx/81dSv49CLNYzHUEZDef
	 ihF7gDWuJa9VZsEANx974CV/5XRPBjkRz/Ode+g4=
Date: Wed, 26 Nov 2025 09:43:34 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,dan.carpenter@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-luo_session-add-sessions-support-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20251126174335.4128DC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: liveupdate: luo_session: fix use after free in luo_session_deserialize()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     liveupdate-luo_session-add-sessions-support-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/liveupdate-luo_session-add-sessions-support-fix.patch

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
From: Dan Carpenter <dan.carpenter@linaro.org>
Subject: liveupdate: luo_session: fix use after free in luo_session_deserialize()
Date: Wed, 26 Nov 2025 17:51:40 +0300

The debug output frees "session" but it was freed on the previous line. 
Move the free after the printk().

Link: https://lkml.kernel.org/r/c5dd637d7eed3a3be48c5e9fedb881596a3b1f5a.1764163896.git.dan.carpenter@linaro.org
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/luo_session.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/liveupdate/luo_session.c~liveupdate-luo_session-add-sessions-support-fix
+++ a/kernel/liveupdate/luo_session.c
@@ -387,9 +387,9 @@ int luo_session_deserialize(void)
 
 		err = luo_session_insert(sh, session);
 		if (err) {
-			luo_session_free(session);
 			pr_warn("Failed to insert session [%s] %pe\n",
 				session->name, ERR_PTR(err));
+			luo_session_free(session);
 			return err;
 		}
 	}
_

Patches currently in -mm which might be from dan.carpenter@linaro.org are

liveupdate-luo_session-add-sessions-support-fix.patch

