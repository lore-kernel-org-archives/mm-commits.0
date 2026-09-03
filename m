Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0DEE4FDE7E
	for <mm-commits@vger.kernel.org>; Thu,  3 Sep 2026 17:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788458195; cv=none; b=THaEaDPAx5wnush1yAYc1NhqX6gxDSbdAd2Qew0j269WGunP6EpB1KTb6hEhwuZdfa77uJAexGIyHOIZAKLhV7BOGwt5MbD6HH0zNVsAVqyyVArsrWzTEfrv0x4oJ/rgZpxpA7CV9vgJAjLiSsg3geznBkZGJMJ9fnPH6aligcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788458195; c=relaxed/simple;
	bh=N1I0pBZ17Fw7qrSVAU3vcINBAx5M9rRqrvR39Hf7KlQ=;
	h=Date:To:From:Subject:Message-Id; b=WKfayqInZUy6ISW2BydGmjCelRlv0IwSaLneFxRC6fkvbFRTClRRtv7xV70krl8lhzrz+Blb14rfB6m14DqjzGFT1NrvsAizzmu0prtf6269VCOCkerTCksD5nl5mwEGOAo1u7ODA/fnYI69UfSveh3NYC/qAmgo1/UN3LcZJT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qO98gMfw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qO98gMfw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484461F000E9;
	Thu,  3 Sep 2026 17:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788458193;
	bh=Fi5j1bieiitxD+Bktl03+ZFsXXP9eizXDcQwQGq7uMs=;
	h=Date:To:From:Subject;
	b=qO98gMfwKn9UsGshgLsprvwJNjyJ84KyvYP2+RpylZg1/sbFdkN1ObDXvzgi7KOKe
	 Ronsjp6QD4W2Zs0IxpMmvrQaiE06smCNWi6WL2z5WIpIaTtSV0pQpH4aeFzW6i9Y5j
	 SUJV0+Ec2VjK2E5q8hIgskFZ/0ABgZ3RACBA3G0s=
Date: Thu, 03 Sep 2026 10:56:32 -0700
To: mm-commits@vger.kernel.org,yukuai@fygo.io,xiao@kernel.org,song@kernel.org,magiclinan@didiglobal.com,hch@lst.de,akpm@linux-foundation.org,geert+renesas@glider.be,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-cover-all-of-raid.patch removed from -mm tree
Message-Id: <20260903175633.484461F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: cover all of RAID
has been removed from the -mm tree.  Its filename was
     maintainers-cover-all-of-raid.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: MAINTAINERS: cover all of RAID
Date: Thu, 27 Aug 2026 09:20:56 +0200

While commit 3626738bc7147d52 ("raid6: move to lib/raid/") handled the
move of RAID6, it didn't take into account there was already more RAID
code under lib/raid/, as XOR got moved over in commit 9e229025e2474115
("xor: move to lib/raid/") before.

Link: https://lore.kernel.org/7a2e5de234cc0286e3fe9bc11b810433775f2280.1787815121.git.geert+renesas@glider.be
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reported-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://lore.kernel.org/20260826205058.a6ff019d0584f75c7f50430b@linux-foundation.org
Cc: Christoph Hellwig <hch@lst.de>
Cc: Song Liu <song@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>
Cc: Xiao Ni <xiao@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-cover-all-of-raid
+++ a/MAINTAINERS
@@ -25405,7 +25405,7 @@ F:	drivers/md/md*
 F:	drivers/md/raid*
 F:	include/linux/raid/
 F:	include/uapi/linux/raid/
-F:	lib/raid/raid6/
+F:	lib/raid/
 
 SOLIDRUN CLEARFOG SUPPORT
 M:	Russell King <linux@armlinux.org.uk>
_

Patches currently in -mm which might be from geert+renesas@glider.be are


