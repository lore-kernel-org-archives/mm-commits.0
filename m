Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CE87EF
	for <mm-commits@vger.kernel.org>; Sat,  1 Jun 2024 00:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717200388; cv=none; b=ElJgfteZsvTSio1UKqaejV8FmgCHf4ypR+wUCCG03kJt42wONKFtLjjwHgYESXj+saQleqTFTfg49G2O1cOb4MAwFfDMna9o+AzVoQypmLKMTMRP+ERlBlnRVT5+a7ZJJ48eo5DAm10ieJf55Q+yfUUoKzrgCAqktWyZLP1mulw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717200388; c=relaxed/simple;
	bh=xUgOMu75S2suyUhpWmBMti90GYeSg9sNUsWc9efkiYk=;
	h=Date:To:From:Subject:Message-Id; b=MI/hc1c/vLNiRs9SyncAchqADr9dxh4AxhZJb42qUjsJyIhSxOwBF841tcwban7UT7yWzXZE1zOYKYS0+qsVb0Zga4ais7qSUxP3N4hvJrTUhwRiZAYJp4jWnEZeHt/wlYFh42gbwU2ny4rdseKjQCtp0awv4wwgOUs9NbatmBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bmBJ3eIy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bmBJ3eIy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F7CC116B1;
	Sat,  1 Jun 2024 00:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717200388;
	bh=xUgOMu75S2suyUhpWmBMti90GYeSg9sNUsWc9efkiYk=;
	h=Date:To:From:Subject:From;
	b=bmBJ3eIyYs0KdSECXQMGw0LwbGcy70k13a+Y0qGGnbR6Zu9x46X7xql3HtXnAuUYA
	 XU9v8MLO6dHtRr8TGfM1LrjbmiwvAQoZFh6UWEOt2WLCsZsZib2c9HGF5OJroFWzOa
	 YmVHjDPuNa1Cd8FUyigJvh2yquzmza5RglIQj140=
Date: Fri, 31 May 2024 17:06:27 -0700
To: mm-commits@vger.kernel.org,gregkh@linuxfoundation.org,jani.nikula@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-panic-initialize-taint_flags-using-a-macro.patch added to mm-nonmm-unstable branch
Message-Id: <20240601000628.10F7CC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel/panic: initialize taint_flags[] using a macro
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-panic-initialize-taint_flags-using-a-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-panic-initialize-taint_flags-using-a-macro.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Jani Nikula <jani.nikula@intel.com>
Subject: kernel/panic: initialize taint_flags[] using a macro
Date: Fri, 31 May 2024 12:04:56 +0300

Make it easier to extend struct taint_flags in follow-up.

Link: https://lkml.kernel.org/r/8a2498285d37953cfad9dce939ed3abef61051bd.1717146197.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |   46 +++++++++++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 19 deletions(-)

--- a/kernel/panic.c~kernel-panic-initialize-taint_flags-using-a-macro
+++ a/kernel/panic.c
@@ -471,32 +471,40 @@ void panic(const char *fmt, ...)
 
 EXPORT_SYMBOL(panic);
 
+#define TAINT_FLAG(taint, _c_true, _c_false, _module)			\
+	[ TAINT_##taint ] = {						\
+		.c_true = _c_true, .c_false = _c_false,			\
+		.module = _module,					\
+	}
+
 /*
  * TAINT_FORCED_RMMOD could be a per-module flag but the module
  * is being removed anyway.
  */
 const struct taint_flag taint_flags[TAINT_FLAGS_COUNT] = {
-	[ TAINT_PROPRIETARY_MODULE ]	= { 'P', 'G', true },
-	[ TAINT_FORCED_MODULE ]		= { 'F', ' ', true },
-	[ TAINT_CPU_OUT_OF_SPEC ]	= { 'S', ' ', false },
-	[ TAINT_FORCED_RMMOD ]		= { 'R', ' ', false },
-	[ TAINT_MACHINE_CHECK ]		= { 'M', ' ', false },
-	[ TAINT_BAD_PAGE ]		= { 'B', ' ', false },
-	[ TAINT_USER ]			= { 'U', ' ', false },
-	[ TAINT_DIE ]			= { 'D', ' ', false },
-	[ TAINT_OVERRIDDEN_ACPI_TABLE ]	= { 'A', ' ', false },
-	[ TAINT_WARN ]			= { 'W', ' ', false },
-	[ TAINT_CRAP ]			= { 'C', ' ', true },
-	[ TAINT_FIRMWARE_WORKAROUND ]	= { 'I', ' ', false },
-	[ TAINT_OOT_MODULE ]		= { 'O', ' ', true },
-	[ TAINT_UNSIGNED_MODULE ]	= { 'E', ' ', true },
-	[ TAINT_SOFTLOCKUP ]		= { 'L', ' ', false },
-	[ TAINT_LIVEPATCH ]		= { 'K', ' ', true },
-	[ TAINT_AUX ]			= { 'X', ' ', true },
-	[ TAINT_RANDSTRUCT ]		= { 'T', ' ', true },
-	[ TAINT_TEST ]			= { 'N', ' ', true },
+	TAINT_FLAG(PROPRIETARY_MODULE,		'P', 'G', true),
+	TAINT_FLAG(FORCED_MODULE,		'F', ' ', true),
+	TAINT_FLAG(CPU_OUT_OF_SPEC,		'S', ' ', false),
+	TAINT_FLAG(FORCED_RMMOD,		'R', ' ', false),
+	TAINT_FLAG(MACHINE_CHECK,		'M', ' ', false),
+	TAINT_FLAG(BAD_PAGE,			'B', ' ', false),
+	TAINT_FLAG(USER,			'U', ' ', false),
+	TAINT_FLAG(DIE,				'D', ' ', false),
+	TAINT_FLAG(OVERRIDDEN_ACPI_TABLE,	'A', ' ', false),
+	TAINT_FLAG(WARN,			'W', ' ', false),
+	TAINT_FLAG(CRAP,			'C', ' ', true),
+	TAINT_FLAG(FIRMWARE_WORKAROUND,		'I', ' ', false),
+	TAINT_FLAG(OOT_MODULE,			'O', ' ', true),
+	TAINT_FLAG(UNSIGNED_MODULE,		'E', ' ', true),
+	TAINT_FLAG(SOFTLOCKUP,			'L', ' ', false),
+	TAINT_FLAG(LIVEPATCH,			'K', ' ', true),
+	TAINT_FLAG(AUX,				'X', ' ', true),
+	TAINT_FLAG(RANDSTRUCT,			'T', ' ', true),
+	TAINT_FLAG(TEST,			'N', ' ', true),
 };
 
+#undef TAINT_FLAG
+
 static void print_tainted_seq(struct seq_buf *s)
 {
 	int i;
_

Patches currently in -mm which might be from jani.nikula@intel.com are

kernel-panic-return-early-from-print_tainted-when-not-tainted.patch
kernel-panic-convert-print_tainted-to-use-struct-seq_buf-internally.patch
kernel-panic-initialize-taint_flags-using-a-macro.patch
kernel-panic-add-verbose-logging-of-kernel-taints-in-backtraces.patch

