Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D99B48B37F
	for <mm-commits@vger.kernel.org>; Thu, 11 Jun 2026 18:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781203382; cv=none; b=aM60rel/LiJECWOaGBMYvRYtcULwvcKxReeRSdjvt7DUOEHmg2lsgssICQrxu2eXEnU7g01U54FIvnoaQDnYDCjFBKHIqArygFt4yl6Et8XLIjjtm4tpEr2QviGVtGQ8LW8ozKny9I8yYy0Tc7egne+cSY3uIkNxTMu0QBnq5c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781203382; c=relaxed/simple;
	bh=P2Zlj5eXATti8LlCvNEMcxPC3ZigFdZuTDjJTZyqxm4=;
	h=Date:To:From:Subject:Message-Id; b=ii5GZtSANfteQr5XM4T8xIOeGCaP5guyMwtgH0a/ZfeIBjhv24OinQ+ug7YVByAiTK3f4irqTZGaNyoevf87aNbNdM4csiwnyRJNTHVnTor41KMWe1HrPGU99cvDeCqHkNcjR2x7jsXN9zqGD7Yj6fWhFCnAMamitDWQ5c+KLxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=loCg3ZQk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="loCg3ZQk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1CFC1F000E9;
	Thu, 11 Jun 2026 18:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781203381;
	bh=AAOlZdIcLqHPAAkIq/bO8SitzrZCLJb2zLSQOSaAzNU=;
	h=Date:To:From:Subject;
	b=loCg3ZQkN9v/9oehG+46gGEYGqgz+RSU/S8bRo5fPO7nk55W4JzO/xsyxe9mvRn00
	 hm2QxrJAshOLlhoRh5B2MEbOCDg9uiB/OVGC2h/KKm+a5afZJ9rhrzinE1258ZzQ7W
	 yHTlh6dH4BQqEKqf92HSB/NupDJHyPVRqIN+FJpE=
Date: Thu, 11 Jun 2026 11:43:00 -0700
To: mm-commits@vger.kernel.org,elver@google.com,dvyukov@google.com,glider@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] maintainers-add-self-as-a-kcov-reviewer.patch removed from -mm tree
Message-Id: <20260611184300.E1CFC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add Alexander as a kcov reviewer
has been removed from the -mm tree.  Its filename was
     maintainers-add-self-as-a-kcov-reviewer.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: MAINTAINERS: add Alexander as a kcov reviewer
Date: Fri, 5 Jun 2026 10:54:23 +0200

Also move Dmitry Vyukov to the bottom of the list.

Link: https://lore.kernel.org/20260605085423.1962700-1-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-add-self-as-a-kcov-reviewer
+++ a/MAINTAINERS
@@ -13838,8 +13838,9 @@ F:	fs/proc/kcore.c
 F:	include/linux/kcore.h
 
 KCOV
-R:	Dmitry Vyukov <dvyukov@google.com>
 R:	Andrey Konovalov <andreyknvl@gmail.com>
+R:	Alexander Potapenko <glider@google.com>
+R:	Dmitry Vyukov <dvyukov@google.com>
 L:	kasan-dev@googlegroups.com
 S:	Maintained
 B:	https://bugzilla.kernel.org/buglist.cgi?component=Sanitizers&product=Memory%20Management
_

Patches currently in -mm which might be from glider@google.com are


