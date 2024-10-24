Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7C83C3C
	for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 03:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729739106; cv=none; b=uwM6193DYEjjB86MOaDPev5+vrnZiJhVHqxj8+/gOkR0jOhqAb4yFLT4dZrJzPVAFzBI6HiuTevadqwj4Szy5lI5QpuDiXHCw/FiH8FF2jAYmNlVlFQwEh7OW20RKW6viplp0Pa6w9aiZUvtazUy5FjvuCPmJFU+nSfuY5wt+hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729739106; c=relaxed/simple;
	bh=MP+z8KMv6bXI9QXOquoioIDDST3HTEAp2awzkr6r2H0=;
	h=Date:To:From:Subject:Message-Id; b=OV2eP6N75dA+P+3+Pp+GCyEEAH0M5ip/g9/mrdiJ9ziN8e9xswXilc1kEvvGzeoKxRx6+FwdFL8ZyJLPQ6r4sXx/IXqT/P76qMIqqc5xGkwDEoZ5JMdmKRYRbO/saRGaL07ArJeha3PnVc23KXm0rVFs7YoaufNxDmvfLSCyfYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K0pIZK8y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K0pIZK8y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BAAC4CEC6;
	Thu, 24 Oct 2024 03:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729739105;
	bh=MP+z8KMv6bXI9QXOquoioIDDST3HTEAp2awzkr6r2H0=;
	h=Date:To:From:Subject:From;
	b=K0pIZK8yyy9KFobX8Jg4YFTNaFNuKzTwG83Be8elI5w4u7lgevZDDMtKHDs1h8qt0
	 Z0YW/uhZx8BGX0EuyD3tawKm/STWZP88T0+y3rq94DrBnFdx6ok03PTQ1QBpBupZIA
	 E87O/UX55C43wtcEu8xhCpmJ6KE0w+GtiHqfveTQ=
Date: Wed, 23 Oct 2024 20:05:05 -0700
To: mm-commits@vger.kernel.org,snovitoll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-delete-config_kasan_module_test-fix.patch added to mm-unstable branch
Message-Id: <20241024030505.98BAAC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation/kasan: fix indentation in translation
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-delete-config_kasan_module_test-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-delete-config_kasan_module_test-fix.patch

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
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Subject: Documentation/kasan: fix indentation in translation
Date: Sun, 20 Oct 2024 09:28:13 +0500

Fix the warning in linux-next (htmldocs):

> Documentation/translations/zh_TW/dev-tools/kasan.rst:410:
>	ERROR: Unexpected indentation.

This is based on -mm tree (linux-mm-unstable branch).

Link: https://lkml.kernel.org/r/20241020042813.3223449-1-snovitoll@gmail.com
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/translations/zh_TW/dev-tools/kasan.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/translations/zh_TW/dev-tools/kasan.rst~kasan-delete-config_kasan_module_test-fix
+++ a/Documentation/translations/zh_TW/dev-tools/kasan.rst
@@ -407,7 +407,7 @@ 有一些KASAN測試可以驗證KASAN是
 
 所有 KASAN 測試均與 KUnit 測試框架集成，並且可以啟用
 透過 ``CONFIG_KASAN_KUNIT_TEST``。可以運行測試並進行部分驗證
- 以幾種不同的方式自動進行；請參閱下面的說明。
+以幾種不同的方式自動進行；請參閱下面的說明。
 
 如果偵測到錯誤，每個 KASAN 測試都會列印多個 KASAN 報告之一。
 然後測試列印其編號和狀態。
_

Patches currently in -mm which might be from snovitoll@gmail.com are

x86-traps-move-kmsan-check-after-instrumentation_begin.patch
mm-kasan-kmsan-copy_from-to_kernel_nofault.patch
kasan-move-checks-to-do_strncpy_from_user.patch
kasan-migrate-copy_user_test-to-kunit.patch
kasan-delete-config_kasan_module_test.patch
kasan-delete-config_kasan_module_test-fix.patch

