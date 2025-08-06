Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B8619F420
	for <mm-commits@vger.kernel.org>; Wed,  6 Aug 2025 02:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754447556; cv=none; b=WIvEf7p/K3tKUY5kURp+s2S7moMDcugfOe/3gxyGumV5a9J8gRuwU/mjh+VJ/BDhs4r/tF2JMiopaALwoH444LIXb7HWrLbdVhyKpeVnLwEPgcu0ddwkE1Kq3EC2SIVWmr8xPMaKXYShZWw3PxnSePqewpsw/Iw+jgLKHYZxGkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754447556; c=relaxed/simple;
	bh=eRjTh7Thw+ynt0u16/18ufjyO+K1AoiCTpo0HkXncnY=;
	h=Date:To:From:Subject:Message-Id; b=iWsYOBqbUYSaMBNIV8XE48smcOP3titsM4myAOMlFsqhdghKfCyOLcM5cw2NRrod7VLnQftRbKLEE+AkieK9Xiu/lW+Pi/aZQ0ycryu96soajOUqsGojzQMerV1XICRQw4eIrn2x1SPQdhvw7goRpupE34zTrRX40kKFYu8wuPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ltGpi4g8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ltGpi4g8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17936C4CEF0;
	Wed,  6 Aug 2025 02:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754447555;
	bh=eRjTh7Thw+ynt0u16/18ufjyO+K1AoiCTpo0HkXncnY=;
	h=Date:To:From:Subject:From;
	b=ltGpi4g8gKgVAjplPxZoOENap00KL3lUSCzbWuQuKu/UU4CI7i90JPbF+TfcCktn3
	 vJLXO8FjKkyEM0TBJ6K2czuM2VKmH9mgMbMwO261OKeO2H6VIS+NUp4NAdXqJiUKQ2
	 xo/BoZHGj2+WQSUjWPIw8cp6QqhpKaUaM58J9irA=
Date: Tue, 05 Aug 2025 19:32:34 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kasan-move-kasan=-code-to-common-place.patch added to mm-new branch
Message-Id: <20250806023235.17936C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/kasan: move kasan= code to common place
has been added to the -mm mm-new branch.  Its filename is
     mm-kasan-move-kasan=-code-to-common-place.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kasan-move-kasan=-code-to-common-place.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Baoquan He <bhe@redhat.com>
Subject: mm/kasan: move kasan= code to common place
Date: Tue, 5 Aug 2025 14:23:31 +0800

This allows generic and sw_tags to be set in kernel cmdline too.

When at it, rename 'kasan_arg' to 'kasan_arg_disabled' as a bool variable.
And expose 'kasan_flag_enabled' to kasan common place too.

This is prepared for later adding kernel parameter kasan=on|off for
all kasan modes.

Link: https://lkml.kernel.org/r/20250805062333.121553-3-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kasan-enabled.h |    4 ++-
 mm/kasan/common.c             |   27 ++++++++++++++++++++++++
 mm/kasan/hw_tags.c            |   35 +-------------------------------
 3 files changed, 32 insertions(+), 34 deletions(-)

--- a/include/linux/kasan-enabled.h~mm-kasan-move-kasan=-code-to-common-place
+++ a/include/linux/kasan-enabled.h
@@ -4,10 +4,12 @@
 
 #include <linux/static_key.h>
 
-#ifdef CONFIG_KASAN_HW_TAGS
+extern bool kasan_arg_disabled;
 
 DECLARE_STATIC_KEY_FALSE(kasan_flag_enabled);
 
