Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBC121506E
	for <mm-commits@vger.kernel.org>; Thu, 17 Apr 2025 23:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744933965; cv=none; b=c7AzHPT3XyExNQwVxqP+6tchOwoJGFyqnoYh9JBxmVuAMi6XComv6Fju6RN4bMXAzpWG6asg4KG2qtfeaTix83il7uPzBh2pO4GG73llLWv4unUPXVjj5M6MvJMpwnWpyvMw1uZf5Uh57AVSE687yqydALC+ilHUVIpSIrZF/Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744933965; c=relaxed/simple;
	bh=3UJv7lZFD6p0WR4BxJfj73RcvbsYSIWA3jmdAAqCuIc=;
	h=Date:To:From:Subject:Message-Id; b=A3KE+u3tGV0vGRFfNICaeWdW0tdG4y1HNle6VLn1Y+VAFJJW3DW6LRvxsxTKg9gqts/BHpy3LAZQ7z1Jd2Vr3CqsAiEAfEzyCRX0EjOPRzquWYMaGsIQQU4QQkSuj7F+H74Kr1t12oeM1tdK3RKINTzj3msKgAF48h+uIVu6+gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0bdmWBxy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0bdmWBxy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D41FC4CEE4;
	Thu, 17 Apr 2025 23:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744933965;
	bh=3UJv7lZFD6p0WR4BxJfj73RcvbsYSIWA3jmdAAqCuIc=;
	h=Date:To:From:Subject:From;
	b=0bdmWBxysNrEH16AidwtIzXTITR9saJRf2dYGq9LS1ycc5za128sgtbqh+eQCViQY
	 MITNGtbohalVToyrmSgEtyBdSSP//puQN2KW3iGf9j+lTtb3BOT2IRdiIXekTMbOvw
	 aRHbvyx2n/YjjMuJTJYikDRkSNu5e4WTZx/y/MPw=
Date: Thu, 17 Apr 2025 16:52:44 -0700
To: mm-commits@vger.kernel.org,mjguzik@gmail.com,hch@infradead.org,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_vmallocc-allow-built-in-execution.patch added to mm-new branch
Message-Id: <20250417235245.6D41FC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_vmalloc.c: allow built-in execution
has been added to the -mm mm-new branch.  Its filename is
     lib-test_vmallocc-allow-built-in-execution.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_vmallocc-allow-built-in-execution.patch

This patch will later appear in the mm-new branch at
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
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: lib/test_vmalloc.c: allow built-in execution
Date: Thu, 17 Apr 2025 18:12:14 +0200

Remove the dependency on module loading ("m") for the vmalloc test suite,
enabling it to be built directly into the kernel, so both ("=m") and
("=y") are supported.

Motivation:
- Faster debugging/testing of vmalloc code;
- It allows to configure the test via kernel-boot parameters.

Configuration example:
  test_vmalloc.nr_threads=64
  test_vmalloc.run_test_mask=7
  test_vmalloc.sequential_test_order=1

Link: https://lkml.kernel.org/r/20250417161216.88318-2-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christop Hellwig <hch@infradead.org>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug  |    3 +--
 lib/test_vmalloc.c |    5 +++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/lib/Kconfig.debug~lib-test_vmallocc-allow-built-in-execution
+++ a/lib/Kconfig.debug
@@ -2574,8 +2574,7 @@ config TEST_BITOPS
 config TEST_VMALLOC
 	tristate "Test module for stress/performance analysis of vmalloc allocator"
 	default n
-       depends on MMU
-	depends on m
+	depends on MMU
 	help
 	  This builds the "test_vmalloc" module that should be used for
 	  stress and performance analysis. So, any new change for vmalloc
--- a/lib/test_vmalloc.c~lib-test_vmallocc-allow-built-in-execution
+++ a/lib/test_vmalloc.c
@@ -591,10 +591,11 @@ static void do_concurrent_test(void)
 	kvfree(tdriver);
 }
 
-static int vmalloc_test_init(void)
+static int __init vmalloc_test_init(void)
 {
 	do_concurrent_test();
-	return -EAGAIN; /* Fail will directly unload the module */
+	/* Fail will directly unload the module */
+	return IS_BUILTIN(CONFIG_TEST_VMALLOC) ? 0:-EAGAIN;
 }
 
 module_init(vmalloc_test_init)
_

Patches currently in -mm which might be from urezki@gmail.com are

vmalloc-add-for_each_vmap_node-helper.patch
vmalloc-switch-to-for_each_vmap_node-helper.patch
vmalloc-use-for_each_vmap_node-in-purge-vmap-area.patch
vmalloc-use-atomic_long_add_return_relaxed.patch
lib-test_vmallocc-replace-rwsem-to-srcu-for-setup.patch
lib-test_vmallocc-allow-built-in-execution.patch
maintainers-add-test_vmallocc-to-vmalloc-section.patch
vmalloc-align-nr_vmalloc_pages-and-vmap_lazy_nr.patch

