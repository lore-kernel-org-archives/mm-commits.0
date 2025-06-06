Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3C91FAA
	for <mm-commits@vger.kernel.org>; Fri,  6 Jun 2025 05:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749186183; cv=none; b=heBQ7MgVfh2nH1cPgdnByk9xs83kPudXDzY0mm9Nh27WS5AlqzTPrxOgLcao3MPeAcXe3TSQUhPSy82nrxQ8beDLf/jI4eQUpe8lHxN0+Zb/e+1ytGxXwHL7vTyEMBzPG+M5TzxGncF7SXJdjGGH3GUVPmnO0jPYESvC6zWvQ5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749186183; c=relaxed/simple;
	bh=hVQVo3uI+AjZj5WEyOLeM96DCqZT8QPDiaZ75BoJ97M=;
	h=Date:To:From:Subject:Message-Id; b=emNRsmmt4WzmaU1z2wnbmVI2t7wYG89po60pq7yGZSuZw+SU3LEZi9hElYBg92T7noC3Np2I2DsjWp5PRYg4dNUvGRhPf6vC5UxAgb5KM7fT46TvML7+3dTvGpbOZ6dJJQTPP73p4QWsc5LNHp+v7W8A0QA1AYdnnjF6j9ureFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GpGUyvQq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GpGUyvQq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D03C4CEEB;
	Fri,  6 Jun 2025 05:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749186183;
	bh=hVQVo3uI+AjZj5WEyOLeM96DCqZT8QPDiaZ75BoJ97M=;
	h=Date:To:From:Subject:From;
	b=GpGUyvQqVAQPlgwEcTDouyypHQ99DNYfBHEklrtfa+znh+309wdsYsOBBZNVI3cAM
	 ovFX6zDEDxYWcIl1x2QCdtVfgcoDDiLmqJSQ26wDqsaBEiDym4iWZW4SX/+tYt5NXl
	 0p26aTqwz3Ts4+vv5iHF+UAsGP5vsfMKPxaXhU9Y=
Date: Thu, 05 Jun 2025 22:03:02 -0700
To: mm-commits@vger.kernel.org,snovitoll@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kmsan-test-add-module-description.patch removed from -mm tree
Message-Id: <20250606050303.31D03C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kmsan: test: add module description
has been removed from the -mm tree.  Its filename was
     kmsan-test-add-module-description.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: kmsan: test: add module description
Date: Tue, 3 Jun 2025 09:53:07 +0200

Every module should have a description, and kbuild now warns for those
that don't.

WARNING: modpost: missing MODULE_DESCRIPTION() in mm/kmsan/kmsan_test.o

Link: https://lkml.kernel.org/r/20250603075323.1839608-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Macro Elver <elver@google.com>
Cc: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/kmsan_test.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/kmsan/kmsan_test.c~kmsan-test-add-module-description
+++ a/mm/kmsan/kmsan_test.c
@@ -732,3 +732,4 @@ kunit_test_suites(&kmsan_test_suite);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Alexander Potapenko <glider@google.com>");
+MODULE_DESCRIPTION("Test cases for KMSAN");
_

Patches currently in -mm which might be from arnd@arndb.de are