+#ifdef CONFIG_KASAN_HW_TAGS
+
 static __always_inline bool kasan_enabled(void)
 {
 	return static_branch_likely(&kasan_flag_enabled);
--- a/mm/kasan/common.c~mm-kasan-move-kasan=-code-to-common-place
+++ a/mm/kasan/common.c
@@ -32,6 +32,33 @@
 #include "kasan.h"
 #include "../slab.h"
 
+/*
+ * Whether KASAN is enabled at all.
+ * The value remains false until KASAN is initialized.
+ */
+DEFINE_STATIC_KEY_FALSE(kasan_flag_enabled);
+EXPORT_SYMBOL(kasan_flag_enabled);
+
+bool kasan_arg_disabled;
+/* kasan=off/on */
+static int __init early_kasan_flag(char *arg)
+{
+	if (!arg)
+		return -EINVAL;
+
+	if (!strcmp(arg, "off"))
+		kasan_arg_disabled = true;
+	else if (!strcmp(arg, "on"))
+		kasan_arg_disabled = false;
+	else
+		return -EINVAL;
+
+	return 0;
+}
+early_param("kasan", early_kasan_flag);
+
+
+
 struct slab *kasan_addr_to_slab(const void *addr)
 {
 	if (virt_addr_valid(addr))
--- a/mm/kasan/hw_tags.c~mm-kasan-move-kasan=-code-to-common-place
+++ a/mm/kasan/hw_tags.c
@@ -22,12 +22,6 @@
 
 #include "kasan.h"
 
-enum kasan_arg {
-	KASAN_ARG_DEFAULT,
-	KASAN_ARG_OFF,
-	KASAN_ARG_ON,
-};
-
 enum kasan_arg_mode {
 	KASAN_ARG_MODE_DEFAULT,
 	KASAN_ARG_MODE_SYNC,
@@ -41,18 +35,10 @@ enum kasan_arg_vmalloc {
 	KASAN_ARG_VMALLOC_ON,
 };
 
-static enum kasan_arg kasan_arg __ro_after_init;
 static enum kasan_arg_mode kasan_arg_mode __ro_after_init;
 static enum kasan_arg_vmalloc kasan_arg_vmalloc __initdata;
 
 /*
- * Whether KASAN is enabled at all.
- * The value remains false until KASAN is initialized by kasan_init_hw_tags().
- */
-DEFINE_STATIC_KEY_FALSE(kasan_flag_enabled);
-EXPORT_SYMBOL(kasan_flag_enabled);
-
-/*
  * Whether the selected mode is synchronous, asynchronous, or asymmetric.
  * Defaults to KASAN_MODE_SYNC.
  */
@@ -85,23 +71,6 @@ unsigned int kasan_page_alloc_sample_ord
 
 DEFINE_PER_CPU(long, kasan_page_alloc_skip);
 
-/* kasan=off/on */
-static int __init early_kasan_flag(char *arg)
-{
-	if (!arg)
-		return -EINVAL;
-
-	if (!strcmp(arg, "off"))
-		kasan_arg = KASAN_ARG_OFF;
-	else if (!strcmp(arg, "on"))
-		kasan_arg = KASAN_ARG_ON;
-	else
-		return -EINVAL;
-
-	return 0;
-}
-early_param("kasan", early_kasan_flag);
-
 /* kasan.mode=sync/async/asymm */
 static int __init early_kasan_mode(char *arg)
 {
@@ -209,7 +178,7 @@ void kasan_init_hw_tags_cpu(void)
 	 * When this function is called, kasan_flag_enabled is not yet
 	 * set by kasan_init_hw_tags(). Thus, check kasan_arg instead.
 	 */
-	if (kasan_arg == KASAN_ARG_OFF)
+	if (kasan_arg_disabled)
 		return;
 
 	/*
@@ -227,7 +196,7 @@ void __init kasan_init_hw_tags(void)
 		return;
 
 	/* If KASAN is disabled via command line, don't initialize it. */
-	if (kasan_arg == KASAN_ARG_OFF)
+	if (kasan_arg_disabled)
 		return;
 
 	switch (kasan_arg_mode) {
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-kasan-add-conditional-checks-in-functions-to-return-directly-if-kasan-is-disabled.patch
mm-kasan-move-kasan=-code-to-common-place.patch
mm-kasan-dont-initialize-kasan-if-its-disabled.patch
mm-kasan-make-kasan=onoff-take-effect-for-all-three-modes.patch

