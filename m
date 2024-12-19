Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6C719C578
	for <mm-commits@vger.kernel.org>; Thu, 19 Dec 2024 23:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734650033; cv=none; b=mOpVzVv3VZUfeJe14/J9RWT5TRfyOgV1rBnq/9N5JtKp/TYPICIsugyHUlUMfAsX0o3p/wCKSBWEoKZXZWW2U/YjP/RZXOCUSlm65gIHe7UzB5+gPuYhtg1D1y1L8AwyEg8vpbCQYpqP0UBoLxfkJ0T2STBVXDk+U3XeJlISELk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734650033; c=relaxed/simple;
	bh=f4XDtt8a+19U26f8Aau9h0D9ZBC5WNgWqTUPrBh/Hko=;
	h=Date:To:From:Subject:Message-Id; b=Fez3hzfJo5x6pgI3TUrDbimJLYCyGCyZ8sYbqhPZdGAN0eoRjEOTZiXeAa/nk0A4Cqti1k9rn55vdQ/yz7cdZQoI7XVoqQ40FWkFJLo0HetwakwruD17wxAsB2bzcc3Cj07xGMbU8PvLqKWuNEdX88CTrQWOJ0WLCr63NBNHkXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1XcdhvIg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1XcdhvIg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579D5C4CECE;
	Thu, 19 Dec 2024 23:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734650032;
	bh=f4XDtt8a+19U26f8Aau9h0D9ZBC5WNgWqTUPrBh/Hko=;
	h=Date:To:From:Subject:From;
	b=1XcdhvIgnHCduUJTSO5aQxoxGgwAfEDkskSZ1aWI41oSoFpFeqxjrIDwt5KPw1qmR
	 dygADd8AnYSqgtpbaNGOv6ywM0RbqLrdUO/p5QCui1FYDhZAFBCK7r8g7I+2fmZFrZ
	 4ixMX2bhPucYew+5y5xp5I7o6Tml4yAAQj6c3GIg=
Date: Thu, 19 Dec 2024 15:13:51 -0800
To: mm-commits@vger.kernel.org,sstabellini@kernel.org,roger.pau@citrix.com,michal.orzel@amd.com,julien@xen.org,jbeulich@suse.com,anthony.perard@vates.tech,andrew.cooper3@citrix.com,ariel.otilibili-anieli@eurecom.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-remove-dead-code.patch added to mm-nonmm-unstable branch
Message-Id: <20241219231352.579D5C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/inflate.c: remove dead code
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-remove-dead-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-remove-dead-code.patch

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
From: Ariel Otilibili <ariel.otilibili-anieli@eurecom.fr>
Subject: lib/inflate.c: remove dead code
Date: Thu, 19 Dec 2024 10:21:12 +0100

This is a follow up from a discussion in Xen:

The if-statement tests that `res` is non-zero; meaning the case zero is
never reached.

Link: https://lore.kernel.org/all/7587b503-b2ca-4476-8dc9-e9683d4ca5f0@suse.com/
Link: https://lkml.kernel.org/r/20241219092615.644642-2-ariel.otilibili-anieli@eurecom.fr
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Ariel Otilibili <ariel.otilibili-anieli@eurecom.fr>
Suggested-by: Jan Beulich <jbeulich@suse.com>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: Anthony PERARD <anthony.perard@vates.tech>
Cc: Michal Orzel <michal.orzel@amd.com>
Cc: Julien Grall <julien@xen.org>
Cc: Roger Pau Monné <roger.pau@citrix.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/inflate.c |    2 --
 1 file changed, 2 deletions(-)

--- a/lib/inflate.c~lib-remove-dead-code
+++ a/lib/inflate.c
@@ -1257,8 +1257,6 @@ static int INIT gunzip(void)
     /* Decompress */
     if ((res = inflate())) {
 	    switch (res) {
-	    case 0:
-		    break;
 	    case 1:
 		    error("invalid compressed format (err=1)");
 		    break;
_

Patches currently in -mm which might be from ariel.otilibili-anieli@eurecom.fr are

lib-remove-dead-code.patch

