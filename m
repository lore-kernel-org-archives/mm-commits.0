Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8773B371867
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028751; cv=none; b=YtI/pp5tSMrpKon6ZqCWOaBz0NV/xajnq4npZ5gqnwVZdRZzEJ64hrz7kNG3hkui+gUAESJtFAGp2JF0f3hZIKFZagcpITx0nihre62DgIp2UdliJxdj6kVXY6Ev/OCsxgmqQkc6a9ragQ1dpH9JlnJxWzwH+8cx5T7wE5inKPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028751; c=relaxed/simple;
	bh=kWEfuPilnOD4YU9c4R0KbqBsaOKLgwGcRHppFh0x2QA=;
	h=Date:To:From:Subject:Message-Id; b=Ikpu3Q3ubwTmuHJjELHd5wzDb6vuhTP8JhJdnKTnTi3SZiBEWZc6BYSIXTd/qrl4EcIkfS1xuOeCxVmJJB3vsjB22cVSAcM9IXFrt6Ek3tDu6I6mFpApz+zsrAERe4iDMHh4WJSBdn3vEUxwEvx1ezq3+Yhv2qgiBrHWV3Xtgoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lRfkgupj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lRfkgupj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE5CF1F00893;
	Fri, 29 May 2026 04:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028750;
	bh=F/9Nq6Gd62B2EGs+oNYziP3858F0H4Va+QU96VCss8Y=;
	h=Date:To:From:Subject;
	b=lRfkgupjslIEgjsU5rbCQ3p4sVjVkadIUVTuqapoMUFgD1jv0COH9qQZgjrJ4inXB
	 dd7fYeBD1YkGpCTGds4YE5Xs8BvtHWxC+wGRjdOzss8cTSyvkYAejFjCvMrKJs8XKs
	 1RZb1LTmnM3Pkr0FGc5UtH2GHnes9dEwU+k/Drfo=
Date: Thu, 28 May 2026 21:25:48 -0700
To: mm-commits@vger.kernel.org,pmladek@suse.com,peterz@infradead.org,nsc@kernel.org,nathan@kernel.org,kees@kernel.org,jpoimboe@kernel.org,elver@google.com,dmitry.torokhov@gmail.com,andriy.shevchenko@linux.intel.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] inith-discard-exitcall-symbols-early.patch removed from -mm tree
Message-Id: <20260529042549.CE5CF1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: init.h: discard exitcall symbols early
has been removed from the -mm tree.  Its filename was
     inith-discard-exitcall-symbols-early.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: init.h: discard exitcall symbols early
Date: Tue, 31 Mar 2026 16:28:38 +0200

Any __exitcall() and built-in module_exit() handler is marked as __used,
which leads to the code being included in the object file and later
discarded at link time.

As far as I can tell, this was originally added at the same time as
initcalls were marked the same way, to prevent them from getting dropped
with gcc-3.4, but it was never actaully necessary to keep exit functions
around.

Mark them as __maybe_unused instead, which lets the compiler treat the
exitcalls as entirely unused, and make better decisions about dropping
specializing static functions called from these.

Link: https://lore.kernel.org/all/acruxMNdnUlyRHiy@google.com/
Link: https://lore.kernel.org/20260331142846.3187706-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Nicolas Schier <nsc@kernel.org>
Cc: Andriy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Marco Elver <elver@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/init.h~inith-discard-exitcall-symbols-early
+++ a/include/linux/init.h
@@ -47,7 +47,7 @@
 #define __initdata	__section(".init.data")
 #define __initconst	__section(".init.rodata")
 #define __exitdata	__section(".exit.data")
-#define __exit_call	__used __section(".exitcall.exit")
+#define __exit_call	__maybe_unused __section(".exitcall.exit")
 
 /*
  * modpost check for section mismatches during the kernel build.
_

Patches currently in -mm which might be from arnd@arndb.de are

errh-use-__always_inline-on-all-error-pointer-helpers.patch

