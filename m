Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20EC8152E08
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 22:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708467444; cv=none; b=eYHvi8sIfqtO/alD4GQ5TOXzO1tdRzIeKqvHYuo8cAT7uRELi5KtgBsfQF4yN41CwY1di6b5k5sbKtjQiB6jVemZDpYKk0BdKfJzdJT7tRiV/Aqy+JhnpDuwoJtrFAcxvcUUcpbnXSkvt49wjJ12374G1zobr1fHzJgIiwehX10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708467444; c=relaxed/simple;
	bh=EBuT1e+HnrEgqgKbSyJUpbnrUoPwE4D7+LemSs/GQHU=;
	h=Date:To:From:Subject:Message-Id; b=YHZ/G2kYc7Q3AQ7/qtJ/EYm11MBEEHL764jlus5x7ZTdye7OG51CiQEmx6NaAy16dZsADjzPdoVOjgNS+Cia+UedUoStwJqElcC6oFQMVaQgoa8JMip24n/+z+ilHf3tBnAb8ymFdAv/R826hjOxtK2t6NlDpjfjDXS1zepzoWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oEydFVmi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oEydFVmi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A101AC433F1;
	Tue, 20 Feb 2024 22:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708467443;
	bh=EBuT1e+HnrEgqgKbSyJUpbnrUoPwE4D7+LemSs/GQHU=;
	h=Date:To:From:Subject:From;
	b=oEydFVmiQ8dSQpC3j+w9nQPIcDpEWO3zoXasWgGbQX4VJkNhhnNmF/44EWiku9gth
	 ogoxa3Nbxk5LSe8e0ilklXgb7q0TnO2ag1pKmSwRENXyp/8U5NyTUQO5bniUjsGyzA
	 bVR8W1RxQnn/qQcJ48kqO6mO3Sh9h5ZAEfB+xzjk=
Date: Tue, 20 Feb 2024 14:17:23 -0800
To: mm-commits@vger.kernel.org,hannes@cmpxchg.org,colin.i.king@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memcontrol-clarify-swapaccount=0-deprecation-warning-fix.patch removed from -mm tree
Message-Id: <20240220221723.A101AC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: Fix spelling mistake "commdandline" -> "commandline"
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-clarify-swapaccount=0-deprecation-warning-fix.patch

This patch was dropped because it was folded into mm-memcontrol-clarify-swapaccount=0-deprecation-warning.patch

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

mm-memcontrol-clarify-swapaccount=0-deprecation-warning.patch

