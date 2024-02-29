Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25DA7D08D
	for <mm-commits@vger.kernel.org>; Thu, 29 Feb 2024 18:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709232175; cv=none; b=VYs7o3aRXOKw2ghw2WZOdoVa0XOoHclEWbgqpmWhj2ti4w9nUKzRxuqvlL4UHE0W+yffz64W/WAIJ+FSkKH3yZCFZ5rjmL+Gfw+gOv9bPyq3m8VdCvOcPL/6rTJot5MA7e+LuXZuo1Um+deyghzl5ePET4EctxOGapho5BK/2Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709232175; c=relaxed/simple;
	bh=zM7jE8Pe88fqM/P5aZmjK1bdU4WNrpZqj5uTr91JIVg=;
	h=Date:To:From:Subject:Message-Id; b=fnTzN33WmULlfv8PDuywyavH9QDhygdpdbG5b3qRAoUNbypXexs6R02fdmnqRZs7r0sI6N5lsiYJ/x8mveizTSJAoWG92LpYY1lYWqWN2PxNCOKNbkotDo8ufShNF31dtB5E4DZilwHlqtGbH5vwUt9ZsSkZ+yyoCbkEPC+bGbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1fatUcrF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1fatUcrF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47C3C43390;
	Thu, 29 Feb 2024 18:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709232175;
	bh=zM7jE8Pe88fqM/P5aZmjK1bdU4WNrpZqj5uTr91JIVg=;
	h=Date:To:From:Subject:From;
	b=1fatUcrFas1IZJIYERmY5TGACXnKT6CPTMfmEYMiZZCmNyAd5OFxAr+BAeoax8qG8
	 zjoOYRUx1ktF+7EujdxnhrsxyGIUJzZp+K8ZZHLjTrsXsSrFHo5XcT/4XGnCfKquxS
	 1FcWCDVvMR+ALHPZA749fRDxnGNzolgulevExH3g=
Date: Thu, 29 Feb 2024 10:42:53 -0800
To: mm-commits@vger.kernel.org,kishon@ti.com,kishon@kernel.org,cassel@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-fix-kishons-email.patch added to mm-hotfixes-unstable branch
Message-Id: <20240229184254.D47C3C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: fix Kishon's email
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-fix-kishons-email.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-fix-kishons-email.patch

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
From: Niklas Cassel <cassel@kernel.org>
Subject: mailmap: fix Kishon's email
Date: Thu, 29 Feb 2024 14:43:18 +0100

Kishon updated his email in commit e6aa4edd2f5b ("MAINTAINERS: Update
Kishon's email address in PCI endpoint subsystem").

However, as he is no longer at TI, his TI email now bounces.

Add the same email as he has in MAINTAINERS to a mailmap, so that
get_maintainer.pl will not output an email that bounces.

(This is neeed as get_maintainer.pl will use "git author" to CC
people who have significantly modified the same file as you.)

Link: https://lkml.kernel.org/r/20240229134318.1201935-1-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Cc: Kishon Vijay Abraham I <kishon@kernel.org>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-fix-kishons-email
+++ a/.mailmap
@@ -325,6 +325,7 @@ Kenneth W Chen <kenneth.w.chen@intel.com
 Kenneth Westfield <quic_kwestfie@quicinc.com> <kwestfie@codeaurora.org>
 Kiran Gunda <quic_kgunda@quicinc.com> <kgunda@codeaurora.org>
 Kirill Tkhai <tkhai@ya.ru> <ktkhai@virtuozzo.com>
+Kishon Vijay Abraham I <kishon@kernel.org> <kishon@ti.com>
 Konstantin Khlebnikov <koct9i@gmail.com> <khlebnikov@yandex-team.ru>
 Konstantin Khlebnikov <koct9i@gmail.com> <k.khlebnikov@samsung.com>
 Koushik <raghavendra.koushik@neterion.com>
_

Patches currently in -mm which might be from cassel@kernel.org are

mailmap-fix-kishons-email.patch

