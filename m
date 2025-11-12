Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99AE189F43
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762908307; cv=none; b=s0gaA9XENZLq+gAW2QKtSHYmtwbl7VSfrXzITHkeDyRY3aG0DF4wbEhf8KxgrpMlvge1I0tI+oWFxxEo9DQ72N8Jd1SvmMNikxgr+tXyuhtzOChvVZWrb6rAp7jyR+7rmQ4OB6DhER/6v/5FxMg9PRerPP1waaFKH9E71erMNdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762908307; c=relaxed/simple;
	bh=LoTeyhoB0zolxyOYTQWIic7/NvS6XFK37z3by9p8M5w=;
	h=Date:To:From:Subject:Message-Id; b=PoNphd11uVHN2oAmK4mjrnqDFU+W9aLa/StfzpnpleaIrcNCi/njX/jo3B128hEXlGQYbQ7tPhMraPZYhkZt8XoPkdF8cexQrCssXrAoDrrP+oOduopcr/6zHVwcS4x9Jq++SkZkyIadNcTkJa2YjXYvmi3XtVxATS0xFQMLokA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gVcbNaoj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gVcbNaoj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54BD1C4CEF5;
	Wed, 12 Nov 2025 00:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762908306;
	bh=LoTeyhoB0zolxyOYTQWIic7/NvS6XFK37z3by9p8M5w=;
	h=Date:To:From:Subject:From;
	b=gVcbNaojwePzdX5H8pZqD/u3OjHJwvagLLafcScIagP8t7Tep1Td9jXm2qjOEhKit
	 FNNx+15Pq+bOFCXT1N0mMxh6JsygCmQu8RXWp6UECrvVHAyf2DfzldXXnnenK2LOCs
	 zyoI+fWMVZpluNZPV9cydK4Ff+WUg5WwbS3ttkDQ=
Date: Tue, 11 Nov 2025 16:45:05 -0800
To: mm-commits@vger.kernel.org,tj@kernel.org,tglx@linutronix.de,svens@linux.ibm.com,shakeel.butt@linux.dev,rppt@kernel.org,rdunlap@infradead.org,peterz@infradead.org,paulmck@kernel.org,ojeda@kernel.org,nathan@kernel.org,mkoutny@suse.com,mingo@kernel.org,masahiroy@kernel.org,kernel@jfarr.cc,kees@kernel.org,jeffxu@chromium.org,hca@linux.ibm.com,guoweikang.kernel@gmail.com,geert@linux-m68k.org,francesco@valla.it,chenhuacai@kernel.org,brgerst@gmail.com,brauner@kernel.org,alexander.shishkin@linux.intel.com,achant@google.com,dianders@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs-v4.patch removed from -mm tree
Message-Id: <20251112004506.54BD1C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs-v4
has been removed from the -mm tree.  Its filename was
     init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs-v4.patch

This patch was dropped because it was folded into init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs.patch

------------------------------------------------------
From: Douglas Anderson <dianders@chromium.org>
Subject: init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs-v4
Date: Mon, 27 Oct 2025 08:22:13 -0700

- Use 0 instead of -1 to disable wrapping.
- If COMMAND_LINE_SIZE makes wrapping impossible then help compiler optimize.

Link: https://lkml.kernel.org/r/20251027082204.v4.1.I095f1e2c6c27f9f4de0b4841f725f356c643a13f@changeid
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andrew Chant <achant@google.com>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Francesco Valla <francesco@valla.it>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: guoweikang <guoweikang.kernel@gmail.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jan Hendrik Farr <kernel@jfarr.cc>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    4 ++--
 init/main.c  |    5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

--- a/init/Kconfig~init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs-v4
+++ a/init/Kconfig
@@ -1515,7 +1515,7 @@ config BOOT_CONFIG_EMBED_FILE
 config CMDLINE_LOG_WRAP_IDEAL_LEN
 	int "Length to try to wrap the cmdline when logged at boot"
 	default 1021
-	range -1 1021
+	range 0 1021
 	help
 	  At boot time, the kernel command line is logged to the console.
 	  The log message will start with the prefix "Kernel command line: ".
@@ -1526,7 +1526,7 @@ config CMDLINE_LOG_WRAP_IDEAL_LEN
 	  ideal length if a place to wrap isn't found before the specified
 	  number of characters.
 
-	  A value of -1 disables wrapping, though be warned that the maximum
+	  A value of 0 disables wrapping, though be warned that the maximum
 	  length of a log message (1021 characters) may cause the cmdline to
 	  be truncated.
 
--- a/init/main.c~init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs-v4
+++ a/init/main.c
@@ -948,8 +948,9 @@ static void __init print_kernel_cmdline(
 {
 	size_t len;
 
-	/* Config option of -1 disables wrapping */
-	if (CONFIG_CMDLINE_LOG_WRAP_IDEAL_LEN < 0) {
+	/* Config option of 0 or anything longer than the max disables wrapping */
+	if (CONFIG_CMDLINE_LOG_WRAP_IDEAL_LEN == 0 ||
+	    IDEAL_CMDLINE_LEN >= COMMAND_LINE_SIZE - 1) {
 		pr_notice("%s%s\n", KERNEL_CMDLINE_PREFIX, cmdline);
 		return;
 	}
_

Patches currently in -mm which might be from dianders@chromium.org are

init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs.patch

