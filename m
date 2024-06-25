Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19B0145344
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293199; cv=none; b=H22IxkRLwKXSFMZVVbgZHBEgNHRb8dV/Fm1qSGvWSQI8HeFpjYsLNjp5drMT7w01A8wjsMHYUESzIXeO4NR+YkBHEdthiPZMHMap0b0QG8dy82UbDREHAihuS7Yq/+Pw2hgyftp3Cell7Td7VJ8AE/yFLf4yB+B2nDm5tc4aypI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293199; c=relaxed/simple;
	bh=5hmcUSN1UmuogMXzXsx+4HOPehBOOE6JLwgg9aGkOiA=;
	h=Date:To:From:Subject:Message-Id; b=OAuoDI3SWPrT2A/tHx+VJX1thNPxKNXtwOXQcaf1ld/N/nISJyaQAjs7NHRKGotG51z65eL8z1Ln0D4rGp/eY8oDXCflP7xdgnVbtOqVBRx0mZiGzr7LPSfaUpM1JfA4FI9vPPHhQeJOrwJ+5SamNwTAfDHRb0DjvQzmku1Pn1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U+LrLe8s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U+LrLe8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A95C7C32789;
	Tue, 25 Jun 2024 05:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293199;
	bh=5hmcUSN1UmuogMXzXsx+4HOPehBOOE6JLwgg9aGkOiA=;
	h=Date:To:From:Subject:From;
	b=U+LrLe8sesWeW2Mfgh4jal3jesPvZKXSf5KB/t3iYJgkTWdSQOOfIB9ELNFoK/Zg5
	 Yefjif/JqZMz53PE0rew97m3zO9BVEOFPRR5eiLZ36AohuKutRB69QyWduyxcnCH84
	 qn+QgAuqxCzpi2DTMFkHe3qvyqdmwIBTUfgtuZHM=
Date: Mon, 24 Jun 2024 22:26:39 -0700
To: mm-commits@vger.kernel.org,gregkh@linuxfoundation.org,jani.nikula@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-panic-initialize-taint_flags-using-a-macro.patch removed from -mm tree
Message-Id: <20240625052639.A95C7C32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel/panic: initialize taint_flags[] using a macro
has been removed from the -mm tree.  Its filename was
     kernel-panic-initialize-taint_flags-using-a-macro.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jani Nikula <jani.nikula@intel.com>
Subject: kernel/panic: initialize taint_flags[] using a macro
Date: Fri, 31 May 2024 12:04:56 +0300

Make it easier to extend struct taint_flags in follow-up.

Link: https://lkml.kernel.org/r/8a2498285d37953cfad9dce939ed3abef61051bd.1717146197.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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


