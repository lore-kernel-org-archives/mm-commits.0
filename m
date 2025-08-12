Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACE6F9EC
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 01:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754961698; cv=none; b=IGW8emx+PL1pd9ATxnmMMKQUYmQR5+0vAdj5cSR1BXNVRUvr+J4EqbP/xWDuyz63KhqHiHs1ABLKi1N5uy7eb4NPayBU/JYts98yOl/4TP1Ulh2hIb4c5Gz0CgWz10bll95zKNozEGnykki7f2Quz/j3UHGG/mqGj/tHkyTbKzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754961698; c=relaxed/simple;
	bh=2vFRaaJnFl72DKPcyo1f3YHs0nrFvlzZt+xT5gnf/80=;
	h=Date:To:From:Subject:Message-Id; b=s4cJeI/rRE1m+1gEeF5gTXct1l802XPYTTGwK5urT0IaWXv+0OqORwISnCSuP+VS26q6LTb5T5ZzxMNLCPbQVcSfkZZugl4Xq+4VxH4BYOJc9FqK0bTHUNur34sJfjNliJM+NTSgIQZyo5hsfDPq9KQkLEcLFjzqucm1+O9FrBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BtGEie8G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BtGEie8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1EE9C4CEED;
	Tue, 12 Aug 2025 01:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754961697;
	bh=2vFRaaJnFl72DKPcyo1f3YHs0nrFvlzZt+xT5gnf/80=;
	h=Date:To:From:Subject:From;
	b=BtGEie8Gx9SNgnQwWi86Zfx2fDDeErT8TfAymMk0KgYv+qmkNP8UJE6JDv3pphmHS
	 Zq401ByLz2UCQOkDTsFUfEiFX+O1YNINHlukyT8vbsdyBpn7KGdm9drlH1qS7MrlJa
	 6pb+FOfUvD1YhWb0P71Qqj3iGatCsfLswBuVVKgs=
Date: Mon, 11 Aug 2025 18:21:36 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,anshuman.khandual@arm.com,andreyknvl@gmail.com,zhao.xichao@vivo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-unnecessary-pointer-variables.patch added to mm-unstable branch
Message-Id: <20250812012136.F1EE9C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/kasan/init.c: remove unnecessary pointer variables
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-unnecessary-pointer-variables.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-unnecessary-pointer-variables.patch

This patch will later appear in the mm-unstable branch at
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
From: Xichao Zhao <zhao.xichao@vivo.com>
Subject: mm/kasan/init.c: remove unnecessary pointer variables
Date: Mon, 11 Aug 2025 11:42:57 +0800

Simplify the code to enhance readability and maintain a consistent
coding style.

Link: https://lkml.kernel.org/r/20250811034257.154862-1-zhao.xichao@vivo.com
Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/init.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/kasan/init.c~mm-remove-unnecessary-pointer-variables
+++ a/mm/kasan/init.c
@@ -266,11 +266,9 @@ int __ref kasan_populate_early_shadow(co
 		}
 
 		if (pgd_none(*pgd)) {
-			p4d_t *p;
 
 			if (slab_is_available()) {
-				p = p4d_alloc(&init_mm, pgd, addr);
-				if (!p)
+				if (!p4d_alloc(&init_mm, pgd, addr))
 					return -ENOMEM;
 			} else {
 				pgd_populate(&init_mm, pgd,
_

Patches currently in -mm which might be from zhao.xichao@vivo.com are

mm-remove-unnecessary-pointer-variables.patch

