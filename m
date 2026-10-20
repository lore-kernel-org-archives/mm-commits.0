Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792532209;
	b=i3u7KPmyEO3cBSIch8gjNr3PGDRuqzOarP2v0C+zNoiRX7Z5Hu4sicKDv8EjWfT9DlZ/
	 K08G7MwM7dGWxlC6QP5xyy1iaYGMfKfrYeCcnivTVfZAmzNkAfgEoWbIK6RXqtkmtG56p
	 KbUJyeMb2vhq+DEt9w9n7nafXHbeb9/seMNnwdOtrGzcufbP0jbcDZEzIVrZa3jHmto2Y
	 HBvda3mOnrdL/D0GmmVk2blD6JUoGVjiESYSf6RHr6Lm8daEsn2k0cyc8E7YqDMmM3kew
	 SQXkPKKNFcngOeIwNZjFeUntA4HHL9hoaNRP50FGYKKCAoRx8zid3bmlXkA8MbehsMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792532209;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Vh11N3uQTXgEOuV6/jbsee5+owt5Eb/8drsv7AKClOg=;
	b=MVAfFiYR4023Q2LEBWs9wRjPX95aEUBkjGLvW8sMdKr3dugEG+chCMnnz+L4WEE19VZw
	 kdiLFzMpqbUJaxErpeT0HJCWiSVMKud4hyCJbbW4w5/sSzCh162+UKo1KiBvmp5eUbT9T
	 xRMPO5/AlFHnSJe1AFTAOeGPUgVcUV6rT3jUDiDNlgZg6hbt6VFuSyZjmJuHPg5aev3KP
	 2lrs8ueQm/EWvd5WaD1ZdNbA3f92O5znG/FcXC4ao2WdcKdQ0BR7VQbFW0+gprkXqycFp
	 Bp9XzyORo/uHRb2NFdnSfzVptvJmzWO4rAKHHnlzyXbuzh/apVZ6+zqea7gDxQiY/RA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=CS8PDVUy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70066606A31A;
	Tue, 20 Oct 2026 21:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=CS8PDVUy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5FD1F000C9;
	Tue, 20 Oct 2026 21:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792532209;
	bh=Vh11N3uQTXgEOuV6/jbsee5+owt5Eb/8drsv7AKClOg=;
	h=Date:To:From:Subject;
	b=CS8PDVUyFuR5OTfF1G0b0h6JeLoxF7w1wwxjDeqc18ze1BDDzzfmsvXaOTeQCPkdX
	 Mq+04CUDrIYdHR+dmPJ6C2gKOFGtJMxnz09kJVbnig6D/oIyJzAeS6oLVafiUwR3vo
	 6sDG1x8feMAR8qy0b03TkCms46f6mUtPhWH2Zbwc=
Date: Tue, 20 Oct 2026 14:36:48 -0700
To: mm-commits@vger.kernel.org,tglx@kernel.org,stable@vger.kernel.org,arnd@arndb.de,akpm@linux-foundation.org,dennylin0707@gmail.com
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + compat-avoid-double-rounding-in-times.patch added to mm-nonmm-unstable branch
Message-Id: <20261020213649.2C5FD1F000C9@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: compat: avoid double rounding in times()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     compat-avoid-double-rounding-in-times.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/compat-avoid-double-rounding-in-times.patch

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
From: Hungyu Lin <dennylin0707@gmail.com>
Subject: compat: avoid double rounding in times()
Date: Tue, 20 Oct 2026 21:01:57 +0000

do_sys_times() already converts CPU time to USER_HZ ticks.  The compat
path converts each value back to jiffies before converting it to
COMPAT_USER_HZ.  This round trip can lose precision even when the two
userspace rates match.

With HZ=250 and USER_HZ=COMPAT_USER_HZ=100, one user tick becomes two
jiffies and then zero compat ticks.  Every odd tick count loses one tick,
so any of the four tms fields can underreport CPU time by an additional 10
ms.

Return the value directly when the native and compat units match.  Keep
the existing conversion for differing rates.

Link: https://lore.kernel.org/20261020210157.52057-1-dennylin0707@gmail.com
Fixes: f06febc96ba8 ("timers: fix itimer/many thread hang")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: <stable@vger.kernel.org>
---

 kernel/sys.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/sys.c~compat-avoid-double-rounding-in-times
+++ a/kernel/sys.c
@@ -1077,6 +1077,9 @@ SYSCALL_DEFINE1(times, struct tms __user
 #ifdef CONFIG_COMPAT
 static compat_clock_t clock_t_to_compat_clock_t(clock_t x)
 {
+	if (USER_HZ == COMPAT_USER_HZ)
+		return x;
+
 	return compat_jiffies_to_clock_t(clock_t_to_jiffies(x));
 }
 
_

Patches currently in -mm which might be from dennylin0707@gmail.com are

compat-avoid-double-rounding-in-times.patch

