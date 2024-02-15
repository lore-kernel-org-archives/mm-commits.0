Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF90A3D6D
	for <mm-commits@vger.kernel.org>; Thu, 15 Feb 2024 19:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708024306; cv=none; b=Hv7Ay2dLqmGiSKgEtO7hLF+rul2Qfnbpig+oBB3tVGGDtV2DCz1OEGZHojnqRyZesl7b874zmf0l7Ob3WjOFYIl40AucmVj2qXvaOSz+Ij/Ekm6IpuHNL47OpK2UpHyL/EBeBg8qTN0gxO9wgWcrhjbhIsfzeUX5FlzcxEuKXiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708024306; c=relaxed/simple;
	bh=I+KK4trdOfNtw8vJFUpxZ2YeTn0wZQipu2qbMSA6Gh8=;
	h=Date:To:From:Subject:Message-Id; b=eEYSJAQDGTsXhhFrmJGxG4aQT1qm0WIFwK8MPCI8UeaICxdmBlT4VikY4ZildNDbJag1eONY7+8cx9oFZvdSNkO0cxj2Pht4W+0XBOdzx0byn1VcMgs4yxIy0xElQVHPvXhiX02yMgYauWz4C/5LqJqhk2DLatnYIzsB23li0xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rP/aopT3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rP/aopT3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B128C433C7;
	Thu, 15 Feb 2024 19:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708024306;
	bh=I+KK4trdOfNtw8vJFUpxZ2YeTn0wZQipu2qbMSA6Gh8=;
	h=Date:To:From:Subject:From;
	b=rP/aopT3J7eWJqsIXNEJcoHcvyMNorhF59kR0tJdj5wi1ZR+OmbWvbMErSXbbZ20M
	 muMolAH1T/YWiQQnL6iO9C+Rx0doX+FCSbSDBIgOi3yzJJu+wpcPlx48yTK0ghVzEc
	 /+DNkXualTvCJkqqcWkCpjnVeOiFQkb2JcWC/nSU=
Date: Thu, 15 Feb 2024 11:11:45 -0800
To: mm-commits@vger.kernel.org,hannes@cmpxchg.org,colin.i.king@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-clarify-swapaccount=0-deprecation-warning-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20240215191146.0B128C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: Fix spelling mistake "commdandline" -> "commandline"
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memcontrol-clarify-swapaccount=0-deprecation-warning-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-clarify-swapaccount=0-deprecation-warning-fix.patch

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
From: Colin Ian King <colin.i.king@gmail.com>
Subject: mm: Fix spelling mistake "commdandline" -> "commandline"
Date: Thu, 15 Feb 2024 09:05:44 +0000

There is a spelling mistake in a pr_warn_once message. Fix it.

Link: https://lkml.kernel.org/r/20240215090544.1649201-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrol-clarify-swapaccount=0-deprecation-warning-fix
+++ a/mm/memcontrol.c
@@ -7974,7 +7974,7 @@ static int __init setup_swap_account(cha
 	bool res;
 
 	if (!kstrtobool(s, &res) && !res)
-		pr_warn_once("The swapaccount=0 commdandline option is deprecated "
+		pr_warn_once("The swapaccount=0 commandline option is deprecated "
 			     "in favor of configuring swap control via cgroupfs. "
 			     "Please report your usecase to linux-mm@kvack.org if you "
 			     "depend on this functionality.\n");
_

Patches currently in -mm which might be from colin.i.king@gmail.com are

mm-memcontrol-clarify-swapaccount=0-deprecation-warning-fix.patch

