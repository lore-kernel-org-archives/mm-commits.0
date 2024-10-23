Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A1F78C9C
	for <mm-commits@vger.kernel.org>; Wed, 23 Oct 2024 23:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729726357; cv=none; b=C2Wnee5CO2oLguOhnn2Zu6HUAEYyi3isOPp44nxcc+QsxQ8rYLZ9xcBU5kqK/Bm4fKctWDXHAXxUbgSfy7mzgKsf7dhT0mCNAWu0TmYtloFOcdNXwIz61hhPFLf1MUwC+Vuiu+QX4xAsJhHcoZT4/2+PNXC6eSXbkGh9JtNB/aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729726357; c=relaxed/simple;
	bh=ZYzVtksRBTaKRzeggmjDYtq6Oc/9wXl77G9UGf+MdxI=;
	h=Date:To:From:Subject:Message-Id; b=XF6hh8Miklq2G8GmVKC9HuXKCIgSTPROQVO6WwgDqs4J0ydAqHlrdY4jWwr9LtrxmBjbyyZ305lex/MtsdFg9qhJ8xhFTep+DVQC21F/cm9kddah/8IFHjVWiNU09Ui1SV/Ob41O6kQYmY0AdLWhy9Vr0Yb1P3e6CD65mao3ovw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Mn+R337h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Mn+R337h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF9EDC4CEC6;
	Wed, 23 Oct 2024 23:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729726357;
	bh=ZYzVtksRBTaKRzeggmjDYtq6Oc/9wXl77G9UGf+MdxI=;
	h=Date:To:From:Subject:From;
	b=Mn+R337hzcbGaK8O66I+eEWFJKKnONl4oW0QGPueL1zoRX5dB1qNDYvGfCY4sB8oJ
	 9qfRUbnhGPNac0V3TiBUPBjmVjw4yLqccYgkTGznKBF3JXrSlYTmZnHHK6NeRLKFPk
	 aGZhWJEjd9dDG1IdIuX1yzm7TM4p9I52L0Oxp9NY=
Date: Wed, 23 Oct 2024 16:32:36 -0700
To: mm-commits@vger.kernel.org,yang.lee@linux.alibaba.com,hbathini@linux.ibm.com,david@redhat.com,bhe@redhat.com,liad.per@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + makefile-remove-unused-filechk_cat.patch added to mm-nonmm-unstable branch
Message-Id: <20241023233236.DF9EDC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Makefile: remove unused filechk_cat
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     makefile-remove-unused-filechk_cat.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/makefile-remove-unused-filechk_cat.patch

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
From: Liad Peretz <liad.per@gmail.com>
Subject: Makefile: remove unused filechk_cat
Date: Wed, 23 Oct 2024 10:06:11 +0300

Link: https://lkml.kernel.org/r/20241023070611.67449-1-liad.per@gmail.com
Signed-off-by: Liad Peretz <liad.per@gmail.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/Makefile |    2 --
 1 file changed, 2 deletions(-)

--- a/kernel/Makefile~makefile-remove-unused-filechk_cat
+++ a/kernel/Makefile
@@ -146,8 +146,6 @@ targets += config_data config_data.gz
 $(obj)/config_data.gz: $(obj)/config_data FORCE
 	$(call if_changed,gzip)
 
-filechk_cat = cat $<
-
 $(obj)/config_data: $(KCONFIG_CONFIG) FORCE
 	$(call filechk,cat)
 
_

Patches currently in -mm which might be from liad.per@gmail.com are

makefile-remove-unused-filechk_cat.patch

