Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1243F822B
	for <mm-commits@vger.kernel.org>; Thu, 13 Aug 2026 22:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786660969; cv=none; b=Z1VeNHAQlUJwT4buyaLSQPN4upbTYp+T2kY4bbz1bNB53l2ha7N8ggJIPHMX6umTSTk4GBh6LathOPBL/I3lCuQtWn1pRLWMcwnM8WCwghaAIL9z0p3IOS0b9Q22dIKwGf7Hnjs22d++UOWTqv2pwLgP8IVYnPsaAcSPaZG64og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786660969; c=relaxed/simple;
	bh=LBZipkgcHeBunjnaX0iFYh5GY9cl0elyo0WmvnV87xQ=;
	h=Date:To:From:Subject:Message-Id; b=sg69tp/C6bgi0h6g/bgHPKhjx4Bm7/OPUoro5efkRMLFQupmFFUSU/aMrUmquWx2+5dai9NwBg+oiAm+Q4pis0lxEWgA2Kwbgd9OY9pkbdOi+o6LDjNDrhr0hxCmzlF1TmZ9yj7O05rhzXXZmN6Jrm5Uy+mr8ZhcAQM03niVvl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XH5vXtRd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XH5vXtRd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C02611F00A3A;
	Thu, 13 Aug 2026 22:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786660967;
	bh=Ep8Tgxuwe320+KWFNGnN2MwWZhtMgTqwsPLHwyiEAVU=;
	h=Date:To:From:Subject;
	b=XH5vXtRdv8u5Ey+76QLLMEUU2ikcXlXyzWEtFo/XyV8AILi5qccj6wigGlpYhPtXY
	 1bIQHAW4hTdRUEswKi7uAz5ZghMhcYXkfrkXxxzmaZzUt81mKgfe4V1bbYtmLcZ59Q
	 eIZM9WouIhwa/nCRlK5Q85mbQg66mgONN4yxkelk=
Date: Thu, 13 Aug 2026 15:42:47 -0700
To: mm-commits@vger.kernel.org,tim.bird@sony.com,li.wang@linux.dev,jstancek@redhat.com,chrubis@suse.cz,ben.copeland@linaro.org,andrea.cervesato@suse.com,anders.roxell@linaro.org,pvorel@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] maintainers-add-irc-and-patchwork-for-ltp.patch removed from -mm tree
Message-Id: <20260813224247.C02611F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add IRC and patchwork for LTP
has been removed from the -mm tree.  Its filename was
     maintainers-add-irc-and-patchwork-for-ltp.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Li Wang <li.wang@linux.dev>
Reviewed-by: Andrea Cervesato <andrea.cervesato@suse.com>
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

checkpatch-skip-camelcase-cache-for-no-tree-without-root.patch

