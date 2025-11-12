Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5BD14B96E
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762908590; cv=none; b=TQodrpsgba8UX4kD7nJvLYMzIe/L8kc0Cr/9zRIhVhL3tgEhQ4bl30A6ZLKAJX6pdbuXowLH8oMaJ5TY7DxhT541GbHpCfZvVErqwYUQfJUBgKxjLJWtWvqAXNbF4TSjdJneT8lDaa32Sw2QFWmyAj4ftHpPQ4zRsiykzrosBI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762908590; c=relaxed/simple;
	bh=82eLJqif0LTcQbzbbpce2ZbW6u+QzZ1Pez6LGB8KB5I=;
	h=Date:To:From:Subject:Message-Id; b=O125Nc8m226G++N0NIFpJ4Z0PEc6noAGycBzcB9wVgrVNkGtsu1mNC0dg6gfnMT+aXcGg/1MGPrUsQIxLTFzZE6fJnF3qccJkiECPpbMSbAD2pLLhT2QsKtRamkXZ+w6DcTJENGrc38UX21s47ICti4Xq/Kdx4kmEIWe8W3Gzhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XUa25gEz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XUa25gEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 570CBC4CEF5;
	Wed, 12 Nov 2025 00:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762908590;
	bh=82eLJqif0LTcQbzbbpce2ZbW6u+QzZ1Pez6LGB8KB5I=;
	h=Date:To:From:Subject:From;
	b=XUa25gEz8Ej3AmZJLHHRuh9rpV9HFM+spPOL26z/jzcXlCjJhypQwbziJ+AkOjYd1
	 d0PfwUXHb9E7HzB2ztUsALh6Bl/IEDz8Y91Z0qovFNUn2Q3I8MRDrDNvu+8VYtQUKc
	 ePHpK2IlVNHoQgape+rwKTXrnnxstQ52HiMssIgs=
Date: Tue, 11 Nov 2025 16:49:49 -0800
To: mm-commits@vger.kernel.org,samitolvanen@google.com,rdunlap@infradead.org,pmladek@suse.com,mcgrof@kernel.org,atomlin@atomlin.com,petr.pavlu@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] taint-module-remove-unnecessary-taint_flagmodule-field.patch removed from -mm tree
Message-Id: <20251112004950.570CBC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: taint/module: remove unnecessary taint_flag.module field
has been removed from the -mm tree.  Its filename was
     taint-module-remove-unnecessary-taint_flagmodule-field.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Petr Pavlu <petr.pavlu@suse.com>
Subject: taint/module: remove unnecessary taint_flag.module field
Date: Wed, 22 Oct 2025 10:28:04 +0200

The TAINT_RANDSTRUCT and TAINT_FWCTL flags are mistakenly set in the
taint_flags table as per-module flags.  While this can be trivially
corrected, the issue can be avoided altogether by removing the
taint_flag.module field.

