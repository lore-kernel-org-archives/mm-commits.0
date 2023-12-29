Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F5013ADC
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O3z3x0ID"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 007D0C433C7;
	Fri, 29 Dec 2023 20:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880075;
	bh=U0zW7WQP5o5FNepZbJsXWlmDm5dCTYWJnXau2tjI1ck=;
	h=Date:To:From:Subject:From;
	b=O3z3x0IDVSvkuVFuNRNkBfmokv/YtGuBUFlp0zmp5BA88guG8R1GsRS1XLOGaQAlE
	 KQIUBZxt3gBoC8UvUKrbZXnO48990h9yn6Bh87stMsaTgGRj1EKyQX3rQobZTyeRmy
	 IK8CUXWgFl9I3BTJue+U85H9KZtgOQZQCrtzBpXk=
Date: Fri, 29 Dec 2023 12:01:14 -0800
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-respect-config_kasan_vmalloc-for-kasan_flag_vmalloc.patch removed from -mm tree
Message-Id: <20231229200115.007D0C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: respect CONFIG_KASAN_VMALLOC for kasan_flag_vmalloc
has been removed from the -mm tree.  Its filename was
     kasan-respect-config_kasan_vmalloc-for-kasan_flag_vmalloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: respect CONFIG_KASAN_VMALLOC for kasan_flag_vmalloc
Date: Thu, 21 Dec 2023 21:04:49 +0100

Never enable the kasan_flag_vmalloc static branch unless
CONFIG_KASAN_VMALLOC is enabled.

This does not fix any observable bugs (vmalloc annotations for the HW_TAGS
mode are no-op with CONFIG_KASAN_VMALLOC disabled) but rather just cleans
up the code.

Link: https://lkml.kernel.org/r/3e5c933c8f6b59bd587efb05c407964be951772c.1703188911.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/hw_tags.c |    7 +++++++
 mm/kasan/kasan.h   |    1 +
 2 files changed, 8 insertions(+)

--- a/mm/kasan/hw_tags.c~kasan-respect-config_kasan_vmalloc-for-kasan_flag_vmalloc
+++ a/mm/kasan/hw_tags.c
@@ -57,7 +57,11 @@ enum kasan_mode kasan_mode __ro_after_in
 EXPORT_SYMBOL_GPL(kasan_mode);
 
 /* Whether to enable vmalloc tagging. */
+#ifdef CONFIG_KASAN_VMALLOC
 DEFINE_STATIC_KEY_TRUE(kasan_flag_vmalloc);
+#else
+DEFINE_STATIC_KEY_FALSE(kasan_flag_vmalloc);
+#endif
 
 #define PAGE_ALLOC_SAMPLE_DEFAULT	1
 #define PAGE_ALLOC_SAMPLE_ORDER_DEFAULT	3
@@ -119,6 +123,9 @@ static int __init early_kasan_flag_vmall
 	if (!arg)
 		return -EINVAL;
 
+	if (!IS_ENABLED(CONFIG_KASAN_VMALLOC))
+		return 0;
+
 	if (!strcmp(arg, "off"))
 		kasan_arg_vmalloc = KASAN_ARG_VMALLOC_OFF;
 	else if (!strcmp(arg, "on"))
--- a/mm/kasan/kasan.h~kasan-respect-config_kasan_vmalloc-for-kasan_flag_vmalloc
+++ a/mm/kasan/kasan.h
@@ -49,6 +49,7 @@ DECLARE_PER_CPU(long, kasan_page_alloc_s
 
 static inline bool kasan_vmalloc_enabled(void)
 {
+	/* Static branch is never enabled with CONFIG_KASAN_VMALLOC disabled. */
 	return static_branch_likely(&kasan_flag_vmalloc);
 }
 
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-stop-leaking-stack-trace-handles.patch

