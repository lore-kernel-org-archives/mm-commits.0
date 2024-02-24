Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920B18F58
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739405; cv=none; b=N3bldjzm31C493AY0IH5wP3GoNtKIcNJQybIBhpg2boCh13WmCoPJK+djfwfd9SkDNIlEXWmqzw7SElsu+OX5VNWs/xVdQ2vOLBwdPNftYQHO43gv8VyL22+AAUJkpZ9gyk7aBfhdmsHTxK5P8SjSJBIimsv43LHTavy4MvSAAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739405; c=relaxed/simple;
	bh=xhjIiwB6TC3QVKRLpWTlqpdXagy9xsgeyR8HEazB5hc=;
	h=Date:To:From:Subject:Message-Id; b=uw8hvb3n686j9G7OfEb7isdFtF+iZMLNsyl7YmxIZyOsoS6xpridLNo2DSdumF5yOVtxB7Ga0FQTil3lzYaWRYBi5EZK4PNB5thdM6tVCgMXLuM4z3fGmW9O64zh02JzvgVyBnGhb95tM7BpyI0GeJAFe3VBjECDP5XWd675Wzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ROzxIBcN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ROzxIBcN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ADC1C433F1;
	Sat, 24 Feb 2024 01:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739405;
	bh=xhjIiwB6TC3QVKRLpWTlqpdXagy9xsgeyR8HEazB5hc=;
	h=Date:To:From:Subject:From;
	b=ROzxIBcN7JZV8xATcjTWe/hdNG3yeD1dYqWbgTQqvTk3gN9uL3+4dab1u9ph+9tYP
	 BeIhCISZUnJhP9WA2fWHOAfzP/fUA1tzJGi1l7y3UG2sxisdQg2wviWGiO68CHTx9M
	 GFwk0k3Wsr25AZDzzGcxQ/wEjsKHKgg85VfHjbl0=
Date: Fri, 23 Feb 2024 17:50:04 -0800
To: mm-commits@vger.kernel.org,yang.lee@linux.alibaba.com,viro@zeniv.linux.org.uk,sfr@canb.auug.org.au,piliu@redhat.com,nathan@kernel.org,mhklinux@outlook.com,klarasmodin@gmail.com,hbathini@linux.ibm.com,ebiederm@xmission.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch removed from -mm tree
Message-Id: <20240224015005.6ADC1C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm, crash: wrap crash dumping code into crash related ifdefs
has been removed from the -mm tree.  Its filename was
     arm-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: arm, crash: wrap crash dumping code into crash related ifdefs
Date: Wed, 24 Jan 2024 13:12:53 +0800

Now crash codes under kernel/ folder has been split out from kexec
code, crash dumping can be separated from kexec reboot in config
items on arm with some adjustments.

Here use CONFIG_CRASH_RESERVE ifdef to replace CONFIG_KEXEC ifdef.

Link: https://lkml.kernel.org/r/20240124051254.67105-14-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Pingfan Liu <piliu@redhat.com>
Cc: Klara Modin <klarasmodin@gmail.com>
Cc: Michael Kelley <mhklinux@outlook.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/setup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/kernel/setup.c~arm-crash-wrap-crash-dumping-code-into-crash-related-ifdefs
+++ a/arch/arm/kernel/setup.c
@@ -979,7 +979,7 @@ static int __init init_machine_late(void
 }
 late_initcall(init_machine_late);
 
-#ifdef CONFIG_KEXEC
+#ifdef CONFIG_CRASH_RESERVE
 /*
  * The crash region must be aligned to 128MB to avoid
  * zImage relocating below the reserved region.
@@ -1066,7 +1066,7 @@ static void __init reserve_crashkernel(v
 }
 #else
 static inline void reserve_crashkernel(void) {}
-#endif /* CONFIG_KEXEC */
+#endif /* CONFIG_CRASH_RESERVE*/
 
 void __init hyp_mode_check(void)
 {
_

Patches currently in -mm which might be from bhe@redhat.com are


