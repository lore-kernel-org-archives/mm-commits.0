Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794608075;
	b=wCvyy+GLPnZzdq+zyRmpZhICU87sS9adGqtE0dbs/JN+vqxoTi/ebbFtvd17nK/hw0dG
	 wXSz987sUg++H/QrOkKTJj2raOYFiimnuvnufNgPbtTiPg7yCCgEkstKkYK2S+6eQGxCf
	 wKGQztJZTwZslxdJ54Ss44x4itm4ChoM2sXCT+BKkj0eIJVRH1GGMSGVN4ckejlKmSIf3
	 WDXo7yHrUvEQdcWHQ6raC6UO1hxh4YkUABnBFN383aHIewhcWZluNZODI1b80jhxsUrZJ
	 r9QmHfwVtw3UExPzEINpi2szztToWI4Pm56DrG3jBpEC25K7MRdWBzQ43UGEFMWWmYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794608075;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=VzYwFPp8tq8ZK3wMNVGeFhQd+GBORRi6QWz8pc86eLk=;
	b=QzxtEQPAe16so/04UHC0dmXffeqnufgaxT7GlZJfOtByTTTJ3TuwIF5hNeGbfOj/Lxud
	 TTAnq+etwcgG7vvNVslQEzrdDPKmXGSEZx4/s+3ah/YWE2unIlx37GdqRLhtMDYjKNcAK
	 E+CkRa+KP3hwWC8+fgI9CONIHSeCPdMMZCbtzKRl2uI3r1RIc1GqyTRjRECTLbvIV4Qyf
	 N9TC6jGCHgur4bqcLc6jwg3m9q/lrhbKftMqR1aYqPiGqA8fI2M0q/IeR17aGU1QUsSsC
	 aQwQJQ8dO0qEPl6KpAXoeG+4rdj18NoAvFSGyY5x1ghatHWBNjCBxDFUTS60xw4kBZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=goaoJFfV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA0C606A88A
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 22:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=goaoJFfV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506231F000C5;
	Fri, 13 Nov 2026 22:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794608075;
	bh=VzYwFPp8tq8ZK3wMNVGeFhQd+GBORRi6QWz8pc86eLk=;
	h=Date:To:From:Subject;
	b=goaoJFfV8DaJLXiElwyjCkEDk8TvSWzAZ5HfII1Um2e3undFAUteQ6YfLY6dOVSu/
	 9SzGlSEoADSweeU3eYULsIspJfiHYgyXiL6ND13NWVMdutxMvB9uS9kSMV1Dza1eMN
	 EONC5tYhxMwHs8Mdg+9mT1TffRqVrOl2qJ1XQNl8=
Date: Fri, 13 Nov 2026 14:14:34 -0800
To: mm-commits@vger.kernel.org,wfelipe@google.com,ryan.roberts@arm.com,
	rppt@kernel.org,mhiramat@kernel.org,leitao@debian.org,ekffu200098@gmail.com,
	brauner@kernel.org,blum@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + init-reject-bare-rodata-parameter-before-architecture-parsing.patch added to mm-nonmm-unstable branch
Message-Id: <20261113221435.506231F000C5@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: init: reject bare rodata parameter before architecture parsing
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     init-reject-bare-rodata-parameter-before-architecture-parsing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-reject-bare-rodata-parameter-before-architecture-parsing.patch

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
Subject: init: reject bare rodata parameter before architecture parsing
Date: Fri, 13 Nov 2026 21:23:19 +0100

When a bare rodata parameter is specified on the kernel command line
without the '=' separator, early parameter parsing passes NULL to
set_debug_rodata().

Current hooks already handle NULL safely.  Reject NULL before calling
arch_parse_debug_rodata() so architecture hooks always receive a non-NULL
string.

Return -EINVAL to report the malformed option instead of falling through
to the existing warning.  Also remove the now-redundant NULL checks from
the "on" and "off" comparisons.

Link: https://lore.kernel.org/20261113202321.91770-2-blum@kernel.org
Signed-off-by: Thorsten Blum <blum@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Breno Leitao <leitao@debian.org>
Cc: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Wilson Felipe Pereira <wfelipe@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
---

 init/main.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/init/main.c~init-reject-bare-rodata-parameter-before-architecture-parsing
+++ a/init/main.c
@@ -1566,12 +1566,15 @@ static inline bool arch_parse_debug_roda
 
 static int __init set_debug_rodata(char *str)
 {
+	if (!str)
+		return -EINVAL;
+
 	if (arch_parse_debug_rodata(str))
 		return 0;
 
-	if (str && !strcmp(str, "on"))
+	if (!strcmp(str, "on"))
 		rodata_enabled = true;
-	else if (str && !strcmp(str, "off"))
+	else if (!strcmp(str, "off"))
 		rodata_enabled = false;
 	else
 		pr_warn("Invalid option string for rodata: '%s'\n", str);
_

Patches currently in -mm which might be from blum@kernel.org are

init-reject-bare-rodata-parameter-before-architecture-parsing.patch

