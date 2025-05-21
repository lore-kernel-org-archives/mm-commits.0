Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CEE02B9A9
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 22:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747866804; cv=none; b=qK+bLkuV0SXCYRMrRnyjYe6oEr2HHtyM+7W2e8dkS+hYtc732WkXkVhbrBU8x/fOAOefso85eTsd8JyncXPUC8DOPzfSbdF8YXHUI+aWsdXrD+OrS+Wj4iGEqdqpn2Lg4tBhMXeHKz9l40EPA4lahLW6dPG/QYb9myx7rUc89i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747866804; c=relaxed/simple;
	bh=4mBIeZryVV3in7JVOXiHe3O+pwUh2uy4iDJF/oWwl2I=;
	h=Date:To:From:Subject:Message-Id; b=Mp/ilVuDX41sVfjoNTH0lB2HTUmLIPpO67eWtRlJXaNEd7yxqd8iErtNS7R3utFMYz55fTxxvkHc+MdnKY55UO1CtTxvSf07DmtNs7pncTU19b7kEUc/MI4P6BX7W7G+o39xMpsaJmfiXbb2ZvZbK6kYFGu/XaLWMkdOpXvU6kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iRbrylzO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iRbrylzO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB254C4CEEA;
	Wed, 21 May 2025 22:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747866803;
	bh=4mBIeZryVV3in7JVOXiHe3O+pwUh2uy4iDJF/oWwl2I=;
	h=Date:To:From:Subject:From;
	b=iRbrylzOQ4UGeio+zv76fXfxd/t7Ny+ag+Cz/iak2JYsKRujABhGmADRMe5Jma04d
	 rjUFXwpdVlvbcRkoUcEysydfymOCdTaNKIUVSTXGRPyfrKyqmqMK50is5M4rUVCNzA
	 nALME+qEUrJIuCHtp4cGXBdU348+MLH1Tp4oyPws=
Date: Wed, 21 May 2025 15:33:23 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-kconfig-enable-config_damon-by-default.patch added to mm-unstable branch
Message-Id: <20250521223323.DB254C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/Kconfig: enable CONFIG_DAMON by default
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-kconfig-enable-config_damon-by-default.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-kconfig-enable-config_damon-by-default.patch

This patch will later appear in the mm-unstable branch at
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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/Kconfig: enable CONFIG_DAMON by default
Date: Tue, 20 May 2025 21:27:55 -0700

As of this writing, multiple major distros including Alma, Amazon,
Android, CentOS, Debian, Fedora, and Oracle are build-enabling DAMON (set
CONFIG_DAMON[1]).  Enabling it by default will save configuration setup
time for the current and future DAMON users.

Build-enabling DAMON does not introduce a real risk since it makes no
behavioral change by default.  It requires explicit user requests to do
anything.  Only one potential risk is making the size of the kernel a
little bit larger.  On a production-purpose configuration, it increases
the resulting kernel package size by about 0.1 % of the final package
file.  I believe that's too small to be a real problem in common setups.

Hence, the benefit of enabling CONFIG_DAMON outweighs the potential risk. 
Set CONFIG_DAMON by default.

Link: https://oracle.github.io/kconfigs/?config=UTS_RELEASE&config=DAMON [1]
Link: https://lkml.kernel.org/r/20250521042755.39653-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/Kconfig~mm-damon-kconfig-enable-config_damon-by-default
+++ a/mm/damon/Kconfig
@@ -4,6 +4,7 @@ menu "Data Access Monitoring"
 
 config DAMON
 	bool "DAMON: Data Access Monitoring Framework"
+	default y
 	help
 	  This builds a framework that allows kernel subsystems to monitor
 	  access frequency of each memory region. The information can be useful
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-kconfig-set-damon_vaddrpaddrsysfs-default-to-damon.patch
mm-damon-kconfig-enable-config_damon-by-default.patch

