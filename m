Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038148;
	b=Mz1849c+Cjo+qiWiOvkkZTFh+weBM5HgunTadv0I0ZxRf+oYBr2Kdtl00xmCAUEoYi+k
	 I7Yf2/wVITFKOdiwfTTVki1MCoZl6DCGjpPJyBZDPwDvRbhsFKXnX3IKX0VIRlHe3Vo/b
	 BiQRTE7xy6JM7oSlcFvrNok9HufbCjkPMXhvTjqvu0bs54K2+w0euQ1mYG9Wk/DFAaOOJ
	 fntqQCT3yw1TTilcvhTvB48DhQKAfpOgOep4OUEoRE/ud/INFCuN3lL2hy50KCnPd8zet
	 vQ3pwoWH1vj2R6TxgbLy4lZRSfeLOiyb0Sh+sdmG+pQCWii1WjkO3eBYBPybt6+J5wQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038148;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=BnAk/q9PE9OSgmOjl06zd9/5aDzvI+9VF/6vgx9+DNc=;
	b=mQ2keeR2z0e45xqyGvAC4CYd7OV8Q4QBCNTCNq/tCYr0Eya5Rl7M4D2iBMVPU9eeMuVb
	 mnrAXWE7YyKNDhAXs2+BvJrD71fg8paYldG44GrcK4rQMOssANfg5jqdJfXcyEwi3V9ZQ
	 j57J493GENZRTstQYqAGd3FV2VhZBlon/uOhX1rUWFjHF4X642E17X4Fcx1ikwA0kZ8fR
	 3PeXB6YyEQ0hB+b2aUbXOHzygJ1txEYf5YeOGR1+UmowUO4G1hU0muDFZ7Jp1K4mdo/WP
	 Jtcf6tFYNakoibo89Pji3bTY7r8POj4lU+qaraa9+LL40y9/ZWaqQDdTKrPu+FnoPIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=yJveHL7Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4095606A320
	for <mm-commits@vger.kernel.org>; Wed, 18 Nov 2026 21:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=yJveHL7Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 550B81F000C5;
	Wed, 18 Nov 2026 21:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795038148;
	bh=BnAk/q9PE9OSgmOjl06zd9/5aDzvI+9VF/6vgx9+DNc=;
	h=Date:To:From:Subject;
	b=yJveHL7YrSS6ikYKdVjI+EJHG9tWqLtG21Nxepy5m7vbPagFXLaoDJm++pHeMDheM
	 ECIsHwZqOETvWH82oPCZn/eBruUBjdE5SO130NcN/AtgASDfLLf3yvFpmjovRrtLs5
	 k33pi3at1vBtbbhQQJBYyJmq8fensq4uogPSYF+A=
Date: Wed, 18 Nov 2026 13:42:27 -0800
To: mm-commits@vger.kernel.org,sudipm.mukherjee@gmail.com,blum@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + parport-use-kstrdup-in-parse_data.patch added to mm-nonmm-unstable branch
Message-Id: <20261118214228.550B81F000C5@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: parport: use kstrdup() in parse_data()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     parport-use-kstrdup-in-parse_data.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/parport-use-kstrdup-in-parse_data.patch

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
From: Thorsten Blum <blum@kernel.org>
Subject: parport: use kstrdup() in parse_data()
Date: Wed, 18 Nov 2026 19:10:34 +0100

strcpy() has been deprecated [1] because it performs no bounds checking on
the destination buffer, which can lead to buffer overflows.

While the current code works correctly, replace kmalloc() and strcpy()
with a single kstrdup() call to simplify the code.

Link: https://lore.kernel.org/20261118181033.666623-3-blum@kernel.org
Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strcpy [1]
Signed-off-by: Thorsten Blum <blum@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>

 drivers/parport/probe.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/parport/probe.c~parport-use-kstrdup-in-parse_data
+++ a/drivers/parport/probe.c
@@ -52,7 +52,7 @@ static void pretty_print(struct parport
 
 static void parse_data(struct parport *port, int device, char *str)
 {
-	char *txt = kmalloc(strlen(str)+1, GFP_KERNEL);
+	char *txt = kstrdup(str, GFP_KERNEL);
 	char *p = txt, *q;
 	int guessed_class = PARPORT_CLASS_UNSPEC;
 	struct parport_device_info *info = &port->probe_info[device + 1];
@@ -61,7 +61,6 @@ static void parse_data(struct parport *p
 		pr_warn("%s probe: memory squeeze\n", port->name);
 		return;
 	}
-	strcpy(txt, str);
 	while (p) {
 		char *sep;
 		q = strchr(p, ';');
_

Patches currently in -mm which might be from blum@kernel.org are

init-reject-bare-rodata-parameter-before-architecture-parsing.patch
init-use-strscpy-in-do_initcalls.patch
init-use-kmalloc-in-do_initcalls.patch
init-remove-strlcat-and-sprintf-from-do_one_initcall.patch
init-use-strscpy-in-initcall_blacklist.patch
init-combine-blacklist-entry-allocations-in-initcall_blacklist.patch
parport-use-kstrdup-in-parse_data.patch

