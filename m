Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1A0146A6F
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248802; cv=none; b=W/WiOLSpLO//IYKYOuzDU8pIla/OledFCZVC2TvqwvGuGDhPDEbFCX9fAjzRLwd23mgwNlq6Nvlw6RKw0zKZJW+ElG13p0mXQJsy5xIaaY3qPMqwfhTmEc66SJsDNep/Vm4RytFub0Gg72eUZrjAWRO1cqwxu5kuy2O3MjNOvoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248802; c=relaxed/simple;
	bh=3bNe+vS/YevuR2GzHHUOuNb13psnHu2FLT37ADM8KZU=;
	h=Date:To:From:Subject:Message-Id; b=HJ8jFeKr1wAFA+adf7WvlW0J8RrYGv7/hhb2GfIIgmPjZ9ZGSIQZzeNHnBGouA4dN5nJjRk9jKPzlBrP2wmF2W7ulPqMfxtH4q1XXCNl2nDG6wem/Tbl1jRxg4o9fA8ahz5raMkIU2UELrppSSArQO+vcRmaFrDVCNXC1Zy6KJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uOKMidFy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uOKMidFy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33927C4CEC2;
	Mon,  2 Sep 2024 03:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248802;
	bh=3bNe+vS/YevuR2GzHHUOuNb13psnHu2FLT37ADM8KZU=;
	h=Date:To:From:Subject:From;
	b=uOKMidFy0MqjUaw4MC2CN0wYu7INDh/W9K26fT7LP9j3jQs4Lno8TsZpSQ8CasE8A
	 MrqPPflijodhgcMtdck7WTBlV9AhD9MT/E3ivzLa1If1ZY4lShMFEATHbgEKSWVQjH
	 JhXfv/QOHiCPE51omluiEHnahpCURnWGY528BDo4=
Date: Sun, 01 Sep 2024 20:46:41 -0700
To: mm-commits@vger.kernel.org,akinobu.mita@gmail.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] failcmd-make-failcmdsh-executable.patch removed from -mm tree
Message-Id: <20240902034642.33927C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: failcmd: make failcmd.sh executable
has been removed from the -mm tree.  Its filename was
     failcmd-make-failcmdsh-executable.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: failcmd: make failcmd.sh executable
Date: Mon, 29 Jul 2024 01:52:11 -0700

Change the file permissions of tools/testing/fault-injection/failcmd.sh to
allow execution.  This ensures the script can be run directly without
explicitly invoking a shell.

Link: https://lkml.kernel.org/r/20240729085215.3403417-1-leitao@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 0 files changed

diff --git a/tools/testing/fault-injection/failcmd.sh a/tools/testing/fault-injection/failcmd.sh
old mode 100664
new mode 100755
_

Patches currently in -mm which might be from leitao@debian.org are


