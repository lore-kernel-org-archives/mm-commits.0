Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C1C34E75D
	for <mm-commits@vger.kernel.org>; Sun, 11 Oct 2026 22:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791757212; cv=none; b=Ahgz4j/E2XIsWec5pyxkeNp2FHrOy85zw0DvOd+b/7kGCnUJepALkcyZmmyx+4k4CBEhqVhLc4RzXT1XUVKtOCt0gZCJnn/f4KDttC9zMimdXRdBDziLl5HWcIQ5fN3r9yxDMP0tK0CFmNPnpgbg/jyLVE0yVthaNph9gAkz4rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791757212; c=relaxed/simple;
	bh=NCVAYijZgMKKcPTT0flWZgnr1zLdUWUm2+fY/3LYu4c=;
	h=Date:To:From:Subject:Message-Id; b=uPfJEFwzNvEtUF4Z0ausNZBZmXF0aNjvYh5RZhUJABUcrQJSiRr3iUKchIb35PMsJUwmgTHaiZ02k2tSKKAVuY+ICo+G0A3Qrl6kbHKKaIrnwPTpVTK2I+Wdlgcg8O3yl1Q8qbD8NugNEsBZC6LPBex5sZoO0kw2D4wKo+AKZ3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xPE7ffLi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xPE7ffLi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9111F0089B;
	Sun, 11 Oct 2026 22:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791757211;
	bh=hVC45f9tHv/OAoe3ZSf5ahxfO0MZ/STZNIMz+/5PsOc=;
	h=Date:To:From:Subject;
	b=xPE7ffLiBfUzVjEzQF3mpyX3rzAhPchHGMC/ecqnt+VBwbA99yI+z+XCLU8/BI2Rn
	 7YTZd2THUUki8zeQRFXey9ENtYSX5Jl2F80SNEU8wFyeODI8y2VN6PK1aejhbv8uls
	 8qxQzPW5w2o3uRXqroc9L65EdVboJ2FcfjXoM84A=
Date: Sun, 11 Oct 2026 15:20:10 -0700
To: mm-commits@vger.kernel.org,tglx@kernel.org,dianders@chromium.org,blum@kernel.org,brads@mainlining.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] watchdog-perf-one-digit-too-short-in-the-raw-event-config-copy.patch removed from -mm tree
Message-Id: <20261011222011.4A9111F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: watchdog/perf: one digit too short in the raw event config copy
has been removed from the -mm tree.  Its filename was
     watchdog-perf-one-digit-too-short-in-the-raw-event-config-copy.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bradley Morgan <brads@mainlining.org>
Subject: watchdog/perf: one digit too short in the raw event config copy
Date: Sat, 3 Oct 2026 11:02:00 +0000

Commit 6164be01f179 ("watchdog/perf: optimize bytes copied and remove
manual NUL-termination") swapped strscpy(buf, str, sizeof(buf)) plus a
manual buf[len] = 0 for strscpy(buf, str, len), and that count is one
short.  strscpy() keeps the last byte of the destination for the NUL, so
the config loses its final digit, nmi_watchdog=r300,panic for example ends
up with buf = "30" and arms the raw event with the wrong config.

The empty case falls over too, strscpy() with a zero count writes nothing
at all, so nmi_watchdog=r,1 leaves buf uninitialized and kstrtoull() reads
whatever stack garbage is sitting there.

The old code was safe on both by accident, it filled the whole buffer
first and buf[len] = 0 then stomped the comma position, so the worst you
got was a truncated parse failure.

Pass len + 1 so the copy includes the character the NUL replaces, and
reject len >= sizeof(buf) like it was before the optimization, which also
turns an empty config back into a clean parse failure.

Link: https://lore.kernel.org/20261003110200.3-brads@mainlining.org
Fixes: 6164be01f179 ("watchdog/perf: optimize bytes copied and remove manual NUL-termination")
Signed-off-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Cc: Thorsten Blum <blum@kernel.org>
Cc: Thomas Gleixner <tglx@kernel.org>
---

 kernel/watchdog_perf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/watchdog_perf.c~watchdog-perf-one-digit-too-short-in-the-raw-event-config-copy
+++ a/kernel/watchdog_perf.c
@@ -301,10 +301,10 @@ void __init hardlockup_config_perf_event
 	} else {
 		unsigned int len = comma - str;
 
-		if (len > sizeof(buf))
+		if (len >= sizeof(buf))
 			return;
 
-		strscpy(buf, str, len);
+		strscpy(buf, str, len + 1);
 		if (kstrtoull(buf, 16, &config))
 			return;
 	}
_

Patches currently in -mm which might be from brads@mainlining.org are


