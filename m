Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F4C328B7F
	for <mm-commits@vger.kernel.org>; Mon,  3 Aug 2026 20:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785790407; cv=none; b=eNDR119pHC8ZiGLhjn4wuAF0+rgGR9A0+WOpWN0piQALFDbETFiirvmaqMgTp+QCGT5HDuCb7gbITyvQt4GSmHzdb4VE+oNLKFsZgn0Dg1z96i070OiaItwva3Jfihh7Xjh8gVWaoIfdw1IGOD3WBtiEZ71TrmQpXIQFa6mVTu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785790407; c=relaxed/simple;
	bh=/AuMLMG49KLzLu0fLSUl5kXbqiWDWa7z165w8r/xvbM=;
	h=Date:To:From:Subject:Message-Id; b=QJY+tHG71wkrSo2tYBqTLT/m3bkMXE7VLWyEFynU7WlcGJi+sH5DExrzdO5T+Au9L5FMtrnmSCHcAgZjGj19XfH41RhAgiV0/nwTrVwaoL8HAZHszhsDsVk8Ga0Lm2VMErlNoIT2rBdS8IhohdX6E2hE5kVzWf1M3gBzS91/mx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g7vRI0L6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g7vRI0L6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99CB61F000E9;
	Mon,  3 Aug 2026 20:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785790405;
	bh=4ByQzZT52mL3sheoW4OhDFkN0md1WkE4w/bdpZ79InI=;
	h=Date:To:From:Subject;
	b=g7vRI0L6V/FA/AnH5QDIkerkGJzbUSynXikIED6cGBZp3ExSUpt7kYiXkhkKQZdvl
	 gfx45+ZLlXcXW91hWfKWo9pz/ZDKe4x7aa5TN4kA/7eAC/pPf93bKC7YtuuQmyAe7R
	 2Xvyng570cutXjrQN6tFEunHdzOi0RCg1EMOsnWM=
Date: Mon, 03 Aug 2026 13:53:25 -0700
To: mm-commits@vger.kernel.org,tim.bird@sony.com,jstancek@redhat.com,chrubis@suse.cz,ben.copeland@linaro.org,anders.roxell@linaro.org,pvorel@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-irc-and-patchwork-for-ltp.patch added to mm-unstable branch
Message-Id: <20260803205325.99CB61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add IRC and patchwork for LTP
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-add-irc-and-patchwork-for-ltp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-irc-and-patchwork-for-ltp.patch

This patch will later appear in the mm-unstable branch at
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
From: Petr Vorel <pvorel@suse.cz>
Subject: MAINTAINERS: add IRC and patchwork for LTP
Date: Mon, 3 Aug 2026 13:58:21 +0200

LTP project recently switched to patchwork.kernel.org, document it.  Add
also IRC channel.

Link: https://github.com/linux-test-project/ltp/commit/3590f66120d1c875bef5d573c66c4c0d340c1612
Link: https://lore.kernel.org/ltp/20260731054548.133241-1-pvorel@suse.cz/
Link: https://lore.kernel.org/20260803115821.238704-1-pvorel@suse.cz
Signed-off-by: Petr Vorel <pvorel@suse.cz>
Suggested-by: Cyril Hrubis <chrubis@suse.cz>
Reviewed-by: Cyril Hrubis <chrubis@suse.cz>
Cc: Anders Roxell <anders.roxell@linaro.org>
Cc: Ben Copeland <ben.copeland@linaro.org>
Cc: Jan Stancek <jstancek@redhat.com>
Cc: Tim Bird <tim.bird@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-add-irc-and-patchwork-for-ltp
+++ a/MAINTAINERS
@@ -15426,7 +15426,9 @@ M:	Yang Xu <xuyang2018.jy@fujitsu.com>
 M:	Xiao Yang <yangx.jy@fujitsu.com>
 L:	ltp@lists.linux.it (subscribers-only)
 S:	Maintained
+C:	irc://irc.libera.chat/ltp
 W:	https://linux-test-project.readthedocs.io/
+Q:	https://patchwork.kernel.org/project/ltp/list/
 T:	git https://github.com/linux-test-project/ltp.git
 
 LTR390 AMBIENT/UV LIGHT SENSOR DRIVER
_

Patches currently in -mm which might be from pvorel@suse.cz are

maintainers-add-irc-and-patchwork-for-ltp.patch

