Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17872EAB82
	for <mm-commits@vger.kernel.org>; Thu, 15 Jan 2026 20:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768507498; cv=none; b=ZGvITN+/PPEPe5DFUQUN9p5U1rEPEi0V575oM2n6PdU6m74hQEjuS18/1LDUicw8nMWs85upOnE2tpdubHXeKLRHmMpkFpaTfNKEkb8wJOHMKZfKSHVzFu8woA2kwI+EoiB/qRdpfc0IveZsarUqhTWRCBbHwFL+KBszuKwxKq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768507498; c=relaxed/simple;
	bh=PuGvtyB+1SXefGPYi3yuudaXcQdhXZ9V34deQtjJMJE=;
	h=Date:To:From:Subject:Message-Id; b=UlyOQ5XhisXYDBHMqPBpNXbJhLw4nOvQqHqHvcdCiTvoIPUOUSuCmyw4mFBjDRO/tGPiXvLsPs3YbcQZMNglEOojIa08ueLUuk6NMBvBDc6A3ZfzXxqFJuyVAA1EAxUsgaqveXFPt0SX5phE6KF9Z5l8KUtbFFuOR6SFu9ahoJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a3crWAy2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a3crWAy2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A238C16AAE;
	Thu, 15 Jan 2026 20:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768507498;
	bh=PuGvtyB+1SXefGPYi3yuudaXcQdhXZ9V34deQtjJMJE=;
	h=Date:To:From:Subject:From;
	b=a3crWAy2xu/OZqmzCCewAzJzdk0i19gcPZrInxZvW0ArtvyBm9iqMsb/7otOXIJOl
	 DKa0qb0O0yI5dCOh9UB6Jd3x+OeuyTT8/GlWD/Fe46Fb709JMHCWJP88lNwycZhN21
	 JkD+i8kOpDlRpiVP5kZj2DqMkUU3RGLpJbrQrq/A=
Date: Thu, 15 Jan 2026 12:04:57 -0800
To: mm-commits@vger.kernel.org,linux@leemhuis.info,corbet@lwn.net,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-chktaint-add-reporting-for-tainted-modules.patch added to mm-nonmm-unstable branch
Message-Id: <20260115200458.3A238C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel-chktaint: add reporting for tainted modules
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-chktaint-add-reporting-for-tainted-modules.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-chktaint-add-reporting-for-tainted-modules.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: kernel-chktaint: add reporting for tainted modules
Date: Wed, 14 Jan 2026 22:47:56 -0800

Check all loaded modules and report any that have their 'taint'
flags set.  The tainted module output format is:
 * <module_name> (<taint_flags>)

Example output:

Kernel is "tainted" for the following reasons:
 * externally-built ('out-of-tree') module was loaded  (#12)
 * unsigned module was loaded (#13)
Raw taint value as int/string: 12288/'G           OE      '

Tainted modules:
 * dump_test (OE)

Link: https://lkml.kernel.org/r/20260115064756.531592-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Thorsten Leemhuis <linux@leemhuis.info>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/debugging/kernel-chktaint |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/tools/debugging/kernel-chktaint~kernel-chktaint-add-reporting-for-tainted-modules
+++ a/tools/debugging/kernel-chktaint
@@ -211,9 +211,25 @@ else
 	addout "J"
 	echo " * fwctl's mutating debug interface was used (#19)"
 fi
+echo "Raw taint value as int/string: $taint/'$out'"
+
+# report on any tainted loadable modules
+[ "$1" = "" ] && [ -r /sys/module/ ] && \
+	cnt=`grep [A-Z] /sys/module/*/taint | wc -l` || cnt=0
 
+if [ $cnt -ne 0 ]; then
+	echo
+	echo "Tainted modules:"
+	for dir in `ls /sys/module` ; do
+		if [ -r /sys/module/$dir/taint ]; then
+			modtnt=`cat /sys/module/$dir/taint`
+			[ "$modtnt" = "" ] || echo " * $dir ($modtnt)"
+		fi
+	done
+fi
+
+echo
 echo "For a more detailed explanation of the various taint flags see"
 echo " Documentation/admin-guide/tainted-kernels.rst in the Linux kernel sources"
 echo " or https://kernel.org/doc/html/latest/admin-guide/tainted-kernels.html"
-echo "Raw taint value as int/string: $taint/'$out'"
 #EOF#
_

Patches currently in -mm which might be from rdunlap@infradead.org are

kernelh-drop-hexh-and-update-all-hexh-users.patch
kfifo-fix-kmalloc_array_node-argument-order.patch
kernel-chktaint-add-reporting-for-tainted-modules.patch

