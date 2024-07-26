Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B4428DCC
	for <mm-commits@vger.kernel.org>; Fri, 26 Jul 2024 16:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722013132; cv=none; b=sPUWO2hV6a78KI9GPnYLqTK1ag7cpbHkjDhs8byAjhU8TPPokti/9xiVUN6SWTfbGueYKnI0A8oYptUfDMXxXA94lu9CDJ/s9R4bkj9Xjx+kOawqaNiVAMucuvbwjFjsHoTXj0dfvUIUUD6mSomXVXpVVKUpgDVSdh5hPj2WyNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722013132; c=relaxed/simple;
	bh=MtvGMNMQOmKYdGSfT0Dy1tuN0SSCrfaWxUJue3p+zrg=;
	h=Date:To:From:Subject:Message-Id; b=jpGNjWQL4Rlhn+cQEX2K5fjYEVHptLAAJ+M1HQAwnMKOHkndaKJyUQ29bpys+KpKH9DOGHWvcEUbrmlzZEU/E0A711y6HOUrfyEWZZn8ZLz2JJ8Ql/z4nK3zQtHEp/GFairn51W9GH0xTIiCt1NERgktSve4jJhBRwhQSS/FSVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bGmOdCBl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bGmOdCBl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2804C32782;
	Fri, 26 Jul 2024 16:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722013132;
	bh=MtvGMNMQOmKYdGSfT0Dy1tuN0SSCrfaWxUJue3p+zrg=;
	h=Date:To:From:Subject:From;
	b=bGmOdCBlkazK77DF+IoLhwfdHCX/YkKpqNwCeEYuzNL/gbnPdP1JkaNyjM93R/U94
	 x+ji4lzJZrcupTEwmmG1mhacrrNTRLXSD+5VzNZTcFGsJG31inWWy4EW6KiZm1z6Qb
	 751BFVWY9mYkeIThaqUvLGmaR2bd+OG+3qLDmZUI=
Date: Fri, 26 Jul 2024 09:58:51 -0700
To: mm-commits@vger.kernel.org,yangx.jy@fujitsu.com,xuyang2018.jy@fujitsu.com,liwang@redhat.com,jstancek@redhat.com,chrubis@suse.cz,pvorel@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-ltp-members-and-web.patch added to mm-hotfixes-unstable branch
Message-Id: <20240726165851.E2804C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: Update LTP members and web
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-update-ltp-members-and-web.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-update-ltp-members-and-web.patch

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
From: Petr Vorel <pvorel@suse.cz>
Subject: MAINTAINERS: Update LTP members and web
Date: Fri, 26 Jul 2024 09:20:09 +0200

LTP project uses now readthedocs.org instance instead of GitHub wiki.

LTP maintainers are listed in alphabetical order.

Link: https://lkml.kernel.org/r/20240726072009.1021599-1-pvorel@suse.cz
Signed-off-by: Petr Vorel <pvorel@suse.cz>
Reviewed-by: Li Wang <liwang@redhat.com>
Reviewed-by: Cyril Hrubis <chrubis@suse.cz>
Cc: Jan Stancek <jstancek@redhat.com>
Cc: Xiao Yang <yangx.jy@fujitsu.com>
Cc: Yang Xu <xuyang2018.jy@fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-update-ltp-members-and-web
+++ a/MAINTAINERS
@@ -13322,14 +13322,16 @@ F:	Documentation/devicetree/bindings/i2c
 F:	drivers/i2c/muxes/i2c-mux-ltc4306.c
 
 LTP (Linux Test Project)
+M:	Andrea Cervesato <andrea.cervesato@suse.com>
 M:	Cyril Hrubis <chrubis@suse.cz>
 M:	Jan Stancek <jstancek@redhat.com>
 M:	Petr Vorel <pvorel@suse.cz>
 M:	Li Wang <liwang@redhat.com>
 M:	Yang Xu <xuyang2018.jy@fujitsu.com>
+M:	Xiao Yang <yangx.jy@fujitsu.com>
 L:	ltp@lists.linux.it (subscribers-only)
 S:	Maintained
-W:	http://linux-test-project.github.io/
+W:	https://linux-test-project.readthedocs.io/
 T:	git https://github.com/linux-test-project/ltp.git
 
 LTR390 AMBIENT/UV LIGHT SENSOR DRIVER
_

Patches currently in -mm which might be from pvorel@suse.cz are

maintainers-update-ltp-members-and-web.patch