This is possible because, since commit 7fd8329ba502 ("taint/module: Clean
up global and module taint flags handling") in 2016, the handling of
module taint flags has been fully generic.  Specifically,
module_flags_taint() can print all flags, and the required output buffer
size is properly defined in terms of TAINT_FLAGS_COUNT.  The actual
per-module flags are always those added to module.taints by calls to
add_taint_module().

Link: https://lkml.kernel.org/r/20251022082938.26670-1-petr.pavlu@suse.com
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Acked-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Aaron Tomlin <atomlin@atomlin.com>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/panic.h |    1 
 kernel/module/main.c  |    2 -
 kernel/panic.c        |   46 ++++++++++++++++++----------------------
 3 files changed, 22 insertions(+), 27 deletions(-)

--- a/include/linux/panic.h~taint-module-remove-unnecessary-taint_flagmodule-field
+++ a/include/linux/panic.h
@@ -86,7 +86,6 @@ static inline void set_arch_panic_timeou
 struct taint_flag {
 	char c_true;		/* character printed when tainted */
 	char c_false;		/* character printed when not tainted */
-	bool module;		/* also show as a per-module taint flag */
 	const char *desc;	/* verbose description of the set taint flag */
 };
 
--- a/kernel/module/main.c~taint-module-remove-unnecessary-taint_flagmodule-field
+++ a/kernel/module/main.c
@@ -954,7 +954,7 @@ size_t module_flags_taint(unsigned long
 	int i;
 
 	for (i = 0; i < TAINT_FLAGS_COUNT; i++) {
-		if (taint_flags[i].module && test_bit(i, &taints))
+		if (test_bit(i, &taints))
 			buf[l++] = taint_flags[i].c_true;
 	}
 
--- a/kernel/panic.c~taint-module-remove-unnecessary-taint_flagmodule-field
+++ a/kernel/panic.c
@@ -628,17 +628,13 @@ void panic(const char *fmt, ...)
 }
 EXPORT_SYMBOL(panic);
 
-#define TAINT_FLAG(taint, _c_true, _c_false, _module)			\
+#define TAINT_FLAG(taint, _c_true, _c_false)				\
 	[ TAINT_##taint ] = {						\
 		.c_true = _c_true, .c_false = _c_false,			\
-		.module = _module,					\
 		.desc = #taint,						\
 	}
 
 /*
- * TAINT_FORCED_RMMOD could be a per-module flag but the module
- * is being removed anyway.
- *
  * NOTE: if you modify the taint_flags or TAINT_FLAGS_COUNT,
  * please also modify tools/debugging/kernel-chktaint and
  * Documentation/admin-guide/tainted-kernels.rst, including its
@@ -646,26 +642,26 @@ EXPORT_SYMBOL(panic);
  * /proc/sys/kernel/tainted.
  */
 const struct taint_flag taint_flags[TAINT_FLAGS_COUNT] = {
-	TAINT_FLAG(PROPRIETARY_MODULE,		'P', 'G', true),
-	TAINT_FLAG(FORCED_MODULE,		'F', ' ', true),
-	TAINT_FLAG(CPU_OUT_OF_SPEC,		'S', ' ', false),
-	TAINT_FLAG(FORCED_RMMOD,		'R', ' ', false),
-	TAINT_FLAG(MACHINE_CHECK,		'M', ' ', false),
-	TAINT_FLAG(BAD_PAGE,			'B', ' ', false),
-	TAINT_FLAG(USER,			'U', ' ', false),
-	TAINT_FLAG(DIE,				'D', ' ', false),
-	TAINT_FLAG(OVERRIDDEN_ACPI_TABLE,	'A', ' ', false),
-	TAINT_FLAG(WARN,			'W', ' ', false),
-	TAINT_FLAG(CRAP,			'C', ' ', true),
-	TAINT_FLAG(FIRMWARE_WORKAROUND,		'I', ' ', false),
-	TAINT_FLAG(OOT_MODULE,			'O', ' ', true),
-	TAINT_FLAG(UNSIGNED_MODULE,		'E', ' ', true),
-	TAINT_FLAG(SOFTLOCKUP,			'L', ' ', false),
-	TAINT_FLAG(LIVEPATCH,			'K', ' ', true),
-	TAINT_FLAG(AUX,				'X', ' ', true),
-	TAINT_FLAG(RANDSTRUCT,			'T', ' ', true),
-	TAINT_FLAG(TEST,			'N', ' ', true),
-	TAINT_FLAG(FWCTL,			'J', ' ', true),
+	TAINT_FLAG(PROPRIETARY_MODULE,		'P', 'G'),
+	TAINT_FLAG(FORCED_MODULE,		'F', ' '),
+	TAINT_FLAG(CPU_OUT_OF_SPEC,		'S', ' '),
+	TAINT_FLAG(FORCED_RMMOD,		'R', ' '),
+	TAINT_FLAG(MACHINE_CHECK,		'M', ' '),
+	TAINT_FLAG(BAD_PAGE,			'B', ' '),
+	TAINT_FLAG(USER,			'U', ' '),
+	TAINT_FLAG(DIE,				'D', ' '),
+	TAINT_FLAG(OVERRIDDEN_ACPI_TABLE,	'A', ' '),
+	TAINT_FLAG(WARN,			'W', ' '),
+	TAINT_FLAG(CRAP,			'C', ' '),
+	TAINT_FLAG(FIRMWARE_WORKAROUND,		'I', ' '),
+	TAINT_FLAG(OOT_MODULE,			'O', ' '),
+	TAINT_FLAG(UNSIGNED_MODULE,		'E', ' '),
+	TAINT_FLAG(SOFTLOCKUP,			'L', ' '),
+	TAINT_FLAG(LIVEPATCH,			'K', ' '),
+	TAINT_FLAG(AUX,				'X', ' '),
+	TAINT_FLAG(RANDSTRUCT,			'T', ' '),
+	TAINT_FLAG(TEST,			'N', ' '),
+	TAINT_FLAG(FWCTL,			'J', ' '),
 };
 
 #undef TAINT_FLAG
_

Patches currently in -mm which might be from petr.pavlu@suse.com are


