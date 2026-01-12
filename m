Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD5B23EAAD
	for <mm-commits@vger.kernel.org>; Mon, 12 Jan 2026 20:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768248638; cv=none; b=jceJlJa/jl+WyIEkNw1iluH94w4Z3hmPRpiVZW8BNPoK7ybafEIdsytifs/sXgi6eMpR7Ifu+Nrk4dz8qssmng4WAfLhXvrxVda+v/nrCAFyb+6cNBwHDm2WFx8lklkUKtyYuZFmkOx69KR3pZoigdEhQ7XReoynAvyGgTBCXnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768248638; c=relaxed/simple;
	bh=gr64KhOeO6ftckOKWeXg8XWSoGKhBPKvBB/JaTIpRDA=;
	h=Date:To:From:Subject:Message-Id; b=hKdnFryXkRIp3wyHEEpAXynNuaCdcySyGoBYhD3Y3DU9E+ggA84Nz6vu9gRCt08I+aTNZ+tgvby/dJgTItFPiUIMebiflcMyC49zIKhlNt7tLXqwE1IVTcW2YIyE2HCvDD6tK7DZzemZ5oAfCS3jQ9Qsjf46BH1vBJtfbAVIon4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zz2V5SD6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zz2V5SD6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9303DC116D0;
	Mon, 12 Jan 2026 20:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768248637;
	bh=gr64KhOeO6ftckOKWeXg8XWSoGKhBPKvBB/JaTIpRDA=;
	h=Date:To:From:Subject:From;
	b=Zz2V5SD6eoVsIa1PeacNMdjj3EJG9NkBLMjjwfF6al8YgyYwHIjRvKRZr/69MABZ3
	 tSQrMczm8KbuqJMsgP3dJ60GcB4w8PtFbU4S/IKmsthZAJkV3Jf52IoQ+aKUG5LAYn
	 c6Rz6WXy+5pphpDioikkw12x6aR6qkLpmfH7ZEQw=
Date: Mon, 12 Jan 2026 12:10:36 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,tglx@kernel.org,rppt@kernel.org,mingo@kernel.org,link@vivo.com,kernel@pengutronix.de,guoweikang.kernel@gmail.com,francesco@valla.it,dianders@chromium.org,chenhuacai@kernel.org,alexander.shishkin@linux.intel.com,a.fatoum@pengutronix.de,lillian@star-ark.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning.patch added to mm-nonmm-unstable branch
Message-Id: <20260112201037.9303DC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: init/main.c: check if rdinit was explicitly set before printing warning
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning.patch

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
From: Lillian Berry <lillian@star-ark.net>
Subject: init/main.c: check if rdinit was explicitly set before printing warning
Date: Sun, 11 Jan 2026 07:56:35 -0500

The rdinit parameter is set by default, and attempted during boot even if
not specified in the command line.  Only print the warning about rdinit
being inaccessible if the rdinit value was found in command line; it's
just noise otherwise.

Link: https://lkml.kernel.org/r/20260111125635.53682-1-lillian@star-ark.net
Signed-off-by: Lillian Berry <lillian@star-ark.net>
Cc: Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Francesco Valla <francesco@valla.it>
Cc: Guo Weikang <guoweikang.kernel@gmail.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Huan Yang <link@vivo.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: Thomas Gleixner <tglx@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/init/main.c~init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning
+++ a/init/main.c
@@ -162,6 +162,7 @@ static size_t initargs_offs;
 
 static char *execute_command;
 static char *ramdisk_execute_command = "/init";
+static bool ramdisk_execute_command_set;
 
 /*
  * Used to generate warnings if static_key manipulation functions are used
@@ -623,6 +624,7 @@ static int __init rdinit_setup(char *str
 	unsigned int i;
 
 	ramdisk_execute_command = str;
+	ramdisk_execute_command_set = true;
 	/* See "auto" comment in init_setup */
 	for (i = 1; i < MAX_INIT_ARGS; i++)
 		argv_init[i] = NULL;
@@ -1700,8 +1702,9 @@ static noinline void __init kernel_init_
 	int ramdisk_command_access;
 	ramdisk_command_access = init_eaccess(ramdisk_execute_command);
 	if (ramdisk_command_access != 0) {
-		pr_warn("check access for rdinit=%s failed: %i, ignoring\n",
-			ramdisk_execute_command, ramdisk_command_access);
+		if (ramdisk_execute_command_set)
+			pr_warn("check access for rdinit=%s failed: %i, ignoring\n",
+				ramdisk_execute_command, ramdisk_command_access);
 		ramdisk_execute_command = NULL;
 		prepare_namespace();
 	}
_

Patches currently in -mm which might be from lillian@star-ark.net are

init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning.patch

