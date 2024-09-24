Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DBF13C9D9
	for <mm-commits@vger.kernel.org>; Tue, 24 Sep 2024 22:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727216334; cv=none; b=gJMkJ9F1aNN0RALWSQ/ovelEFblmlSmNNBHGTsqq4q9XrSQ4gGGbcajTfdzyll5r65u0kr8xF5DVaofq6Zqpg597d++b6DjERdN7F9w/mmO5LcaZy2poam5Zq2GKIeCQ7UgbutNpEqCptVgVvHUndjvzkWo+n45C1wLf8WmWAbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727216334; c=relaxed/simple;
	bh=xHrkUqTwFfKDui+QPaVC3McpJk6qS8oPCtiOZDOCxws=;
	h=Date:To:From:Subject:Message-Id; b=A/VuTJWzpmHtkdZ7Y4BBbJX7pzXv+E7y5JZGafMaFeKzklZGrDPewOWfzvIbkIwKbJtYRlAgR1FsMqpyX8MBcWQpbqHIVdC4SUZtIlZyFrQJZRj6IwGxtTdFhFnBxb/sYaS11Vr1DgHtCigtdyhXaWtNwM8PloiGnbt79g+FcWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=osV+4qaF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="osV+4qaF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7F8C4CEC4;
	Tue, 24 Sep 2024 22:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727216333;
	bh=xHrkUqTwFfKDui+QPaVC3McpJk6qS8oPCtiOZDOCxws=;
	h=Date:To:From:Subject:From;
	b=osV+4qaFKdOLioASKwSYNpBVuidhmb4zAuXHiIC1J1YlF7hfxTcxrSoxMBtajopd3
	 NnKtzXJDa2ndd/o2fhewh9i/00lk3+hIi3iPvQgCJ+QSY8uptclMdTlIFasg3J2gJ/
	 bu5PdJlyMuyt9CGkPYhFiwzb2Qodo9UImGNmcUXo=
Date: Tue, 24 Sep 2024 15:18:53 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,didi.debian@cknow.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-kconfig-update-damon-doc-url.patch added to mm-hotfixes-unstable branch
Message-Id: <20240924221853.CD7F8C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/Kconfig: update DAMON doc URL
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-kconfig-update-damon-doc-url.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-kconfig-update-damon-doc-url.patch

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
From: Diederik de Haas <didi.debian@cknow.org>
Subject: mm/damon/Kconfig: update DAMON doc URL
Date: Tue, 24 Sep 2024 10:21:46 +0200

The old URL doesn't really work anymore and as the documentation has been
integrated in the main kernel documentation site, change the URL to point
to that.

Link: https://lkml.kernel.org/r/20240924082331.11499-1-didi.debian@cknow.org
Signed-off-by: Diederik de Haas <didi.debian@cknow.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/Kconfig~mm-damon-kconfig-update-damon-doc-url
+++ a/mm/damon/Kconfig
@@ -9,7 +9,7 @@ config DAMON
 	  access frequency of each memory region. The information can be useful
 	  for performance-centric DRAM level memory management.
 
-	  See https://damonitor.github.io/doc/html/latest-damon/index.html for
+	  See https://www.kernel.org/doc/html/latest/mm/damon/index.html for
 	  more information.
 
 config DAMON_KUNIT_TEST
_

Patches currently in -mm which might be from didi.debian@cknow.org are

mm-damon-kconfig-update-damon-doc-url.patch

