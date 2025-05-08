Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EF62192E6
	for <mm-commits@vger.kernel.org>; Thu,  8 May 2025 06:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746686455; cv=none; b=nqrQNMTWp954cTD/fI0VNwCym06lJZFeySZn2m3OJKmH0H7pVUdvWRK4awPUceA+uOxjn7esPnRY3/v8V1juQAKeGxHUcsxYCjdRk5eW/luadwpCMnXUOwfWAyimUvDN/eKRCc5xE/ajjc4iWD8zD+gEctxMHIN67Q1OGa7vD6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746686455; c=relaxed/simple;
	bh=kF78hXhBuZaM5ZbZCTj02XFv+99pOvX9EAT3qMVDcvA=;
	h=Date:To:From:Subject:Message-Id; b=rLc+myRK2XMYZTSj1nNgHpv70vMadf3bqnS4IEU5xXjvohQe0QMlwojEaYpDAJHK4iXlmzlnB2i0VAY7nbZBkHNZaJ9i+PbGxe4wgK2ZIALK2+7xehUYSFR1S3kQ1zcX3klx5id8u3duUCzYgZtZ14u63NMRNQzc83bNSm9dmmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X3wn433p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X3wn433p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88B7FC4CEEB;
	Thu,  8 May 2025 06:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746686455;
	bh=kF78hXhBuZaM5ZbZCTj02XFv+99pOvX9EAT3qMVDcvA=;
	h=Date:To:From:Subject:From;
	b=X3wn433pwwM7MzVhZz3VhVmTaXb+58MMYmOA55+snsMbQqCj6Njbd9qiSEe1EAn+L
	 3edx8nk31FIb63EItUM7RPHFp4jqFLtR0ujIwfQzwyU7leeABlUj+V0+Pffj5o9gme
	 dANepF6BmcFx9cva1xoFo1r5txm0TDOl8BXNrHN0=
Date: Wed, 07 May 2025 23:40:55 -0700
To: mm-commits@vger.kernel.org,u.kleine-koenig@baylibre.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-map-uwes-baylibre-addresses-to-a-single-one.patch removed from -mm tree
Message-Id: <20250508064055.88B7FC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: map Uwe's BayLibre addresses to a single one
has been removed from the -mm tree.  Its filename was
     mailmap-map-uwes-baylibre-addresses-to-a-single-one.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


