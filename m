Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890017580E
	for <mm-commits@vger.kernel.org>; Sun,  5 May 2024 21:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714942889; cv=none; b=N0ArRb0RUmSG4lJni8rt+SiQglTeO3JGAxQI5LHje57uB45wgPnR03bdO8isU8pdVqvpXN6end5ctf7YYYy+VN9HWGbB+wgjqGmdSksW3zEnIpIWGFJg4bKBF5K9RUzqcY1ruRfgJxj30ND7iBuWbF3ePQswGiP20U6B75MLmNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714942889; c=relaxed/simple;
	bh=vvfMv3Ezizz8NFUZkqOxcHpRvLgBjrodRmhbHIED+TE=;
	h=Date:To:From:Subject:Message-Id; b=J810AyXxBnvXtiwTq/P2jD9yAY0EaNOK2xvE6z8aEBYwjuTKzYBLkNU8QIpZAV8Rgrs2YFmROjm8uxZpytgO5EBJu4nsILulNVccUd/IC69M9Ay2SdcuCfZ8t2LkYvp3HUNZUpAG+0/4N1zYF+/hvbBiBDe6sL1b+rN5ERfYbOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O8TtjL1z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O8TtjL1z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36F6BC113CC;
	Sun,  5 May 2024 21:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714942889;
	bh=vvfMv3Ezizz8NFUZkqOxcHpRvLgBjrodRmhbHIED+TE=;
	h=Date:To:From:Subject:From;
	b=O8TtjL1zWiVqolYK/jsp7bcYeanXSyo1LDrrNreRFtY5SmyzWa2JgBGEnQEDGiN9o
	 WSzlL7oQfgrHRfUtKyUhCnd3dv4Yusjwobm2NcKg2A4yLje7fzFVxssXoUrv9WMl3Z
	 Zls4LNS3bcdKaPNtFV2AA9vUayuqiaegWjLWRuxk=
Date: Sun, 05 May 2024 14:01:28 -0700
To: mm-commits@vger.kernel.org,conor@kernel.org,john.g.garry@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-entry-for-john-garry.patch added to mm-hotfixes-unstable branch
Message-Id: <20240505210129.36F6BC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: add entry for John Garry
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-add-entry-for-john-garry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entry-for-john-garry.patch

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
From: John Garry <john.g.garry@oracle.com>
Subject: mailmap: add entry for John Garry
Date: Fri, 3 May 2024 08:57:36 +0000

get_maintainers.pl sometimes suggests my name and old e-mail address, so
update .mailmap to point to my current e-mail address.

Link: https://lkml.kernel.org/r/20240503085736.3354268-1-john.g.garry@oracle.com
Signed-off-by: John Garry <john.g.garry@oracle.com>
Reported-by: Conor Dooley <conor@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-entry-for-john-garry
+++ a/.mailmap
@@ -292,6 +292,7 @@ Johan Hovold <johan@kernel.org> <jhovold
 Johan Hovold <johan@kernel.org> <johan@hovoldconsulting.com>
 John Crispin <john@phrozen.org> <blogic@openwrt.org>
 John Fastabend <john.fastabend@gmail.com> <john.r.fastabend@intel.com>
+John Garry <john.g.garry@oracle.com> <john.garry@huawei.com>
 John Keeping <john@keeping.me.uk> <john@metanate.com>
 John Moon <john@jmoon.dev> <quic_johmoo@quicinc.com>
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
_

Patches currently in -mm which might be from john.g.garry@oracle.com are

mailmap-add-entry-for-john-garry.patch

