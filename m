Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDC110E9
	for <mm-commits@vger.kernel.org>; Fri, 25 Apr 2025 00:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745541562; cv=none; b=dIOgFUMSg7JOUvnSKWcnQs645mbsIz/WgXgU9gagFE1MD/AXHAi/wg35fauV1XvD1APEZyJpZGJBiYiDwoC8bROaNOnu3DZhsaqzt3C+PDZUCXi52OisrjivNyXy6pTfkNM/eVQ/tuRx0mZ1qitRlJti4epD3DoNDeGTbjCky7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745541562; c=relaxed/simple;
	bh=2ddNlx6HC1cW7dvnsu1tQ1jqJ6WXnBhb31VB9kUvLfY=;
	h=Date:To:From:Subject:Message-Id; b=hxAbUfm9WPv7epbZv/VyciOw0KcDey3QHStH4tQPrt36sP01cZEGjev1NYDaRGKGFQmfI25aVBSdlGrF4uirh5iATP7XHLpu6qtU21VFHqq93ITzeIZOGEcAAIMdh7H8RhUL1rBO5T3L5DY/bbrDSGGxUllBgtKrHAHRoPGOJws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AsxilYtQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AsxilYtQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20D43C4CEE3;
	Fri, 25 Apr 2025 00:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745541562;
	bh=2ddNlx6HC1cW7dvnsu1tQ1jqJ6WXnBhb31VB9kUvLfY=;
	h=Date:To:From:Subject:From;
	b=AsxilYtQG2+NnHmCl7r55ho1l4/koiohPAj2oihEGVt2Vj8DaPBFjUPIaqZQly3O5
	 B4H64gh3qA3W+NpA649/PI3zuQxCbH8Ie6d9ri0XWOlbCvj/bm0On4+RSsogAi/rMs
	 5xbwqobQERQhcZvinOX3j3cSjvglvncyT7wtcvdE=
Date: Thu, 24 Apr 2025 17:39:21 -0700
To: mm-commits@vger.kernel.org,u.kleine-koenig@baylibre.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-map-uwes-baylibre-addresses-to-a-single-one.patch added to mm-hotfixes-unstable branch
Message-Id: <20250425003922.20D43C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: map Uwe's BayLibre addresses to a single one
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-map-uwes-baylibre-addresses-to-a-single-one.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-map-uwes-baylibre-addresses-to-a-single-one.patch

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
From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Subject: mailmap: map Uwe's BayLibre addresses to a single one
Date: Thu, 24 Apr 2025 08:02:51 +0200

When I started working for BayLibre I wasn't aware that the mailserver
rewrote the sender address and so a few commits entered kernel history
with a working but unexpected address.  Map the unexpected to the intended
one.  This also makes the author of those commits (e.g.  32b4f1a4f07f
("pwm: jz4740: Another few conversions to regmap_{set,clear}_bits()"))
match the address used in the sign-off line.

Link: https://lkml.kernel.org/r/20250424060250.3085683-2-u.kleine-koenig@baylibre.com
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-map-uwes-baylibre-addresses-to-a-single-one
+++ a/.mailmap
@@ -751,6 +751,7 @@ Tvrtko Ursulin <tursulin@ursulin.net> <t
 Tycho Andersen <tycho@tycho.pizza> <tycho@tycho.ws>
 Tzung-Bi Shih <tzungbi@kernel.org> <tzungbi@google.com>
 Uwe Kleine-König <ukleinek@informatik.uni-freiburg.de>
+Uwe Kleine-König <u.kleine-koenig@baylibre.com> <ukleinek@baylibre.com>
 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
 Uwe Kleine-König <ukleinek@strlen.de>
 Uwe Kleine-König <ukl@pengutronix.de>
_

Patches currently in -mm which might be from u.kleine-koenig@baylibre.com are

mailmap-map-uwes-baylibre-addresses-to-a-single-one.patch

