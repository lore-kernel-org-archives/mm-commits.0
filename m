Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2D5223DE5
	for <mm-commits@vger.kernel.org>; Thu, 20 Aug 2026 02:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787193834; cv=none; b=LkxX2lrrgsI1S1r4Z01G1Iu9CRvqSA6+EOPQeQhVknpQ5eXCoVhQzLWhxaDcKJl0xxuKyw01tlst2bU9odBeWaEtLYCezeY6b+X9maPQu4/72hiFFNG823hfAu2y5kn6FvvDj1U+KBwV2vGlhXPsxgUDw6biDoiy+40WpJod+bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787193834; c=relaxed/simple;
	bh=qSJKaEqHlNqtgizc4R+FwCtAxarWHQmaTVEXnWReDvc=;
	h=Date:To:From:Subject:Message-Id; b=T2OKATCjvf/TcNxL8uY+0P7Q69rJ63+TzECsI+CaoiC9dtzF6RgRErKvcfhJvK3JyWiPW564WDBGxVGDxGI+QIz/TjZodYXx+VgDq4gHiepDDraq8893NkesBmKukEedtHnT4AZeqxbJuMykA9zXh6iVbj7qPGCVZ7tZtD//EAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=joZKLrBa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="joZKLrBa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7195D1F000E9;
	Thu, 20 Aug 2026 02:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787193832;
	bh=W8iR5IYYwDXH3YXpy11sDWWxka0sIQJhNLWNO1B2xCk=;
	h=Date:To:From:Subject;
	b=joZKLrBaz7qYreaJzP3jlQfm0gLDl6GnT5U0rBdfs7LUaoM90J0NTEyPd53tLT5Uc
	 BxSPm6TiyAlmd237EoqWwrsrvE5p/VvvcjqxdSblm73WoVGhH2Av2GRd6hCUZ3ubV/
	 Ii/Hub0/bPaNpVqsxxkwASFX42ciRWo7fas+01Lo=
Date: Wed, 19 Aug 2026 19:43:52 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,mhiramat@kernel.org,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-lance-yang-as-a-hung-task-detector-co-maintainer.patch added to mm-hotfixes-unstable branch
Message-Id: <20260820024352.7195D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add Lance Yang as a hung task detector co-maintainer
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-lance-yang-as-a-hung-task-detector-co-maintainer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-lance-yang-as-a-hung-task-detector-co-maintainer.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Lance Yang <lance.yang@linux.dev>
Subject: MAINTAINERS: add Lance Yang as a hung task detector co-maintainer
Date: Thu, 20 Aug 2026 09:45:35 +0800

I've been a hung_task reviewer for over a year now and plan to stay
involved.

Take on more responsibility for hung_task as a co-maintainer.

Link: https://lore.kernel.org/20260820014535.79105-1-lance.yang@linux.dev
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-add-lance-yang-as-a-hung-task-detector-co-maintainer
+++ a/MAINTAINERS
@@ -12140,7 +12140,7 @@ F:	drivers/tty/hvc/
 
 HUNG TASK DETECTOR
 M:	Andrew Morton <akpm@linux-foundation.org>
-R:	Lance Yang <lance.yang@linux.dev>
+M:	Lance Yang <lance.yang@linux.dev>
 R:	Masami Hiramatsu <mhiramat@kernel.org>
 R:	Petr Mladek <pmladek@suse.com>
 L:	linux-kernel@vger.kernel.org
_

Patches currently in -mm which might be from lance.yang@linux.dev are

maintainers-add-lance-yang-as-a-hung-task-detector-co-maintainer.patch

